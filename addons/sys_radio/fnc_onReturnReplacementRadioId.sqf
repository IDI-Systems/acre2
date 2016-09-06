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
LOG("HIT CALLBACK");

params["_player", "_class", "_replacementId"];

if(_player == acre_player) then {
    // Add a new radio based on the id we just got
    TRACE_1("Adding replacement radio", _class);
    TRACE_2("checking", _replacementId, GVAR(replacementRadioIdList));
    if(!(_replacementId in GVAR(replacementRadioIdList))) exitWith {
        LOG("WTF?!?!?!");
    };
    // copy the oblix info
    // @TODO copy radio data to new id
    if(!(isNil "_oldOblix")) then {
        // @TODO copy radio data to new id
        // order of operations..we must always add the weapon LAST.
        [acre_player, _class] call EFUNC(lib,addGear);
        if((count GVAR(currentRadioList)) == 0) then {
            [_class] call EFUNC(sys_radio,setActiveRadio);
        };
        GVAR(pendingClaim) = GVAR(pendingClaim) - 1;
    } else {
        [_player, _class] call FUNC(onReturnRadioId);
    };

    REM(GVAR(replacementRadioIdList), _replacementId);
};
