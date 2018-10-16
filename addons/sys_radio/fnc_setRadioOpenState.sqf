#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handle radio GUI opened/closed state.
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 * 1: Radio open state <BOOL>
 *
 * Return Value:
 * Can open radio <BOOL>
 *
 * Example:
 * ["acre_prc152_id_1", false] call acre_sys_radio_fnc_setRadioOpenState
 *
 * Public: No
 */

params ["_radioId", "_isRadioOpen"];

[_radioId, "setState", ["radioGuiOpened", _isRadioOpen]] call EFUNC(sys_data,dataEvent);

// In case of external radios or accessible racked radios, update the status on the server as well
if (_radioId in ACRE_ACCESSIBLE_RACK_RADIOS || {_radioId in ACRE_ACTIVE_EXTERNAL_RADIOS} || {_radioId in ACRE_EXTERNALLY_USED_MANPACK_RADIOS}) then {
    [QEGVAR(sys_server,openRadioUpdate), [_radioId, _isRadioOpen, acre_player]] call CBA_fnc_serverEvent;
};
