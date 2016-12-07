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

// if (!(_radioId in ([] call EFUNC(sys_data,getPlayerRadioList)))) then {
    HASH_SET(acre_sys_data_radioData, _radioId, nil);
    if (HASH_HASKEY(acre_sys_data_radioScratchData, _radioId)) then {
        HASH_REM(acre_sys_data_radioScratchData, _radioId);
    };
    HASH_REM(GVAR(objectIdRelationTable), _radioId)
// } else {
    // _radioData = HASH_GET(acre_sys_data_radioData, _radioId);

    // [QGVAR(invalidGarbageCollect), [acre_player, _radioId, _radioData]] call CALLSTACK(CBA_fnc_serverEvent);
// };
