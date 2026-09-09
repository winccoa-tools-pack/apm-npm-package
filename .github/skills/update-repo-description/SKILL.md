Title: Update Repository Description
Description: Update `.github/repository.settings.yml` description field to a repository-specific value after templating.

When to use:
- After creating a repository from the `template-npm-shared-library` template to replace the template description with a repo-specific description.

Inputs:
- `repo`: local clone with `origin` set. The skill auto-detects the repo name from the remote.
- `description`: (optional) explicit description to set. If omitted, the skill generates a description from the repo owner/name.

Outputs:
- Updated `.github/repository.settings.yml` with a repository-specific `description:` value, committed and pushed.

Behavior & safety:
- Performs a non-destructive replacement of the `description:` line. A dry-run mode shows proposed changes without committing.
- Requires commit/push permissions. If file is missing, the skill creates one using a minimal template.

See `.instructions.md` for exact commands and examples (PowerShell-friendly).
