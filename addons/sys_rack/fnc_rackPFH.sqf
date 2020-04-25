#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Per frame execution. Sets if player is inside a vehicle and manages the access to rack radios.
 *
 * Arguments:
 * 0: Array of arguments <ARRAY>
 *  0: Player unit <OBJECT>
 *  1: Vehicle with intercom <OBJECT>
 * 1: PFH unique identifier <NUMBER> (unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * [[player, vehicle player], 12] call acre_sys_rack_fnc_rackPFH
 *
 * Public: No
 */

params ["_param", ""];
_param params ["_player", "_vehicle"];

// Check if the player entered a position with a rack already active in intercom
if (_player != vehicle _player) then {
    {
        private _radioId = [_x] call FUNC(getMountedRadio);
        if (_radioId != "" && {!(_radioId in ACRE_HEARABLE_RACK_RADIOS || {_radioId in ACRE_ACCESSIBLE_RACK_RADIOS})}) then {
            private _functionality = [_radioId, _vehicle, _player, _x] call EFUNC(sys_intercom,getRackRxTxCapabilities);
            if (_functionality > RACK_NO_MONITOR) then {
                // Add the radio to the active list since it is already active in the intercom system
                [_vehicle, _player, _radioId] call FUNC(startUsingMountedRadio);
            };
        };
    } forEach ([_vehicle, _player] call FUNC(getHearableVehicleRacks));
};

// Check whether the vehicle rack radios can still be used
private _remove = [];
{
    if !([_x] call EFUNC(sys_radio,radioExists)) then {_remove pushBackUnique _x;};
    private _rack = [_x] call FUNC(getRackFromRadio);
    if (_rack == "") then {_remove pushBackUnique _x;}; // Radio is no longer stored in a rack

    private _isRackHearable = [_rack, _player] call FUNC(isRackHearable);
    private _isRackAccessible = [_rack, _player] call FUNC(isRackAccessible);

    // Check only those radios connected on intercom systems
    if (_isRackHearable && {!(([_rack] call FUNC(getWiredIntercoms)) isEqualTo [])}) then {
        private _functionality = [_x, _vehicle, _player, _rack] call EFUNC(sys_intercom,getRackRxTxCapabilities);

        if (_functionality == RACK_NO_MONITOR) then {
            _remove pushBackUnique _x;
        };
    };

    if !(_isRackAccessible || {_isRackHearable}) then {_remove pushBackUnique _x;};
} forEach (ACRE_ACCESSIBLE_RACK_RADIOS + ACRE_HEARABLE_RACK_RADIOS);

{
    if (_x in ACRE_ACCESSIBLE_RACK_RADIOS) then {
        ACRE_ACCESSIBLE_RACK_RADIOS deleteAt (ACRE_ACCESSIBLE_RACK_RADIOS find _x);
    } else {
        ACRE_HEARABLE_RACK_RADIOS deleteAt (ACRE_HEARABLE_RACK_RADIOS find _x);
    };

    // Handle active radio
    [_x] call EFUNC(sys_radio,stopUsingRadio);
} forEach _remove;

if !(_remove isEqualTo []) then {
    [_vehicle, _player] call EFUNC(sys_intercom,updateVehicleInfoText);
};

if ((_player == vehicle _player) && {ACRE_ACCESSIBLE_RACK_RADIOS isEqualTo []} && {ACRE_HEARABLE_RACK_RADIOS isEqualTo []}) then {
    [GVAR(rackPFH)] call CBA_fnc_removePerFrameHandler;
    TRACE_1("del rack PFH",GVAR(rackPFH));
    GVAR(rackPFH) = -1;
};
