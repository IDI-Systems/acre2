#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

if (!hasInterface) exitWith {};

["ACRE2", "CycleRadio", localize LSTRING(CycleRadio), {
    [1] call FUNC(cycleRadios)
}, "", [DIK_CAPSLOCK, [true, false, true]]] call CBA_fnc_addKeybind;

["ACRE2", "OpenRadio", localize LSTRING(OpenRadio), {
    [ACRE_ACTIVE_RADIO] call EFUNC(sys_radio,openRadio)
}, "", [DIK_CAPSLOCK, [false, true, true]]] call CBA_fnc_addKeybind;

// Notification displays
[IDD_RSCDISPLAYCURATOR] call FUNC(addDisplaySupport);
//[IDD_AV_TERMINAL] call FUNC(addDisplaySupport); // Text shows up as '-' for some reason
[IDD_RSCDISPLAYEGSPECTATOR] call FUNC(addDisplaySupport);

// Cleanup any remaining notification controls (eg. restart in editor)
private _display = findDisplay 46;
for "_i" from 0 to 4 do {
    ctrlDelete (_display displayCtrl (IDC_GROUP + _i));
    ctrlDelete (_display displayCtrl (IDC_FLASH_GROUP + _i));
};
