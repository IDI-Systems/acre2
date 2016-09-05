//fnc_setOnOffState.sqf
#include "script_component.hpp"

params ["_radioId", "_event", "_eventData", "_radioData"];

HASH_SET(_radioData, "radioOn", _eventData);
if(_radioId == acre_sys_radio_currentRadioDialog) then {
    if(_eventData == 0) then {
        //acre_player sideChat "RADIO OFF!";
        HASH_SET(_radioData, "currentState", "OffDisplay");
        HASH_SET(_radioData, "menuPage", 0);
        HASH_SET(_radioData, "menuIndex", 0);
        HASH_SET(_radioData, "entryCursor", 0);
        HASH_SET(_radioData, "selectedEntry", 0);
    } else {
        if(_eventData == 0.5) then {
            //acre_player sideChat "RADIO ON!";
            HASH_SET(_radioData, "currentState", "PostScreen");
            HASH_SET(_radioData, "menuPage", 0);
            HASH_SET(_radioData, "menuIndex", 0);
            HASH_SET(_radioData, "entryCursor", 0);
            HASH_SET(_radioData, "selectedEntry", 0);
        };
    };
    _display = uiNamespace getVariable QUOTE(GVAR(currentDisplay));
    [_display] call FUNC(render);
};

