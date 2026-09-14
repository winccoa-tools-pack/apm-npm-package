---
name: linkedin-release-post
description: Draft a LinkedIn post promoting a first or major npm/package release
---

# LinkedIn release promotion post

Produce a **ready-to-paste LinkedIn post** (and optional short variants) when the operator asks to promote a **first release**, **major version**, or other milestone release of a winccoa-tools-pack package or extension.

Agents: draft text only. Do **not** post to LinkedIn, store credentials, or scrape private profiles. Operator publishes manually.

## When to use

- First public npm release (`0.x` or `1.0.0`)
- Major SemVer bump or headline feature launch
- Operator explicitly asks for social/LinkedIn copy after [first-release](../first-release/SKILL.md)

Skip for routine patch dependency bumps unless asked.

## Inputs to gather (ask if missing)

| Input | Example |
|-------|---------|
| Package display name | WinCC OA Install Info |
| npm name / repo | `@winccoa-tools-pack/npm-winccoa-install-info` |
| Version | `0.1.1` |
| One-sentence problem/value | List installed OA versions and registered projects from CLI/CI |
| 2–4 concrete capabilities | `versions` / `projects`, JSON default, `--result-file` |
| Audience | WinCC OA engineers, automation/CI, integrators |
| Links | npm, GitHub release, docs/VISION, org site |
| Language | English default; German if operator requests |
| Tone | Professional, community, no hype spam |

## Structure (English default)

1. **Hook** (1–2 lines): problem or outcome for WinCC OA / industrial automation devs  
2. **Announce** what shipped + version  
3. **Bullets** (3–5): capabilities, not buzzwords  
4. **Ecosystem** one line: part of open `winccoa-tools-pack`  
5. **CTA**: try install command + links  
6. **Hashtags** (3–6): e.g. `#WinCCOA` `#Siemens` `#IndustrialAutomation` `#OpenSource` `#TypeScript` `#npm` — do not over-tag  

Length: ~150–300 words for main post; also provide a **short** (~500 chars) variant.

## Template (fill in)

```text
[Hook: pain or goal in one line.]

We just released [Name] [vX.Y.Z] — [one-line value].

Highlights:
• …
• …
• …

It is part of the open winccoa-tools-pack tooling for SIMATIC WinCC OA engineers ([org/github]).

Try it:
npm install -g [npm-name]
npx [npm-name] --help

📦 npm: [url]
🐙 GitHub: [url]
[Docs if any]

#[tags]
```

## German variant (when requested)

Same structure; use clear engineering German (Du/Sie per operator preference; default **Sie** for LinkedIn B2B unless told otherwise). Keep product/CLI names in original form.

## Quality bar

- Accurate: only claim shipped features (read README/VISION/CHANGELOG)
- No fake metrics, awards, or “#1” claims
- No competitor bashing
- Mention Siemens/WinCC OA factually; do not imply official Siemens endorsement unless true
- Include correct scoped package name and version
- Prefer `npx` or `npm install` that matches README

## Deliverables

1. Main LinkedIn post (paste-ready)  
2. Short variant  
3. Optional image/alt text suggestion (e.g. terminal screenshot of CLI — operator captures; agent only describes)  
4. Link checklist (npm, release, repo)

## Related

- [first-release](../first-release/SKILL.md)
- Package README + `docs/VISION.md` as source of truth for claims
