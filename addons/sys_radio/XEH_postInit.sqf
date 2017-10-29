#include "script_component.hpp"

if (isServer) then {
    // Close the radio if it was opened in case of disconnection in order to prevend dead lock state
    GVAR(playerDisconnected) = addMissionEventHandler ["HandleDisconnected", {
        params ["_unit", "", "", ""];
        {
            [_x, "setState", ["radioGuiOpened", false]] call EFUNC(sys_data,dataEvent);
        } forEach (_unit getVariable [QEGVAR(sys_data,radioIdList), []]);
    }];
};

if (!hasInterface) exitWith {};

// radio claiming handler
[QGVAR(returnRadioId), { _this call FUNC(onReturnRadioId) }] call CALLSTACK(CBA_fnc_addEventHandler);

// main inventory thread
[] call FUNC(monitorRadios); // OK
