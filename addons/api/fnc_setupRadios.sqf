#include "script_component.hpp"
/*
 * Author: mrschick
 * When run locally it will set the currently carried radios to the selected channel numbers.
 *
 * Arguments:
 * 0-N: Radio assignments <ARRAY>
 *   0: Radio Baseclass <STRING>
 *   1: Radio Channel/Block/Frequency <INTEGER> or <ARRAY>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _success = [ ["ACRE_PRC343", [2,3]], ["ACRE_PRC152", 3], ["ACRE_PRC77", [2,4]] ] call acre_api_fnc_setupRadios;
 * // Will set PRC343 to Ch2 Blk3, PRC152 to Ch3 and PRC77 to 31.15 MHz
 * 
 * _success = [ ["ACRE_PRC343", 6], ["ACRE_PRC152", 2], ["ACRE_PRC152", 3] ] call acre_api_fnc_setupRadios;
 * // Will set PRC343 to Ch6 Blk1, the first PRC152 to Ch2 and the second PRC152 to Ch3
 *
 * Public: Yes
 */

private _assignments = _this;

if (count(_assignments) isEqualTo 0 || !((_assignments select 0) isEqualType [])) exitWith {}; // Abort if argument is empty or not an array

private _radios = [] call EFUNC(sys_data,getPlayerRadioList);

if (_radios isEqualTo []) exitWith {}; // Abort if carrying no radios

{ // iterate through carried radios
    private _radio = _x;
    private _radioBaseClass = [_radio] call EFUNC(sys_radio,getRadioBaseClassname);

    // iterate through arguments and set up radio if baseclass matches
    for "_i" from 0 to count(_assignments)-1 do {
        (_assignments select _i) params ["_radioType", "_channel"];
        private _eventData = [];

        // Skip assignment if its type doesn't match current radio baseclass
        if !(_radioType isEqualTo _radioBaseClass) then { continue; };

        // Turn channel argument into an array of 1 or 2 numbers, 0-index them
        if (_channel isEqualType []) then {
            { _eventData pushBack (_x - 1) } forEach _channel;
        } else {
            _eventData = [_channel - 1];
        };

        // Parse eventData to match the expected input for the respective radio's setCurrentChannel function
        switch (_radioType) do {
            case "ACRE_PRC343": {
                if (count _eventData == 2) then { // set channel and block
                    _eventData = ((_eventData select 1) * 16) + (_eventData select 0);
                } else { // set channel
                    _eventData = _eventData select 0;
                };
            };
            case "ACRE_PRC77": {
                if (count _eventData < 2) then { // set only MHz, insert 0 to nullify KHz
                    _eventData pushBack 0;
                };
            };
            // @TODO parsing for SEM52L/SEM70
            default {
                _eventData = _eventData select 0;
            };
        };

        [_radio, "setCurrentChannel", _eventData] call EFUNC(sys_data,dataEvent);

        // Delete applied assignment and break out to handle next radio
        _assignments deleteAt _i;
        break;
    };
} forEach _radios;

true
