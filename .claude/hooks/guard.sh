#!/bin/bash
# Rung 5: a PreToolUse hook. Claude Code sends every Bash call here as JSON on stdin.
# Exit 2 = block the command (stderr is shown to Claude as the reason).
# Exit 0 with no output = allow, and the normal permission prompt still applies.
# Needs jq. Deliberately broad so it always fires in a live demo.

cmd=$(jq -r '.tool_input.command // empty')

if echo "$cmd" | grep -Eq 'rm -rf|:\(\)\{|curl[^|]*\|[[:space:]]*(ba)?sh|/etc/shadow'; then
  echo "Blocked by CyberHawks guard hook: $cmd" >&2
  exit 2
fi

exit 0
