/*
 * Author: ACRE2Team
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

params["_iconId", "_toggle"];

_display = uiNamespace getVariable QGVAR(currentDisplay);
_type = ctrlType (_display displayCtrl _iconId);

if((count _this) > 2) then {
    _newPosition = _this select 2;
    (_display displayCtrl _iconId) ctrlSetPosition _toggle;
};

//if(_type == 8) then {
//    (_display displayCtrl _iconId) progressSetPosition 0.85;
//};

(_display displayCtrl _iconId) ctrlShow _toggle;
(_display displayCtrl _iconId) ctrlCommit 0;
