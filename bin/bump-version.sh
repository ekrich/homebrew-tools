#!/bin/bash
set -e

# Ensure a version argument was passed
if [ -z "$1" ]; then
    echo "Usage: ./bin/bump-version.sh <version_number>"
    echo "Example: ./bin/bump-version.sh 1.3.0"
    exit 1
fi

NEW_VERSION="$1"
FORMULA_NAME="accelerate-lapacke"

echo "🚀 Bumping $FORMULA_NAME to version $NEW_VERSION..."

# Execute Homebrew's built-in formula bumper
# --write modifies your local workspace file instead of opening a GitHub PR
brew bump-formula-pr \
  --write \
  --version="$NEW_VERSION" \
  ekrich/tools/$FORMULA_NAME

echo "✅ Local formula file updated successfully!"
