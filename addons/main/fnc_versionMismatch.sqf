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

#define __br (parseText "<br />")
#define __det (parseText (format ["Version mismatch detected."]))
#define __server (parseText (format ["Server Version: %1", _serverVersion]))
#define __client (parseText (format ["Client Version:  <t color ='#FF0F00'>%1</t>", _localVersion]))
#define __update (parseText (format ["Go update sucker!"]))


private["_serverVersion", "_localVersion", "_i"];
_serverVersion = _this select 0;
_localVersion = _this select 1;
_player = _this select 2;

while { true } do {
    waitUntil { !dialog }; // OK
    if (_i > 5) exitWith { endMission "END6" };
    ADD(_i,1);

    createDialog "ACRE_VERSION_MISMATCH";
    ((findDisplay 666123666) displayCtrl 114113) ctrlSetStructuredText (composeText [__det, __br, __br, __server, __br, __client, __br, __br, __br, __update]);
    ((findDisplay 666123666) displayCtrl 4112) ctrlSetText "ACRE VERSION MISMATCH";

    sleep 10; // OK - TEMP
};
