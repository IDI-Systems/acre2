#define DEBUG_SYNCHRONOUS
#include "\x\cba\addons\main\script_macros_common.hpp"

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

#define ACRE_NOTIFICATION_WHITE 0.8, 0.8, 0.8, 1
#define ACRE_NOTIFICATION_BLACK 0, 0, 0, 1
#define ACRE_NOTIFICATION_YELLOW 1, 0.8, 0, 1
#define ACRE_NOTIFICATION_RED 1, 0.29, 0.16, 1
#define ACRE_NOTIFICATION_GREEN 0.13, 0.61, 0.12, 1
#define ACRE_NOTIFICATION_BLUE 0.08, 0.71, 1, 1
#define ACRE_NOTIFICATION_PURPLE 0.66, 0.05, 1, 1
#define ACRE_NOTIFICATION_BG_BLACK 0, 0, 0, 0.8


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

/*
Speaking Type Defines
SQF equivalent of extensions/src/ACRE2Shared/Types.h
*/
#define SPEAKING_TYPE_DIRECT    0
#define SPEAKING_TYPE_RADIO     1
#define SPEAKING_TYPE_UNKNOWN   2
#define SPEAKING_TYPE_INTERCOM  3
#define SPEAKING_TYPE_SPECTATE  4
#define SPEAKING_TYPE_GOD       5
#define SPEAKING_TYPE_ZEUS      6


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

#define GET_STATE(id)            ([GVAR(currentRadioId), "getState", id] call EFUNC(sys_data,dataEvent))
#define SET_STATE(id, val)        ([GVAR(currentRadioId),"setState",[id,val]] call EFUNC(sys_data,dataEvent))
#define SET_STATE_CRIT(id, val)    ([GVAR(currentRadioId), "setStateCritical",[id,val]] call EFUNC(sys_data,dataEvent))
#define GET_STATE_DEF(id, default)    ([id,default] call FUNC(getDefaultState))

#define SCRATCH_SET(radioId, key, val) ([radioId,key,val] call EFUNC(sys_data,setScratchData))
#define SCRATCH_GET(radioId, key) ([radioId,key] call EFUNC(sys_data,getScratchData))
#define SCRATCH_GET_DEF(radioId, key, defaultVal) ([radioId,key,defaultVal] call EFUNC(sys_data,getScratchData))

#define GET_TS3ID(object) (object call { private _ret = (_this getVariable [QGVAR(ts3id), -1]); if (_ret == -1) then { WARNING_1("%1 has no TS3 ID",_this); }; _ret })

#define IS_HASH(hash) (hash isEqualType locationNull && {(type hash) isEqualTo "ACRE_FastHashNamespaceDummy"})

#define HASH_CREATE_NAMESPACE (createLocation ["ACRE_FastHashNamespaceDummy", [-1000, -1000, 0], 0, 0])
#define HASH_CREATE (call EFUNC(main,fastHashCreate))
#define HASH_DELETE(hash) (ACRE_FAST_HASH_TO_DELETE pushBack hash)
#define HASH_HASKEY(hash, key) (!(isNil {hash getVariable key}))
#define HASH_SET(hash, key, val) (hash setVariable [key,val])
#define HASH_GET(hash, key) (hash getVariable key)
#define HASH_REM(hash, key) (hash setVariable [key,nil])
#define HASH_COPY(hash) (hash call EFUNC(main,fastHashCopy))
#define HASH_KEYS(hash) (hash call EFUNC(main,fastHashKeys))

#define HASHLIST_CREATELIST(keys) []
#define HASHLIST_CREATEHASH(hashList) HASH_CREATE
#define HASHLIST_SELECT(hashList, index) (hashList select index)
#define HASHLIST_SET(hashList, index, value) (hashList set[index,value])
#define HASHLIST_PUSH(hashList, value) (hashList pushBack value)

#define BASECLASS(radioId) ([radioId] call EFUNC(sys_radio,getRadioBaseClassname))

#define DGVAR(varName) if (isNil "ACRE_DEBUG_NAMESPACE") then { ACRE_DEBUG_NAMESPACE = []; }; if (!(QGVAR(varName) in ACRE_DEBUG_NAMESPACE)) then { ACRE_DEBUG_NAMESPACE pushBack QGVAR(varName); }; GVAR(varName)
#define DVAR(varName) if (isNil "ACRE_DEBUG_NAMESPACE") then { ACRE_DEBUG_NAMESPACE = []; }; if (!(QUOTE(varName) in ACRE_DEBUG_NAMESPACE)) then { ACRE_DEBUG_NAMESPACE pushBack QUOTE(varName); }; varName

// Dynamic sub-modules for systems
// #define DISABLE_COMPILE_CACHE
#ifdef DISABLE_COMPILE_CACHE
    #define PREP_MODULE(module, fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(module\DOUBLES(fnc,fncName).sqf)
#else
    #define PREP_MODULE(module, fncName) [QPATHTOF(module\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif
#define PREP_FOLDER(folder) [] call compile preprocessFileLineNumbers QPATHTOF(folder\__PREP__.sqf)
#define PREP_STATE(stateFile) [] call compile preprocessFileLineNumbers format [QPATHTOF(states\%1.sqf), #stateFile]
#define PREP_MENU(menuType) [] call compile preprocessFileLineNumbers QPATHTOF(menus\types\menuType.sqf)
#define MENU_DEFINITION(folder,menu) [] call compile preprocessFileLineNumbers QPATHTOF(folder\menu.sqf);

// Deprecation
#define ACRE_DEPRECATED(arg1,arg2,arg3) WARNING_3("%1 is deprecated. Support will be dropped in version %2. Replaced by: %3",arg1,arg2,arg3)

// Icons
#define ICON_RADIO_CALL "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"

#define BASE_CLASS_CONFIG(configName) call { private _baseClass = getText(configFile >> "CfgWeapons" >> configName >> "acre_baseClass"); if (_baseClass == "") then { _baseClass = getText(configFile >> "CfgVehicles" >> configName >> "acre_baseClass"); }; _baseClass }

#include "script_debug.hpp"
