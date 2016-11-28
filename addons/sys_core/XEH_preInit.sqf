#include "script_component.hpp"

NO_DEDICATED;

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#include "initSettings.sqf"

/**
*
*
*
*/

// globals
DGVAR(lowered) = 0;
DGVAR(muting) = [];
DGVAR(speakers) = [];
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
DVAR(ACRE_SPECTATOR_VOLUME) = 1;

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

DVAR(ACRE_AI_ENABLED) = true;
DGVAR(monitorAIHandle) = -1;

DVAR(ACRE_FULL_DUPLEX) = false;
DVAR(ACRE_INTERFERENCE) = true;

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

_acrePlayerFnc = {
    acre_player = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];
    /*if(cameraOn != acre_player) then {
        if(lifeState cameraOn != "") then {
            acre_player = cameraOn;
        };
    };*/
};
ADDPFH(_acrePlayerFnc, 0, []);

#ifdef USE_DEBUG_EXTENSIONS
"acre_dynload" callExtension format["load:%1", "idi\build\win32\Debug\acre.dll"];
#endif

private _monitorFnc = {
    private _res = ["fetch_result", ""] call FUNC(callExt);
    while {!isNil "_res"} do {
        // diag_log text format["RES: %1", _res];
        private _id = _res select 0;
        private _callBack = GVAR(threadedExtCalls) select _id;
        if(IS_ARRAY(_callBack)) then {
            private _args = (_res select 1);
            if(count _args > 0) then {
                _args = _args select 0;
            };
            [_callBack select 0, _args] call (_callBack select 1);
        };
        _res = ["fetch_result", ""] call FUNC(callExt);
    };
};
ADDPFH(_monitorFnc, 0, []);

ACRE_TESTANGLES = [];
_m = 8;
_spread = 75;
for "_i" from 1 to (_m/2) do {
    _positive = (_spread/_m)*_i;
    _negative = ((_spread/_m)*_i)*-1;
    PUSH(ACRE_TESTANGLES, _positive);
    if(_positive != _negative) then {
        PUSH(ACRE_TESTANGLES, _negative);
    };
};


ADDON = true;
