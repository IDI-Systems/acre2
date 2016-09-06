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

private ["_gainData", "_3dDis", "_pEaddRx", "_Rp", "_ituLoss", "_Ltx", "_Lrx", "_Lm", "_Lb"];

params["_f", "_mW", "_receiverClass", "_transmitterClass", "_returnPos"];

_gainData = [_receiverClass, _transmitterClass, _f] call EFUNC(sys_antenna,getAntennaInfo);

if((count _gainData) == 0) exitWith { -999; }; // no antenna someplace!

_gainData params ["_receiverGain", "_transmitterGain", "","", "_receiverPos", "_transmitterPos"];

_returnPos set[0, _transmitterPos];
_returnPos set[1, _receiverPos];

if((_transmitterPos distance _receiverPos) == 0) then {
    _receiverPos set[2, (_receiverPos select 2)+0.1];
};

_3dDis = (_transmitterPos distance _receiverPos);

_pEaddRx = 0;
_pEaddRx = [_transmitterPos, _receiverPos, _f] call FUNC(objectLoss);

_Rp = [_3dDis, _f, _mW, 1] call FUNC(getFspl);
_ituLoss = [_transmitterPos, _receiverPos, _f] call FUNC(getItuLoss);

/*
Transmitter/Receiver cable/internal loss.
*/
_Ltx = 3; // Transmitter
_Lrx = 3; // Receiver

/*
Loss from fading, obstruction, noise, etc (including ITU model)
*/
_Lm = _ituLoss + ((random 1) - 0.5) + _pEaddRx;

/*
Total Link Budget
*/
_Lb = _Rp + _transmitterGain - _Ltx - _Lm + _receiverGain - _Lrx;


_Lb;
