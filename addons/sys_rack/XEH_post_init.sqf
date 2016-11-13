#include "script_component.hpp"

NO_DEDICATED;

// EH for vehicle racks

[QGVAR(returnRackId), { _this call FUNC(onReturnRackId) }] call CALLSTACK(CBA_fnc_addEventHandler);

/*
[{
    ["vehicle", {[] call FUNC(monitorVehicle);}] call CBA_fnc_addPlayerEventHandler;
}, {ACRE_DATA_SYNCED}, []] call CBA_fnc_waitUntilAndExecute;
*/

/*

// radio claiming handler

["acre_handleDesyncCheck", { _this call FUNC(handleDesyncCheck) }] call CALLSTACK(CBA_fnc_addEventHandler);

// main inventory thread
[] call FUNC(monitorRadios); // OK
*/
[QGVAR(returnRadioId), { _this call FUNC(onReturnRadioId) }] call CALLSTACK(CBA_fnc_addEventHandler);

private _vehicleCrewPFH = {
    private _vehicle = vehicle acre_player;
    if (_vehicle != acre_player) then {
    
        private _initialized = _vehicle getVariable [QGVAR(initialized),false];
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
        };
    };
    
    //Check we can still use the vehicle rack radios.
    private _remove = [];
    {
        if (!([_x] call EFUNC(sys_radio,radioExists))) exitWith {_remove pushBack _x;};
        private _rack = [_x] call FUNC(getRackFromRadio);
        if (_rack == "") exitWith { _remove pushBack _x; }; // Radio is no longer stored in a rack.
        if (!([_rack,acre_player] call FUNC(isRackAccessible))) then {
            _remove pushBack _x;
        };
    } forEach ACRE_ACTIVE_RACK_RADIOS;
    if (count _remove > 0) then {
        ACRE_ACTIVE_RACK_RADIOS = ACRE_ACTIVE_RACK_RADIOS - _remove;
        if (ACRE_ACTIVE_RADIO in _remove) then { // If it is the active radio.
            // Check if radio is now in inventory
            private _items = [acre_player] call EFUNC(lib,getGear);
            _items = _items apply {toLower _x};
            if ((toLower ACRE_ACTIVE_RADIO) in _items) exitWith {}; // no need to remove
            // Otherwise cleanup
            if(ACRE_ACTIVE_RADIO == ACRE_BROADCASTING_RADIOID) then {
                // simulate a key up event to end the current transmission
                [] call EFUNC(sys_core,handleMultiPttKeyPressUp);
            };
            [1] call EFUNC(sys_list,cycleRadios); // Change active radio
        };
    };
};
ADDPFH(_vehicleCrewPFH, 0.91, []);