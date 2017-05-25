/*
 * Author: ACRE2Team
 * Sets the given radio as mounted.
 *
 * Arguments:
 * 0: Rack ID <STRING>
 * 1: Base radio to mount <STRING>
 *
 * Return Value:
 * Setup successful <BOOL>
 *
 * Example:
 * ["ACRE_VRC103_ID_1", "ACRE_PRC117F"] call acre_api_fnc_mountRackRadio
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_rackId", ""], ["_baseRadio", ""]];

if (!isServer) exitWith {
    WARNING("Function must be called on the server.");
    false
};

if (isDedicated) then {
    // Pick the first player
    private _player = (allPlayers - entities "HeadlessClient_F") select 0;
    [QGVAR(mountRackRadio), [_rackId, _baseRadio], _player] call CBA_fnc_targetEvent;
} else {
    if (!([_rackId] call EFUNC(sys_radio,radioExists))) exitWith {
        WARNING_1("Non existant rack ID provided: %1",_rackId);
    };

    if ([_baseRadio] call EFUNC(sys_radio,radioExists)) exitWith {
        WARNING_1("Unique radio ID provided: %1",_baseRadio);
    };

    if ([_rackId] call FUNC(getMountedRackRadio) != "") exitWith {
        WARNING_1("Rack ID %1 has already a radio mounted.",_rackId);
    };

    if (getNumber (configFile >> "CfgWeapons" >> _baseRadio >> "acre_hasUnique") == 1) then {

        private "_rackObject";
        {
            private _type = typeOf _x;
            if (_type == (toLower _rackId)) exitWith {
                _rackObject = _x;
            };
        } forEach (nearestObjects [[-1000,-1000], ["ACRE_baseRack"], 1, true]);

        [_rackId, "setState", ["mountedRadio", _baseRadio]] call EFUNC(sys_data,dataEvent);

        //Init the radio
        ["acre_getRadioId", [_rackObject, _baseRadio, QEGVAR(sys_rack,returnRadioId)]] call CBA_fnc_globalEvent;
    };
};

true
