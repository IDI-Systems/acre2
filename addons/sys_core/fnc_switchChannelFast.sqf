#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the channel switching keybind.
 *
 * Arguments:
 * 0: Channel change amount (expected -1 or 1) <NUMBER>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [1] call acre_sys_core_fnc_switchChannelFast
 *
 * Public: No
 */

params ["_dir"];

private _return = false;
private _radioId = ACRE_ACTIVE_RADIO;

private _radioType = [_radioId] call EFUNC(sys_radio,getRadioBaseClassname);
private _typeName = getText (configFile >> "CfgAcreComponents" >> _radioType >> "name");
private _isManpack = getNumber (configFile >> "CfgAcreComponents" >> _radioType >> "isPackRadio");
private _isRackRadio = (vehicle acre_player != acre_player) && {_radioId in (([vehicle acre_player] call EFUNC(api,getVehicleRacks)) apply {[_x] call EFUNC(api,getMountedRackRadio)})} && {[_radioId, acre_player] call EFUNC(sys_rack,isRadioAccessible)};

if (_isManpack == 0 || {_isRackRadio}) then {
    private _channel = [_radioId] call EFUNC(api,getRadioChannel);

    switch (_radioType) do {
        case "ACRE_PRC343";
        case "ACRE_PRC148": {
            private _currentBlock = floor((_channel-1) / 16);
            _channel = ((_channel + _dir) max (_currentBlock*16 + 1)) min ((_currentBlock + 1)*16);
        };
        case "ACRE_PRC152": {
            _channel = (_channel + _dir) min 5;
        };
        default {
            _channel = _channel + _dir;
        };
    };

    _return = [_radioId,_channel] call EFUNC(api,setRadioChannel);

    private _listInfo = [_radioId, "getListInfo"] call EFUNC(sys_data,dataEvent);
    [_typeName, _listInfo, "", 0.5, [ACRE_NOTIFICATION_PURPLE]] call EFUNC(sys_list,displayHint);
    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
};

_return
