#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#include "initSettings.sqf" // CBA Settings

// Fast hashes
FUNC(fastHashCreate) = {
    if (count FAST_HASH_POOL > 0) exitWith {
        private _ret = (FAST_HASH_POOL deleteAt 0);
        FAST_HASH_CREATED_HASHES_NEW pushBack _ret;
        _ret
    };

    private _ret = HASH_CREATE_NAMESPACE;
    FAST_HASH_CREATED_HASHES_NEW pushBack _ret;
    _ret
};

if (isNil "FAST_HASH_POOL") then {
    ACRE_FAST_HASH_POOL = [];
    for "_i" from 1 to 50000 do {
        FAST_HASH_POOL pushBack HASH_CREATE_NAMESPACE;
    };
};
ACRE_FAST_HASH_TO_DELETE = [];

[FUNC(hashMonitor), 0.33, []] call cba_fnc_addPerFrameHandler;

ACRE_FAST_HASH_CREATED_HASHES = [];
ACRE_FAST_HASH_VAR_STATE = (allVariables missionNamespace);
ACRE_FAST_HASH_VAR_LENGTH = count FAST_HASH_VAR_STATE;
ACRE_FAST_HASH_GC_INDEX = 0;
ACRE_FAST_HASH_GC_FOUND_OBJECTS = [];
ACRE_FAST_HASH_GC_FOUND_ARRAYS = [];
ACRE_FAST_HASH_GC_CHECK_OBJECTS = [];
ACRE_FAST_HASH_CREATED_HASHES_NEW = [];
ACRE_FAST_HASH_GC_IGNORE = ["fast_hash_gc_found_objects","fast_hash_gc_found_arrays","fast_hash_created_hashes","fast_hash_gc_check_objects","fast_hash_created_hashes_new","fast_hash_var_state","fast_hash_pool","fast_hash_to_delete"];
ACRE_FAST_HASH_GC_ORPHAN_CHECK_INDEX = 0;

[FUNC(garbageCollector), 0.25, []] call CBA_fnc_addPerFrameHandler;


if (!hasInterface) exitWith {
    ADDON = true;
};

/**
*
*
*
*/

// globals
DGVAR(lowered) = 0;
DGVAR(muting) = [];
DGVAR(speakers) = [];
DGVAR(enableDistanceMuting) = true;
DGVAR(ts3id) = -1;
DGVAR(keyedMicRadios) = [];
DGVAR(keyedRadioIds) = HASH_CREATE;
DGVAR(globalVolume) = 1.0;
DGVAR(maxVolume) = 1.0;
DGVAR(playerList) = []; // Paired array: [TS_ID, Object]
//DGVAR(ts3IdPlayerList) = [];
DGVAR(isDeaf) = false;
//DGVAR(playerListHash) = HASH_CREATE;
DGVAR(spectatorSpeakers) = [];

DGVAR(threadedExtCalls) = [];

DGVAR(nearRadios) = [];

DGVAR(pttKeyDown) = false;

DGVAR(speaking_cache_valid) = false;

DVAR(ACRE_SPIT_VERSION) = false;
DVAR(ACRE_IS_SYNCING) = false;
DVAR(ACRE_SPECTATORS_LIST) = [];
DVAR(ACRE_HAS_WARNED) = false;

DVAR(ACRE_LOCAL_BROADCASTING) = false;
DVAR(ACRE_LOCAL_SPEAKING) = false;

DVAR(ACRE_MUTE_SPECTATORS) = false;
DVAR(ACRE_CORE_INIT) = false;

DVAR(ACRE_VOICE_CURVE_MODEL) = ACRE_CURVE_MODEL_SELECTABLE_B;
DVAR(ACRE_VOICE_CURVE_SCALE) = 1.0;

DVAR(ACRE_LISTENER_POS) = [0,0,0];
DVAR(ACRE_LISTENER_DIR) = [0,1,0];
DVAR(ACRE_LISTENER_DIVE) = 0;

DVAR(ACRE_PTT_RELEASE_DELAY) = 0.2;
DVAR(ACRE_ASSIGNED_PTT_RADIOS) = [];
GVAR(delayReleasePTT_Handle) = nil;

DVAR(ACRE_ACTIVE_PTTKEY) = -2;
DVAR(ACRE_BROADCASTING_RADIOID) = "";

DVAR(ACRE_CURRENT_LANGUAGE_ID) = 0;
DVAR(ACRE_SPOKEN_LANGUAGES) = [];

DGVAR(monitorAIHandle) = -1;

DGVAR(languages) = [];

DVAR(ACRE_TEST_OCCLUSION) = true;
DVAR(ACRE_SIGNAL_DEBUGGING) = 0;

acre_player = player;

GVAR(coreCache) = HASH_CREATE;

acre_sys_io_ioEventFnc = {
    BEGIN_COUNTER(ioEventFunction);
    _this call EFUNC(sys_rpc,handleData);
    END_COUNTER(ioEventFunction);
};

["unit", {
    acre_player = (_this select 0);
}] call CBA_fnc_addPlayerEventHandler;

#ifdef USE_DEBUG_EXTENSIONS
"acre_dynload" callExtension format["load:%1", "idi\build\win32\Debug\acre.dll"];
#endif

private _monitorFnc = {
    private _res = ["fetch_result", ""] call FUNC(callExt);
    while {!isNil "_res"} do {
        // diag_log text format["RES: %1", _res];
        private _id = _res select 0;
        private _callBack = GVAR(threadedExtCalls) select _id;
        if (IS_ARRAY(_callBack)) then {
            private _args = (_res select 1);
            if (count _args > 0) then {
                _args = _args select 0;
            };
            [_callBack select 0, _args] call (_callBack select 1);
        };
        _res = ["fetch_result", ""] call FUNC(callExt);
    };
};
ADDPFH(_monitorFnc, 0, []);

ACRE_TESTANGLES = [];
private _m = 8;
private _spread = 75;
for "_i" from 1 to (_m/2) do {
    private _positive = (_spread/_m)*_i;
    private _negative = ((_spread/_m)*_i)*-1;
    ACRE_TESTANGLES pushBack _positive;
    if (_positive != _negative) then {
        ACRE_TESTANGLES pushBack _negative;
    };
};


ADDON = true;
