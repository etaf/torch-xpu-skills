#!/bin/bash
# Link XPU skills into a PyTorch workspace so Copilot/Claude can discover them.
# Usage: ./setup.sh /path/to/pytorch
PYTORCH_DIR="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$PYTORCH_DIR/.claude/skills"

for skill in "$SCRIPT_DIR"/skills/*/; do
    name=$(basename "$skill")
    target="$PYTORCH_DIR/.claude/skills/$name"
    if [ -L "$target" ] || [ -e "$target" ]; then
        echo "skip: $name (already exists)"
    else
        ln -s "$skill" "$target"
        echo "linked: $name"
    fi
done
