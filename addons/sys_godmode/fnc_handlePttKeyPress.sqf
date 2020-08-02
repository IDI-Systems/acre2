#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Used to handle a keypress for God Mode PTT transmission.
 *
 * Arguments:
 * 0: Action <NUMBER>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [1] call acre_sys_godmode_fnc_handlePttKeyPress
 *
 * Public: No
 */

params ["_action"];

if !([_action] call FUNC(accessAllowed)) exitWith { false };

private _channel = "";
switch (_action) do {
    case GODMODE_CURRENTCHANNEL: {
        GVAR(targetUnits) = [] call FUNC(getUnitsBIChannel);

        private _currentBIChannel = switch (currentChannel) do {
            case 0: { "Global" };
            case 1: { "Side" };
            case 3: { "Group" };
            case 4: { "Vehicle" };
            default { "Other" };
        };
        _channel = format ["Current Channel (%1)", _currentBIChannel]; // TODO Stringtable
    };
    case GODMODE_GROUP1: {
        GVAR(targetUnits) = (GVAR(groupPresets) select 0) select {alive _x};
        _channel = "Group 1"; // TODO Stringtable
    };
    case GODMODE_GROUP2: {
        GVAR(targetUnits) = (GVAR(groupPresets) select 1) select {alive _x};
        _channel = "Group 2"; // TODO Stringtable
    };
    case GODMODE_GROUP3: {
        GVAR(targetUnits) = (GVAR(groupPresets) select 2) select {alive _x};
        _channel = "Group 3"; // TODO Stringtable
    };
    default { ERROR_1("Invalid action %1",_action); };
};

// Enable after debug phase
//if (GVAR(targetUnits) isEqualTo []) exitWith {
//    WARNING("No units in the selected group.");
//    false
//};

[QGVAR(startSpeaking), [acre_player], GVAR(targetUnits)] call CBA_fnc_targetEvent;

// Give some time to process
[EFUNC(sys_rpc,callRemoteProcedure), ["startGodModeSpeaking", ""]] call CBA_fnc_execNextFrame;

if (GVAR(txNotification)) then {
    GVAR(txNotificationLayer) = [format ["TX: %1", localize LSTRING(god)], _channel, "", -1, GVAR(notificationColor)] call EFUNC(sys_list,displayHint);
};

true
