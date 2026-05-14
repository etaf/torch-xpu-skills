# torch-xpu-skills

GitHub Copilot / Claude agent skills for XPU backend development in PyTorch.

These skills are **not upstreamed** to `pytorch/pytorch` because they are XPU-specific. This repository is packaged as a [GitHub Copilot CLI plugin](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating), while still supporting the original symlink-based setup as a fallback.

## Skills

| Skill | Description |
|-------|-------------|
| `xpu-nightly-ci-fix` | Triage and fix XPU CI nightly test failures. Parses failure reports, reproduces locally, identifies root causes, and applies fixes. |

## Installation

### Install as a Copilot CLI plugin (recommended)

Install from a local clone:

```bash
git clone git@github.com:xinanlin/torch-xpu-skills.git
copilot plugin install ./torch-xpu-skills
```

Verify:

```bash
copilot plugin list
```

To pick up changes after updating the repo, re-install:

```bash
copilot plugin install ./torch-xpu-skills
```

To uninstall:

```bash
copilot plugin uninstall torch-xpu-skills
```

### Install via marketplace

If a marketplace catalog includes this plugin:

```bash
copilot plugin marketplace add <marketplace-owner>/<marketplace-repo>
copilot plugin install torch-xpu-skills@<marketplace-name>
```

### Manual setup fallback

```bash
git clone git@github.com:xinanlin/torch-xpu-skills.git
./torch-xpu-skills/setup.sh /path/to/pytorch
```

This creates symlinks under `pytorch/.claude/skills/` pointing back to this repo. The symlinks are not tracked by PyTorch's git.

## Usage

After installation, the plugin skills are automatically discovered. This plugin exposes:

- `xpu-nightly-ci-fix` for XPU nightly CI triage and repair workflows

Typical prompts:

```text
Use xpu-nightly-ci-fix to analyze this nightly failure report.
```

```text
Please investigate these failing XPU tests from nightly CI and fix the root cause.
```

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`) and workflow content.
2. Bump the version in `plugin.json`.
3. If using manual symlinks, run `./setup.sh /path/to/pytorch` again — existing links are skipped, new ones are created.
4. If installed as a plugin, re-install: `copilot plugin install ./torch-xpu-skills`.
