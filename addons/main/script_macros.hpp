#include "\x\cba\addons\main\script_macros_common.hpp"

#define CALL_RPC(proc,params) [proc, params] call EFUNC(sys_rpc,callRemoteProcedure);

#define NO_DEDICATED if (!hasInterface) exitWith {}
#define NO_CLIENT if (!isServer) exitWith {}

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

#define IS_ARRAY(array) array isEqualType []
#define IS_HASH(hash) (hash isEqualType locationNull && {(text hash) == "acre_hash"})


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


#define REMOTEDEBUGMSG(msg) [QEGVAR(sys_server,remoteDebugMsg), msg] call CBA_fnc_globalEvent;

#define LOAD_SOUND(className) [QUOTE(className)] call EFUNC(sys_sounds,loadSound);

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)

#ifdef ENABLE_CALLSTACK
    #define CALLSTACK(function) {private ['_ret']; if(ACRE_IS_ERRORED) then { ['AUTO','AUTO'] call ACRE_DUMPSTACK_FNC; ACRE_IS_ERRORED = false; }; ACRE_IS_ERRORED = true; ACRE_STACK_TRACE set [ACRE_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, ACRE_CURRENT_FUNCTION, 'ANON', _this]]; ACRE_STACK_DEPTH = ACRE_STACK_DEPTH + 1; ACRE_CURRENT_FUNCTION = 'ANON'; _ret = _this call ##function; ACRE_STACK_DEPTH = ACRE_STACK_DEPTH - 1; ACRE_IS_ERRORED = false; _ret;}
    #define CALLSTACK_NAMED(function, functionName) {private ['_ret']; if(ACRE_IS_ERRORED) then { ['AUTO','AUTO'] call ACRE_DUMPSTACK_FNC; ACRE_IS_ERRORED = false; }; ACRE_IS_ERRORED = true; ACRE_STACK_TRACE set [ACRE_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, ACRE_CURRENT_FUNCTION, functionName, _this]]; ACRE_STACK_DEPTH = ACRE_STACK_DEPTH + 1; ACRE_CURRENT_FUNCTION = functionName; _ret = _this call ##function; ACRE_STACK_DEPTH = ACRE_STACK_DEPTH - 1; ACRE_IS_ERRORED = false; _ret;}
    #define DUMPSTACK ([__FILE__, __LINE__] call ACRE_DUMPSTACK_FNC)

    #define FUNC(var1) {private ['_ret']; if(ACRE_IS_ERRORED) then { ['AUTO','AUTO'] call ACRE_DUMPSTACK_FNC; ACRE_IS_ERRORED = false; }; ACRE_IS_ERRORED = true; ACRE_STACK_TRACE set [ACRE_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, ACRE_CURRENT_FUNCTION, 'TRIPLES(ADDON,fnc,var1)', _this]]; ACRE_STACK_DEPTH = ACRE_STACK_DEPTH + 1; ACRE_CURRENT_FUNCTION = 'TRIPLES(ADDON,fnc,var1)'; _ret = _this call TRIPLES(ADDON,fnc,var1); ACRE_STACK_DEPTH = ACRE_STACK_DEPTH - 1; ACRE_IS_ERRORED = false; _ret;}
    #define EFUNC(var1,var2) {private ['_ret']; if(ACRE_IS_ERRORED) then { ['AUTO','AUTO'] call ACRE_DUMPSTACK_FNC; ACRE_IS_ERRORED = false; }; ACRE_IS_ERRORED = true; ACRE_STACK_TRACE set [ACRE_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, ACRE_CURRENT_FUNCTION, 'TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)', _this]]; ACRE_STACK_DEPTH = ACRE_STACK_DEPTH + 1; ACRE_CURRENT_FUNCTION = 'TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)'; _ret = _this call TRIPLES(DOUBLES(PREFIX,var1),fnc,var2); ACRE_STACK_DEPTH = ACRE_STACK_DEPTH - 1; ACRE_IS_ERRORED = false; _ret;}
#else
    #define CALLSTACK(function) function
    #define CALLSTACK_NAMED(function, functionName) function
    #define DUMPSTACK
#endif



#define SCRATCH_SET(radioId, key, val) ([radioId, key, val] call EFUNC(sys_data,setScratchData))
#define SCRATCH_GET(radioId, key) ([radioId, key] call EFUNC(sys_data,getScratchData))
#define SCRATCH_GET_DEF(radioId, key, defaultVal) ([radioId, key, defaultVal] call EFUNC(sys_data,getScratchData))

#define GET_TS3ID(object) (object call { private _ret = (_this getVariable [QUOTE(GVAR(ts3id)), -1]); if(_ret == -1) then { diag_log text format["%1 has no TS3 ID at %2:%3", _this, __FILE__, __LINE__]; }; _ret })


#define HASH_CREATE (call EFUNC(lib,fastHashCreate))
#define HASH_DELETE(hash) (FAST_HASH_TO_DELETE pushBack hash)
#define HASH_HASKEY(hash, key) (!(isNil {hash getVariable key}))
#define HASH_SET(hash, key, val) (hash setVariable [key, val])
#define HASH_GET(hash, key) (hash getVariable key)
#define HASH_REM(hash, key) (hash setVariable [key, nil])
#define HASH_COPY(hash) (hash call EFUNC(lib,fastHashCopy))
#define HASH_KEYS(hash) (hash call EFUNC(lib,fastHashKeys))

#define HASHLIST_CREATELIST(keys) []
#define HASHLIST_CREATEHASH(hashList) HASH_CREATE
#define HASHLIST_SELECT(hashList, index) (hashList select index)
#define HASHLIST_SET(hashList, index, value) (hashList set[index, value])
#define HASHLIST_PUSH(hashList, value) (hashList pushBack value)


#define BASECLASS(radioId) (configName (inheritsFrom (configFile >> "CfgWeapons" >> radioId)))

#define DGVAR(varName)    if(isNil "ACRE_DEBUG_NAMESPACE") then { ACRE_DEBUG_NAMESPACE = []; }; if(!(QUOTE(GVAR(varName)) in ACRE_DEBUG_NAMESPACE)) then { PUSH(ACRE_DEBUG_NAMESPACE, QUOTE(GVAR(varName))); }; GVAR(varName)
#define DVAR(varName)     if(isNil "ACRE_DEBUG_NAMESPACE") then { ACRE_DEBUG_NAMESPACE = []; }; if(!(QUOTE(varName) in ACRE_DEBUG_NAMESPACE)) then { PUSH(ACRE_DEBUG_NAMESPACE, QUOTE(varName)); }; varName

// Dynamic sub-modules for systems
#define PREP_FOLDER(folder) [] call compile preprocessFileLineNumbers QUOTE(PATHTOF(folder\__PREP__.sqf))
#define PREP_MODULE(module, fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QUOTE(PATHTOF(module\DOUBLES(fnc,fncName).sqf))

/**
PERFORMANCE COUNTERS
**/
#ifdef ENABLE_PERFORMANCE_COUNTERS
    #define ADDPFH(function, timing, args) call { _ret = [function, timing, args] call CBA_fnc_addPerFrameHandler; if(isNil "ACRE_PFH" ) then { ACRE_PFH=[]; }; ACRE_PFH pushBack [[_ret, __FILE__, __LINE__], [function, timing, args]];  _ret }

    #define CREATE_COUNTER(x) if(isNil "ACRE_COUNTERS" ) then { ACRE_COUNTERS=[]; }; GVAR(DOUBLES(x,counter))=[]; GVAR(DOUBLES(x,counter)) set[0, QUOTE(GVAR(DOUBLES(x,counter)))];  GVAR(DOUBLES(x,counter)) set[1, diag_tickTime]; ACRE_COUNTERS pushBack GVAR(DOUBLES(x,counter));
    #define BEGIN_COUNTER(x) if(isNil QUOTE(GVAR(DOUBLES(x,counter)))) then { CREATE_COUNTER(x) }; GVAR(DOUBLES(x,counter)) set[2, diag_tickTime];
    #define END_COUNTER(x) GVAR(DOUBLES(x,counter)) pushBack [(GVAR(DOUBLES(x,counter)) select 2), diag_tickTime];

    #define DUMP_COUNTERS ([__FILE__, __LINE__] call ACRE_DUMPCOUNTERS_FNC)
#else
    #define ADDPFH(function, timing, args) [function, timing, args] call CBA_fnc_addPerFrameHandler

    #define CREATE_COUNTER(x) /* disabled */
    #define BEGIN_COUNTER(x) /* disabled */
    #define END_COUNTER(x) /* disabled */
    #define DUMP_COUNTERS  /* disabled */
#endif
