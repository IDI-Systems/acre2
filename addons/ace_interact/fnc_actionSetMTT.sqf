/*
 * Author: AUTHOR
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

 #include "script_component.hpp"

params ["_target","_player","_params","_desiredIdx"];
_params params ["_radio","","_pttAssign",""];

if (count _pttAssign > 3) then {
    _pttAssign resize 3;
};
_oldIdx = _pttAssign find _radio;

if (_desiredIdx +1 > count _pttAssign) then {
    _desiredIdx = (count _pttAssign) - 1;
};

if (_oldIdx > -1 and _oldIdx < 3) then {
    _pttAssign set [_oldIdx, _pttAssign select _desiredIdx];
};

_pttAssign set [_desiredIdx, _radio];

[_pttAssign] call acre_api_fnc_setMultiPushToTalkAssignment;
