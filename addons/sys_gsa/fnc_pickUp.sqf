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

if (_radioId != "") then {
    [_unit, _gsa] call FUNC(disconnect);
};

// Add it to the inventory
private _classname = typeOf _gsa;
private _item = "";
private _canDelete = false;

switch (_classname) do {
    case "vhf30108Item": {
        _item = "ACRE_VHF30108";
        if (_unit canAdd _item) then {
            _canDelete = true;
        };
    };
    case "vhf30108spike": {
        _item = "ACRE_VHF30108SPIKE";

        if (_unit canAdd _item) then {
            // If the unit has a mast, delete the mast item and try to add the whole antenna. Usually this should
            // not happen if the masses are consistent, but better be sure.
            if ([_unit, "ACRE_VHF30108MAST"] call EFUNC(sys_core,hasItem)) then {
                _unit removeItem "ACRE_VHF30108MAST";  // Delete the mast
                if (_unit canAdd "ACRE_VHF30108") then {
                    _item = "ACRE_VHF30108";
                    _canDelete = true;
                } else {
                    _unit addItem "ACRE_VHF30108MAST";  // Add the mast again since there is no space in the inventory
                    _canDelete = false;
                };
            } else {
                _canDelete = true;
            };
        };
    };
    case "ws38_12ft_antenna": {
        _item = "ACRE_12FT_ANTENNA";
        if (_unit canAdd _item) then {
            _canDelete = true;
        };
    };
};

if (_canDelete) then {
    // Remove the ground spike antenna
    if (stance _unit == "STAND") then {
        [_unit, "AmovPercMstpSrasWrflDnon_diary"] call ace_common_fnc_doAnimation;
    };

    [{
        params ["_unit", "_item", "_gsa"];

        _unit addItem _item;
        deleteVehicle _gsa;
    }, [_unit, _item, _gsa], 1] call CBA_fnc_waitAndExecute;
} else {
    [[ICON_RADIO_CALL], [localize LSTRING(inventoryFull)]] call CBA_fnc_notify;
};
