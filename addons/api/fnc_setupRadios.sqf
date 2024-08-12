#include "script_component.hpp"
/*
 * Author: mrschick
 * When run locally it will set the currently carried radios to the selected channel numbers.
 *
 * Arguments:
 * [RadioSetting1, RadioSetting2, ...] <ARRAY>
 * 
 * RadioSetting: [RadioType, Channel] or
 *               [RadioType, [Channel, Block]] or
 *               [RadioType, MHz] or
 *               [RadioType, [MHz, KHz]]
 *   0: Radio Base Class <STRING>
 *   1: Radio Channel/Block/Frequency <INTEGER> or <ARRAY>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _success = [ ["ACRE_PRC343", [2,3]], ["ACRE_PRC152", 3], ["ACRE_PRC77", [31,15]] ] call acre_api_fnc_setupRadios;
 * // Will set PRC343 to Ch2 Blk3, PRC152 to Ch3 and PRC77 to 31.15 MHz
 * 
 * _success = [ ["ACRE_PRC343", 6], ["ACRE_PRC152", 2], ["ACRE_PRC152", 3] ] call acre_api_fnc_setupRadios;
 * // Will set PRC343 to Ch6 Blk1, the first PRC152 to Ch2 and the second PRC152 to Ch3
 * 
 * _success = [ ["ACRE_SEM52SL", 8], ["ACRE_SEM70", [34,075]] ] call acre_api_fnc_setupRadios;
 * // Will set SEM52SL to Ch8 and SEM70 to 34.075 MHz
 *
 * Public: Yes
 */

private _settings = _this;

// Abort if argument is empty or not an array
if ((_settings isEqualTo []) || {!((_settings select 0) isEqualType [])}) exitWith { false };

private _radios = [] call EFUNC(sys_data,getPlayerRadioList);

// Abort if carrying no radios
if (_radios isEqualTo []) exitWith { false };

{ // iterate through carried radios
    private _radio = _x;
    private _radioBaseClass = [_radio] call EFUNC(sys_radio,getRadioBaseClassname);

    // iterate through arguments and set up radio if baseclass matches
    for "_i" from 0 to count(_settings)-1 do {
        (_settings select _i) params ["_radioType", "_channel"];
        private _eventData = [];

        // Skip setting if its type doesn't match current radio baseclass
        if !(_radioType isEqualTo _radioBaseClass) then { continue; };

        // Turn channel argument into an array of 1 or 2 numbers
        if (_channel isEqualType []) then {
            { _eventData pushBack (_x) } forEach _channel;
        } else {
            _eventData = [_channel];
        };

        // Parse eventData to match the expected input for the respective radio's setCurrentChannel function
        switch (_radioType) do {
            case "ACRE_PRC343": {
                if (count _eventData == 2) then { // set channel and block
                    _eventData = (((_eventData select 1) - 1) * 16) + (_eventData select 0) - 1;
                } else { // set channel
                    _eventData = (_eventData select 0) - 1;
                };
            };
            case "ACRE_PRC77": {
                if (count _eventData < 2) then { // set only MHz, insert 0 to nullify KHz
                    _eventData pushBack 0;
                } else {
                    if (_eventData select 1 > 0) then { // parse KHz if set by user
                        _eventData set [1, (floor ((_eventData select 1) / 5) min 19)];
                    };
                };
                _eventData set [0, (0 max ((_eventData select 0) - 30))];
            };
            case "ACRE_SEM70": {
                if (count _eventData < 2) then { // set only MHz, insert 0 to nullify KHz
                    _eventData pushBack 0;
                } else {
                    if (_eventData select 1 > 0) then { // parse KHz if set by user
                        _eventData set [1, (round ((_eventData select 1) / 25) min 39)];
                    };
                };
                _eventData set [0, (0 max ((_eventData select 0) - 30))];
            };
            default {
                _eventData = (_eventData select 0) - 1;
            };
        };

        [_radio, "setCurrentChannel", _eventData] call EFUNC(sys_data,dataEvent);

        // Delete applied setting and break out to handle next radio
        _settings deleteAt _i;
        break;
    };
} forEach _radios;

true
