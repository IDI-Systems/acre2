#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_prc152_fnc_handleEndTransmission
 *
 * Public: No
 */

params ["_radioId", "", "_eventData"];

_eventData params ["_txId"];
private _currentTransmissions = SCRATCH_GET(_radioId,"currentTransmissions");
_currentTransmissions = _currentTransmissions - [_txId];

if (_currentTransmissions isEqualTo []) then {
    private _beeped = SCRATCH_GET(_radioId,"hasBeeped");
    private _pttDown = SCRATCH_GET_DEF(_radioId,"PTTDown",false);
    if (!_pttDown && {!isNil "_beeped" && {_beeped}}) then {
        private _volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
        [_radioId, "Acre_GenericClickOff", [0,0,0], [0,1,0], _volume] call EFUNC(sys_radio,playRadioSound);
    };
    SCRATCH_SET(_radioId,"hasBeeped",false);
    SCRATCH_SET(_radioId,"receivingSignal",0);
};

// Update interface
if (_radioId isEqualTo GVAR(currentRadioId)) then {
    // If display is open
    private _currentMenu = GET_STATE_DEF("currentMenu","");
    if ((_currentMenu isEqualType "") && {_currentMenu != ""}) then {
        private _tmpMenu = HASH_GET(GVAR(Menus),_currentMenu);
        if (!isNil "_tmpMenu") then {
            _currentMenu = _tmpMenu;
        };
    };

    [_currentMenu, _currentMenu] call FUNC(renderMenu);
};

true;
