/*
 * Author: ACRE2Team
 * Sets the intercom connection status of a limited intercom station.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 * 2: Intercom network <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle acre_player, acre_player, 1] call acre_sys_intercom_fnc_setLimitedConnectionStatus
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_intercomNetwork", "_connected"];

private _numLimitedPositions = (_vehicle getVariable [QGVAR(numLimitedPositions), []]);
private _num = _numLimitedPositions select _intercomNetwork;
private _unitsIntercom = _vehicle getVariable [QGVAR(unitsIntercom), []];
private _intercomUnits = +(_unitsIntercom select _intercomNetwork);

private _usingLimitedPosition = _unit getVariable [QGVAR(usingLimitedPosition), []];

if (_connected == INTERCOM_CONNECTED) then {
    if (_num > 0) then {
        _numLimitedPositions set [_intercomNetwork, _num - 1];
        _vehicle setVariable [QGVAR(numLimitedPositions), _numLimitedPositions, true];

        _intercomUnits pushBackUnique _unit;
        _unitsIntercom set [_intercomNetwork, _intercomUnits];
        _vehicle setVariable [QGVAR(unitsIntercom), _unitsIntercom, true];

        // Unit is using a limited position
        _usingLimitedPosition set [_intercomNetwork, true];
        _unit setVariable [QGVAR(usingLimitedPosition), _usingLimitedPosition];

        [format ["Connected to %1", (_vehicle getVariable [QGVAR(intercomDisplayNames), []]) select _intercomNetwork], ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    } else {
        ["Cannot connect to intercom. Maximum connections reached", ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    };
} else {
    _numLimitedPositions set [_intercomNetwork, _num + 1];
    _vehicle setVariable [QGVAR(numLimitedPositions), _numLimitedPositions, true];
    _intercomUnits = _intercomUnits - [_unit];
    _unitsIntercom set [_intercomNetwork, _intercomUnits];
    _vehicle setVariable [QGVAR(unitsIntercom), _unitsIntercom, true];

    // Unit is not using a limited position
    _usingLimitedPosition set [_intercomNetwork, false];
    _unit setVariable [QGVAR(usingLimitedPosition), _usingLimitedPosition];

    [format ["Disconnected from %1", (_vehicle getVariable [QGVAR(intercomDisplayNames), []]) select _intercomNetwork], ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
};
