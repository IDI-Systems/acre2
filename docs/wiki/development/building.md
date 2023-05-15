---
title: Building
---

This page describes how you can setup your development environment for ACRE2, allowing you to properly build ACRE2 and utilize file patching. ACRE2 currently supports **HEMTT** (recommended) on Windows and Linux and **Mikero Tools** on Windows.

## Requirements

- Arma 3
- Arma 3 Tools (available on Steam)
- P-drive
- Run Arma 3 and Arma 3 Tools directly from Steam once to install registry entries (and again after every update)
- [CBA](https://github.com/CBATeam/CBA_A3/releases/latest) mod (release or development version)
- _(Recommended)_ [ACE3](https://github.com/acemod/ACE3/releases/latest) mod (release or development version)

**HEMTT:** _(recommended)_
- [Windows] PowerShell v3.0+ _(pre-installed on Windows 8 or newer)_
- [HEMTT](https://github.com/BrettMayson/HEMTT) (>=v1.4.0) in project root _(Windows users can double-click `tools/setup.bat`)_

**Mikero Tools:**
- [Python 3.x](https://www.python.org/)
- [Mikero Tools](https://mikero.bytex.digital/Downloads): DePbo, DeOgg, Rapify, MakePbo, pboProject
  - `*.hpp` removed from PboProject's "Exclude From Pbo" list
  - `-F rebuild RequiredAddons` disabled
- Python, Mikero Tools and Git in PATH environment variable


## Why so complicated?

ACRE2 uses macros to simplify things and give the developer access to a better debug process, which requires a stricter build environment.

Additionally, HEMTT and Mikero's Tools are stricter and report more errors than Addon Builder does. The structure of this development environment also allows for [file patching](#file-patching), which is very useful for debugging.

Not offering executables for the Python scripts we use allows us to make easy changes without the hassle of compiling self-extracting exes all the time.


## Getting Source Code

To actually get the ACRE2 source code on your machine, it is recommended that you use Git. Tutorials for this are all around the web, and it allows you to track your changes and easily update your local copy.

You can clone ACRE2 with any Git command line client using the following command:
```bat
git clone https://github.com/IDI-Systems/acre2.git
```

If you just want to create a quick and dirty build, you can also directly download the source code using the "Download ZIP" button on the front page of the GitHub repo.


## Setup and Building (HEMTT)

_Replace `hemtt` with `hemtt.exe` on Windows. P-drive is **not** required for HEMTT or file patching._

### Initial Setup

Execute `tools\setup.bat` (double-click on Windows) or download [HEMTT](https://github.com/BrettMayson/HEMTT/releases/latest) and place the executable in project root (Windows and Linux - binarization supported only on Windows at this time).

#### File Patching Setup

_Not available on Linux as there is no officially supported Arma 3 client for Linux._

ACRE2 comes pre-configured for testing with [file patching](#file-patching) using only CBA's and ACE3's latest published versions. You must subscribe to [CBA_A3](https://steamcommunity.com/workshop/filedetails/?id=450814997) and [ACE](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057) on the Workshop. _Note: ACRE2 can run with only CBA, however ACE3 is natively supported and recommended to be used for full radio interaction fidelity._

If you intend to test using file patching with CBA/ACE3 versions different than latest published, or with other mods, further setup is required. First, create a folder called `idi` in your Arma 3 directory. Then run the following command as admin, replacing the text in brackets with the appropriate paths:

```bat
mklink /J "[Arma 3 installation folder]\idi\acre" "[location of the ACRE2 project]/.hemttout/dev"
```

### Create a Development Build

Run `$ hemtt dev` to build the mod for use with [file patching](#file-patching) (with links to the original addon folders) without binarization (faster and often not needed for development). This will populate the `.hemttout/dev` folder with unbinarized PBOs, with links back to the original addon folders. You cannot distribute this build to others.

Run `$ hemtt launch` to run ACRE2 with pre-configured file patching. _Uses `$ hemtt dev` before launching Arma._

To launch a development build using file patching with CBA/ACE3 versions different than latest published, or with other mods, you must build the mod with `$ hemtt dev` and start the game by providing a modline:
```bat
-mod=@CBA_A3;@ace;idi\acre -skipIntro -noSplash -showScriptErrors -debug -filePatching
```

### Create a Test Build

To create a development build to test changes or to debug something, execute `build.bat` (double-click on Windows) or run `$ hemtt build` in the root folder. This will populate the `.hemttout/build` folder with binarized PBOs. This type of build is meant for sharing, group testing, but not for release.

To start the game using this build, you can use the following modline:
```bat
-mod=@CBA_A3;@ace;idi\acre -skipIntro -noSplash -showScriptErrors -debug
```

### Create a Release Build

To create a complete build that you can use without the source files, with full binarization and all optimizations, run `$ hemtt release` in the root folder. This will populate the `.hemttout/releases` folder with binarized PBOs and an archive in `releases` that you can redistribute. These handle like those of any other mod.


## Setup and Building (Mikero Tools)

### Initial Setup

Navigate to `tools` folder in command line.
```bat
cd <path-to-cloned-repository>\tools
```
Execute `setup.py` to create symbolic links to P-drive and Arma 3 directory required for building.

Should the script fail, you can create the required links manually. First, create `idi` folders both in your Arma 3 directory and on your P-drive. Then run the following commands as admin, replacing the text in brackets with the appropriate paths:

```bat
mklink /J "[Arma 3 installation folder]\idi\acre" "[location of the ACRE2 project]"
mklink /J "P:\idi\acre" "[location of the ACRE2 project]"
```

Then, copy the `cba` folder from the `include\x` folder to `P:\x\cba`. Create the `x` folder if needed. That folder contains the parts of the CBA source code that are required for the macros to work.

### Create a Test Build

To create a development build of ACRE2 to test changes or to debug something, execute `build.py` in the `tools` folder. This will populate the `addons` folder with binarized PBOs. These PBOs still point to the source files in their respective folders however, which allows you to use [file patching](#file-patching). This also means that you cannot distribute this build to others.

To start the game using this build, you can use the following modline:
```bat
-mod=@CBA_A3;idi\acre
```

You will also need `acre.dll` and `ACRE2Arma.dll` (or `acre_x64.dll` and `ACRE2Arma_x64.dll` for 64-bit) placed in `idi\acre` folder. You can obtain those from last release or [build them yourself](building-extensions). TeamSpeak plugin is not required for basic operation.

### Create a Release Build

To create a complete build of ACRE2 that you can use without the source files you will need:

- All [C++ requirements](building-extensions)
- `msbuild` in `PATH` environment variable (usually `C:\Program Files (x86)\MSBuild\14.0\Bin`)
- Ensure `.hpp` is **NOT** in pboProject's "Exclude From Pbo" list

When the requirements are met:

- Execute `make.py version increment_build <other-increment-args> compile force release` in the `tools` folder, replacing `<other-increment-args>` with the part of version you want to increment (options described below)

This will populate the `release` folder with binarized PBOs, compiled extensions, copied extras, bisigns and a bikey. Additionally, 2 archive files will also be created in the folder, one general and one for Steam which includes the required Steam extension. The folder and archives handle like those of any other mod.

Different `make.py` command line options include:

- `version` - update version number in all files and leave them in working directory (leaving this out will still update the version in all files present in the `release` folder, but they will be reverted to not disturb the working directory)
- `increment_build` - increments _build_ version number
- `increment_patch` - increments _patch_ version number (ignored with `increment_minor` or `increment_major`)
- `increment_minor` - increments _minor_ version number and resets _patch_ version number to `0` (ignored with `increment_major`)
- `increment_major` - increments _major_ version number and resets _minor_ and _patch_ version numbers to `0`
- `compile` - compile extensions incrementally (leaving this out will simply copy extensions if already present)
- `force` - force rebuild all PBOs, even those already present in the `release` directory (combined with `compile` it will also rebuild all extensions)
- `release` - create release packages/archives
- `<component1> <component2>` - build only specified component(s) (incompatible with `release`)
- `force <component1> <component2>` - force rebuild specified component(s) (incompatible with `release`)


## File Patching

File Patching allows you to change the files in an addon while the game is running, requiring only a restart of the mission. This makes it great for debugging, as it cuts down the time required between tests.

To run Arma 3 with file patching add the `-filePatching` startup parameter.

Files must exist in the built PBOs for file patching to work. If you create a new file you must rebuild the PBO or Arma will not find it in your file paths.

### Disable CBA Function Caching

By default CBA caches a compiled version of functions to reduce mission load times. This interferes with file patching. There are three ways to disable function caching:

- Load `cba_cache_disable.pbo` (included in CBA’s `optionals` folder - simply move it to `addons` folder for the time being)
- Add the following to your test missions description.ext:

```cpp
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

```cpp
#define DISABLE_COMPILE_CACHE
```

### Restrictions

Configs are not patched during run time, only at load time. You do not have have to rebuild a PBO to make config changes, just restart Arma. You can get around this though if you are on the dev branch of Arma 3 and running the diagnostic exe. That includes `diag_mergeConfig` which takes a full system path (as in `p:\idi\clients\acre\addons\my_module\config.cpp`) and allows you to selectively reload config files.
