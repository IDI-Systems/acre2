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

params ["_player", "_class", "_callback", ["_replacementId",""]];

if (!(_class call EFUNC(sys_radio,isBaseClassRadio))) then {
    _class = BASECLASS(_class);
};

private _ret = [_class] call FUNC(getRadioId);
if (_ret != -1) then {
    private _uniqueClass = format["%1_id_%2", tolower(_class), _ret];

    if (!(_uniqueClass in GVAR(masterIdList))) then {
        GVAR(masterIdList) pushBack _uniqueClass;
        if (isServer) then {
            private _dataHash = HASH_CREATE;
            if (_replacementId != "") then {
                _dataHash = HASH_COPY(HASH_GET(acre_sys_data_radioData, _replacementId));
            };
            HASH_SET(acre_sys_data_radioData,_uniqueClass,_dataHash);
        };
        TRACE_1("callback=", _callback);
        GVAR(unacknowledgedIds) pushBack _uniqueClass;
        HASH_SET(GVAR(unacknowledgedTable), _uniqueClass, time);
        HASH_SET(GVAR(masterIdTable), _uniqueClass, [ARR_2(acre_player,acre_player)]);
        [_callback, [_player, _uniqueClass, _ret, _replacementId]] call CALLSTACK(CBA_fnc_globalEvent);
        // GVAR(waitingForIdAck) = true;
    };
} else {
    WARNING("All IDs for class %2 are taken!",_class);
};
