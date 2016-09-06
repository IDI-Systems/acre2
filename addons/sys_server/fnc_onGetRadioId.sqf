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

params["_player", "_class", "_callback", ["_replacementId",""]];

if (getNumber(configFile >> "CfgWeapons" >> _class >> "acre_hasUnique") == 0) then {
    _class = BASECLASS(_class);
};

private _ret = [_class] call FUNC(getRadioId);
if(_ret != -1) then {
    private _uniqueClass = format["%1_id_%2", tolower(_class), _ret];

    if(!(_uniqueClass in GVAR(masterIdList))) then {
        PUSH(GVAR(masterIdList), _uniqueClass);
        if(isServer) then {
            private _dataHash = HASH_CREATE;
            if(_replacementId != "") then {
                _dataHash = HASH_COPY(HASH_GET(acre_sys_data_radioData, _replacementId));
            };
            HASH_SET(acre_sys_data_radioData,_uniqueClass,_dataHash);
        };
        TRACE_1("callback=", _callback);
        PUSH(GVAR(unacknowledgedIds), _uniqueClass);
        HASH_SET(GVAR(masterIdTable), _uniqueClass, ARR_2(acre_player, acre_player));
        [_callback, [_player, _uniqueClass, _ret, _replacementId]] call CALLSTACK(LIB_fnc_globalEvent);
        // GVAR(waitingForIdAck) = true;
    };
} else {
    diag_log text format["%1 ACRE ERROR: ALL IDS FOR CLASS %2 ARE TAKEN!", COMPAT_diag_tickTime, _class];
};
