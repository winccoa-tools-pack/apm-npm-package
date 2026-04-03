# apm-npm-package

npm package specific APM package for winccoa-tools-pack.

## Overview

This package contains AI agent skills, prompts, and instructions specific to **npm package development**.

Inherits from `apm-org` (organization-wide skills).

## Setup

### 1. Install APM (once per machine)

**Windows (PowerShell):**
```powershell
irm https://aka.ms/apm-windows | iex
```

**macOS / Linux:**
```bash
curl -sSL https://aka.ms/apm-unix | sh
```

> For alternative install methods (Homebrew, Scoop, pip) see the official guide:  
> https://microsoft.github.io/apm/getting-started/quick-start/

### 2. After cloning any repository

```bash
apm install
```

This syncs skills, instructions, and prompts from `apm.yml` into `.github/`, `.claude/`, `.cursor/` — the native directories your AI tools read automatically.

### 3. Keeping up to date

Re-run `apm install` when `apm.yml` or `apm.lock.yaml` changes (e.g. after `git pull`).

## Usage in repositories

Add to your npm package's `apm.yml`:

```yaml
dependencies:
  apm:
    - winccoa-tools-pack/apm-org
    - winccoa-tools-pack/apm-npm-package
```

## Contents

- `skills/` — npm package specific AI capabilities
- `instructions/` — Package development context
- `prompts/` — Package specific templates
