#include "script_component.hpp"

#define PREP_STATE(stateFile) [] call (compile preprocessFileLineNumbers format["\idi\acre\addons\sys_prc148\states\%1.sqf", #stateFile])

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

[] call FUNC(preset_information);

ADDON = true;
