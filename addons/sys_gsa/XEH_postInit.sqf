#include "script_component.hpp"

[QGVAR(notifyPlayer), {
    params ["_text"];

    [[ICON_RADIO_CALL], [_text]] call CBA_fnc_notify;
}] call CBA_fnc_addEventHandler;
