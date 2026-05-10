# torch-xpu-skills

GitHub Copilot / Claude agent skills for XPU backend development in PyTorch.

These skills are **not upstreamed** to `pytorch/pytorch` because they are XPU-specific. This repository is now shaped like a plugin repository so it can be published through a plugin marketplace, while still supporting the original symlink-based setup as a fallback.

## Skills

| Skill | Description |
|-------|-------------|
| `xpu-nightly-ci-fix` | Triage and fix XPU CI nightly test failures. Parses failure reports, reproduces locally, identifies root causes, and applies fixes. |

## Installation

### GitHub Copilot CLI via marketplace

Target install flow:

```bash
copilot plugin marketplace add obra/superpowers-marketplace
copilot plugin install superpowers@superpowers-marketplace
```

For this repository, the important part is plugin packaging compatibility: it now includes standard plugin metadata under `.claude-plugin/` plus a SessionStart hook under `hooks/` so a marketplace catalog can point at this repository directly.

To make the exact two commands above install this plugin, a marketplace entry still needs to be added in the catalog repository that users register with `copilot plugin marketplace add`.

### Manual setup fallback

```bash
git clone git@github.com:<you>/torch-xpu-skills.git
./torch-xpu-skills/setup.sh /path/to/pytorch
```

This creates symlinks under `pytorch/.claude/skills/` pointing back to this repo. The symlinks are not tracked by PyTorch's git.

## Usage

After installation, the agent should automatically discover the plugin skills. Right now this repository exposes:

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
2. If you use manual symlinks, run `./setup.sh /path/to/pytorch` again — existing links are skipped, new ones are created.
3. If you use plugin marketplace install, bump the plugin version in `.claude-plugin/plugin.json` before publishing the updated plugin or marketplace entry.
