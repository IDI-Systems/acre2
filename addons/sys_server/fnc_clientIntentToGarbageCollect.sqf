/*
 * Author: ACRE2Team
 * Handles an intent to garbage collect message on the client side. Will create a PFH to monitor the local inventory and periodically send messages to the server to indiciate if the radio is still in use this will prevent it from being garbage collected.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc152_id_1"] call acre_sys_server_fnc_clientIntentToGarabageCollect
 *
 * Public: No
 */
#include "script_component.hpp"
params ["_radioId"];

_radioId = (toLower _radioId);
private _radioList = ([] call EFUNC(sys_data,getPlayerRadioList)) apply {toLower _x};

if (_radioId in _radioList) then {
    WARNING_1("The server was intending to garbage collect radio '%1' but it still exists locally.",_radioId);

    // Send event to server - so it is logged to server RPT as well.
    GVAR(radioGCWatchList) pushBackUnique _radioId;

    if (GVAR(clientGCPFHID) == -1) then {
        GVAR(clientGCPFHID) = [{
            private _radioList = ([] call EFUNC(sys_data,getPlayerRadioList)) apply {toLower _x};
            GVAR(radioGCWatchList) = GVAR(radioGCWatchList) select {
                private _bool = _x in _radioList;
                if (!(_x in _radioList)) then {
                    // Local player no longer has radio - send event to restart the GC process should another desynced player recieve it.
                    [QGVAR(removeGCQueue), [_x]] call CALLSTACK(CBA_fnc_serverEvent);
                    false;
                } else {
                    true;
                };
            };

            {
                [QGVAR(stopRadioGarbageCollect), [acre_player, _x]] call CALLSTACK(CBA_fnc_serverEvent);
            } forEach GVAR(radioGCWatchList);

            if (count GVAR(radioGCWatchList) == 0) then {
                [_this select 1] call CBA_fnc_removePerFrameHandler;
                GVAR(clientGCPFHID) = -1;
            };
        }, 10, []] call CBA_fnc_addPerFrameHandler;
    };
};
