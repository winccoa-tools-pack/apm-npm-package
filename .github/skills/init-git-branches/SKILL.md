Title: Init Git Branches
Description: Create a clean default branch layout after instantiating a repository from template.

When to use:
- Right after creating a repository from the template to normalise branches and remove template noise (tags, example branches, Dependabot PRs).

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

Safety & constraints:
- This skill performs destructive git operations. Run only when you have admin access and a verified backup/clone.
- If the remote has branch protection preventing deletion, the skill will surface errors for manual resolution.
- Closing PRs should be done carefully — the instructions include filtering by author (e.g., `dependabot[bot]`).

Examples:
- Normalise repo using defaults (primary `main`, develop `develop`).
- Close open Dependabot PRs and delete example branches created by the template.

See also: `.instructions.md` for exact commands and examples.
