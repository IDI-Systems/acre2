---
title: Building
permalink: dev_building.html
folder: dev
---

This page describes how you can setup your development environment for ACRE2, allowing you to properly build ACRE2 and utilize file patching.

## Requirements

- Arma 3
- Arma 3 Tools (available on Steam)
- P-drive
- Run Arma 3 and Arma 3 Tools directly from Steam once to install registry entries (and again after every update)
- [Python 3.x](https://www.python.org/)
- [Mikero Tools](https://dev.withsix.com/projects/mikero-pbodll/files): DePbo, DeRap, DeOgg, Rapify, MakePbo, pboProject
- Python, Mikero Tools and Git in PATH environment variable
- [CBA](https://github.com/CBATeam/CBA_A3/releases/latest) mod (release or development version)

## Why so complicated?

ACRE2 uses macros to simplify things and give the developer access to a better debug process, which requires a stricter build environment. Additionally, Mikero’s Tools are stricter and report more errors than AddonBuilder does. The structure of this development environment also allows for [file patching](#file-patching), which is very useful for debugging.

Not offering .exes for the Python scripts we use allows us to make easy changes without the hassle of compiling self-extracting exes all the time.

## Getting Source Code

To actually get the ACRE2 source code on your machine, it is recommended that you use Git. Tutorials for this are all around the web, and it allows you to track your changes and easily update your local copy.

You can clone ACRE2 with any Git command line client using the following command:
```
git clone https://github.com/IDI-Systems/acre2.git
```

If you just want to create a quick and dirty build, you can also directly download the source code using the "Download ZIP" button on the front page of the GitHub repo.

## Setup and Building

### Initial Setup

Navigate to `tools` folder in command line.
```
cd <path-to-cloned-repository>\tools
```
Execute `setup.py` to create symbolic links to P-drive and Arma 3 directory required for building.

Should the script fail, you can create the required links manually. First, create `idi` folders both in your Arma 3 directory and on your P-drive. Then run the following commands as admin, replacing the text in brackets with the appropriate paths:

```bat
mklink /J "[Arma 3 installation folder]\idi\acre" "[location of the ACRE2 project]"
mklink /J "P:\idi\acre" "[location of the ACRE2 project]"
```

Then, copy the `cba` folder from the `tools` folder to `P:\x\cba`. Create the `x` folder if needed. That folder contains the parts of the CBA source code that are required for the macros to work.

### Create a Test Build

To create a development build of ACRE2 to test changes or to debug something, execute `build.py` in the `tools` folder. This will populate the `addons` folder with binarized PBOs. These PBOs still point to the source files in their respective folders however, which allows you to use [file patching](#file-patching). This also means that you cannot distribute this build to others.

To start the game using this build, you can use the following modline:
```
-mod=@CBA_A3;idi\clients\acre
```

You will also need `acre.dll` and `ACRE2Arma.dll` placed in `idi\clients\acre` folder. You can obtain those from last release or [build them yourself](../Building-ACRE2-Extensions). TeamSpeak plugin is not required for basic operation.

### Create a Release Build

To create a complete build of ACRE2 that you can use without the source files you will need:

- All [C++ requirements](./Building-ACRE2-Extensions#requirements)
- `msbuild` in `PATH` environment variable (usually `C:\Program Files (x86)\MSBuild\14.0\Bin`)
- Ensure `.hpp` is **NOT** in pboProject's "Exclude From Pbo" list

When the requirements are met:

- Execute `make.py version increment_build <other-increment-args> compile force checkexternal release` in the `tools` folder, replacing `<other-increment-args>` with the part of version you want to increment (options described below)

This will populate the `release` folder with binarized PBOs, compiled extensions, copied extras, bisigns and a bikey. Additionally, 2 archive files will also be created in the folder, one general and one for Steam which includes the required Steam extension. The folder and archives handle like those of any other mod.

Different `make.py` command line options include:

- `version` - update version number in all files and leave them in working directory (leaving this out will still update the version in all files present in the `release` folder, but they will be reverted to not disturb the working directory)
- `increment_build` - increments _build_ version number
- `increment_patch` - increments _patch_ version number (ignored with `increment_minor` or `increment_major`)
- `increment_minor` - increments _minor_ version number and resets _patch_ version number to `0` (ignored with `increment_major`)
- `increment_major` - increments _major_ version number and resets _minor_ and _patch_ version numbers to `0`
- `compile` - compile extensions incrementally (leaving this out will simply copy extensions if already present)
- `force` - force rebuild all PBOs, even those already present in the `release` directory (combined with `compile` it will also rebuild all extensions)
- `checkexternal` - check external references (incompatible only with `<component1> <component2>` and `force <component1> <component2>`)
- `release` - create release packages/archives
- `<component1> <component2>` - build only specified component(s) (incompatible with `release`)
- `force <component1> <component2>` - force rebuild specified component(s) (incompatible with `release`)

## File Patching

File Patching allows you to change the files in an addon while the game is running, requiring only a restart of the mission. This makes it great for debugging, as it cuts down the time required between tests. Note that this only works with PBOs created using MakePbo, which `build.py` uses.

To run Arma 3 with file patching add the `-filePatching` startup parameter.

Files must exist in the built PBOs for file patching to work. If you create a new file you must rebuild the PBO or Arma will not find it in your file paths.

### Disable CBA Function Caching

By default CBA caches a compiled version of functions to reduce mission load times. This interferes with file patching. There are three ways to disable function caching:

- Load `cba_cache_disable.pbo` (included in CBA’s `optionals` folder - simply move it to `addons` folder for the time being)
- Add the following to your test missions description.ext:
```c++
class CfgSettings {
    class CBA {
        class Caching {
            compile = 0;
            xeh = 0;
            functions = 0;
        };
    };
};
```
- To only disable caching for a single module, hence greatly improving mission restart time, add the following line to the `script_component.hpp` file of said module:
```c++
#define DISABLE_COMPILE_CACHE
```

### Restrictions

Configs are not patched during run time, only at load time. You do not have have to rebuild a PBO to make config changes, just restart Arma. You can get around this though if you are on the dev branch of Arma 3 and running the diagnostic exe. That includes `diag_mergeConfig` which takes a full system path (as in `p:\idi\clients\acre\addons\my_module\config.cpp`) and allows you to selectively reload config files.

{% include links.html %}
