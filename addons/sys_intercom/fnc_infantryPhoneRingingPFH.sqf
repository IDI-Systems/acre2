/*
 * Author: ACRE2Team
 * Ringing event.
 *
 * Arguments:
 * 0: Vehicle <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_intercom_fnc_infantryPhoneRingingPFH
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_position", "_direction", "_volume"];

private _ringing = {
    params ["_args", "_pfhID"];
    _args params ["_vehicle", "_position", "_direction", "_volume"];

    private _unitInfantryPhone = _vehicle getVariable [QGVAR(unitInfantryPhone), objNull];
    private _isCalling = _vehicle getVariable [QGVAR(isInfantryPhoneCalling), false];

    private _crew = [driver _vehicle, gunner _vehicle, commander _vehicle];
    {
        _crew pushBackUnique (_vehicle turretUnit _x);
    } forEach (allTurrets [_vehicle, false]);
    _crew = _crew - [objNull];

    private _noCrew = false;
    if (count _crew == 0) then {
        _noCrew = true;
    };

    if ((isNull _unitInfantryPhone) && {_isCalling} && {alive _vehicle} && {!_noCrew}) then {
        TRACE_5("Infantry Phone Calling PFH Check",_vehicle,acre_player,_position,_direction,_volume);
        ["Acre_GenericBeep", _position, _direction, _volume, true] call EFUNC(sys_sounds,playSound);
    } else {
        // A unit picked up the phone. Reset isCalling variable.
        if (_isCalling) then {
            _vehicle setVariable [QGVAR(isInfantryPhoneCalling), false, true];
        };
        [_pfhID] call CBA_fnc_removePerFrameHandler;
    };
};

[_ringing, 1, [_vehicle, _position, _direction, _volume]] call CBA_fnc_addPerFrameHandler;
