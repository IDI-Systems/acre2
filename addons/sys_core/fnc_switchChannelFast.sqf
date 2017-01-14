/*
 * Author: ACRE2Team
 * Handles the channel switching keybind
 *
 * Arguments:
 * 0: Channel change amount (expected -1 or 1) <NUMBER>
 *
 * Return Value:
 * Handled <BOOLEAN>
 *
 * Example:
 * [1] call acre_sys_core_fnc_switchChannelFast
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_dir"];

private _return = false;
private _radioId = ACRE_ACTIVE_RADIO;

private _baseConfig = inheritsFrom  (configFile >> "CfgWeapons" >> _radioId);
private _radioType = configName (_baseConfig);
private _typeName = getText (configFile >> "CfgAcreComponents" >> _radioType >> "name");
private _isManpack = getNumber (configFile >> "CfgAcreComponents" >> _radioType >> "isPackRadio");

if (_isManpack == 0) then {
    private _channel = [_radioId] call acre_api_fnc_getRadioChannel;

    switch (_radioType) do {
        case ("ACRE_PRC343"): {
            private _currentBlock = floor((_channel-1) / 16);
            _channel = ((_channel + _dir) max (_currentBlock*16 + 1)) min ((_currentBlock + 1)*16);
        };
        case ("ACRE_PRC152"): {
            _channel = (_channel + _dir) min 5;
        };
        default {
            _channel = _channel + _dir;
        };
    };

    _return = [_radioId,_channel] call acre_api_fnc_setRadioChannel;

    private _listInfo = [_radioId, "getListInfo"] call EFUNC(sys_data,dataEvent);
    [_typeName, _listInfo, "", 1] call EFUNC(sys_list,displayHint);
    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
};

_return
