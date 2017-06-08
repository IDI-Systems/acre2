---
title: Building Extensions
---

This page describes how you can setup your extensions development environment for ACRE2, allowing you to properly build extensions with Visual Studio.

## Requirements

- [CMake](https://cmake.org/) (>=v3.x)
- [Visual Studio 2017](https://www.visualstudio.com/en-us/downloads/download-visual-studio-vs.aspx)
- [DirectX SDK](https://www.microsoft.com/en-gb/download/details.aspx?id=6812)

## Build Project (Windows)

_This is done automatically when doing a [release build](building#create-a-release-build) with `compile` option._

- Open a command prompt and navigate to the folder in which you downloaded or Git cloned out the ACRE2 source.

### 32-bit

- Navigate to the `extensions\vcproj` directory.
- Run `cmake .. -G "Visual Studio 15 2017` (replace generator for any other 32-bit Visual Studio generator)
- Compile projects.

### 64-bit

- Navigate to the `extensions\vcproj64` directory.
- Run `cmake .. -G "Visual Studio 15 2017 Win64"` (replace generator for any other 64-bit Visual Studio generator)
- Compile projects.

Extensions files will also be copied to their appropriate locations automatically after compilation (ready for [test](building#create-a-test-build) and [release](building#create-a-release-build) builds).
