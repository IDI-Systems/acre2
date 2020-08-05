#include "script_component.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

if (!hasInterface) exitWith {};

// CBA Event Handlers
[QGVAR(startSpeaking), {
    params ["_speakingUnit", "_channel", "_channelEx"];

    GVAR(speakingGods) pushBackUnique _speakingUnit;

    if (GVAR(rxNotification)) then {
        _channel = _channel;
        if (_channelEx != "") then {
            if (isLocalized _channelEx) then {
                _channelEx = localize _channelEx;
            };
            _channel = format ["%1 (%2)", _channel, _channelEx];
        };

        private _notificationLayer = [
            format ["RX: %1", localize LSTRING(god)],
            _channel,
            name _speakingUnit,
            -1,
            GVAR(rxNotificationColor)
        ] call EFUNC(sys_list,displayHint);
        GVAR(rxNotificationLayers) setVariable [getPlayerUID _speakingUnit, _notificationLayer];
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(stopSpeaking), {
    params ["_speakingUnit"];

    GVAR(speakingGods) deleteAt (GVAR(speakingGods) find _speakingUnit);

    private _speakingUID = getPlayerUID _speakingUnit;
    private _notificationLayer = GVAR(rxNotificationLayers) getVariable [_speakingUID, ""];
    if (_notificationLayer != "") then {
        [_notificationLayer] call EFUNC(sys_list,hideHint);
        GVAR(rxNotificationLayers) setVariable [_speakingUID, ""];
    }
}] call CBA_fnc_addEventHandler;

[QGVAR(showText), {
    params ["_speakingUnit", "_text"];
    systemChat format ["God (%1): %2", name _speakingUnit, _text];
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
