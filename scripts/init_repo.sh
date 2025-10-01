#!/usr/bin/env bash
set -euo pipefail
REMOTE="${1:-}"
git init
 git add .
 git commit -m 'Init: Safe Mode Expanded v3.1'
 git branch -M main
if [ -n "$REMOTE" ]; then git remote add origin "$REMOTE"; git push -u origin main; fi
