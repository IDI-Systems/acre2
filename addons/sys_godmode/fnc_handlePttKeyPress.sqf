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
            case 0: { localize "str_channel_global" };
            case 1: { localize "str_channel_side" };
            case 3: { localize "str_channel_group" };
            case 4: { localize "str_channel_vehicle" };
            default { localize "str_disp_other" };
        };
        _channel = format ["%1 (%2)", localize LSTRING(currentChannel_display), _currentBIChannel];
    };
    case GODMODE_GROUP1: {
        GVAR(targetUnits) = (GVAR(groupPresets) select 0) select {alive _x};
        _channel = localize LSTRING(group1);
    };
    case GODMODE_GROUP2: {
        GVAR(targetUnits) = (GVAR(groupPresets) select 1) select {alive _x};
        _channel = localize LSTRING(group2);
    };
    case GODMODE_GROUP3: {
        GVAR(targetUnits) = (GVAR(groupPresets) select 2) select {alive _x};
        _channel = localize LSTRING(group3);
    };
    default { ERROR_1("Invalid action %1",_action); };
};

// Enable after debug phase
//if (GVAR(targetUnits) isEqualTo []) exitWith {
//    WARNING("No units in the selected group.");
//    false
//};

[QGVAR(startSpeaking), [acre_player], GVAR(targetUnits)] call CBA_fnc_targetEvent;

["startGodModeSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);

if (GVAR(txNotification)) then {
    GVAR(txNotificationLayer) = [format ["TX: %1", localize LSTRING(god)], _channel, "", -1, GVAR(notificationColor)] call EFUNC(sys_list,displayHint);
};

true
