#!/bin/bash

set -e
set -o pipefail

if [[ -n "${TOKEN}" ]]; then
    GITHUB_TOKEN=${TOKEN}
fi

if [[ -z "${GITHUB_TOKEN}" ]]; then
    echo "Set the GITHUB_TOKEN env variable."
    exit 1
fi

if [[ -z "${TARGET_REPO}" ]]; then
    echo "Set the TARGET_REPO env variable."
    exit 1
fi

if [[ -z "${HUGO_VERSION}" ]]; then
    HUGO_VERSION=0.66.0
    echo "No HUGO_VERSION was set, so defaulting to ${HUGO_VERSION}"
fi

echo "Downloading Hugo: ${HUGO_VERSION}"
curl -sSL https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz > /tmp/hugo.tar.gz && tar -f /tmp/hugo.tar.gz -xz

echo "Building the Hugo site with: ./hugo ${HUGO_ARGS}"
./hugo "${HUGO_ARGS}"

TARGET_REPO_URL="https://${GITHUB_TOKEN}@github.com/${TARGET_REPO}.git"

rm -rf .git
cd public

if [[ -n "${CNAME}" ]]; then
    echo "CNAME set to ${CNAME}, creating file CNAME"
    echo "${CNAME}" > CNAME
fi

echo "Committing the site to git and pushing"

git init

if ! git config --get user.name; then
    git config --global user.name "${GITHUB_ACTOR}"
fi

if ! git config --get user.email; then
    git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
fi

echo "Getting hash for base repository commit"
HASH=$(echo "${GITHUB_SHA}" | cut -c1-7)

# Now add all the changes and commit and push
git add . && \
git commit -m "Auto publishing site from ${GITHUB_REPOSITORY}@${HASH}" && \
git push --force "${TARGET_REPO_URL}" master:master

echo "Complete"
