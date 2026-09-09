Title: Update Vision Document
Description: Ensure the repository's single vision document `docs/VISION.md` is updated to a repo-specific version and remove template content.

When to use:
- Immediately after repo creation from a template that provides a generic `VISION.md` so the repository has an accurate, focused vision statement.

Inputs:
- `repo`: local clone with `origin` set.
- `vision`: (optional) explicit vision content or short summary to insert. If omitted, the operator is prompted to edit the generated header.

Interactive behavior:
- This skill welcomes interactive user input. If `vision` is not provided, the instructions open the repository `docs/VISION.md` in the user's editor (or `notepad` on Windows) so the user can compose or paste the vision text. After the user saves and closes the editor, the skill commits the changes.

Outputs:
- `docs/VISION.md` updated (or created if missing) with a repository-specific header and placeholder for the vision text.

Behavior & constraints:
- The skill only updates `docs/VISION.md`. It must NOT create other files named `VISION.md` elsewhere.
- Default behavior is non-destructive: it preserves existing content by committing a change only if replacement occurs; a dry-run preview mode is provided.

See `.instructions.md` for PowerShell-ready commands and dry-run steps.
