/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params["_radioList"];

private _listId = 20100;
lbClear _listId;
private _curIndex = 0;

// Populate local radio list
{
    private _radioClass = _x;
    private _freq = [_radioClass, "getListInfo"] call EFUNC(sys_data,dataEvent);
    private _baseConfig = inheritsFrom (configFile >> "CfgWeapons" >> _radioClass);
    private _realRadio = configName ( _baseConfig );
    private _typeName = getText (configFile >> "CfgAcreComponents" >> _realRadio >> "name");

    lbAdd [_listId, format["%1   Freq: %2Mhz",_typeName,_freq]];
    lbSetData [_listId, _curIndex, _radioClass];
    if(_radioClass == ACRE_ACTIVE_RADIO) then {
        lbSetColor [_listId, _curIndex, [1,0,0,1]];
        lbSetCurSel [_listId, _curIndex];
    };
    _curIndex = _curIndex + 1;
} foreach _radioList;
