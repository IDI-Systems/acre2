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

params ["_radioId", "_event", "_eventData", "_radioData"];

private _vol = _eventData;

if(_vol%0.10 != 0) then {
    _vol = _vol-(_vol%0.10);
};

HASH_SET(_radioData, "volume", _eventData);

TRACE_3("VOLUME SET",_radioId, _vol, _radioData);

if(!isNil "_display") then {
    (_display displayCtrl ICON_VOLUME) progressSetPosition _eventData;
    (_display displayCtrl ICON_VOLUME) ctrlCommit 0;
};

if(IS_STRING(GVAR(currentRadioId))) then {
    if(GVAR(currentRadioId) == _radioId) then {
        private _currentMenu = GET_STATE_DEF(currentMenu, GVAR(VULOSHOME));
        TRACE_2("", GVAR(currentRadioId), _currentMenu);
        [_currentMenu, ["VOLUME", _vol] ] call FUNC(changeValueAck);
    };
};
