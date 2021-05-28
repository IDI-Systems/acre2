#include "script_component.hpp"

["handleGetHeadlessID", { call FUNC(handleGetHeadlessID) }] call EFUNC(sys_rpc,addProcedure);
[QEGVAR(sys_radio,returnRadioId), { call FUNC(handleReturnRadioId) }] call CBA_fnc_addEventHandler;

if (hasInterface) then {
    [
        {!isNull findDisplay 46},
        {
            (findDisplay 46) displayAddEventHandler ["Unload", {
                // Cleanup all headless ID's at mission end (or they will keep playing next mission, lol)
                {
                    TRACE_1("RPC STOP: mission end",_x);
                    ["ext_remoteStopSpeaking", format ["%1,", _x]] call EFUNC(sys_rpc,callRemoteProcedure);
                } forEach (missionNamespace getVariable [QGVAR(idsToCleanup), []])
            }];
        }
    ] call CBA_fnc_waitUntilAndExecute;
};
