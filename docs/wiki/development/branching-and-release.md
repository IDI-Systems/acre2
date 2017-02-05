---
title: Branching and Release
---

_To be updated for CI builds._

## Versioning
ACRE2 uses a versioning strategy based on [semver.org](http://semver.org). This means our version numbering has the following structure: **`MAJOR.MINOR.PATCH.BUILD`**

Because this modification is for Arma and backwards compatibility is not always possible, our `MAJOR.MINOR.PATCH.BUILD` rules are slightly different. We increment the:

```
MAJOR version when we switch to a new Arma version (i.e. Arma 4 or standalone expansion).
MINOR version when we add new features or large amount of bug fixes.
PATCH version when a release contains only bug fixes.
```

## Branching and Releases

When an ACRE2 release is being prepared, the current `master` branch will be merged into the `development-build` branch which will automatically start a development build process. Once the development build is confirmed to be stable, `development-build` (or `master`) branch is merged into `release-build` branch which will automatically start a build and publish process.

The `development-build` and `release-build` branches will not contain any direct commits and no other branches will be merged into those branches. The exception being hotfixes, which are branched off `release-build` into a new `hotfix` branch and merged back once hotfix is ready (at which point the hotfix branch is deleted), allowing patches to be released without disrupting the work on features. `release-build` will automaticlly be merged back into `master` during the automatic build process.

Hotfixes are fixes for critical bugs that prevent stable gameplay with the currently available stable version of ACRE2.

During this release process work can continue on as normal on the `master` branch. This includes new features, bug fixes that won't make it for release or other work. These will not be merged into the `release-build` branch until the next release cycle.

### Branching

- New features, bug fixes that are not a hotfix or other work will always be branched off `master` or another branch but never a `hotfix` or the `release-build` branch.
- Hotfixes are always branched off the `release-build` branch.
- The `release-build` and `development-build` branches are never merged or deleted.
    - Only `master` is allowed to merge into the `development-build` branch.
    - Only `master` or hotfixes are allowed to merge into the `release-build` branch.

### Diagram

{% include image.html file="dev/branching-and-release.png" alt="Branching and Release Flowchart" %}
