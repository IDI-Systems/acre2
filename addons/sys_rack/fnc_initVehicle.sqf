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

    for "_i" from 0 to ((count _racks) - 1) do {
        private _x = _racks select _i;
        private _componentName = getText (_x >> "componentname");
        private _displayName = getText (_x >> "name");
        private _allowed = [_vehicle, getArray (_x >> "allowed")] call EFUNC(sys_core,processConfigArray);
        private _disabled = [_vehicle, getArray (_x >> "disabled")] call EFUNC(sys_core,processConfigArray);
        private _components = getArray (_x >> "defaultComponents");
        private _mountedRadio = getText (_x >> "mountedRadio");
        private _isRadioRemovable = getNumber (_x >> "isRadioRemovable") == 1;
        private _intercoms = [_vehicle, _x] call FUNC(configWiredIntercoms);

        [_vehicle, _componentName, _displayName, _isRadioRemovable, _allowed, _disabled, _mountedRadio, _components, _intercoms] call FUNC(addRack);
    };

    [_vehicle] call EFUNC(sys_intercom,configRxTxCapabilities);
    _vehicle setVariable [QGVAR(initialized), true, true];
};
