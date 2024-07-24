#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initializes all the radios and components associated with the vehicle.
 *
 * Arguments:
 * 0: Target vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTaget] call acre_sys_rack_fnc_initVehicle
 *
 * Public: No
 */

params ["_vehicle"];

private _initialized = _vehicle getVariable [QGVAR(initialized), false];
if (!_initialized) then {
    private _racks = configProperties [(configOf _vehicle >> "AcreRacks"), "isClass _x", true];

    // Set initialized flag if vehicle config has no defined Racks
    if (_racks isEqualTo []) exitWith {
        _vehicle setVariable [QGVAR(initialized), true, true];
    };

    // Handle acre_api_fnc_replaceRacksOnVehicle having defined a Rack class to replace
    private _replaceVar = _vehicle getVariable [QGVAR(replaceRacks), false];
    private ["_fromRack", "_toRack"];
    if (_replaceVar isEqualType []) then {
        _fromRack = _replaceVar select 0;
        _toRack = _replaceVar select 1;
        _vehicle setVariable [QGVAR(replaceRacks), false, true];
    };

    {
        private _componentName = getText (_x >> "componentName");

        private ["_componentName", "_components", "_mountedRadio"];
        if (!isNil "_toRack" && {_componentName == _fromRack}) then {
            private _toRackConfig = configFile >> "CfgAcreRacks" >> _toRack;
            _componentName = _toRack;
            _components = getArray (_toRackConfig >> "defaultComponents");
            _mountedRadio = switch (_toRack) do {
                case "ACRE_VRC64": { "ACRE_PRC77" };
                case "ACRE_VRC103": { "ACRE_PRC117F" };
                case "ACRE_SEM90": { "ACRE_SEM70" };
                default { "" };
            };
        } else {
            _components = getArray (_x >> "defaultComponents");
            _mountedRadio = getText (_x >> "mountedRadio");
        };

        private _displayName = getText (_x >> "displayName");
        private _shortName = getText (_x >> "shortName");
        private _allowed = [_vehicle, getArray (_x >> "allowedPositions")] call EFUNC(sys_core,processVehicleSystemAccessArray);
        private _disabled = [_vehicle, getArray (_x >> "disabledPositions")] call EFUNC(sys_core,processVehicleSystemAccessArray);
        private _isRadioRemovable = getNumber (_x >> "isRadioRemovable") == 1;
        private _intercoms = [_vehicle, _x] call FUNC(configWiredIntercoms);

        if (count _shortName > 5) then {
            WARNING_2("Rack short name %1 is longer than 5 characters for %2",_shortName,_vehicle);
        };

        [_vehicle, _componentName, _displayName, _shortName, _isRadioRemovable, _allowed, _disabled, _mountedRadio, _components, _intercoms] call FUNC(addRack);
    } forEach _racks;
};
