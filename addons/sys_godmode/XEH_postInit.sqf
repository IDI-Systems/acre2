#include "script_component.hpp"

if (!hasInterface) exitWith {};

// CBA Event Handlers
[QGVAR(godModeStart), {
    params ["_speakingUnit"];

    // Debug
    if (GVAR(speakingGods) find _speakingUnit != -1) then {
    	ERROR_1("Tryied to add an already speaking God....",_speakingUnit);
    };

    GVAR(speakingGods) pushBackUnique _speakingUnit;

    // [[ICON_RADIO_CALL], ["Receiving God message!"]] call CBA_fnc_notify;
}] call CBA_fnc_addEventHandler;

[QGVAR(godModeStop), {
    params ["_speakingUnit"];

    // Debug
   	if (GVAR(speakingGods) isEqualTo []) then {
   		ERROR_1("Empty speaking Gods array while trying to delete %1!",_speakingUnit);
   	};

    GVAR(speakingGods) deleteAt (GVAR(speakingGods) find _speakingUnit);

    // [[ICON_RADIO_CALL], ["God message ended!"]] call CBA_fnc_notify;
}] call CBA_fnc_addEventHandler;

[QGVAR(godModeText), {
    params ["_text"];

    private _notifyText = format ["God message: %1", _text];

    [[ICON_RADIO_CALL], [_notifyText]] call CBA_fnc_notify;
}] call CBA_fnc_addEventHandler;

// Keybinds - God Mode
["ACRE2", "GodModePTTKeyCurrentChannel", [localize LSTRING(currentChannelPttKey), localize LSTRING(currentChannelPttKey_description)], {
    [GODMODE_CURRENTCHANNEL] call FUNC(handlePttKeyPress)
}, {
    [] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;

["ACRE2", "GodModePTTKeyGroup1", [localize LSTRING(group1PttKey), localize LSTRING(group1PttKey_description)], {
    [GODMODE_GROUP1] call FUNC(handlePttKeyPress)
}, {
    [] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;

["ACRE2", "GodModePTTKeyGroup2", [localize LSTRING(group2PttKey), localize LSTRING(group2PttKey_description)], {
    [GODMODE_GROUP2] call FUNC(handlePttKeyPress)
}, {
    [] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;

["ACRE2", "GodModePTTKeyGroup3", [localize LSTRING(group3PttKey), localize LSTRING(group3PttKey_description)], {
    [GODMODE_GROUP3] call FUNC(handlePttKeyPress)
}, {
    [] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;
