#!/bin/bash
set -e

# Ensure both package name and version arguments are passed
if [[ -z "$1" ]] || [[ -z "$2" ]]
then
  echo "Usage: ./bin/bump-version.sh <formula_name> <version_number>"
  echo "Example: ./bin/bump-version.sh accelerate-lapacke 1.1.0"
  exit 1
fi

FORMULA_NAME="${1}"
NEW_VERSION="${2}"

echo "🚀 Bumping ${FORMULA_NAME} to version ${NEW_VERSION}..."

# Execute Homebrew's built-in formula bumper safely offline
brew bump-formula-pr \
  --write \
  --no-fork \
  --version="${NEW_VERSION}" \
  ekrich/tools/"${FORMULA_NAME}"

echo "✅ Local formula file updated successfully!"
