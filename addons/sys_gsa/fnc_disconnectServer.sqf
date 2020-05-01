#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Disconnects the ground spike antenna and re-connects the default radio antenna. Server Event.
 *
 * Arguments:
 * 0: Ground Spike Antenna <OBJECT>
 * 1: Player or unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [gsa, acre_player] call acre_sys_gsa_fnc_disconnectServer
 *
 * Public: No
 */

params ["_gsa", "_unit"];

private _success = false;
private _radioId = _gsa getVariable [QGVAR(connectedRadio), ""];
if (_radioId isEqualTo "") exitWith {
    ERROR("Empty unique radio ID");
    _success
};

private _connectedUnit = [_radioId] call EFUNC(sys_radio,getRadioObject);
if (isNull _connectedUnit) exitWith {
    ERROR("Null connected object returned");
    _success
};

private _parentComponentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_radioId);
{
    _x params ["", "_component"];

    private _componentType = getNumber (configFile >> "CfgAcreComponents" >> _component >> "type");
    if (_componentType == ACRE_COMPONENT_ANTENNA) then {
        _success = [_radioId, 0, _component, HASH_CREATE, true] call EFUNC(sys_components,attachSimpleComponent);
        if (_success) exitWith {
            _gsa setVariable [QGVAR(connectedRadio), "", true];
            [_radioId, "setState", ["externalAntennaConnected", [false, objNull]]] call EFUNC(sys_data,dataEvent);

            // Support for having several radios connected to GSA
            private _pfh = [GVAR(gsaPFH), _radioId, _pfh] call CBA_fnc_hashGet;
            if !(isNil "_pfh") then {
                [_pfh] call CBA_fnc_removePerFrameHandler;
                [GVAR(gsaPFH), _radioId, nil] call CBA_fnc_hashSet;
            };

            if (_connectedUnit isKindOf "CAManBase" || {!(crew _connectedUnit isEqualTo [])}) then {
                if (_connectedUnit isKindOf "CAManBase") then {
                    [QGVAR(notifyPlayer), [localize LSTRING(disconnected)], _connectedUnit] call CBA_fnc_targetEvent;
                } else {
                    {
                        [QGVAR(notifyPlayer), [localize LSTRING(disconnected)], _connectedUnit] call CBA_fnc_targetEvent;
                    } forEach (crew _connectedUnit);
                };
            };

            if (_connectedUnit != _unit && {_connectedUnit isKindOf "CAManBase"}) then {
                // The unit that disconnected the antenna is different from the unit that was connected to it
                private _text = format [localize LSTRING(disconnectedUnit), name _unit];
                [QGVAR(notifyPlayer), [_text], _unit] call CBA_fnc_targetEvent;
            };
        };
    };
} forEach (getArray (_parentComponentClass >> "defaultComponents"));
