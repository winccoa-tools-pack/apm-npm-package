Title: Sync .github config to template and roll out to dependents
Description: When repository-local changes are made to `.github` (workflows, actions, policies, or repo settings) in a non-template repository, create a PR to apply the same changes to the organization template repository, and after the template PR is merged, roll out the resulting changes to dependent repositories by opening PRs that apply the same updates.

When to use:
- After making changes to files under `.github` in a repository that was created from the `winccoa-tools-pack/template-npm-shared-library` template (or any org template). Use this skill to keep the canonical template in sync and propagate fixes back to other repositories.

Inputs:
- `Repo`: local clone with `origin` pointing to the repository where `.github` was edited.
- `TemplateRepo`: the template repository (default: `winccoa-tools-pack/template-npm-shared-library`).
- `ReposList`: optional path to a file listing dependent repositories (one per line, `org/repo`). If omitted, the skill will attempt to read `.github/repos.txt` or query the org via `gh`.
- `Branch`: optional branch to create in target repos (default: `chore/sync-github-from-<repo>`).
- `DryRun`: show planned changes without pushing or opening PRs.

Outputs:
- A PR opened against the template repository containing the `.github` changes.
- After the template PR is merged, PRs opened against dependent repositories applying the same `.github` changes.

Behavior:
- Non-destructive by default: the skill computes the set of changed files under `.github`, creates a new branch in the template repo with those files, and opens a PR for review.
- The rollout only starts after the template PR is merged (the skill polls `gh` for merge completion). Rollout uses the merged files from the template branch.
- Uses `gh` and `git`; requires auth with scopes to create PRs, push branches, and read/write repos.

Safety & constraints:
- Always operates via PRs (no force-push or direct fast-forward to protected branches).
- Provide a `-DryRun` to preview all repository-level PRs before making changes.
- Requires admin/maintainer permissions for pushing branches and creating PRs. Branch-protection rules may prevent push — in that case, the skill will open a PR and report any errors.

See `.instructions.md` for concrete PowerShell steps and examples.
