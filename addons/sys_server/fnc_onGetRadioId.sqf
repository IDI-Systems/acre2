/*
 * Author: ACRE2Team
 * This function is used to start initializing a radio for the intended player. The callback is used to complete the process.
 *
 * Arguments:
 * 0: Player's game object <OBJECT>
 * 1: Radio base classname <STRING>
 * 2: CBA event name that is triggered when complete <STRING>
 * 3: Replacement ID - Use this when copying data from another radio <STRING> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_player,"acre_prc152","acre_sys_radio_returnRadioId"] call acre_sys_server_fnc_onGetRadioId
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_player", "_class", "_callback", ["_replacementId",""]];

if !(_class call EFUNC(sys_radio,isBaseClassRadio)) then {
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
