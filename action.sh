#!/bin/bash

set -e
set -o pipefail

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

if [[ -z "$TARGET_REPO" ]]; then
	echo "Set the TARGET_REPO env variable."
	exit 1
fi

echo 'Building the hugo site'
hugo

echo 'Cloning the GitHub Pages repo'
BUILD_DIR=build
rm -fr "${BUILD_DIR}"
TARGET_REPO_URL="https://${GITHUB_TOKEN}@github.com/${TARGET_REPO}.git"
git clone "${TARGET_REPO_URL}" "${BUILD_DIR}"

echo 'Moving the content over'
cp -r public/* build/

echo 'Committing the site to git and pushing'
git add . && \
git commit -m "Publishing site $(date)" && \
git push origin master

echo 'Complete'
