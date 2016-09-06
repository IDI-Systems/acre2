/*
 * Author: AUTHOR
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
disableSerialization;
_listId = 20100;
_listControl = ((findDisplay 20099) displayCtrl 20100);
_index = lbCurSel _listId;
_radio = lbData [_listId, _index];
[_radio] call EFUNC(sys_radio,setActiveRadio);

[([] call EFUNC(sys_data,getPlayerRadioList))] call FUNC(populateList);
