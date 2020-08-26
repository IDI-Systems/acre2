#include "script_component.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

if (!hasInterface) exitWith {};

LOAD_SOUND(Acre_GenericBeep);
LOAD_SOUND(Acre_GenericClickOn);
LOAD_SOUND(Acre_GenericClickOff);

// CBA Event Handlers
[QGVAR(startSpeaking), {
    params ["_speakingId", "_speakingName", "_channel", "_channelEx"];

    #ifndef ALLOW_SELF_RX
    if (_speakingId == EGVAR(sys_core,ts3id)) exitWith {};
    #endif

    GVAR(speakingGods) pushBackUnique _speakingId;

    ["Acre_GenericClickOn", [0,0,0], [0,0,0], EGVAR(sys_core,godVolume), false] call EFUNC(sys_sounds,playSound);

    if (GVAR(rxNotification)) then {
        _channel = localize _channel;
        if (_channelEx != "") then {
            if (isLocalized _channelEx) then {
                _channelEx = localize _channelEx;
            };
            _channel = format ["%1 (%2)", _channel, _channelEx];
        };

        private _notificationLayer = [
            format ["RX: %1", localize LSTRING(god)],
            _channel,
            _speakingName,
            -1,
            GVAR(rxNotificationColor)
        ] call EFUNC(sys_list,displayHint);
        GVAR(rxNotificationLayers) setVariable [str _speakingId, _notificationLayer];
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(stopSpeaking), {
    params ["_speakingId"];

    GVAR(speakingGods) deleteAt (GVAR(speakingGods) find _speakingId);

    ["Acre_GenericClickOff", [0,0,0], [0,0,0], EGVAR(sys_core,godVolume), false] call EFUNC(sys_sounds,playSound);

    private _notificationLayer = GVAR(rxNotificationLayers) getVariable [str _speakingId, ""];
    if (_notificationLayer != "") then {
        [_notificationLayer] call EFUNC(sys_list,hideHint);
        GVAR(rxNotificationLayers) setVariable [str _speakingId, ""];
    }
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
