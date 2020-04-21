#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// CBA Settings
#include "initSettings.sqf"

if (!hasInterface) exitWith {
    ADDON = true;
};

/**
*
*
*
*/

// globals
DGVAR(antennaDirUp) = false;
DGVAR(lowered) = false;
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
DVAR(ACRE_BROADCASTING_NOTIFICATION_LAYER) = ""; // Name of the notification system layer where the current broadcast is displayed

DVAR(ACRE_CURRENT_LANGUAGE_ID) = 0;
DVAR(ACRE_SPOKEN_LANGUAGES) = [];

DGVAR(monitorAIHandle) = -1;

DGVAR(languages) = [];

DVAR(ACRE_TEST_OCCLUSION) = true;
DVAR(ACRE_SIGNAL_DEBUGGING) = 0;

DVAR(ACRE_ACTIVE_EXTERNAL_RADIOS) = [];          // Radios not in player's inventory
DVAR(ACRE_EXTERNALLY_USED_MANPACK_RADIOS) = [];  // Manpack radios in player's inventory that are being used externally
DVAR(ACRE_EXTERNALLY_USED_PERSONAL_RADIOS) = []; // Personal radios in player's inventory that are being used externally
DVAR(ACRE_ACCESSIBLE_RACK_RADIOS) = [];          // Extra radios that a player can use, should be used for radios that are racked
DVAR(ACRE_HEARABLE_RACK_RADIOS) = [];            // Extra rack radios that a player can use
DVAR(ACRE_ARSENAL_RADIOS) = [];                  // Radios that are 'stashed' while arsenal is open.
DVAR(ACRE_BLOCKED_TRANSMITTING_RADIOS) = [];

DGVAR(arsenalOpen) = false;

acre_player = player;

GVAR(coreCache) = HASH_CREATE;

acre_sys_io_ioEventFnc = {
    #ifdef ENABLE_PERFORMANCE_COUNTERS
        BEGIN_COUNTER(ioEventFunction);
    #endif
    _this call EFUNC(sys_rpc,handleData);
    #ifdef ENABLE_PERFORMANCE_COUNTERS
        END_COUNTER(ioEventFunction);
    #endif
};

["unit", {
    acre_current_player = _this select 0;
    acre_player = acre_current_player;
    if !(acre_player isEqualTo player) then {
        if (acre_current_player getVariable [QEGVAR(sys_zeus,usePlayer), EGVAR(sys_zeus,zeusDefaultVoiceSource)]) then {
            acre_player = player;
        };
    };
}] call CBA_fnc_addPlayerEventHandler;

#ifdef USE_DEBUG_EXTENSIONS
"acre_dynload" callExtension format["load:%1", "idi\build\win32\Debug\acre.dll"];
#endif

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

addMissionEventHandler ["ExtensionCallback", {
    params ["_name", "_function", "_data"];
    if (_name != "ACRE_TR") exitWith {};
    (parseSimpleArray _data) params ["_id", "_args"];
    TRACE_2("ExtensionCallback",_function,_id);

    private _callBack = GVAR(threadedExtCalls) select _id;

    if (IS_ARRAY(_callBack)) then {
        if !(_args isEqualTo []) then {
            _args = _args select 0;
        };
        [_callBack select 0, _args] call (_callBack select 1);
    };
}];


ADDON = true;
