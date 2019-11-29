# GitHub Action to build and deploy a Hugo site to GitHub Pages

This GitHub action will build your [Hugo site](https://gohugo.io/), and then
publish back to [GitHub Pages](https://pages.github.com/).

## Secrets

- `TOKEN`: A GitHub access token that can push to other repos, which in this case will be your GitHub pages repo. We cannot use `GITHUB_TOKEN` as defined [here](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#environment-variables) because it is a locally scoped token to a specific repo.

## Environment Variables

- `GITHUB_ACTOR`: The name of the person or app that initiated the workflow. For example, octocat. [See here](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#environment-variables).
- `TARGET_REPO`: This is the repo slug for the GitHub pages site. e.g. `benmatselby/benmatselby.github.io`.
- `HUGO_VERSION`: This allows you to control which version of Hugo you want to use. There is a default within the action, but this may be out of date.
- HUGO_ARGS: Arguements passed to ```hugo`.
- CNAME: Contents of a `CNAME` file.

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
          HUGO_VERSION: 0.57.2
          TARGET_REPO: benmatselby/benmatselby.github.io
          TOKEN: ${{ secrets.TOKEN }}
          HUGO_ARGS: '-t academic'
          CNAME: benmatselby.github.io
```

This will:

- Clone the `TARGET_REPO` into the `build` folder.
- Commit the changes with the `date` as the git commit message.
- Push back to GitHub.

## Testing

To test this action locally, you can run the following in your hugo site:

```shell
TARGET_REPO=benmatselby/benmatselby.github.io ../hugo-deploy-gh-pages/action.sh
```
