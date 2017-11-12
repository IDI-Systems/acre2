#include "script_component.hpp"

if (!hasInterface) exitWith {};

["ace_arsenal_rightPanelFilled", {
    if (ace_arsenal_currentLeftPanel in [2010, 2012, 2014] && {ace_arsenal_currentRightPanel == 38}) then {
        private _rightPanel = (findDisplay 1127001) displayCtrl 15;
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
