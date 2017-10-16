/*
 * Author: ACRE2Team
 * Handles entering a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit entering a vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, player] call acre_sys_intercom_fnc_enterVehicle
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit"];

if (_unit != _vehicle) then {
    _unit setVariable [QGVAR(intercomVehicle), _vehicle];

    // Configure the array for handling if a player is in a limited intercom position or not.
    private _usingLimitedPosition = (_vehicle getVariable [QGVAR(intercomNames), []]) apply {false};

    _unit setVariable [QGVAR(usingLimitedPosition), _usingLimitedPosition];

    {
        [_vehicle, _unit, _forEachIndex] call FUNC(seatSwitched);
    } forEach (_vehicle getVariable [QGVAR(intercomNames), []]);
    GVAR(intercomPFH) = [DFUNC(intercomPFH), 1.1, [_unit, _vehicle]] call CBA_fnc_addPerFrameHandler;
} else {
    [GVAR(intercomPFH)] call CBA_fnc_removePerFrameHandler;
    private _intercomVehicle = _unit getVariable [QGVAR(intercomVehicle), objNull];
    private _unitsIntercom = _intercomVehicle getVariable [QGVAR(unitsIntercom) , []];
    private _disconnected = false;
    {
        private _temp = +_x;
        if (_unit in _temp) then {
            _temp deleteAt (_temp find _unit);
            _unitsIntercom set [_forEachIndex, _temp];
            _disconnected = true;
            private _usingLimitedPosition = _unit getVariable [QGVAR(usingLimitedPosition), []];
            if (_usingLimitedPosition select _forEachIndex) then {
                private _numLimitedPositions = _intercomVehicle getVariable [QGVAR(numLimitedPositions), []];
                private _num = _numLimitedPositions select _forEachIndex;

                _numLimitedPositions set [_forEachIndex, _num + 1];
                _intercomVehicle setVariable [QGVAR(numLimitedPositions), _numLimitedPositions, true];

                _usingLimitedPosition set [_forEachIndex, false];
                _unit setVariable [QGVAR(usingLimitedPosition), _usingLimitedPosition];
            };
        };
    } forEach _unitsIntercom;

    // Reset variables
    _unit setVariable [QGVAR(usingLimitedPosition), []];
    _intercomVehicle setVariable [QGVAR(unitsIntercom), _unitsIntercom, true];
    _unit setVariable [QGVAR(intercomVehicle), objNull];
    ACRE_PLAYER_INTERCOM = [];

    ["Disconnected from intercom system", ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
};
