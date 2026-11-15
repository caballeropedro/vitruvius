#!/usr/bin/env bash
# Regenerates the derived copies from their canonical sources:
#   SKILL.md, references/, examples/  ->  .agents/skills/first-principles-architect/
#   AGENTS.md              ->  GEMINI.md (title differs, body identical)
# Usage: scripts/sync.sh          rewrite the derived copies
#        scripts/sync.sh --check  exit 1 if any derived copy has drifted
set -euo pipefail
cd "$(dirname "$0")/.."

skill_dir=.agents/skills/first-principles-architect
gemini() { sed '1s/`AGENTS.md`/`GEMINI.md`/' AGENTS.md; }

if [[ "${1:-}" == "--check" ]]; then
  status=0
  diff -q SKILL.md "$skill_dir/SKILL.md" || status=1
  diff -rq references "$skill_dir/references" || status=1
  diff -rq examples "$skill_dir/examples" || status=1
  gemini | diff -q - GEMINI.md || status=1
  if [[ $status -ne 0 ]]; then
    echo "Derived copies have drifted. Edit the canonical files, then run scripts/sync.sh." >&2
  fi
  exit $status
fi

mkdir -p "$skill_dir"
cp SKILL.md "$skill_dir/SKILL.md"
rm -rf "$skill_dir/references"
cp -r references "$skill_dir/references"
rm -rf "$skill_dir/examples"
cp -r examples "$skill_dir/examples"
gemini > GEMINI.md
