# GitHub Action to build and deploy a hugo site to GitHub Pages

[![Build Status](https://travis-ci.org/benmatselby/hugo-deploy-gh-pages.png?branch=master)](https://travis-ci.org/benmatselby/hugo-deploy-gh-pages)

This GitHub action will build your hugo site, and then publish back to GitHub Pages.

## Secrets

- `TOKEN`: A GitHub access token that can push to other repos, which in this case will be your GitHub pages repo. We cannot use `GITHUB_TOKEN` as defined [here](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#environment-variables) because it is a locally scoped token to a specific repo.

## Environment Variables

- `GITHUB_ACTOR`: The name of the person or app that initiated the workflow. For example, octocat. [See here](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#environment-variables).
- `TARGET_REPO`: This is the repo slug for the GitHub pages site. e.g. `benmatselby/benmatselby.github.io`.

## Example

```shell
workflow "New workflow" {
  on = "push"
  resolves = ["benmatselby/hugo-deploy-gh-pages@master"]
}

action "master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "benmatselby/hugo-deploy-gh-pages@master" {
  needs = "master"
  uses = "benmatselby/hugo-deploy-gh-pages@master"
  env = {
    TARGET_REPO = "benmatselby/benmatselby.github.io"
  }
  secrets = ["TOKEN"]
}
```

This will:

- Clone the `TARGET_REPO` into the `build` folder.
- Commit the changes with the `date` as the git commit message.
- Push back to GitHub.
