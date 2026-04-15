# torch-xpu-skills

Copilot / Claude agent skills for XPU backend development in PyTorch.

These skills are **not upstreamed** to `pytorch/pytorch` because they are XPU-specific. They are designed to be symlinked into a PyTorch workspace so the agent can discover and use them automatically.

## Skills

| Skill | Description |
|-------|-------------|
| `xpu-nightly-ci-fix` | Triage and fix XPU CI nightly test failures. Parses failure reports, reproduces locally, identifies root causes, and applies fixes. |

## Setup

```bash
git clone git@github.com:<you>/torch-xpu-skills.git
./torch-xpu-skills/setup.sh /path/to/pytorch
```

This creates symlinks under `pytorch/.claude/skills/` pointing back to this repo. The symlinks are not tracked by PyTorch's git.

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`) and workflow content.
2. Run `./setup.sh /path/to/pytorch` again — existing links are skipped, new ones are created.
