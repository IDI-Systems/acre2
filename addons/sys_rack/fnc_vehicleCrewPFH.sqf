/*
 * Author: ACRE2Team
 * Per frame execution. Sets if player is inside a vehicle and manages the access to rack radios.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_rack_fnc_vehicleCrewPFH
 *
 * Public: No
 */
#include "script_component.hpp"

private _vehicle = vehicle acre_player;
if (_vehicle != acre_player) then {

    private _initialized = _vehicle getVariable [QGVAR(initialized), false];
    if (!_initialized) then {
        //Only initialize if we are first in the crew array - This helps prevent multiple requests if multiple players enter a vehicle around the same time.
        private _crew = crew _vehicle;
        private _firstPlayer = objNull;
        {
            if (!isNull _firstPlayer) exitWith {};
            if (isPlayer _x) exitWith {
                _firstPlayer = _x;
            };
        } forEach _crew;
        if (!isNull _firstPlayer) then {
            if (acre_player == _firstPlayer) then {
                [_vehicle] call FUNC(initVehicle);
            };
        } else { // No other players.
            [_vehicle] call FUNC(initVehicle);
        };
    } else {
        if (!(_vehicle getVariable [QGVAR(rackIntercomInitialised), false])) then {
            private _racks = [_vehicle] call FUNC(getVehicleRacks);
            {
                private _intercoms = [_x] call FUNC(getWiredIntercoms);
                private _rackRxTxConfig = _vehicle getVariable [QGVAR(rackRxTxConfig), []];
                if (count _intercoms > 0 && {count _rackRxTxConfig == 0}) exitWith {
                    [_vehicle] call EFUNC(sys_intercom,configRxTxCapabilities);
                    _vehicle setVariable [QGVAR(rackIntercomInitialised), true, true];
                };
            } forEach _racks;
        };
    };
};

// Check if the player entered a position with a rack already active in intercom
{
    private _radioId = [_x] call FUNC(getMountedRadio);
    if (_radioId != "" && {!(_radioId in ACRE_ACCESSIBLE_RACK_RADIOS || _radioId in ACRE_HEARABLE_RACK_RADIOS)}) then {
        private _functionality = [_radioId, _vehicle, acre_player, _x] call EFUNC(sys_intercom,getRxTxCapabilities);
        // Add the radio to the active list since it is already active in the intercom system
        if (_functionality > RACK_NO_MONITOR) then {
            if ([_x, acre_player] call FUNC(isRackAccessible)) then {
                ACRE_ACCESSIBLE_RACK_RADIOS pushBackUnique (toLower _radioId);
            } else {
                ACRE_HEARABLE_RACK_RADIOS pushBackUnique (toLower _radioId);
            };
            ACRE_ACTIVE_RADIO = _radioId;
        };
    };
} forEach (([_vehicle, acre_player] call FUNC(getHearableVehicleRacks)) apply {toLower _x});

//Check we can still use the vehicle rack radios.
private _remove = [];
{
    if (!([_x] call EFUNC(sys_radio,radioExists))) then {_remove pushBackUnique _x;};
    private _rack = [_x] call FUNC(getRackFromRadio);
    if (_rack == "") then { _remove pushBackUnique _x; }; // Radio is no longer stored in a rack.

    private _isRackHearable = [_rack, acre_player] call FUNC(isRackHearable);
    private _isRackAccessible = [_rack, acre_player] call FUNC(isRackAccessible);

    // Check only those radios connected on intercom systems
    if (count ([_rack] call FUNC(getWiredIntercoms)) > 0 && _isRackHearable) then {
        private _functionality = [_x, _vehicle, acre_player, toLower _rack] call EFUNC(sys_intercom,getRxTxCapabilities);
        if (_functionality == RACK_NO_MONITOR) then {_remove pushBackUnique _x;};
    };

    if (!(_isRackAccessible || _isRackHearable)) then { _remove pushBackUnique _x; };
} forEach (ACRE_ACCESSIBLE_RACK_RADIOS + ACRE_HEARABLE_RACK_RADIOS);

{
    if (_x in ACRE_ACCESSIBLE_RACK_RADIOS) then {
        ACRE_ACCESSIBLE_RACK_RADIOS = ACRE_ACCESSIBLE_RACK_RADIOS - [_x];
    } else {
        ACRE_HEARABLE_RACK_RADIOS = ACRE_HEARABLE_RACK_RADIOS - [_x];
    };
    if (ACRE_ACTIVE_RADIO isEqualTo _x) then { // If it is the active radio.
        // Check if radio is now in inventory
        private _items = [acre_player] call EFUNC(sys_core,getGear);
        _items = _items apply {toLower _x};
        if (!((toLower ACRE_ACTIVE_RADIO) in _items)) then { // no need to remove
            // Otherwise cleanup
            if (ACRE_ACTIVE_RADIO == ACRE_BROADCASTING_RADIOID) then {
                // simulate a key up event to end the current transmission
                [] call EFUNC(sys_core,handleMultiPttKeyPressUp);
            };
            [1] call EFUNC(sys_list,cycleRadios); // Change active radio
        };
    };
} forEach _remove;
