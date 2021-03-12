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

if [[ -z "${TARGET_BRANCH}" ]]; then
    TARGET_BRANCH=master
    echo "No TARGET_BRANCH was set, so defaulting to ${TARGET_BRANCH}"
fi

if [[ -z "${HUGO_VERSION}" ]]; then
    HUGO_VERSION=0.81.0
    echo "No HUGO_VERSION was set, so defaulting to ${HUGO_VERSION}"
fi

if [[ "${HUGO_EXTENDED}" = "true" ]]; then
  EXTENDED_INFO=" (extended)"
  EXTENDED_URL="extended_"
else
  EXTENDED_INFO=""
  EXTENDED_URL=""
fi

echo "Downloading Hugo: ${HUGO_VERSION}${EXTENDED_INFO}"
URL=https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${EXTENDED_URL}${HUGO_VERSION}_Linux-64bit.deb
echo "Using '${URL}' to download Hugo"
curl -sSL "${URL}" > /tmp/hugo.deb && dpkg --force architecture -i /tmp/hugo.deb

echo "Building the Hugo site with: 'hugo ${HUGO_ARGS}'"
hugo "${HUGO_ARGS}"

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
if [[ "${TARGET_BRANCH}" != "master" ]]; then
  git checkout -b ${TARGET_BRANCH}
fi

git add . && \
git commit -m "Auto publishing site from ${GITHUB_REPOSITORY}@${HASH}" && \
git push --force "${TARGET_REPO_URL}" ${TARGET_BRANCH}

echo "Complete"
