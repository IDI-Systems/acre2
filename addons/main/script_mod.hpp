// COMPONENT should be defined in the script_component.hpp and included BEFORE this hpp

#define MAINPREFIX idi
#define PREFIX acre

//--BUILDPREFIX
#include "\idi\acre\addons\main\script_version.hpp"
//--ENDBUILDPREFIX

#define VERSION MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD
#define VERSION_PLUGIN MAJOR.MINOR.PATCHLVL.BUILD

#define ACRE_TAG ACRE

// MINIMAL required version for the Mod. Components can specify others..
#define REQUIRED_VERSION 1.64
#define REQUIRED_CBA_VERSION {3,1,0}

#define AUTHOR author = "ACRE2 Team"

#ifdef COMPONENT_BEAUTIFIED
    #define COMPONENT_NAME QUOTE(ACRE2 - COMPONENT_BEAUTIFIED)
#else
    #define COMPONENT_NAME QUOTE(ACRE2 - COMPONENT)
#endif
