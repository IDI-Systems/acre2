#include "script_component.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

if (!hasInterface) exitWith {};

LOAD_SOUND(Acre_GodBeep);
LOAD_SOUND(Acre_GodPingOn);
LOAD_SOUND(Acre_GodPingOff);

// CBA Event Handlers
[QGVAR(startSpeaking), {
    params ["_speakingId", "_speakingName", "_channel", "_channelEx"];

    #ifndef TEST_SELF_RX
    if (_speakingId == EGVAR(sys_core,ts3id)) exitWith {};
    #endif

    GVAR(speakingGods) pushBackUnique _speakingId;

    ["Acre_GodPingOn", [0,0,0], [0,0,0], EGVAR(sys_core,godVolume), false] call EFUNC(sys_sounds,playSound);

    if (GVAR(rxNotification)) then {
        _channel = localize _channel;
        if (_channelEx != "") then {
            if (isLocalized _channelEx) then {
                _channelEx = localize _channelEx;
            };
            _channel = format ["%1 (%2)", _channel, _channelEx];
        };

        [
            format [QGVAR(%1), _speakingId],
            format ["RX: %1", localize LSTRING(god)],
            _channel,
            _speakingName,
            -1,
            GVAR(rxNotificationColor)
        ] call EFUNC(sys_list,displayHint);
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(stopSpeaking), {
    params ["_speakingId"];

    GVAR(speakingGods) deleteAt (GVAR(speakingGods) find _speakingId);

    ["Acre_GodPingOff", [0,0,0], [0,0,0], EGVAR(sys_core,godVolume), false] call EFUNC(sys_sounds,playSound);

    [format [QGVAR(%1), _speakingId]] call EFUNC(sys_list,hideHint);
}] call CBA_fnc_addEventHandler;

[QGVAR(showText), {
    params ["_speakingName", "_text"];
    systemChat format ["God (%1): %2", _speakingName, _text];
}] call CBA_fnc_addEventHandler;

// Keybinds - God Mode
private _category = format ["ACRE2 %1", localize LSTRING(godMode)];
[_category, "GodModePTTKeyCurrentChannel", [localize LSTRING(currentChannelPttKey), localize LSTRING(currentChannelPttKey_description)], {
    [GODMODE_CURRENTCHANNEL] call FUNC(handlePttKeyPress)
}, {
    [GODMODE_CURRENTCHANNEL] call FUNC(handlePttKeyPressUp)
}, [DIK_MINUS, [false, true, false]]] call CBA_fnc_addKeybind;

[_category, "GodModePTTKeyGroup1", [localize LSTRING(group1PttKey), localize LSTRING(group1PttKey_description)], {
    [GODMODE_GROUP1] call FUNC(handlePttKeyPress)
}, {
    [GODMODE_GROUP1] call FUNC(handlePttKeyPressUp)
}, [DIK_MINUS, [false, false, true]]] call CBA_fnc_addKeybind;

[_category, "GodModePTTKeyGroup2", [localize LSTRING(group2PttKey), localize LSTRING(group2PttKey_description)], {
    [GODMODE_GROUP2] call FUNC(handlePttKeyPress)
}, {
    [GODMODE_GROUP2] call FUNC(handlePttKeyPressUp)
}, [DIK_MINUS, [true, false, false]]] call CBA_fnc_addKeybind;

[_category, "GodModePTTKeyGroup3", [localize LSTRING(group3PttKey), localize LSTRING(group3PttKey_description)], {
    [GODMODE_GROUP3] call FUNC(handlePttKeyPress)
}, {
    [GODMODE_GROUP3] call FUNC(handlePttKeyPressUp)
}, [DIK_MINUS, [false, true, true]]] call CBA_fnc_addKeybind;
