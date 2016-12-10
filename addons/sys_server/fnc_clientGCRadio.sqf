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

params ["_radioId"];

private _radioList = [] call EFUNC(sys_data,getPlayerRadioList);
_radioList = _radioList apply {toLower _x};

if ((toLower _radioId) in _radioList) then {
    private _message = format ["[ACRE] Your radio '%1' is being garbage collected. The server believes you do not have this radio. You are probably desynced. Please contact the server administrator.",_radioId];
    systemChat _message;
    ERROR(_message);

    // Send event to server - so it is logged to server RPT as well.
    [QGVAR(invalidGarbageCollect), [acre_player, _radioId]] call CALLSTACK(CBA_fnc_serverEvent);
};


// if (!(_radioId in ([] call EFUNC(sys_data,getPlayerRadioList)))) then {
    HASH_SET(acre_sys_data_radioData, _radioId, nil);
    if (HASH_HASKEY(acre_sys_data_radioScratchData, _radioId)) then {
        HASH_REM(acre_sys_data_radioScratchData, _radioId);
    };
    HASH_REM(GVAR(objectIdRelationTable), _radioId);
// } else {
    // NOTE - If you intend to uncomment this the format of Radio Data is now HASH - This would need addressing if the following was to be re-used.
    // _radioData = HASH_GET(acre_sys_data_radioData, _radioId);

    // [QGVAR(invalidGarbageCollect), [acre_player, _radioId, _radioData]] call CALLSTACK(CBA_fnc_serverEvent);
// };
