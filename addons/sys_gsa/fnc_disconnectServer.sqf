#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Disconnects the ground spike antenna and re-connects the default radio antenna. Server Event.
 *
 * Arguments:
 * 0: Ground Spike Antenna (could be null) <OBJECT>
 * 1: Player or unit <OBJECT>
 * 2: RadioID <STRING> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * [gsa, acre_player] call acre_sys_gsa_fnc_disconnectServer
 *
 * Public: No
 */

params ["_gsa", "_unit", ["_radioId", ""]];

private _success = false;

if (_radioId == "") then {
    _radioId = _gsa getVariable [QGVAR(connectedRadio), ""];
};
if (_radioId isEqualTo "") exitWith {
    ERROR_3("Empty unique radio ID %1:%2:%3",_gsa,_unit,_radioId);
    _success
};

private _fnc_removePFEH = {
    private _pfh = [GVAR(gsaPFH), _radioId, _pfh] call CBA_fnc_hashGet;
    if (!isNil "_pfh") then {
        [_pfh] call CBA_fnc_removePerFrameHandler;
        [GVAR(gsaPFH), _radioId, nil] call CBA_fnc_hashSet;
    };
};

private _connectedUnit = [_radioId] call EFUNC(sys_radio,getRadioObject);
if ((isNil "_connectedUnit") || {isNull _connectedUnit}) exitWith {
    ERROR_3("Nil/Null connected object returned %1:%2:%3",_gsa,_unit,_radioId);
    call _fnc_removePFEH;
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

            call _fnc_removePFEH;

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
