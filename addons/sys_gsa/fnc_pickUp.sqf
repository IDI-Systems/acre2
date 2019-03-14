#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Picks up a ground spike antenna and saves it in the inventory.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Ground Spike Antenna <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_player, cursorTarget] call acre_sys_gsa_fnc_pickUp
 *
 * Public: No
 */

params ["_unit", "_gsa"];

private _radioId = _gsa getVariable [QGVAR(connectedRadio), ""];

if (_radioId !=  "") then {
    ["_unit", "_gsa"] call FUNC(disconnect);
};

// Add it to the inventory
private _classname = typeOf _gsa;
private _item = "";
private _canDelete = false;

switch (_classname) do {
    case "vhf30108Item": {
        _item = "ACRE_VHF30108";
        if (_unit canAdd _item) then {
            _item = _item;
            _canDelete = true;
        };
    };
    case "vhf30108spike": {
        _item = "ACRE_VHF30108SPIKE";

        // If the unit has a spike
        if ([_unit, "ACRE_VHF30108MAST"] call EFUNC(sys_core,hasItem)) then {
            _item = "ACRE_VHF30108";
        };

        if (_unit canAdd _item) then {
            _item = _item;
            _canDelete = true;
        };
    };
};

if (_canDelete) then {
    _unit addItem _item;
    deleteVehicle _gsa;
};
