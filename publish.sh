#!/usr/bin/env bash
set -euo pipefail

OWNER="${1:-pikos-apikos}"
REPO="${2:-disciplined-capability-composition}"
DESCRIPTION="An RFC for building reliable and secure systems around non-deterministic language models through typed capability composition."

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI (gh) is required: https://cli.github.com/" >&2
  exit 1
fi

gh auth status >/dev/null

CURRENT_BRANCH="$(git branch --show-current)"
if [[ "$CURRENT_BRANCH" != "main" ]]; then
  echo "Expected branch 'main', found '$CURRENT_BRANCH'." >&2
  exit 1
fi

if gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
  if git remote get-url origin >/dev/null 2>&1; then
    git remote set-url origin "git@github.com:$OWNER/$REPO.git"
  else
    git remote add origin "git@github.com:$OWNER/$REPO.git"
  fi
  git push -u origin main
else
  gh repo create "$OWNER/$REPO" \
    --public \
    --description "$DESCRIPTION" \
    --source . \
    --remote origin \
    --push
fi

printf '\nPublished: https://github.com/%s/%s\n' "$OWNER" "$REPO"
