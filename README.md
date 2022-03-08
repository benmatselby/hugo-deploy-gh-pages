# Hugo Deploy to GitHub Pages

![GitHub Badge](https://github.com/benmatselby/hugo-deploy-gh-pages/workflows/Build/badge.svg)

This GitHub action will build your [Hugo site](https://gohugo.io/), and then publish back to [GitHub Pages](https://pages.github.com/).

## Secrets

- `TOKEN`: A GitHub access token that can push to other repos, which in this case will be your GitHub pages repo. We cannot use `GITHUB_TOKEN` as defined [here](https://help.github.com/en/actions/configuring-and-managing-workflows/authenticating-with-the-github_token#about-the-github_token-secret) because it is a locally scoped token to a specific repo.

## Environment Variables

- `CNAME`: Contents of a `CNAME` file.
- `GITHUB_ACTOR`: The name of the person or app that initiated the workflow. For example, octocat. [See here](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#environment-variables).
- `GO_VERSION`: The version of Go you may want to install. This is not required for basic operation. Values should be in the format of `1.17`.
- `HUGO_ARGS`: Arguments passed to `hugo`.
- `HUGO_EXTENDED`: If set to `true`, the _extended_ version of Hugo will be used. Default is `false`.
- `HUGO_PUBLISH_DIR`: Specify if you do not use the Hugo default of `public`.
- `HUGO_VERSION`: This allows you to control which version of Hugo you want to use. The default is to pull the latest version.
- `TARGET_BRANCH`: This is the branch to push the public files e.g. `docs`. Default is `master` branch.
- `TARGET_REPO`: This is the repo slug for the GitHub pages site. e.g. `benmatselby/benmatselby.github.io`.

## Example

```shell
name: Push to GitHub Pages on push to master
on:
  push:
    branches:
      - master

jobs:
  build:
    name: Deploy
    runs-on: ubuntu-latest
    steps:
      - name: Checkout master
        uses: actions/checkout@v1

      - name: Deploy the site
        uses: benmatselby/hugo-deploy-gh-pages@master
        env:
          HUGO_VERSION: 0.88.0
          TARGET_REPO: benmatselby/benmatselby.github.io
          TARGET_BRANCH: master
          TOKEN: ${{ secrets.TOKEN }}
          HUGO_ARGS: '-t academic'
          CNAME: benmatselby.github.io
```

This will:

- Clone the `TARGET_REPO` into the `build` folder.
- Commit the changes with the `date` as the git commit message.
- Push back to GitHub using the `TARGET_BRANCH` environment variable.

## Testing

To test this action locally, you can run the following in your hugo site:

Build the docker image

```shell
docker build --pull --rm -f "Dockerfile" -t hugodeployghpages:latest .
```

Run the standard version of Hugo and the action.

```shell
# cd to your hugo site
docker run --rm \
  -eGITHUB_TOKEN \
  -eTARGET_REPO=benmatselby/benmatselby.github.io \
  -v "$(pwd)":/site/ \
  --workdir /site \
  hugodeployghpages
```

Run the extended version of Hugo, and the action.

```shell
# cd to your hugo site
docker run --rm \
  -eHUGO_EXTENDED=true \
  -eGITHUB_TOKEN \
  -eTARGET_REPO=benmatselby/benmatselby.github.io \
  -v "$(pwd)":/site/ \
  --workdir /site \
  hugodeployghpages
```

## Tutorial

For an in depth tutorial, see [this blog post](https://www.jameswright.xyz/post/deploy-hugo-academic-using-githubio/). It is geared mostly at users of the Hugo Academic theme, but should be more broadly applicable.
