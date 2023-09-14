#include "script_component.hpp"

if (!hasInterface) exitWith {};

["ace_arsenal_displayOpened", {
    params ["_display"];
    EGVAR(sys_core,arsenalOpen) = true;
    [_display] call EFUNC(sys_core,addDisplayPassthroughKeys);
}] call CBA_fnc_addEventHandler;

["ace_arsenal_displayClosed", {
    EGVAR(sys_core,arsenalOpen) = false;
}] call CBA_fnc_addEventHandler;

["ace_arsenal_rightPanelFilled", {
    #define IDC_buttonUniform 2010
    #define IDC_buttonVest 2012
    #define IDC_buttonBackpack 2014
    #define IDC_buttonMisc 38
    #define IDC_rightTabContentListnBox 15

    params ["_display", "_leftPanelIDC", "_rightPanelIDC"];

    if (_leftPanelIDC in [IDC_buttonUniform, IDC_buttonVest, IDC_buttonBackpack] && {_rightPanelIDC == IDC_buttonMisc}) then {
        private _rightPanel = _display displayCtrl IDC_rightTabContentListnBox;
        (lnbSize _rightPanel) params ["_rows"];

        for "_r" from 0 to (_rows - 1) do {
            private _data = _rightPanel lnbData [_r, 0];
            if (_data call EFUNC(api,isRadio)) then {
                _rightPanel lnbSetText [[_r, 1], _data call EFUNC(sys_core,getDescriptiveName)];
            };
        };
    };
}] call CBA_fnc_addEventHandler;

["ace_respawn_saveGear", {
    params ["_unit"];

    private _filteredLoadout = [_unit] call EFUNC(api,filterUnitLoadout);
    _unit setVariable ["ace_respawn_unitGear", _filteredLoadout];
    TRACE_1("applied loadout filter on ace_respawn_saveGear",_filteredLoadout);
}] call CBA_fnc_addEventHandler;

// Notification displays
[IDD_SPEC_DISPLAY] call EFUNC(api,addNotificationDisplay);
[IDD_ace_arsenal] call EFUNC(api,addNotificationDisplay);
