# apm-npm-package

npm package specific APM package for winccoa-tools-pack.

## Overview

This package contains AI agent skills, prompts, and instructions specific to **npm package development**.

Inherits from `apm-org` (organization-wide configuration).

## Usage

Add to your npm package's `apm.yml`:

```yaml
dependencies:
  apm:
    - winccoa-tools-pack/apm-org
    - winccoa-tools-pack/apm-npm-package
```

Then run:

```bash
apm install
```

## Contents

- `instructions/` — npm package development context
- `skills/` — Package-specific AI capabilities
- `prompts/` — Package-specific templates

## Structure

```
apm-npm-package/
├── apm.yml
├── README.md
├── instructions/
├── skills/
└── prompts/
```
