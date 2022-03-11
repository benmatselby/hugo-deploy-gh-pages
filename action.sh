#!/bin/bash

set -e
set -o pipefail

###
# Environment variable definitions.
##
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

if [[ -z "${HUGO_PUBLISH_DIR}" ]]; then
  HUGO_PUBLISH_DIR=public
  echo "No HUGO_PUBLISH_DIR was set, so defaulting to ${HUGO_PUBLISH_DIR}"
fi

if [[ -z "${HUGO_VERSION}" ]]; then
    HUGO_VERSION=$(curl -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/gohugoio/hugo/releases?page=1&per_page=1" | jq -r ".[].tag_name" | sed 's/v//g')
    echo "No HUGO_VERSION was set, so defaulting to ${HUGO_VERSION}"
fi

if [[ "${HUGO_EXTENDED}" = "true" ]]; then
  EXTENDED_INFO=" (extended)"
  EXTENDED_URL="extended_"
else
  EXTENDED_INFO=""
  EXTENDED_URL=""
fi

###
# Downloading of Hugo.
###
echo "Downloading Hugo: ${HUGO_VERSION}${EXTENDED_INFO}"
URL=https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${EXTENDED_URL}${HUGO_VERSION}_Linux-64bit.deb
echo "Using '${URL}' to download Hugo"
curl -sSL "${URL}" > /tmp/hugo.deb && dpkg --force architecture -i /tmp/hugo.deb


###
# Optionally install Go.
###
# shellcheck disable=SC2153
if [[ -n "${GO_VERSION}" ]]; then
  echo "Installing Go: ${GO_VERSION}"

  curl -sL "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" > /tmp/go.tar.gz
  tar -C /tmp -xf /tmp/go.tar.gz
  mv /tmp/go /go
  rm -rf \
    /usr/local/go/pkg/*/cmd \
    /usr/local/go/pkg/bootstrap \
    /usr/local/go/pkg/obj \
    /usr/local/go/pkg/tool/*/api \
    /usr/local/go/pkg/tool/*/go_bootstrap \
    /usr/local/go/src/cmd/dist/dist \
    /tmp/go.tag.gz

  # Provide version details and sanity check installation
  echo "Installed Go: ${GO_VERSION}"
  go version
fi

###
# Build the site.
###
echo "Building the Hugo site with: 'hugo ${HUGO_ARGS}'"
hugo "${HUGO_ARGS}"

TARGET_REPO_URL="https://${GITHUB_TOKEN}@github.com/${TARGET_REPO}.git"

rm -rf .git
cd ${HUGO_PUBLISH_DIR}

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

###
# Now add all the changes and commit and push
###
if [[ "${TARGET_BRANCH}" != "master" ]]; then
  git checkout -b ${TARGET_BRANCH}
fi

git add . && \
git commit -m "Auto publishing site from ${GITHUB_REPOSITORY}@${HASH}" && \
git push --force "${TARGET_REPO_URL}" ${TARGET_BRANCH}

echo "Complete"
