#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

[QGVAR(onRevealUnit), { _this call FUNC(onRevealUnit) }] call CALLSTACK(CBA_fnc_addEventHandler);

["CBA_loadoutGet", {
    params ["", "_loadout", ""];
    [_loadout] call EFUNC(api,filterUnitLoadout);
}] call CBA_fnc_addEventHandler;

if (!hasInterface) exitWith {};

// Connect to the voice server (via the voice extension); the core init waits for it.
[] call EFUNC(sys_io,startClient);

// Keep the extension up to date with our transmissions, radio channels and camera, and keep our
// voice peer ID published on whichever unit we control.
[FUNC(voiceStatePFH), 0.25, []] call CBA_fnc_addPerFrameHandler;
// Map diary page with the voice connection status
[FUNC(updateDiary), 2, []] call CBA_fnc_addPerFrameHandler;
["unit", {
    params ["_newUnit"];
    if (GVAR(ts3id) != -1) then {
        _newUnit setVariable [QGVAR(ts3id), GVAR(ts3id), true];
    };
    if (GVAR(micMuted)) then {
        _newUnit setVariable [QGVAR(micMuted), true, true];
    };
}] call CBA_fnc_addPlayerEventHandler;

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

// Keybind - direct speech push-to-talk (when voice activation is set to push-to-talk)
// Released after ACRE_PTT_RELEASE_DELAY like the radio keys; pressing again meanwhile keeps it open.
["ACRE2", "DirectPTTKey", [localize LSTRING(DirectPTTKey), localize LSTRING(DirectPTTKey_description)], {
    ["direct"] call FUNC(pttPressed);
    ["vox:ptt", [true]] call EFUNC(sys_io,ext);
    false
}, {
    ["direct", {["vox:ptt", [false]] call EFUNC(sys_io,ext)}] call FUNC(pttReleased);
    false
}, [0, [false, false, false]]] call CBA_fnc_addKeybind;

// Keybind - mute our microphone (toggle)
["ACRE2", "MicMute", [localize LSTRING(MicMute), localize LSTRING(MicMute_description)], {
    [!GVAR(micMuted)] call FUNC(setMicMuted);
    true
}, "", [DIK_M, [true, true, false]]] call CBA_fnc_addKeybind;

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
}, [DIK_RALT, [false, false, false]]] call CBA_fnc_addKeybind;

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
if ([findDisplay 0] isNotEqualTo allDisplays) then {
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
            params ["_callbackArgs", "_result"];
            _callbackArgs params ["_wrpLocation"];

            if (_result < 0) then {
                if (_result == -1) then {
                    WARNING_1("Map Load [%1] (WRP) parsing error - ACRE will now assume the terrain is flat and all at elevation 0m.",_wrpLocation);
                } else {
                    ERROR_MSG_2("ACRE was unable to parse the map [%1]\nACRE will now use Arcade signal propagation model.\nPlease file a ticket on our tracker: %2",_wrpLocation,LELSTRING(Main,URL));
                };
            } else {
                INFO_2("Map Load Complete: %1 with radio signal code %2",_wrpLocation,[worldName] call EFUNC(sys_signal,getRadioClimateCode));
            };

            ACRE_MAP_LOADED = true;
        },
        [_wrpLocation]
    ] call FUNC(callExt);
};

// Check whether ACRE2 is fully loaded
[DFUNC(coreInitPFH), 0, []] call CBA_fnc_addPerFrameHandler;

//Store objects occupying crew seats, note this is empty if the player is not a crew member
ACRE_PLAYER_INTERCOM = [];

// Disable positional audio whilst in briefing (everyone heard plainly)
if (getClientStateNumber < 10) then { // Check before game has started (in briefing state or earlier)
    // Everyone talks to everyone: the voice server routes direct speech over the briefing channel.
    GVAR(inBriefing) = true;
    ["settings:override", [true]] call EFUNC(sys_io,ext);
    [{
        if (getClientStateNumber > 9 && {CBA_missionTime > 0}) then { // Briefing has been read AND Mission has started
            GVAR(inBriefing) = false;
            ["settings:override", [false]] call EFUNC(sys_io,ext);
            [_this select 1] call CBA_fnc_removePerFrameHandler;
        };
    }, 0, []] call CBA_fnc_addPerFrameHandler;
};

true
