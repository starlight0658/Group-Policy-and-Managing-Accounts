#!/usr/bin/env bash
set -euo pipefail

REPO="starlight0658/Group-Policy-and-Managing-Accounts"
cd "$(dirname "$0")"

command -v git >/dev/null || { echo "Git is required."; exit 1; }
command -v gh >/dev/null || { echo "GitHub CLI is required. Install with: brew install gh"; exit 1; }
gh auth status >/dev/null || { echo "Sign in first: gh auth login"; exit 1; }

if [[ ! -d .git ]]; then
  git init -b main
fi
git add README.md PROFILE-README-ENTRY.md UPLOAD-INSTRUCTIONS.md PUBLISH_TO_GITHUB.sh screenshots
if ! git diff --cached --quiet; then
  git commit -m "Add Group Policy and Managing Accounts lab with 40 screenshots"
fi

if gh repo view "$REPO" >/dev/null 2>&1; then
  if ! git remote get-url origin >/dev/null 2>&1; then
    git remote add origin "https://github.com/$REPO.git"
  fi
  git push -u origin main
else
  gh repo create "$REPO" --public --source=. --remote=origin --push
fi

echo "Published: https://github.com/$REPO"
echo "Add the entry in PROFILE-README-ENTRY.md to your GitHub profile README."
