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
#include "script_component.hpp"

params ["_vehicle"];

private _initialized = _vehicle getVariable [QGVAR(initialized), false];
if (!_initialized) then {
    private _classname = typeOf _vehicle;
    private _racks = configFile >> "CfgVehicles" >> _classname >> "AcreRacks";

    {
        private _componentName = getText (_x >> "componentName");
        private _displayName = getText (_x >> "displayName");
        private _shortName = getText (_x >> "shortName");
        private _allowed = [_vehicle, getArray (_x >> "allowedPositions")] call EFUNC(sys_core,processVehicleSystemAccessArray);
        private _disabled = [_vehicle, getArray (_x >> "disabledPositions")] call EFUNC(sys_core,processVehicleSystemAccessArray);
        private _components = getArray (_x >> "defaultComponents");
        private _mountedRadio = getText (_x >> "mountedRadio");
        private _isRadioRemovable = getNumber (_x >> "isRadioRemovable") == 1;
        private _intercoms = [_vehicle, _x] call FUNC(configWiredIntercoms);

        [_vehicle, _componentName, _displayName, _shortName, _isRadioRemovable, _allowed, _disabled, _mountedRadio, _components, _intercoms] call FUNC(addRack);
    } forEach (configProperties [_racks, "isClass _x", true]);

    _vehicle setVariable [QGVAR(initialized), true, true];
};
