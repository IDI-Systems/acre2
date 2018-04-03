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
#include "script_component.hpp"

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
    _unit removeItem _gsaItem;
    if (_gsaItem isEqualTo "acre2_vhf30108" && {!_withMast}) then {
        // Add the mast item
    };

    // Create the ground spike antenna
    if (stance _unit == "STAND") then {
        [_unit, "AmovPercMstpSrasWrflDnon_diary"] call ace_common_fnc_doAnimation;
    };
/*
    [{
        params ["_unit", "_gsa"];

        private _direction = getDir _unit;
        private _position = getPosASL _unit vectorAdd [0.8 * sin _direction, 0.8 * cos _direction, 0.02];

        private _gsaUnit = _gsa createVehicle [0, 0, 0];

        [{
            (_this select 0) params ["_gsaUnit", "_direction", "_position"];

            if (_gsaUnit animationPhase "slide_down_tripod" == 0.5) then {
                _gsaUnit setDir _direction;
                _gsaUnit setPosASL _position;

                if ((getPosATL _gsaUnit select 2) - (getPos _gsaUnit select 2) < 1E-5) then { // if not on object, then adjust to surface normale
                    _gsaUnit setVectorUp (surfaceNormal (position _gsaUnit));
                };

                [_this select 1] call CBA_fnc_removePerFrameHandler;
            };
        }, 0, [_gsaUnit, _direction, _position]] call CBA_fnc_addPerFrameHandler;

    }, [_unit, _gsa], 1] call CBA_fnc_waitAndExecute;*/
};
