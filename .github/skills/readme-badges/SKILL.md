---
name: readme-badges
description: Add or fix standard npm package README badges for winccoa-tools-pack
---

# README badges (npm packages)

Standard badge block for `@winccoa-tools-pack/*` npm packages. Use on new packages, after template setup, and whenever badges still point at the template or a sibling repo.

## Standard block

Place **immediately under** the H1 (or as the first content block). Keep `markdownlint-disable MD033` for the HTML centering.

Replace:

- `NPM_PACKAGE` → full npm name from `package.json` `name` (e.g. `@winccoa-tools-pack/npm-winccoa-install-info`)
- `REPO` → `owner/repo` (e.g. `winccoa-tools-pack/npm-winccoa-install-info`)

```markdown
<!-- markdownlint-disable MD033 -->
<div align="center">

[![npm version](https://img.shields.io/npm/v/NPM_PACKAGE.svg?label=npm)](https://www.npmjs.com/package/NPM_PACKAGE)
![License](https://img.shields.io/github/license/REPO)
[![CI/CD](https://github.com/REPO/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/REPO/actions/workflows/ci-cd.yml)
[![Release](https://github.com/REPO/actions/workflows/release.yml/badge.svg)](https://github.com/REPO/actions/workflows/release.yml)

</div>
```

### URL rules

| Badge | Image | Link target |
|-------|--------|-------------|
| npm version | `https://img.shields.io/npm/v/<npm-name>.svg?label=npm` | `https://www.npmjs.com/package/<npm-name>` |
| License | `https://img.shields.io/github/license/<owner>/<repo>` | (image only is OK) |
| CI/CD | `https://github.com/<owner>/<repo>/actions/workflows/ci-cd.yml/badge.svg` | same workflow URL without `/badge.svg` |
| Release | `.../actions/workflows/release.yml/badge.svg` | same for `release.yml` |

Workflow file names must match the repo (default template: `ci-cd.yml`, `release.yml`). If renamed, fix badges.

## Checklist

- [ ] `NPM_PACKAGE` equals `package.json` `"name"` exactly (including scope)
- [ ] `REPO` equals this GitHub repository (`gh repo view --json nameWithOwner -q .nameWithOwner`)
- [ ] No leftover `template-npm-shared-library`, `npm-winccoa-template`, `npm-winccoa-ui-pnl-xml`, or wrong sibling package
- [ ] No badges pointing at `npm-winccoa-core` unless this package *is* core
- [ ] Quick Links / install snippets use the same npm name
- [ ] `npm run lint:md` / `style-fix` clean after edit

## Template + setup-repo

`template-npm-shared-library` README should contain this block with:

- repo path `winccoa-tools-pack/template-npm-shared-library`
- npm name `@winccoa-tools-pack/npm-winccoa-template`

**Setup-repo** rewrites `winccoa-tools-pack/template-npm-shared-library` → new `owner/repo` in README. It does **not** reliably rewrite the scoped npm name inside badge URLs.

**After setup (or on any derived repo):** always re-check npm badge + install commands against `package.json` `name`. If still `npm-winccoa-template` or the sample converter name, fix with this skill.

## VS Code extensions

This skill is for **npm packages**. Extension READMEs may use Marketplace badges instead of npm version — do not force npm badges on VS Code extension repos.

## Related

- [before-first-release](../before-first-release/SKILL.md)
- [bootstrap-npm-repo](../bootstrap-npm-repo/SKILL.md)
