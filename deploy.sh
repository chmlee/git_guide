#!/usr/bin/env bash
set -euo pipefail

BRANCH="gh-pages"
STATIC_DIR="static"

if [ ! -f "guide.html" ]; then
  echo "Error: guide.html not found"
  exit 1
fi

if [ ! -d "guide_files" ]; then
  echo "Error: guide_files/ not found"
  exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "Error: no git remote named origin found in the parent repo"
  exit 1
fi

ORIGIN_URL="$(git remote get-url origin)"

rm -rf "$STATIC_DIR"
mkdir -p "$STATIC_DIR"

cp guide.html "$STATIC_DIR/index.html"
cp -R guide_files "$STATIC_DIR/"

rm -rf "$STATIC_DIR/.git"

cd "$STATIC_DIR"

git init
git checkout -b "$BRANCH"

git add .
git commit -m "Deploy GitHub Pages"

git remote add origin "$ORIGIN_URL"
git push -f origin "$BRANCH"

echo "Deployed to origin/$BRANCH"
