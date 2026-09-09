Title: Clear Changelog
Description: Remove template-provided CHANGELOG.md content so repositories start with an empty changelog.

When to use:
- Immediately after creating a repository from the template to remove templated changelog entries.

Inputs:
- `repo`: local clone with `origin` set.
- `file`: (optional) path to the changelog file (default: `CHANGELOG.md`).

Outputs:
- `CHANGELOG.md` overwritten with an empty changelog header (or completely emptied) and committed.

Behavior & safety:
- Non-destructive option: default mode replaces the file with a standard header and preserves history. A destructive mode clears the file completely.
- Requires commit permissions on the repository. The command will create a commit `chore: clear template changelog` when changes are made.

Examples:
- Clear and add a header: keeps an initial header for future entries.
- Fully empty the file: remove all content but keep file tracked.

See `.instructions.md` for exact commands and dry-run options.
