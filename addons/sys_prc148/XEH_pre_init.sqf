#include "script_component.hpp"
#define PREP_STATE(stateFile)    [] call (compile preprocessFileLineNumbers format["\idi\acre\addons\sys_prc148\states\%1.sqf", #stateFile])

ADDON = false;

PREP_FOLDER(radio);
PREP_FOLDER(menus);

PREP(initializeRadio);

PREP(closeGui);
PREP(openGui);
PREP(preset_information);
PREP(render);

PREP_STATE(AccessDenied);
PREP_STATE(ChannelDisplays);
PREP_STATE(Group);
PREP_STATE(MainDisplays);
PREP_STATE(ModeDisplays);
PREP_STATE(OffDisplay);
PREP_STATE(ProgramDisplays);
PREP_STATE(ProgrammingDisplays);
PREP_STATE(StartUp);

[] call FUNC(preset_information);
