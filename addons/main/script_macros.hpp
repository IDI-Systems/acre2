#define DISABLE_COMPILE_CACHE

#include "\idi\acre\addons\game\script_common_macros.hpp"

#ifndef PRELOAD_ADDONS
#define PRELOAD_ADDONS class CfgAddons \
{ \
    class PreloadAddons \
    { \
        class ADDON \
        { \
            list[]={ QUOTE(ADDON) }; \
        }; \
    }; \
};
#endif

/**
ARMA2/VBS2 COMPAT SECTION
**/

#include "\idi\acre\addons\game\script_lib.hpp"
#include "\idi\acre\addons\game\script_command_replace.hpp"


/**
END ARMA2/VBS2 COMPAT SECTION
**/

// local event handler naming macro
#define ACRE_EVENT(x) QUOTE(acre_##x)

#define CALL_RPC(proc,params)    [proc, params] call acre_sys_rpc_fnc_callRemoteProcedure;

#define NO_DEDICATED    if(!hasInterface) exitWith { }
#define NO_CLIENT        if(!isServer) exitWith { }

#define ACRE_OBELISK    acre_sys_server_obelisk

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

#define FREE_RADIO_POSTFIX "_freeRadio"
#define METADATA_POSTFIX "_metadata"

#define MASTER_RADIO_LIST "a2ts_sys_radio_masterRadioList"
#define ACRE_OBELISK acre_sys_server_obelisk

#define INDEX_CARRY_BY         0
#define INDEX_USE_BY         1

#define ACTIVE_RADIO "acre_active_radio"

#define ACRE_INDEX_CONTROLLERDATA        2
#define ACRE_INDEX_UIDATA                1
#define ACRE_INDEX_TXDATA                0

#define ACRE_INDEX_FREQUENCY            0
#define ACRE_INDEX_POWER                1

#define ACRE_CONTROLLERDATA(var) (var select ACRE_INDEX_CONTROLLERDATA)
#define ACRE_UIDATA(var) (var select ACRE_INDEX_UIDATA)
#define ACRE_TXDATA(var) (var select ACRE_INDEX_TXDATA)

#define ACRE_SET_CONTROLLERDATA(var, data) var set [ACRE_INDEX_CONTROLLERDATA, data]
#define ACRE_SET_UIDATA(var, data) var set [ACRE_INDEX_UIDATA, data]
#define ACRE_SET_TXDATA(var, data) var set [ACRE_INDEX_TXDATA, data]

#define ACRE_FREQ(var) ((var select ACRE_INDEX_TXDATA) select ACRE_INDEX_FREQUENCY)
#define ACRE_POWER(var) ((var select ACRE_INDEX_TXDATA) select ACRE_INDEX_POWER)

#define ACRE_HINT(title,line1,line2)    [title, line1, line2] call acre_sys_list_fnc_displayHint;

#define ACRE_DEBUG_LOG(message,value1)                                    ACRE_DEBUG_STR = ACRE_DEBUG_STR + format["%1 %2:%3 %4%5", COMPAT_diag_tickTime, __FILE__, __LINE__, QUOTE(message), toStr[10]];\
                                                                        player sideChat format["%1 %2:%3 %4", COMPAT_diag_tickTime, __FILE__, __LINE__, QUOTE(message)];

#define ACRE_DEBUG_TRACE1(message,value1)                                ACRE_DEBUG_STR = ACRE_DEBUG_STR + format["%1 %2:%3 %4 %5%6", COMPAT_diag_tickTime, __FILE__, __LINE__, QUOTE(message), value1, toStr[10]];\
                                                                        player sideChat format["%1 %2:%3 %4%5", COMPAT_diag_tickTime, __FILE__, __LINE__, QUOTE(message), value1];

#define ACRE_DEBUG_TRACE2(message,value1,value2)                        ACRE_DEBUG_STR = ACRE_DEBUG_STR + format["%1 %2:%3 %4 %5 %6%7", COMPAT_diag_tickTime, __FILE__, __LINE__, QUOTE(message), value1, value2, toStr[10]];\
                                                                        player sideChat format["%1 %2:%3 %4 %5 %6", COMPAT_diag_tickTime, __FILE__, __LINE__, QUOTE(message), value1, value2];

#define ACRE_DEBUG_TRACE3(message,value1,value2,value3)                    ACRE_DEBUG_STR = ACRE_DEBUG_STR + format["%1 %2:%3 %4 %5 %6 %7%8", COMPAT_diag_tickTime, __FILE__, __LINE__, QUOTE(message), value1, value2, value3, toStr[10]];\
                                                                        player sideChat format["%1 %2:%3 %4 %5 %6 %7", COMPAT_diag_tickTime, __FILE__, __LINE__, QUOTE(message), value1, value2, value3];

#define ACRE_DEBUG_TRACE4(message,value1,value2,value3,value4)            ACRE_DEBUG_STR = ACRE_DEBUG_STR + format["%1 %2:%3 %4 %5 %6 %7 %8%9", COMPAT_diag_tickTime, __FILE__, __LINE__, QUOTE(message), value1, value2, value3, value4, toStr[10]];\
                                                                        player sideChat format["%1 %2:%3 %4 %5 %6 %7 %8", COMPAT_diag_tickTime, __FILE__, __LINE__, QUOTE(message), value1, value2, value3, value4];

#define ACRE_DEBUG_TRACE5(message,value1,value2,value3,value4,value5)    ACRE_DEBUG_STR = ACRE_DEBUG_STR + format["%1 %2:%3 %4 %5 %6 %7 %8 %9%10", COMPAT_diag_tickTime, __FILE__, __LINE__, QUOTE(message), value1, value2, value3, value4, value5, toStr[10]];\
                                                                        player sideChat format["%1 %2:%3 %4 %5 %6 %7 %8 %9", COMPAT_diag_tickTime, __FILE__, __LINE__, QUOTE(message), value1, value2, value3, value4, value5];


#define ACRE_DEBUG_FLUSH                copyToClipboard ACRE_DEBUG_STR;\
                                        ACRE_DEBUG_STR = "";


#define IS_REMOTE(radio)

#define IS_MUTED(playerObj) ([playerObj] call acre_sys_core_fnc_isMuted)

#define __CFG_GAPI_FUNCTION(x, y) getText ( configFile >> "CfgAcreComponents" >> x >> "interface" >> y )

#define GUI_INTERACT_EVENT    EFUNC(sys_data,guiInteractEvent)
#define GUI_DATA_EVENT        EFUNC(sys_data,guiDataEvent)

#define IS_HASH(hash) (hash isEqualType locationNull && {(text hash) == "acre_hash"})


/*
#define HASH_CREATE                    [] call { diag_log text format["%1 %2:%3 HASH CREATED", diag_tickTime, __FILE__, __LINE__]; ([] call LIB_fnc_hashCreate) }
#define HASH_SET(hash, key, val)    [hash, key, val] call { diag_log text format["%1 %2:%3 HASH SET hash=%4, key=%5 val=%6", diag_tickTime, __FILE__, __LINE__, #hash, key, val]; (_this call LIB_fnc_hashSet) }
#define HASH_GET(hash, key)            [hash, key] call { diag_log text format["%1 %2:%3 HASH GET hash=%4, key=%5", diag_tickTime, __FILE__, __LINE__, #hash, key]; (_this call LIB_fnc_hashGet) }
*/
#define TS3ID2PLAYER(id)    [id] call acre_sys_core_fnc_ts3idToPlayer


#define ACRE_DATA_NETPRIORITY_NONE        0
#define ACRE_DATA_NETPRIORITY_HIGH        1
#define ACRE_DATA_NETPRIORITY_MID        2
#define ACRE_DATA_NETPRIORITY_LOW        3

#include "script_radio_macro.hpp"

/*
Voice Curve Models
*/
#define    ACRE_CURVE_MODEL_ORIGINAL        0
#define    ACRE_CURVE_MODEL_AMPLITUDE        1
#define    ACRE_CURVE_MODEL_SELECTABLE_A    2
#define    ACRE_CURVE_MODEL_SELECTABLE_B    3

/*
Antenna Defines
*/
// polarization
#define VERTICAL_POLARIZE    0
#define HORIZONTAL_POLARIZE    1

#define AVERAGE_MAN_HEIGHT    1.8288

#define ACRE_M_MAG(x,y)    class _xx_##x {magazine = ##x; count = ##y;}
#define ACRE_M_WEP(x,y)    class _xx_##x {weapon = ##x; count = ##y;}

#define ACRE_TEXT_RED(Text) ("<t color='#FF0000'>" + ##Text + "</t>")

#define ACREALIVE(obj)        (alive obj)

#define REMOTEDEBUGMSG(msg)    ["acre_sys_server_remoteDebugMsg", msg] call LIB_fnc_globalEvent;

#define LOAD_SOUND(className)    [QUOTE(className)] call acre_sys_sounds_fnc_loadSound;

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




#define SCRATCH_SET(radioId, key, val)    ([radioId, key, val] call acre_sys_data_fnc_setScratchData)
#define SCRATCH_GET(radioId, key)    ([radioId, key] call acre_sys_data_fnc_getScratchData)
#define SCRATCH_GET_DEF(radioId, key, defaultVal)    ([radioId, key, defaultVal] call acre_sys_data_fnc_getScratchData)

#define GET_TS3ID(object)    (object call { private _ret = (_this getVariable [QUOTE(GVAR(ts3id)), -1]); if(_ret == -1) then { COMPAT_diag_log text format["%1 has no TS3 ID at %2:%3", _this, __FILE__, __LINE__]; }; _ret })
/*
#define HASH_CREATE                    ([] call CALLSTACK(LIB_fnc_hashCreate))
#define HASH_SET(hash, key, val)    ([hash, key, val, __FILE__, __LINE__] call CALLSTACK(LIB_fnc_hashSet))
#define HASH_GET(hash, key)            ([hash, key, __FILE__, __LINE__] call CALLSTACK(LIB_fnc_hashGet))
#define HASH_REM(hash, key)            ([hash, key, __FILE__, __LINE__] call CALLSTACK(LIB_fnc_hashRem))
#define HASH_HASKEY(hash, key)        ([hash, key, __FILE__, __LINE__] call CALLSTACK(LIB_fnc_hashHasKey))
*/
#define HASH_CREATE (call acre_lib_fnc_fastHashCreate)
#define HASH_DELETE(hash) (FAST_HASH_TO_DELETE pushBack hash)
#define HASH_HASKEY(hash, key) (!(isNil {hash getVariable key}))
#define HASH_SET(hash, key, val) (hash setVariable [key, val])
#define HASH_GET(hash, key) (hash getVariable key)
#define HASH_REM(hash, key) (hash setVariable [key, nil])
#define HASH_COPY(hash) (hash call acre_lib_fnc_fastHashCopy)
#define HASH_KEYS(hash) (hash call acre_lib_fnc_fastHashKeys)
/*
#define HASHLIST_CREATELIST(keys)                ([keys] call CALLSTACK(LIB_fnc_hashListCreateList))
#define HASHLIST_CREATEHASH(hashList)            ([hashList] call CALLSTACK(LIB_fnc_hashListCreateHash))
#define HASHLIST_SELECT(hashList, index)        ([hashList, index, __FILE__, __LINE__] call LIB_fnc_hashListSelect)
#define HASHLIST_SET(hashList, index, value)    ([hashList, index, value, __FILE__, __LINE__] call LIB_fnc_hashListSet)
#define HASHLIST_PUSH(hashList, value)            ([hashList, value, __FILE__, __LINE__] call LIB_fnc_hashListPush)
*/

#define HASHLIST_CREATELIST(keys)                []
#define HASHLIST_CREATEHASH(hashList)            HASH_CREATE
#define HASHLIST_SELECT(hashList, index)        (hashList select index)
#define HASHLIST_SET(hashList, index, value)    (hashList set[index, value])
#define HASHLIST_PUSH(hashList, value)            (hashList pushBack value)


#define RADIO_POS(class)        ([class] call acre_sys_radio_fnc_getRadioPos)
#define RADIO_OBJECT(class)        ([class] call acre_sys_radio_fnc_getRadioObject)
#define RADIO_SUBOJBECT(class)    ([class] call acre_sys_radio_fnc_getRadioSubObject)
#define RADIO_SAMEOBJECT(class)    ([class] call acre_sys_radio_fnc_radioObjectsSame)
#define NEAR_RADIOS(position, radius)    ([position, radius] call acre_sys_radio_fnc_nearRadios)

#define BASECLASS(radioId)    (configName (inheritsFrom (configFile >> "CfgWeapons" >> radioId)))

#define ACRE_DEBUG

#ifdef ACRE_DEBUG
#define LOG_COUNT(name, count, value)    [name, count, value] call acre_sys_debug_countLog
#endif

#undef ARR_1
#define ARR_1(val1)                                    [val1]
#undef ARR_2
#define ARR_2(val1, val2)                            [val1, val2]
#undef ARR_3
#define ARR_3(val1, val2, val3)                        [val1, val2, val3]
#undef ARR_4
#define ARR_4(val1, val2, val3, val4)                [val1, val2, val3, val4]
#undef ARR_5
#define ARR_5(val1, val2, val3, val4, val5)            [val1, val2, val3, val4, val5]
#undef ARR_6
#define ARR_6(val1, val2, val3, val4, val5, val6)    [val1, val2, val3, val4, val5, val6]



#define DGVAR(varName)    if(isNil "ACRE_DEBUG_NAMESPACE") then { ACRE_DEBUG_NAMESPACE = []; }; if(!(QUOTE(GVAR(varName)) in ACRE_DEBUG_NAMESPACE)) then { PUSH(ACRE_DEBUG_NAMESPACE, QUOTE(GVAR(varName))); }; GVAR(varName)
#define DVAR(varName)     if(isNil "ACRE_DEBUG_NAMESPACE") then { ACRE_DEBUG_NAMESPACE = []; }; if(!(QUOTE(varName) in ACRE_DEBUG_NAMESPACE)) then { PUSH(ACRE_DEBUG_NAMESPACE, QUOTE(varName)); }; varName

#define ACRE_getAllCuratorObjects    ([] call { private _returnArray = []; { _returnArray pushBack (getAssignedCuratorUnit _x); } forEach allCurators; _returnArray; })

// Dynamic sub-modules for systems
#define PREP_FOLDER(folder) [] call compile preprocessFileLineNumbers QUOTE(PATHTOF(folder\__PREP__.sqf))
#define PREP_MODULE(module, fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QUOTE(PATHTOF(module\DOUBLES(fnc,fncName).sqf))

/**
PERFORMANCE COUNTERS SECTION
**/
//#define ACRE_PERFORMANCE_COUNTERS

#ifdef ACRE_PERFORMANCE_COUNTERS
    #define ADDPFH(function, timing, args) call { _ret = [function, timing, args, #function] call EFUNC(sys_sync,perFrame_add); if(isNil "ACRE_PFH" ) then { ACRE_PFH=[]; }; ACRE_PFH pushBack [[_ret, __FILE__, __LINE__], [function, timing, args]];  _ret }

    #define CREATE_COUNTER(x) if(isNil "ACRE_COUNTERS" ) then { ACRE_COUNTERS=[]; }; GVAR(DOUBLES(x,counter))=[]; GVAR(DOUBLES(x,counter)) set[0, QUOTE(GVAR(DOUBLES(x,counter)))];  GVAR(DOUBLES(x,counter)) set[1, diag_tickTime]; ACRE_COUNTERS pushBack GVAR(DOUBLES(x,counter));
    #define BEGIN_COUNTER(x) if(isNil QUOTE(GVAR(DOUBLES(x,counter)))) then { CREATE_COUNTER(x) }; GVAR(DOUBLES(x,counter)) set[2, diag_tickTime];
    #define END_COUNTER(x) GVAR(DOUBLES(x,counter)) pushBack [(GVAR(DOUBLES(x,counter)) select 2), diag_tickTime];

    #define DUMP_COUNTERS ([__FILE__, __LINE__] call ACRE_DUMPCOUNTERS_FNC)
#else
    #define ADDPFH(function, timing, args)    [function, timing, args, #function] call EFUNC(sys_sync,perFrame_add)

    #define CREATE_COUNTER(x) /* disabled */
    #define BEGIN_COUNTER(x) /* disabled */
    #define END_COUNTER(x) /* disabled */
    #define DUMP_COUNTERS  /* disabled */
#endif
