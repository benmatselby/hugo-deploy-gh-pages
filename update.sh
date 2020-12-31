#!/usr/bin/env bash

set -e
set -o pipefail

# Colours https://misc.flogisoft.com/bash/tip_colors_and_formatting
reset=$'\e[0m'
red=$'\e[1;31m'

if ! [ -x "$(command -v gh)" ]; then
  printf "%sPlease install 'jq' %s\\n" "${red}" "${reset}"
  exit 1
fi

CURRENT_VERSION=$(grep -si HUGO_VERSION= action.sh | cut -d "=" -f 2)
LATEST_VERSION=$(gh release list -R gohugoio/hugo -L 1 | cut -f 1)
LATEST_VERSION=${LATEST_VERSION//v/}

# Update the main action
sed -i.orig "s/HUGO_VERSION=${CURRENT_VERSION}/HUGO_VERSION=${LATEST_VERSION}/g" action.sh

# Update the readme
sed -i.orig "s/HUGO_VERSION: ${CURRENT_VERSION}/HUGO_VERSION: ${LATEST_VERSION}/g" README.md

# Cleanup
rm README.md.orig action.sh.orig

if [[ "${CURRENT_VERSION}" != "${LATEST_VERSION}" ]]; then
  printf "Raising pull request"
  TITLE="Upgrading Hugo to ${LATEST_VERSION}"
  git checkout -b "${LATEST_VERSION}" origin/master
  git add action.sh README.md
  git commit -m "${TITLE}"
  git push origin "${LATEST_VERSION}"
  gh pr create --body "${TITLE}" --title "${TITLE}"
  git checkout master
fi
