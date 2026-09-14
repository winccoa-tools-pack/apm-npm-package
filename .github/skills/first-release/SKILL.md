---
name: first-release
description: Run and verify the first (or any) stable npm release via Git Flow workflows
---

# First release (npm package)

End-to-end checklist for publishing a **stable** version with org Git Flow automation. Applies to the **first** public release and later stables; call out first-release extras where noted.

Agents: do **not** create `release/*` branches by hand. Do **not** squash-merge release PRs into `main`.

## Prerequisites

- [ ] Product on `develop`; CI green
- [ ] [before-first-release](../before-first-release/SKILL.md) cleanup done (first release)
- [ ] [readme-badges](../readme-badges/SKILL.md) correct
- [ ] `NPM_TOKEN` secret available on the repo/org (publish will skip or fail without it)
- [ ] Version chosen per org **versioning** skill (example first line: `0.1.0` or `0.1.1` — operator picks SemVer; no `v` prefix in the workflow input)

## 1. Create release branch + PR

**Actions** → **Create Release Branch + PR** (`create-release-branch.yml`)

| Input | Typical |
|-------|---------|
| `kind` | `release` |
| `version` | e.g. `0.1.1` |
| `base_branch` | `develop` |
| `target_branch` | `main` |

Workflow should:

- Create `release/vX.Y.Z`
- Bump `package.json` / lockfile
- Open PR **→ `main`**

Optional: edit CHANGELOG on the release branch before merge (if the workflow did not fully refresh it).

## 2. Pre-release on the PR

PR to `main` should run **pre-release** (tested tarball / GitHub pre-release tag like `vX.Y.Z-<sha>`).

- [ ] Pre-release workflow green
- [ ] Artifact / pre-release exists for this version (release job will require a matching tested tarball)

## 3. Merge release PR into `main` — **merge commit, never squash**

| PR | Strategy |
|----|----------|
| `release/v*` → `main` | **Merge commit only** |
| `hotfix/v*` → `main` | **Merge commit only** |
| Feature → `develop` | Squash (not this step) |

**Why:** Squashing release → `main` breaks Git Flow history and causes painful upmerges later.

If the GitHub UI default is squash, switch to **Create a merge commit** before confirming.

## 4. Stable release + npm publish

On green `main`, **Release** workflow (`release.yml`) should:

- Create stable tag `vX.Y.Z`
- Attach tested tarball
- `npm publish` with `NPM_TOKEN` (`--access public` for scoped packages)

### Verify publish

```bash
# GitHub
gh release view vX.Y.Z
gh run list --workflow=release.yml --limit 5

# npm (public registry)
npm view @winccoa-tools-pack/<package-name> version
npm view @winccoa-tools-pack/<package-name> time
```

- [ ] `npm view` shows **X.Y.Z** (not only an old version)
- [ ] GitHub Release `vX.Y.Z` is not prerelease
- [ ] Release workflow job did not skip publish due to missing `NPM_TOKEN`

If publish skipped: fix token, then follow repo docs for re-run / manual publish of the tested tarball — do not invent a parallel versioning scheme.

## 5. Upmerge `main` → `develop`

After release on `main`, upmerge automation should open/update PR **main → develop** (often `feature/upmerge-main-to-develop`).

- [ ] Upmerge PR exists and CI is considered
- [ ] Merge it so `develop` carries the released version + changelog

**Merge strategy for upmerge:** prefer **merge commit** when the branch ruleset allows it (org git-flow skill). Some repos enable **squash** auto-merge on develop because of `required_linear_history` — follow **this repo’s** ruleset/auto-merge settings; do not fight protection. Still never squash the **release → main** PR.

## 6. Post-release

- [ ] Default branch remains `develop` for ongoing work
- [ ] README npm badge resolves (may lag shields.io briefly)
- [ ] Optional: [linkedin-release-post](../linkedin-release-post/SKILL.md) for first release or major milestones
- [ ] Optional: docs site / github.io mention if the org maintains a tools page

## Failure cheat sheet

| Symptom | Check |
|---------|--------|
| No release branch | Workflow dispatch permissions; correct workflow file |
| Pre-release missing | PR checks; pre-release workflow on `main` PRs |
| Release did not publish | `NPM_TOKEN`; release logs; tarball from pre-release |
| Upmerge conflicts | Finish release merge cleanly; resolve upmerge PR (main wins for version files) |
| Wrong version on npm | Confirm tag and `package.json` on `main`; do not republish same version with different contents |

## Related

- Org **git-flow**, **versioning**, **create-pr**
- [before-first-release](../before-first-release/SKILL.md)
- [linkedin-release-post](../linkedin-release-post/SKILL.md)
