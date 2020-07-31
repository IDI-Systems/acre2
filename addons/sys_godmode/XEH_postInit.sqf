#include "script_component.hpp"

if (!hasInterface) exitWith {};

// CBA Event Handlers
[QGVAR(startSpeaking), {
    params ["_speakingUnit"];

    // Debug
    if (GVAR(speakingGods) find _speakingUnit != -1) then {
        ERROR_1("Tryied to add an already speaking God....",_speakingUnit);
    };

    GVAR(speakingGods) pushBackUnique _speakingUnit;

    // [[ICON_RADIO_CALL], ["Receiving God message!"]] call CBA_fnc_notify;
}] call CBA_fnc_addEventHandler;

[QGVAR(stopSpeaking), {
    params ["_speakingUnit"];

    // Debug
    if (GVAR(speakingGods) isEqualTo []) then {
        ERROR_1("Empty speaking Gods array while trying to delete %1!",_speakingUnit);
    };

    GVAR(speakingGods) deleteAt (GVAR(speakingGods) find _speakingUnit);

    // [[ICON_RADIO_CALL], ["God message ended!"]] call CBA_fnc_notify;
}] call CBA_fnc_addEventHandler;

[QGVAR(showText), {
    params ["_text"];

    private _notifyText = format ["God message: %1", _text];

    [[ICON_RADIO_CALL], [_notifyText]] call CBA_fnc_notify;
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
