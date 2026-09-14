Title: Init Git Branches
Description: Create a clean default branch layout after instantiating a repository from template.

When to use:
- Right after creating a repository from the template to normalise branches and remove template noise (tags, example branches, Dependabot PRs).
- As **one step** of the fuller day-0 flow in [bootstrap-npm-repo](../bootstrap-npm-repo/SKILL.md) (labels, auto-approve countdown, style gate).

Inputs:
- `repo`: the target repository (local clone with `origin` set to the remote).
- `primary`: (optional) the canonical primary branch name in the template (default: `main`).
- `develop`: (optional) desired develop branch name (default: `develop`).

Outputs:
- `develop` branch pushed to `origin`, based on `primary`.
- Remote tags removed.
- Remote branches other than `primary` and `develop` deleted (unless protected).
- Optionally closed Dependabot or other automated PRs.

Behavior:
- Non-interactive, opinionated: deletes tags and branches on remote — requires repository admin privileges and caution.
- When run, the operator must review and confirm branch protection rules and remote permissions first.

After this skill (npm packages):
1. Prefer default branch = `develop` (setup-repo usually does this).
2. Run **Auto-approve owner PRs** once so countdown labels exist (`merge-in-*-day(s)-without-review`) — see bootstrap-npm-repo and org labels skill.
3. Ensure repo is on org `repos.txt` / label fan-out for catalog labels.
4. Do not treat branch cleanup alone as full bootstrap.

Safety & constraints:
- This skill performs destructive git operations. Run only when you have admin access and a verified backup/clone.
- If the remote has branch protection preventing deletion, the skill will surface errors for manual resolution.
- Closing PRs should be done carefully — the instructions include filtering by author (e.g., `dependabot[bot]`).
- Aligning or force-updating `main` under rulesets may require temporary admin ruleset changes; always re-enable protection (see bootstrap-npm-repo).

Examples:
- Normalise repo using defaults (primary `main`, develop `develop`).
- Close open Dependabot PRs and delete example branches created by the template.

See also:
- `.instructions.md` for exact commands and examples.
- [bootstrap-npm-repo](../bootstrap-npm-repo/SKILL.md) for the full post-template checklist.
