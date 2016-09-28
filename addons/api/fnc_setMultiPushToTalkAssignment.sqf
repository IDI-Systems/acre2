/*
 * Author: ACRE2Team
 * Sets the assignment order for the Multi-Push-To-Talk keys, also known as Alternate Push-to-Talk keys. These assign the keys 1-3, in order, to the ID’s provided in the array. All radios must be valid assigned ACRE radio id’s and must be present on the local player.
 *
 * Arguments:
 * 0: Array of radio IDs <ARRAY>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _personalRadio = [“ACRE_PRC343”] call acre_api_fnc_getRadioByType;
 * _handheldRadio = [“ACRE_PRC152”] call acre_api_fnc_getRadioByType;
 * _manpackRadio = [“ACRE_PRC117F”] call acre_api_fnc_getRadioByType; 
 * _success = [ [ _personalRadio, _handheldRadio, _manpackRadio ] ] call acre_api_fnc_setMultiPushToTalkAssignment;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params["_var"];

private _invalid = false;
if(!(_var isEqualType [])) exitWith { false };

private _currentRadioList = [] call acre_api_fnc_getCurrentRadioList;
{
    if(!(_x isEqualType "")) exitWith {
        _invalid = true;
    };
    private _isRadio = [_x] call acre_api_fnc_isRadio;
    if(!_isRadio) exitWith {
        _invalid = true;
    };
    if(!(_x in _currentRadioList)) exitWith {
        _invalid = false;
    };
} forEach ACRE_ASSIGNED_PTT_RADIOS;

if(_invalid) exitWith { false };

ACRE_ASSIGNED_PTT_RADIOS = _var;

true
