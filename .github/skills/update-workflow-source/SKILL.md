Title: Update Workflow Execution Source
Description: Replace the template `source` entry in `.github/actions/policies/workflow_execution.json` to point to the current repository instead of the template.

When to use:
- Right after creating a repository from the `template-npm-shared-library` template, or when you detect the `workflow_execution.json` still references the template as the `source`.

Inputs:
- `repo`: local clone with `origin` set.
- `file`: (optional) path to the policy file (default: `.github/actions/policies/workflow_execution.json`).

Outputs:
- The `source` property updated from `winccoa-tools-pack/template-npm-shared-library` to `winccoa-tools-pack/<repo-name>`, committed on a branch and pushed (PR optional).

Behavior:
- Dry-run preview shows the current `source` value and the proposed replacement.
- Non-destructive: by default the command creates a branch, commits the change and opens a PR.

Safety & constraints:
- Requires repo write access to push branches and open PRs.
- The skill only edits the single policy file path and will not search other files.

See `.instructions.md` for exact PowerShell commands and usage examples.
