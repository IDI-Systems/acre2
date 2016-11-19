---
title: Building Extensions
permalink: dev_building-extensions.html
sidebar: acre2_sidebar
folder: dev
---

This page describes how you can setup your extensions development environment for ACRE2, allowing you to properly build extensions with Visual Studio.

## Requirements

- [CMake](https://cmake.org/) (>=v3.x)
- [Visual Studio 2015](https://www.visualstudio.com/en-us/downloads/download-visual-studio-vs.aspx)
- [DirectX SDK](https://www.microsoft.com/en-gb/download/details.aspx?id=6812)

## Build Project (Windows)

_This is done automatically when doing a [release build](./Building-ACRE2#create-a-release-build) with `compile` option._

- Open a command prompt and navigate to the folder in which you downloaded or Git cloned out the ACRE2 source.

### 32-bit

- Navigate to the `extensions\vcproj` directory.
- Run `cmake ..`
- Visual Studio project should be selected by default, if not use the `-G` option and choose the right 32-bit CMake generator.
- Compile projects.

### 64-bit

_Only `ACRE2TS` project (`acre2_win64.dll`) TeamSpeak plugin can be built in 64-bit._

- Navigate to the `extensions\vcproj64` directory.
- Run `cmake .. -DUSE_64BIT_BUILD=ON -G "Visual Studio 14 2015 Win64"` (replace generator for any other 64-bit Visual Studio generator)

Extensions files will also be copied to their appropriate locations automatically after compilation (ready for [test](./Building-ACRE2#create-a-test-build) and [release](./Building-ACRE2#create-a-release-build) builds).

{% include links.html %}
