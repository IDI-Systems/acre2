#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

[QGVAR(onRevealUnit), { _this call FUNC(onRevealUnit) }] call CALLSTACK(CBA_fnc_addEventHandler);

if (!hasInterface) exitWith {};

// Ensure the Mumble/TeamSpeak plugin handler code is initialized first
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
    params ["_code"];
    [] call (compile _code);
};

GVAR(aceLoaded) = isClass (configFile >> "CfgPatches" >> "ace_common");
// Do not use ACRE2 unique items if ACE3 is loaded.
if (!GVAR(aceLoaded)) then {
    ["loadout", {
        GVAR(uniqueItemsCache) = nil;
    }] call CBA_fnc_addPlayerEventHandler;
};

// Keybinds - PTT
["ACRE2", "AltPTTKey1", [localize LSTRING(AltPTTKey1), localize LSTRING(AltPTTKey1_description)], {
    [0] call FUNC(handleMultiPttKeyPress)
}, {
    [0] call FUNC(handleMultiPttKeyPressUp)
}, [DIK_CAPSLOCK, [false, false, false]]] call CBA_fnc_addKeybind;

["ACRE2", "AltPTTKey2", [localize LSTRING(AltPTTKey2), localize LSTRING(AltPTTKey2_description)], {
    [1] call FUNC(handleMultiPttKeyPress)
}, {
    [1] call FUNC(handleMultiPttKeyPressUp)
}, [DIK_CAPSLOCK, [false, true, false]]] call CBA_fnc_addKeybind;

["ACRE2", "AltPTTKey3", [localize LSTRING(AltPTTKey3), localize LSTRING(AltPTTKey3_description)], {
    [2] call FUNC(handleMultiPttKeyPress)
}, {
    [2] call FUNC(handleMultiPttKeyPressUp)
}, [DIK_CAPSLOCK, [false, false, true]]] call CBA_fnc_addKeybind;

["ACRE2", "DefaultPTTKey", [localize LSTRING(DefaultPTTKey), localize LSTRING(DefaultPTTKey_description)], {
    [-1] call FUNC(handleMultiPttKeyPress)
}, {
    [-1] call FUNC(handleMultiPttKeyPressUp)
}, [0, [false, false, false]]] call CBA_fnc_addKeybind;

// Keybinds - Channel Switch
["ACRE2", "PreviousChannel", localize LSTRING(PreviousChannel), "", {
    [-1] call FUNC(switchChannelFast)
}, [DIK_DOWNARROW, [false, true, false]]] call CBA_fnc_addKeybind;

["ACRE2", "NextChannel", localize LSTRING(NextChannel), "", {
    [1] call FUNC(switchChannelFast)
}, [DIK_UPARROW, [false, true, false]]] call CBA_fnc_addKeybind;

// Keybinds - Babel
["ACRE2", "BabelCycleKey", localize LSTRING(BabelCycleKey), "", {
    [] call FUNC(cycleLanguage)
}, [DIK_LWIN, [false, false, false]]] call CBA_fnc_addKeybind;

// Keybinds - Radio Ear
["ACRE2", "RadioLeftEar", localize LSTRING(RadioLeftEar), {
    [-1] call FUNC(switchRadioEar)
}, "", [DIK_LEFTARROW, [true, true, false]]] call CBA_fnc_addKeybind;

["ACRE2", "RadioCentertEar", localize LSTRING(RadioBothEars), {
    [0] call FUNC(switchRadioEar)
}, "", [DIK_UPARROW, [true, true, false]]] call CBA_fnc_addKeybind;

["ACRE2", "RightRightEar", localize LSTRING(RightRightEar), {
    [1] call FUNC(switchRadioEar)
}, "", [DIK_RIGHTARROW, [true, true, false]]] call CBA_fnc_addKeybind;

// Keybinds - Head Set
["ACRE2", "HeadSet", localize LSTRING(HeadSet), "", {
    [] call FUNC(toggleHeadset)
}, [DIK_DOWNARROW, [true, true, false]]] call CBA_fnc_addKeybind;

// Keybinds - Antenna Direction
["ACRE2", "acre_AntennaDirToggle", localize LSTRING(AntennaDirToggle), "", {
    [] call EFUNC(sys_components,toggleAntennaDir)
}, [DIK_UPARROW, [false, true, true]]] call CBA_fnc_addKeybind;


// Load map data
ACRE_MAP_LOADED = false;
// Do not load map in Main Menu, allDisplays only returns display 0 in main menu
if (!([findDisplay 0] isEqualTo allDisplays)) then {
    private _wrpLocation = getText(configFile >> "CfgAcreWorlds" >> worldName >> "wrp");
    if (_wrpLocation == "") then {
        _wrpLocation = getText(configFile >> "CfgWorlds" >> worldName >> "worldName");
    };
    private _radioSignalCode = [worldName] call EFUNC(sys_signal,getRadioClimateCode);
    INFO_2("Loading Map: %1 with radio signal code %2",_wrpLocation,_radioSignalCode);

    [
        "load_map",
        [_wrpLocation, _radioSignalCode],
        true,
        {
            params ["", "_result"];

            if (_result < 0) then {
                if (_result == -1) then {
                    WARNING_1("Map Load [%1] (WRP) parsing error - ACRE will now assume the terrain is flat and all at elevation 0m.",getText (configFile >> "CfgWorlds" >> worldName >> "worldName"));
                } else {
                    ERROR_MSG_1("ACRE was unable to parse the map [%1]. Please file a ticket on our tracker http://github.com/idi-systems/acre2 ",getText (configFile >> "CfgWorlds" >> worldName >> "worldName"));
                };
            } else {
                INFO_2("Map Load Complete: %1 with radio signal code %2",getText (configFile >> "CfgWorlds" >> worldName >> "worldName"),[worldName] call EFUNC(sys_signal,getRadioClimateCode));
            };

            ACRE_MAP_LOADED = true;
        },
        []
    ] call FUNC(callExt);
};
[] call FUNC(getClientIdLoop);


// Check whether ACRE2 is fully loaded
ADDPFH(DFUNC(coreInitPFH), 0, []);

//Store objects occupying crew seats, note this is empty if the player is not a crew member
ACRE_PLAYER_INTERCOM = [];

// Disable positional audio whilst in briefing
if (getClientStateNumber < 10) then { // Check before game has started (in briefing state or earlier)
    ["setSoundSystemMasterOverride", [1]] call EFUNC(sys_rpc,callRemoteProcedure);
    [{
        if (getClientStateNumber > 9 && {CBA_missionTime > 0}) then { // Briefing has been read AND Mission has started
            ["setSoundSystemMasterOverride", [0]] call EFUNC(sys_rpc,callRemoteProcedure);
            [_this select 1] call CBA_fnc_removePerFrameHandler;
        } else {
            // Keep calling incase ACRE is not connected to Mumble/TeamSpeak
            ["setSoundSystemMasterOverride", [1]] call EFUNC(sys_rpc,callRemoteProcedure);
        };
    }, 0, []] call CBA_fnc_addPerFrameHandler;
};

true
