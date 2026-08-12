#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Removes a ground spike antenna from the inventory and deploys it on the ground.
 * Deployment is vertical for optimal antenna direction.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Ground Spike Antenna classname <STRING>
 * 2: Include Mast <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_player, "ACRE_VHF30108"] call acre_sys_gsa_fnc_deploy
 *
 * Public: No
 */

params ["_unit", "_gsaItem", ["_withMast", false]];

private _gsa = objNull;
private _canDeploy = false;

switch (_gsaItem) do {
    case "ACRE_VHF30108": {
        _gsa = "vhf30108Item";
        _canDeploy = true;
    };
    case "ACRE_VHF30108SPIKE" : {
        _gsa = "vhf30108spike";
        _canDeploy = true;
    };
    case "ACRE_12FT_ANTENNA" : {
        _gsa = "ws38_12ft_antenna";
        _canDeploy = true;
    };
};

if (_canDeploy) then {
    // Remove item from backpack
    if (_gsaItem isEqualTo "ACRE_VHF30108SPIKE" && {!_withMast} && {[_unit, "ACRE_VHF30108"] call EFUNC(sys_core,hasItem)}) then {
        _unit removeItem "ACRE_VHF30108";
        _unit addItemToBackpack "ACRE_VHF30108MAST";
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
