#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Picks up a ground spike antenna and saves it in the inventory.
 *
 * Arguments:
 * 0: Ground Spike Antenna <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_gsa_fnc_pickUp
 *
 * Public: No
 */

params ["_unit", "_gsaItem", ["_withMast", false]];

private _gsa = objNull;
private _canDeploy = false;

switch (_gsaItem) do {
    case "acre2_vhf30108": {
        _gsa = "vhf30108Item";
        _canDeploy = true;
    };
    case "acre2_vhf30108spike" : {
        _gsa = "vhf30108spike";
        _canDeploy = true;
    };
};

if (_canDeploy) then {
    // Remove item from backpack
    if (_gsaItem isEqualTo "acre2_vhf30108spike" && {!_withMast} && {[_unit, "acre2_vhf30108"] call EFUNC(sys_core,hasItem)}) then {
        _unit removeItem "acre2_vhf30108";
        _unit addItemToBackpack "acre2_vhf30108mast";
    } else {
        _unit removeItem _gsaItem;
    };

    // Create the ground spike antenna
    if (stance _unit == "STAND") then {
        [_unit, "AmovPercMstpSrasWrflDnon_diary"] call ace_common_fnc_doAnimation;
    };

    [{
        params ["_unit", "_gsa"];

        private _direction = getDir _unit;
        private _zOffset = 0.0;
        if (_gsa isEqualTo "vhf30108Item") then {
            _zOffset = MAST_Z_OFFSET;
        };
        private _position = getPosASL _unit vectorAdd [2 * sin _direction, 2 * cos _direction, 0];

        // Always make it vertical, we do not want to take the normal to the surface since that would result
        // in suboptimal antenna direction
        private _vectorUp = [0, 0, 1];
        private _intersections = lineIntersectsSurfaces [_position vectorAdd [0, 0, 1.5], _position vectorDiff [0, 0, 1.5], _unit, objNull, true, 1, "GEOM", "FIRE"];
        if (_intersections isEqualTo []) then {
            TRACE_1("No intersections",_intersections);
        } else {
            (_intersections select 0) params ["_touchingPoint", ""];
            _position = _touchingPoint vectorAdd [0, 0, _zOffset];
        };

        private _gsaUnit = _gsa createVehicle [0, 0, 0];
        _gsaUnit setDir _direction;
        _gsaUnit setPosASL _position;
        _gsaUnit setVectorUp _vectorUp;
    }, [_unit, _gsa], 1] call CBA_fnc_waitAndExecute;
};
