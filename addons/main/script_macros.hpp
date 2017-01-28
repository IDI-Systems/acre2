#define DEBUG_SYNCHRONOUS
#include "\x\cba\addons\main\script_macros_common.hpp"

#define CALL_RPC(proc,params) [proc, params] call EFUNC(sys_rpc,callRemoteProcedure);

#define NO_DEDICATED if (!hasInterface) exitWith {}

#define RGB_GREEN 0, 0.5, 0, 1
#define RGB_BLUE 0, 0, 1, 1
#define RGB_ORANGE 0.5, 0.5, 0, 1
#define RGB_RED 1, 0, 0, 1
#define RGB_YELLOW 1, 1, 0, 1
#define RGB_WHITE 1, 1, 1, 1
#define RGB_GRAY 0.5, 0.5, 0.5, 1
#define RGB_BLACK 0, 0, 0, 1
#define RGB_MAROON 0.5, 0, 0, 1
#define RGB_OLIVE 0.5, 0.5, 0, 1
#define RGB_NAVY 0, 0, 0.5, 1
#define RGB_PURPLE 0.5, 0, 0.5, 1
#define RGB_FUCHSIA 1, 0, 1, 1
#define RGB_AQUA 0, 1, 1, 1
#define RGB_TEAL 0, 0.5, 0.5, 1
#define RGB_LIME 0, 1, 0, 1
#define RGB_SILVER 0.75, 0.75, 0.75, 1

#define ACTIVE_RADIO "acre_active_radio"

#define IS_MUTED(playerObj) ([playerObj] call EFUNC(sys_core,isMuted))

#define GUI_INTERACT_EVENT EFUNC(sys_data,guiInteractEvent)
#define GUI_DATA_EVENT EFUNC(sys_data,guiDataEvent)


#define ACRE_DATA_NETPRIORITY_NONE 0
#define ACRE_DATA_NETPRIORITY_HIGH 1
#define ACRE_DATA_NETPRIORITY_MID 2
#define ACRE_DATA_NETPRIORITY_LOW 3

#include "script_radio_macro.hpp"

/*
Voice Curve Models
*/
#define ACRE_CURVE_MODEL_ORIGINAL 0
#define ACRE_CURVE_MODEL_AMPLITUDE 1
#define ACRE_CURVE_MODEL_SELECTABLE_A 2
#define ACRE_CURVE_MODEL_SELECTABLE_B 3

/*
Antenna Defines
*/
// polarization
#define VERTICAL_POLARIZE 0
#define HORIZONTAL_POLARIZE 1

#define AVERAGE_MAN_HEIGHT 1.8288


#define MACRO_ADDWEAPON(WEAPON,COUNT) class _xx_##WEAPON { \
    weapon = #WEAPON; \
    count = COUNT; \
}

#define MACRO_ADDITEM(ITEM,COUNT) class _xx_##ITEM { \
    name = #ITEM; \
    count = COUNT; \
}

#define MACRO_ADDMAGAZINE(MAGAZINE,COUNT) class _xx_##MAGAZINE { \
    magazine = #MAGAZINE; \
    count = COUNT; \
}

#define MACRO_ADDBACKPACK(BACKPACK,COUNT) class _xx_##BACKPACK { \
    backpack = #BACKPACK; \
    count = COUNT; \
}

#define LOAD_SOUND(className) [QUOTE(className)] call EFUNC(sys_sounds,loadSound);

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#define DEFUNC(var1,var2) TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)

#define GET_STATE(id)            ([GVAR(currentRadioId), "getState", id] call acre_sys_data_fnc_dataEvent)
#define SET_STATE(id, val)        ([GVAR(currentRadioId), "setState", [id, val]] call acre_sys_data_fnc_dataEvent)
#define SET_STATE_CRIT(id, val)    ([GVAR(currentRadioId), "setStateCritical", [id, val]] call acre_sys_data_fnc_dataEvent)
#define GET_STATE_DEF(id, default)    ([id, default] call FUNC(getDefaultState))

#define SCRATCH_SET(radioId, key, val) ([radioId, key, val] call EFUNC(sys_data,setScratchData))
#define SCRATCH_GET(radioId, key) ([radioId, key] call EFUNC(sys_data,getScratchData))
#define SCRATCH_GET_DEF(radioId, key, defaultVal) ([radioId, key, defaultVal] call EFUNC(sys_data,getScratchData))

#define GET_TS3ID(object) (object call { private _ret = (_this getVariable [QGVAR(ts3id), -1]); if (_ret == -1) then { WARNING_1("%1 has no TS3 ID",_this); }; _ret })

#define IS_HASH(hash) (hash isEqualType locationNull && {(text hash) isEqualTo "acre_hash"})

#define HASH_CREATE (call EFUNC(sys_core,fastHashCreate))
#define HASH_DELETE(hash) (FAST_HASH_TO_DELETE pushBack hash)
#define HASH_HASKEY(hash, key) (!(isNil {hash getVariable key}))
#define HASH_SET(hash, key, val) (hash setVariable [key, val])
#define HASH_GET(hash, key) (hash getVariable key)
#define HASH_REM(hash, key) (hash setVariable [key, nil])
#define HASH_COPY(hash) (hash call EFUNC(sys_core,fastHashCopy))
#define HASH_KEYS(hash) (hash call EFUNC(sys_core,fastHashKeys))

#define HASHLIST_CREATELIST(keys) []
#define HASHLIST_CREATEHASH(hashList) HASH_CREATE
#define HASHLIST_SELECT(hashList, index) (hashList select index)
#define HASHLIST_SET(hashList, index, value) (hashList set[index, value])
#define HASHLIST_PUSH(hashList, value) (hashList pushBack value)

#define BASECLASS(radioId) (configName (inheritsFrom (configFile >> "CfgWeapons" >> radioId)))

#define DGVAR(varName) if (isNil "ACRE_DEBUG_NAMESPACE") then { ACRE_DEBUG_NAMESPACE = []; }; if (!(QGVAR(varName) in ACRE_DEBUG_NAMESPACE)) then { ACRE_DEBUG_NAMESPACE pushBack QGVAR(varName); }; GVAR(varName)
#define DVAR(varName) if (isNil "ACRE_DEBUG_NAMESPACE") then { ACRE_DEBUG_NAMESPACE = []; }; if (!(QUOTE(varName) in ACRE_DEBUG_NAMESPACE)) then { ACRE_DEBUG_NAMESPACE pushBack QUOTE(varName); }; varName

// Dynamic sub-modules for systems
#define PREP_FOLDER(folder) [] call compile preprocessFileLineNumbers QUOTE(PATHTOF(folder\__PREP__.sqf))
#define PREP_MODULE(module, fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QUOTE(PATHTOF(module\DOUBLES(fnc,fncName).sqf))
#define PREP_STATE(stateFile) [] call compile preprocessFileLineNumbers format [QPATHTOF(states\%1.sqf), #stateFile]

// Deprecation
#define ACRE_DEPRECATED(arg1,arg2,arg3) WARNING_3("%1 is deprecated. Support will be dropped in version %2. Replaced by: %3",arg1,arg2,arg3)

#include "script_debug.hpp"
