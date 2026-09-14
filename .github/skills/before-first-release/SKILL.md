---
name: before-first-release
description: Audit and remove template leftovers before the first npm package release
---

# Before first release — remove unneeded files

Run this **after** product code is on `develop` and **before** (or as part of preparing) the first stable release. Goal: ship only what the package owns — no template demo product, no dead tests/helpers/fixtures.

Agents: treat every checklist item as a decision with evidence (import graph, tests, `package.json` `bin`/`files`), not a blind delete.

## When

- First release of a repo created from `template-npm-shared-library`
- Anytime a derived package still looks like the PNL/XML converter sample
- After major scope cut (same cleanup mindset)

## Principles

1. **Delete unused code**, do not leave “maybe later” template samples in `src/` or `test/`.
2. **Keep** shared template *infrastructure* (CI scripts, eslint/prettier, workflow callers) unless the package explicitly does not need it.
3. Prefer grepping the repo over memory: if nothing imports it and no test references it, it is a candidate.

## High-risk leftovers (template sample product)

Template ships a **PNL ⇄ XML converter** sample. Derived packages must not publish that API unless that *is* the product.

| Area | Template examples | Action |
|------|-------------------|--------|
| `src/converter.ts` | Sample converter | Remove if not the product |
| `src/api.ts` / CLI for `pnl-to-xml` | Sample API/CLI | Replace or remove |
| `src/types*` for conversion | Sample types | Remove if unused |
| `package.json` `bin` | e.g. `winccoa-pnl-xml` | Must match real CLI name or be removed |
| README features/install/CLI | Converter prose | Rewrite for this package |
| `docs/USAGE.md` (if sample-only) | Converter usage | Replace or delete |

**Fail if:** `package.json` `name`/`bin`/`description` or README still describe ui-pnl-xml / converter while the package is something else.

## Tests, helpers, fixtures

| Area | Keep when | Remove when |
|------|-----------|-------------|
| `test/unit/**` | Tests cover *this* package | Tests still assert converter/sample behavior |
| `test/integration/**` | Integration matches product + real deps | Copy-paste of template OA conversion scenarios unused here |
| `test/helpers/test-project-helpers.ts` | Imported by current tests | **Zero imports** (install-info removed these) |
| `test/helpers/*` | Shared teardown/setup still used | Orphan helpers / README-only dead trees |
| `test/fixtures/**` | Loaded by tests or documented local runs | Fixtures never read; CI no longer verifies them |
| Empty `test/helpers/` or `test/fixtures/` dirs | — | Remove empty dirs after cleanup |

**Process:**

```text
1. List test entrypoints and what they import
2. List helpers/fixtures referenced
3. Delete unreferenced helpers/fixtures first
4. Delete or rewrite tests that only existed for the sample
5. npm test / unit (+ integration if claimed) must pass
```

## Docs and metadata

- [ ] Root `README.md`: real product, correct install name, no “THIS IS AN EXAMPLE README”
- [ ] Badges: this repo + this npm name — see [readme-badges](../readme-badges/SKILL.md)
- [ ] `docs/VISION.md` (or package vision): matches shipped surface
- [ ] `docs/automation/*`: slim stubs OK; drop huge copied essays if unused
- [ ] Community MD footer on package markdown if org convention applies
- [ ] `CHANGELOG.md`: honest Unreleased / first version notes
- [ ] `FUNDING.yml` / `SECURITY.md`: still appropriate (usually keep)
- [ ] Quick Links / npm URLs point at **this** package, not core or template

## package.json / publish surface

- [ ] `name` scoped `@winccoa-tools-pack/<repo>` (or intended name)
- [ ] `files` / exports only ship intended `dist` (or docs) — no accidental source fixtures
- [ ] `dependencies`: only what product imports (drop sample-only deps if any)
- [ ] `config.winccoaImage` or similar: only if integration still needs it
- [ ] No dead scripts that reference removed paths

## Verification commands

```bash
npm ci
npm run style-fix
npm test
# if package claims integration:
npm run test:integration

# smoke: no leftover sample symbols (adjust patterns to product)
rg -n "pnlToXml|xmlToPnl|PnlXmlConverter|winccoa-pnl-xml" src test README.md package.json || true
```

Confirm CI on `develop` is green after the cleanup PR.

## Related

- [bootstrap-npm-repo](../bootstrap-npm-repo/SKILL.md) — day-0; does not replace this pre-release audit
- [readme-badges](../readme-badges/SKILL.md)
- [first-release](../first-release/SKILL.md) — run after this cleanup
- Org **create-pr**: cleanup goes as `chore`/`refactor` PR → `develop` (squash)
