/*
 * Author: ACRE2Team
 * Disconnects the ground spike antenna and re-connects the default radio antenna.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unique Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, "acre_prc152_id_1"] call acre_sys_gsa_fnc_disconnect
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_player", "_gsa"];

private _success = false;
private _radioId = _gsa getVariable [QGVAR(connectedRadio), ""];
if (_radioId isEqualTo "") exitWith {
    ERROR("Emtpy unique radio ID");
    _success
};

private _parentComponentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_radioId);
{
    _x params ["_connector", "_component"];
    systemChat format ["_radioId %1 component %2", _radioId, _component];

    private _componentType = getNumber (configFile >> "CfgAcreComponents" >> _component >> "type");
    systemChat format ["component type %1 equal %2", _componentType, _componentType == ACRE_COMPONENT_ANTENNA];
    if (_componentType == ACRE_COMPONENT_ANTENNA) then {

        _success = [_radioId, 0, _component, [], true] call EFUNC(sys_components,attachSimpleComponent);
        if (_success) exitWith {
            _gsa setVariable [QGVAR(connectedRadio), "", true];
            [_radioId, "setState", ["externalAntennaConnected", [false, objNull]]] call EFUNC(sys_data,dataEvent);
            [localize LSTRING(disconnected), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
        };
    };
} forEach (getArray (_parentComponentClass >> "defaultComponents"));

_success
