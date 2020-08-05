#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Used to handle a keypress for God Mode PTT transmission.
 *
 * Arguments:
 * 0: Group index (0-based index) <NUMBER>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [1] call acre_sys_godmode_fnc_handlePttKeyPress
 *
 * Public: No
 */

params ["_group"];

if !([_group] call FUNC(accessAllowed)) exitWith { false };

private _channel = "";
private _channelEx = "";
private _color = [ACRE_NOTIFICATION_WHITE];
switch (_group) do {
    case GODMODE_CURRENTCHANNEL: {
        GVAR(targetUnits) = [] call FUNC(getUnitsBIChannel);

        private _currentBIChannel = switch (currentChannel) do {
            case 0: { "str_channel_global" };
            case 1: { "str_channel_side" };
            case 3: { "str_channel_group" };
            case 4: { "str_channel_vehicle" };
            default { "str_disp_other" };
        };
        //_channel = format ["%1 (%2)", localize LSTRING(currentChannel_display), _currentBIChannel];
        _channel = LSTRING(currentChannel_display);
        _channelEx = _currentBIChannel;
        _color = GVAR(txNotificationCurrentChatColor);
    };
    case GODMODE_GROUP1: {
        GVAR(targetUnits) = (GVAR(groupPresets) select 0) select {alive _x};
        _channel = GVAR(groupNames) select 0;
        _color = GVAR(txNotificationGroup1Color);
    };
    case GODMODE_GROUP2: {
        GVAR(targetUnits) = (GVAR(groupPresets) select 1) select {alive _x};
        _channel = GVAR(groupNames) select 1;
        _color = GVAR(txNotificationGroup2Color);
    };
    case GODMODE_GROUP3: {
        GVAR(targetUnits) = (GVAR(groupPresets) select 2) select {alive _x};
        _channel = GVAR(groupNames) select 2;
        _color = GVAR(txNotificationGroup3Color);
    };
    default { ERROR_1("Invalid group %1",_group); };
};

if (GVAR(targetUnits) isEqualTo []) exitWith {
    [[ICON_RADIO_CALL], [localize LSTRING(noTargets)], true] call CBA_fnc_notify;
    false
};

[QGVAR(startSpeaking), [acre_player, _channel, _channelEx], GVAR(targetUnits)] call CBA_fnc_targetEvent;

["startGodModeSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);

if (GVAR(txNotification)) then {
    _channel = localize _channel;
    if (_channelEx != "") then {
        _channel = format ["%1 (%2)", _channel, localize _channelEx];
    };

    GVAR(txNotificationLayer) = [
        format ["TX: %1", localize LSTRING(god)],
        _channel,
        "",
        -1,
        _color
    ] call EFUNC(sys_list,displayHint);
};

true
