# CHANGELOG

## 2.5.0

- Fix: [Mark the current directory as "git safe"](https://github.com/benmatselby/hugo-deploy-gh-pages/pull/66). Thanks to [Matej Focko](https://github.com/mfocko) for the contribution.

## 2.4.0

- Update the Dockerfile to `debian:bookworm-slim`. Thanks to [Daniel Terhorst-North](https://github.com/tastapod) for the contribution.

## 2.3.0

- Define config for git (and go) to access private repositories

## 2.2.0

- Fix: [#57](https://github.com/benmatselby/hugo-deploy-gh-pages/issues/57) Tidy up the `action.yml` configuration file. Thanks to [Daniel Terhorst-North](https://github.com/tastapod) for the contribution.

## 2.1.0

- Fix: [#50](https://github.com/benmatselby/hugo-deploy-gh-pages/pull/50) Mark the current working directory as safe. Thanks to [Jiri Popelka](https://github.com/jpopelka) for the contribution.

## 2.0.0

- Switched over to downloading the `Linux-64bit.tar.gz` file. See [this issue](https://github.com/gohugoio/hugo/issues/10331) for more context.

## 1.16.0

- Switched the default branch to `main` from `master`.

## 1.15.0

- Remove an early exit statement, identified by [bearylogical](https://github.com/bearylogical)

## 1.14.0

- Allow users to specify the `HUGO_PUBLISH_DIR` environment variable. Resolves [#43](https://github.com/benmatselby/hugo-deploy-gh-pages/issues/43)

## 1.13.0

- All users to optionally install Go within the action environment. This is not required to deploy the Hugo site.

## 1.12.0

- Always pull the latest Hugo release, if there is not one set.

## 1.11.0

- Bumped the version of hugo to v0.88.0

## 1.10.0

- Bumped the version of hugo to v0.83.1

## 1.9.0

- Bumped the version of hugo to v0.81.0

## 1.8.0

- Bumped the version of hugo to v0.80.1

## 1.7.0

- Bumped the version of hugo to v0.79.1

## 1.6.0

- Add capability to push public files to target branch

## 1.5.0

- [#28](https://github.com/benmatselby/hugo-deploy-gh-pages/pull/28) Add the ability to use the Extended version of Hugo. Thanks to [Michael Schlottke-Lakemper](https://github.com/sloede).
- Bumped the version of hugo to v0.73.0
- Convert the docker image over to Debian

## 1.4.0

- Bumped the version of hugo to v0.70.0

## 1.3.0

- Bumped the version of hugo to v0.65.3

## 1.2.1

- Addition of some more output to help understand what happens during the action.

## 1.2.0

- Define the `action.yml` file required for the Marketplace.

## 1.1.0

- Allow the user of the action to determine the Hugo version being used for site generation.

## 1.0.0

- This GitHub action will build your hugo site, and then publish back to GitHub Pages.
