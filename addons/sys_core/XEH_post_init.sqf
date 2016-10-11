#include "script_component.hpp"
NO_DEDICATED;


[] call EFUNC(sys_io,startServer);

["handleGetClientID", FUNC(handleGetClientID)] call EFUNC(sys_rpc,addProcedure);
["handleGetPluginVersion", FUNC(handleGetPluginVersion)] call EFUNC(sys_rpc,addProcedure);
["handleGetHeadVector", FUNC(handleGetHeadVector)] call EFUNC(sys_rpc,addProcedure);
["remoteStartSpeaking", FUNC(remoteStartSpeaking)] call EFUNC(sys_rpc,addProcedure);
["remoteStopSpeaking", FUNC(remoteStopSpeaking)] call EFUNC(sys_rpc,addProcedure);
["localStartSpeaking", FUNC(localStartSpeaking)] call EFUNC(sys_rpc,addProcedure);
["localStopSpeaking", FUNC(localStopSpeaking)] call EFUNC(sys_rpc,addProcedure);
["pong", FUNC(pong)] call EFUNC(sys_rpc,addProcedure);
["gen", FUNC(gen)] call EFUNC(sys_rpc,addProcedure);

DFUNC(gen) = {
    params["_code"];
    [] call (compile _code);
};


///////////////////////////////////
//
// CBA KEYBINDS
///////////////////////////////////

["ACRE2", "DefaultPTTKey", ["Default Radio Key", "Use currently selected radio to talk."], { [-1] call FUNC(handleMultiPttKeyPress) }, { [-1] call FUNC(handleMultiPttKeyPressUp) }, [58, [false, false, false]]] call cba_fnc_addKeybind;
["ACRE2", "AltPTTKey1", ["Alt Radio Key 1", "Use the first radio in your inventory to talk."], { [0] call FUNC(handleMultiPttKeyPress) }, { [0] call FUNC(handleMultiPttKeyPressUp) }, [58, [true, false, false]]] call cba_fnc_addKeybind;
["ACRE2", "AltPTTKey2", ["Alt Radio Key 2", "Use the second radio in your inventory to talk."], { [1] call FUNC(handleMultiPttKeyPress) }, { [1] call FUNC(handleMultiPttKeyPressUp) }, [58, [false, true, false]]] call cba_fnc_addKeybind;
["ACRE2", "AltPTTKey3", ["Alt Radio Key 3", "Use the third radio in your inventory to talk."], { [2] call FUNC(handleMultiPttKeyPress) }, { [2] call FUNC(handleMultiPttKeyPressUp) }, [58, [false, false, true]]] call cba_fnc_addKeybind;

["ACRE2", "PreviousChannel", "Previous Channel (Active Radio)", "", { [-1] call FUNC(switchChannelFast) }, [208, [false, true, false]]] call cba_fnc_addKeybind;
["ACRE2", "NextChannel", "Next Channel (Active Radio)", "", { [1] call FUNC(switchChannelFast) }, [200, [false, true, false]]] call cba_fnc_addKeybind;

["ACRE2", "BabelCycleKey", "Babel Cycle Language", "", { [] call FUNC(cycleLanguage) }, [0xDB, [false, false, false]]] call cba_fnc_addKeybind;

["ACRE2", "RadioLeftEar", "Radio Left Ear", { [-1] call FUNC(switchRadioEar) }, "", [203, [true, true, false]]] call cba_fnc_addKeybind;
["ACRE2", "RadioCentertEar", "Radio Center Ear", { [0] call FUNC(switchRadioEar) }, "", [200, [true, true, false]]] call cba_fnc_addKeybind;
["ACRE2", "RightRightEar", "Radio Right Ear", { [1] call FUNC(switchRadioEar) }, "", [205, [true, true, false]]] call cba_fnc_addKeybind;

["ACRE2", "HeadSet", "Toggle Headset/Toggle Spectators", "", { [] call FUNC(toggleHeadset) }, [208, [true, true, false]]] call cba_fnc_addKeybind;

///////////////////////////////////
///////////////////////////////////

ACRE_MAP_LOADED = false;
[
    "init",
    []
] call FUNC(callExt);

private _wrpLocation = getText(configFile >> "CfgAcreWorlds" >> worldName >> "wrp");
if (_wrpLocation == "") then {
    _wrpLocation = getText(configFile >> "CfgWorlds" >> worldName >> "worldName");
};
INFO_1("Loading Map: %1",_wrpLocation);

[
    "load_map",
    [_wrpLocation],
    true,
    {
        ACRE_MAP_LOADED = true;
        INFO_1("Map Load Complete: %1",getText (configFile >> "CfgWorlds" >> worldName >> "worldName"));
    },
    []
] call FUNC(callExt);
[] call FUNC(getClientIdLoop);
DFUNC(coreInitPFH) = { // OK
    if (isNull player) exitWith { };
    acre_player = player;
    if(!ACRE_MAP_LOADED) exitWith { };
    if(!ACRE_DATA_SYNCED) exitWith { };
    if(GVAR(ts3id) == -1) exitWith { };
    TRACE_1("GOT TS3 ID", GVAR(ts3id));
    [] call FUNC(utilityFunction); // OK
    [] call FUNC(muting);
    [] call FUNC(speaking);

    //Set the speaking volume to normal.
    [.7] call acre_api_fnc_setSelectableVoiceCurve;
    acre_sys_gui_VolumeControl_Level = 0;

    ACRE_CORE_INIT = true;
    TRACE_1("ACRE CORE INIT", ACRE_CORE_INIT);
    [(_this select 1)] call CBA_fnc_removePerFrameHandler;
};

ADDPFH(DFUNC(coreInitPFH), 0, []);

// Call our setter to enable AI reveal if its been set here
if(ACRE_AI_ENABLED && hasInterface) then {
    INFO("AI Detection Activated.");
    [] call FUNC(enableRevealAI);
} else {
    INFO("AI Detection Not Active.");
};

[QGVAR(onRevealUnit), { _this call FUNC(onRevealUnit) }] call CALLSTACK(CBA_fnc_addEventHandler);

ACRE_PLAYER_VEHICLE_CREW = [];
//Store objects occupying crew seats, note this is empty if the player is not a crew member.

private _vehicleCrewPFH = {
    private _vehicle = vehicle acre_player;
    if (_vehicle != acre_player) then {
        private _crew = [driver _vehicle, gunner _vehicle, commander _vehicle];
        {
            _crew pushBackUnique (_vehicle turretUnit _x);
        } forEach (allTurrets [_vehicle, false]);
        _crew = _crew - [objNull];
        if (acre_player in _crew) then {
            ACRE_PLAYER_VEHICLE_CREW = _crew;
        } else {
            ACRE_PLAYER_VEHICLE_CREW = [];
        };
    } else {
        ACRE_PLAYER_VEHICLE_CREW = [];
    };
};
ADDPFH(_vehicleCrewPFH, 1.1, []);

// Disable positional audio whilst in briefing.
if (getClientStateNumber < 10) then { // Check before game has started (in briefing state or earlier)
    ["setSoundSystemMasterOverride", [1]] call EFUNC(sys_rpc,callRemoteProcedure);
    private _briefingCheck = {
        if (getClientStateNumber > 9 && time > 0) then { // Briefing has been read AND Mission has started.
            ["setSoundSystemMasterOverride", [0]] call EFUNC(sys_rpc,callRemoteProcedure);
            [(_this select 1)] call CBA_fnc_removePerFrameHandler;
        } else {
            // Keep calling incase ACRE is not connected to teamspeak.
            ["setSoundSystemMasterOverride", [1]] call EFUNC(sys_rpc,callRemoteProcedure);
        };
    };
    ADDPFH(_briefingCheck, 0, []);
};

true
