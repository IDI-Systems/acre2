#include "script_component.hpp"

if (!hasInterface) exitWith {};

["ace_arsenal_displayOpened", {
    EGVAR(sys_core,arsenalOpen) = true;
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
        (lnbSize _rightPanel) params ["_rows", "_columns"];

        for "_r" from 0 to (_rows - 1) do {
            private _data = _rightPanel lnbData [_r, 0];
            if ([_data] call EFUNC(api,isRadio)) then {
                private _displayName = [_data] call EFUNC(api,getDisplayName);
                private _currentChannel = [_data] call EFUNC(api,getRadioChannel);
                private _dataNew = format [localize LSTRING(channelShort), _displayName, _currentChannel];

                _rightPanel lnbSetText [[_r, 1], _dataNew];
            };
        };
    };
}] call CBA_fnc_addEventHandler;
