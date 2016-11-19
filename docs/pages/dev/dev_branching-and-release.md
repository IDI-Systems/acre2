---
title: Branching and Release
permalink: dev_branching-and-release.html
sidebar: acre2_sidebar
folder: dev
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

When an ACRE2 release is being prepared, the current `master` branch will be merged into the `release` branch. The `release` branch will not contain any direct commits and no other branches will be merged into this branch. The exception being hotfixes, which are branched off `release` and merged back into `release`, allowing patches to be released without disrupting the work on features. `release` will be merged back into `master` as often as possible.

Hotfixes are fixes for critical bugs that prevent stable gameplay with the currently available version of ACRE2.

During this release process work can continue on as normal on the `master` branch. This includes new features, bug fixes that won't make it for release or other work. These will not be merged into the `release` branch until the next release cycle.

### Branching

* New features, bug fixes that are not a hotfix or other work will always be branched off `master` or another branch but never a `hotfix` or the `release` branch.
* Hotfixes are always branched off the `release` branch
* The `release` branch is never merged or deleted. Only `master` or hotfixes are allowed to merge into the `release` branch.

### Diagram

![Branching and Release Flowchart](images/dev/branching-and-release.jpg)

{% include links.html %}
