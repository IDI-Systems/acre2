#include "script_component.hpp"

[QGVAR(initVehicleRacksActions), {
    params ["_vehicle"];

    [_vehicle] call EFUNC(sys_rack,initActionVehicle);
}] call CBA_fnc_addEventHandler;

[QGVAR(initVehicleRacks), {
    params ["_vehicle"];

    [_vehicle] call EFUNC(sys_rack,initVehicle);

    // Some classes are initialised automatically. Only initialise ACE interaction if the vehicle does not belong to
    // any of these classes
    private _found = false;
    private _automaticInitClasses = ["LandVehicle", "Air", "Ship_F"];
    {
        if (_vehicle isKindOf _x) exitWith {
            _found = true;
        };
    } forEach _automaticInitClasses;

    if (!_found) then {
        [QGVAR(initVehicleRacksActions), [_vehicle]] call CBA_fnc_globalEventJIP;
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(addVehicleRacks), {
    params ["_vehicle", "_componentName", "_displayName", "_isRadioRemovable", "_allowed", "_disabled", "_mountedRadio", "_components", "_intercoms"];

    [_vehicle, _componentName, _displayName, _isRadioRemovable, _allowed, _disabled, _mountedRadio, _components, _intercoms] call EFUNC(sys_rack,addRack);

    if (count _intercoms > 0) then {
        _vehicle setVariable [QEGVAR(sys_rack,rackIntercomInitialised), false, true];
    };
}] call CBA_fnc_addEventHandler;
