#include "script_component.hpp"

if (!hasInterface) exitWith {};

// CBA Event Handlers
[QGVAR(startSpeaking), {
    params ["_speakingUnit"];

    if (GVAR(rxNotification)) then {
        private _notificationLayer = [format ["RX: %1", localize LSTRING(god)], name _speakingUnit, "", -1, GVAR(notificationColor)] call EFUNC(sys_list,displayHint);
        GVAR(rxNotificationLayers) setVariable [getPlayerUID _speakingUnit, _notificationLayer];
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(stopSpeaking), {
    params ["_speakingUnit"];

    private _speakingUID = getPlayerUID _speakingUnit;
    private _notificationLayer = GVAR(rxNotificationLayers) getVariable [_speakingUID, ""];
    if (_notificationLayer != "") then {
        [_notificationLayer] call EFUNC(sys_list,hideHint);
        GVAR(rxNotificationLayers) setVariable [_speakingUID, ""];
    }
}] call CBA_fnc_addEventHandler;

[QGVAR(showText), {
    params ["_text"];
    systemChat format ["God: %1", _text];
}] call CBA_fnc_addEventHandler;

// Keybinds - God Mode
private _category = format ["ACRE2 %1", localize LSTRING(godMode)];
[_category, "GodModePTTKeyCurrentChannel", [localize LSTRING(currentChannelPttKey), localize LSTRING(currentChannelPttKey_description)], {
    [GODMODE_CURRENTCHANNEL] call FUNC(handlePttKeyPress)
}, {
    [GODMODE_CURRENTCHANNEL] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;

[_category, "GodModePTTKeyGroup1", [localize LSTRING(group1PttKey), localize LSTRING(group1PttKey_description)], {
    [GODMODE_GROUP1] call FUNC(handlePttKeyPress)
}, {
    [GODMODE_GROUP1] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;

[_category, "GodModePTTKeyGroup2", [localize LSTRING(group2PttKey), localize LSTRING(group2PttKey_description)], {
    [GODMODE_GROUP2] call FUNC(handlePttKeyPress)
}, {
    [GODMODE_GROUP2] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;

[_category, "GodModePTTKeyGroup3", [localize LSTRING(group3PttKey), localize LSTRING(group3PttKey_description)], {
    [GODMODE_GROUP3] call FUNC(handlePttKeyPress)
}, {
    [GODMODE_GROUP3] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;
