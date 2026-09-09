<#
.SYNOPSIS
  Scan an organization and open PRs updating .github/repository.settings.yml descriptions.

.DESCRIPTION
  Clones each repo shallow, previews or updates the description in
  .github/repository.settings.yml, commits to a branch and opens a PR.

.NOTES
  Requires `gh` (GitHub CLI) and `git` authenticated with an account that
  has push/PR permissions across target repos (bot account recommended).

.EXAMPLE
  # Dry-run preview
  .\update-org-repo-descriptions.ps1 -Org winccoa-tools-pack -DryRun

.EXAMPLE
  # Apply changes (will create branches/PRs)
  $env:DESCRIPTION='My custom description'; .\update-org-repo-descriptions.ps1 -Org winccoa-tools-pack
#>

[param(
  [Parameter(Mandatory=$true)][string]$Org,
  [switch]$DryRun,
  [int]$Limit = 1000
)]

function Exec-GitCommitPushAndPr {
  param($RepoFull, $Branch, $DefaultBranch, $FilePath, $GeneratedDesc)

  git add --all $FilePath
  git commit -m "chore: update repository description to repo-specific value" 2>$null
  if ($LASTEXITCODE -eq 0) {
    git push --set-upstream origin $Branch
    $prTitle = "chore: update repository description"
    $prBody = "Automated: replace template description with repo-specific description.`n`nProposed: $GeneratedDesc"
    gh pr create --title $prTitle --body $prBody --head $Branch --base $DefaultBranch 2>$null
    Write-Host "PR opened for $RepoFull"
  } else {
    Write-Host "No changes to commit for $RepoFull"
  }
}

function Trigger-And-Wait-Workflow {
  param($RepoFull, $WorkflowFile, $BranchToRun, $TimeoutSeconds = 300)

  if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { Write-Host "gh CLI not available; skipping workflow trigger."; return }

  Write-Host "Checking remote branch $BranchToRun for $RepoFull"
  $exists = (gh api repos/$RepoFull/branches/$BranchToRun --silent -H "Accept: application/vnd.github+json" | Out-Null) 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "Branch $BranchToRun not found on $RepoFull; skipping workflow trigger."; return
  }

  Write-Host "Attempting to trigger workflow $WorkflowFile on $BranchToRun for $RepoFull"
  gh workflow run $WorkflowFile --repo $RepoFull --ref $BranchToRun 2>$null
  if ($LASTEXITCODE -ne 0) { Write-Host "Failed to dispatch workflow (maybe no workflow_dispatch)."; return }

  # Poll for the most recent run of that workflow on the branch
  $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
  while ((Get-Date) -lt $deadline) {
    Start-Sleep -Seconds 5
    $runsJson = gh run list --repo $RepoFull --workflow $WorkflowFile --branch $BranchToRun --limit 1 --json databaseId,conclusion,status,headBranch || $null
    if ($runsJson) {
      $run = $runsJson | ConvertFrom-Json
      if ($run -and $run[0]) {
        $status = $run[0].status
        $conclusion = $run[0].conclusion
        Write-Host "Workflow status: $status, conclusion: $conclusion"
        if ($status -eq 'completed') {
          if ($conclusion -eq 'success') { Write-Host "Workflow completed successfully for $RepoFull."; return }
          else { Write-Host "Workflow completed with conclusion: $conclusion for $RepoFull."; return }
        }
      }
    }
  }
  Write-Host "Timed out waiting for workflow run for $RepoFull.";
}

function Set-BranchProtection {
  param($RepoFull, $Branch)

  if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { Write-Host "gh CLI not available; skipping branch protection for $RepoFull/$Branch."; return }

  Write-Host "Setting branch protection for $RepoFull/$Branch"
  $payload = @{
    required_status_checks = @{ strict = $true; contexts = @() }
    enforce_admins = $true
    required_pull_request_reviews = @{ dismiss_stale_reviews = $true; require_code_owner_reviews = $false; required_approving_review_count = 1 }
    restrictions = $null
  } | ConvertTo-Json -Depth 10

  try {
    $resp = $payload | gh api --method PUT "/repos/$RepoFull/branches/$Branch/protection" -H "Accept: application/vnd.github+json" --input - 2>&1
    if ($LASTEXITCODE -eq 0) { Write-Host "Branch protection set for $RepoFull/$Branch" } else { Write-Host "Failed to set branch protection for $RepoFull/$Branch: $resp" }
  } catch {
    Write-Host "Error setting branch protection for $RepoFull/$Branch: $_"
  }
}

# Validate tools
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Write-Error "git not found"; exit 1 }
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { Write-Error "gh (GitHub CLI) not found"; exit 1 }

# List repos
Write-Host "Fetching repo list for org: $Org"
$repos = gh repo list $Org --limit $Limit --json name,nameWithOwner,defaultBranch,visibility | ConvertFrom-Json
if (-not $repos) { Write-Host "No repositories found or gh failed."; exit 1 }

foreach ($r in $repos) {
  $full = $r.nameWithOwner
  $name = $r.name
  $defaultBranch = $r.defaultBranch
  Write-Host "`n--- Processing $full (default: $defaultBranch) ---"

  $tmp = Join-Path $env:TEMP ("repo-" + [guid]::NewGuid().ToString())
  git clone --depth 1 "https://github.com/$full.git" $tmp 2>$null
  if (-not (Test-Path $tmp)) { Write-Warning "Failed to clone $full"; continue }

  Push-Location $tmp
  try {
    $file = ".github\repository.settings.yml"
    $currentDescLine = $null
    if (Test-Path $file) {
      $currentDescLine = (Get-Content $file | Where-Object { $_ -match '^description:' }) -join "`n"
    }

    $generated = if ($env:DESCRIPTION) { $env:DESCRIPTION } else { "WinCC OA APM package: $Org/$name" }
    Write-Host "Current: $currentDescLine"
    Write-Host "Proposed: description: \"$generated\""

    if ($DryRun) { Write-Host "DryRun - skipping changes for $full"; continue }

    $branch = "chore/update-repo-description"
    git checkout -b $branch 2>$null

    if (-not (Test-Path ".github")) { New-Item -ItemType Directory -Path ".github" | Out-Null }
    if (Test-Path $file) {
      $fileContents = Get-Content $file
      if ($fileContents -match '^description:') {
        $newContents = $fileContents -replace '^description:.*', "description: \"$generated\""
      } else {
        $newContents = @()
        $newContents += "description: \"$generated\""
        $newContents += $fileContents
        $newContents = $newContents -join "`n"
      }
      $newContents | Out-File -Encoding utf8 $file
    } else {
      @"
# Repository settings used by org automation and publishing tools
description: "$generated"
default_branch: $defaultBranch
"@ | Out-File -Encoding utf8 $file
    }

    Exec-GitCommitPushAndPr -RepoFull $full -Branch $branch -DefaultBranch $defaultBranch -FilePath $file -GeneratedDesc $generated
    # After pushing changes and creating PR, attempt to trigger apply-settings workflow on `develop` branch
    Trigger-And-Wait-Workflow -RepoFull $full -WorkflowFile 'apply-settings-and-rulesets.yml' -BranchToRun 'develop' -TimeoutSeconds 300
  } finally {
    Pop-Location
    Remove-Item -Recurse -Force $tmp
  }
}

Write-Host "Done."
