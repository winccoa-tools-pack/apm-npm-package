---
name: bootstrap-npm-repo
description: Day-0 checklist after creating an npm package repo from the shared template
---

# Bootstrap npm package repository

Use this **immediately after** creating a repository from `template-npm-shared-library` (or after cloning a fresh template-derived npm package).

Write for agents: complete the checklist in order; skip only steps the operator confirms already done.

## Goals

- GitFlow ready: `develop` default, `main` stable
- Org catalog labels + auto-approve countdown labels present
- First feature work can open PRs → `develop` without missing labels or style/CI surprises

## Day-0 checklist

### 1. Template setup workflow

- Confirm **Setup new repository** / `setup-repo.yml` (or reusable setup) finished successfully on first push to `main`.
- Confirm `develop` exists and is the **default branch**.
- Placeholders in `package.json`, README, `repository.settings.yml` replaced; version/changelog reset as designed by setup.

If setup did not run, use [init-git-branches](../init-git-branches/SKILL.md) carefully, then fix default branch via GitHub settings/API.

### 2. Branch layout cleanup (if needed)

If template left extra branches, tags, or noise Dependabot PRs:

- Follow [init-git-branches](../init-git-branches/SKILL.md) (destructive; needs admin).

### 3. Org label rollout membership

- Ensure `winccoa-tools-pack/<repo>` is listed in [`.github` `repos.txt`](https://github.com/winccoa-tools-pack/.github/blob/main/repos.txt).
- Run org **single-target label sync** or fan-out so catalog labels from `labels/labels.yml` exist.
- Details: org [labels](../labels/SKILL.md) skill (from `apm-org` after `apm install`).

### 4. Auto-approve countdown labels (mandatory)

Org fan-out does **not** replace this step.

Run once right after repo creation:

```bash
gh workflow run auto-approve-owner-prs.yml
# Actions → "Auto-approve owner PRs" → Run workflow
```

Expect labels:

- `merge-in-3-days-without-review`
- `merge-in-2-days-without-review`
- `merge-in-1-day-without-review`

Verify:

```bash
gh label list --limit 100 | findstr /i "merge-in"
```

Do this **before** the first owner PRs that should use countdown auto-approve.

### 5. Settings / rulesets / secrets

- Confirm `apply-settings-and-rulesets` (or equivalent) ran if the template expects it.
- `REPO_ADMIN_TOKEN` / org admin secrets: only when apply-settings or protection workflows fail for missing permissions — do not invent tokens “just in case”.
- Public vs private: follow operator preference; do not force public in the skill.

### 6. `main` branch caution

- Default development branch is **`develop`**. Do not push product work to `main`.
- If `main` must be created or realigned with `develop` and **rulesets** block the push (required checks, linear history, etc.):
  - Prefer a proper PR/release path when one exists.
  - Last resort (admin only): temporarily relax the blocking ruleset, push the intended `main`, **re-enable** the ruleset immediately.
  - Never leave `main` unprotected.

### 7. Local package sanity

```bash
npm ci
npm run style-fix
npm test
# or package-equivalent unit/integration scripts
```

Add or fix README badges for **this** package/repo — see [readme-badges](../readme-badges/SKILL.md). Do not leave template or sibling package badge URLs.

### 8. First product PR

- Branch from `develop`: `feature/...` or `bugfix/...`
- PR target: **`develop`**, squash merge
- Before push: `npm run style-fix` (see org **create-pr** skill)

### 9. Before / at first stable release (later)

Not day-0, but do not skip the chain:

1. [before-first-release](../before-first-release/SKILL.md) — drop template sample code, unused helpers/fixtures
2. [readme-badges](../readme-badges/SKILL.md) — final badge pass
3. [first-release](../first-release/SKILL.md) — create release → **merge commit** to `main` → verify npm → upmerge
4. [linkedin-release-post](../linkedin-release-post/SKILL.md) — optional promotion for first/major release

## Out of scope for this skill

- Product-specific CLI behavior (e.g. install-info `--result-file`, core registry watchers)
- One-off Dependabot noise cleanup beyond init-git-branches optional PR close
- Deep release execution (see first-release + org versioning)

## Related skills

- [init-git-branches](../init-git-branches/SKILL.md) — branch/tag cleanup after template
- [labels](../labels/SKILL.md) — catalog fan-out (mirrored); countdown labels documented in org labels skill
- [before-first-release](../before-first-release/SKILL.md) · [readme-badges](../readme-badges/SKILL.md) · [first-release](../first-release/SKILL.md) · [linkedin-release-post](../linkedin-release-post/SKILL.md)
- Org **create-pr**, **git-flow**, **versioning** — after `apm install` from `apm-org`
