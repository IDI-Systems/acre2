/*
 * Author: ACRE2Team
 * Function called when the radio transmission is ended. It manages the radio behaviour if there
 * are more than one transmission.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "handleEndTransmission" <STRING> (Unused)
 * 2: Event data with transmitting ID <STRING>
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * True <BOOL>
 *
 * Example:
 * ["ACRE_PRC343_ID_1", "handleEndTransmission", "ACRE_PRC343_ID_2", [], false] call acre_sys_prc343_fnc_handleEndTransmission
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "", "_eventData", "", ""];

_eventData params ["_txId"];
private _currentTransmissions = SCRATCH_GET(_radioId,"currentTransmissions");
_currentTransmissions = _currentTransmissions - [_txId];

if ((count _currentTransmissions) == 0) then {
    private _beeped = SCRATCH_GET(_radioId, "hasBeeped");
    private _pttDown = SCRATCH_GET_DEF(_radioId, "PTTDown", false);
    if (!_pttDown) then {
        if (!isNil "_beeped" && {_beeped}) then {
            private _volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
            [_radioId, "Acre_GenericClickOff", [0,0,0], [0,1,0], _volume] call EFUNC(sys_radio,playRadioSound);
        };
    };
    SCRATCH_SET(_radioId, "hasBeeped", false);
};

true;
