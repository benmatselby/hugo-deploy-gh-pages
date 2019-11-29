#!/bin/bash

set -e
set -o pipefail
set -o xtrace

if [[ -n "$TOKEN" ]]; then
	GITHUB_TOKEN=$TOKEN
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

if [[ -z "$TARGET_REPO" ]]; then
	echo "Set the TARGET_REPO env variable."
	exit 1
fi

if [[ -z "$HUGO_VERSION" ]]; then
	HUGO_VERSION=0.59.1
    echo 'No HUGO_VERSION was set, so defaulting to '$HUGO_VERSION
fi

echo 'Downloading hugo'
curl -sSL https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz > /tmp/hugo.tar.gz && tar -f /tmp/hugo.tar.gz -xz

echo "Print directory contents"
find . -maxdepth 2 -type d -exec ls -ld "{}" \;


echo 'Building the hugo site'
./hugo

TARGET_REPO_URL="https://${GITHUB_TOKEN}@github.com/${TARGET_REPO}.git"

rm -rf .git
cd public

if ! [ -z "${CNAME}" ]; then
    echo '$CNAME set, creating file CNAME'
    echo ${CNAME} > CNAME
fi

echo 'Committing the site to git and pushing'

git init

if git config --get user.name; then
    git config --global user.name "${GITHUB_ACTOR}"
fi

if ! git config --get user.email; then
    git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
fi

echo "Getting hash for base repository commit"
HASH=$(echo $GITHUB_SHA | cut -c1-7)

# Now add all the changes and commit and push
git add . && \
git commit -m "Auto Publishing Site from ${GITHUB_REPOSITORY}@${HASH}" && \
git push --force $TARGET_REPO_URL master:master

echo 'Complete'
