#include "script_component.hpp"

[QGVAR(disconnectGsa), FUNC(disconnectServer)] call CBA_fnc_addEventHandler;

[QGVAR(connectGsa), FUNC(connectServer)] call CBA_fnc_addEventHandler;

[QGVAR(notifyPlayer), {
    params ["_text"];

    [[ICON_RADIO_CALL], [_text]] call CBA_fnc_notify;
}] call CBA_fnc_addEventHandler;
