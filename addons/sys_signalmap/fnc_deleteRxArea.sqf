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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_deleteRxArea;
 *
 * Public: No
 */
#include "script_component.hpp"

with uiNamespace do {
    _index = lbCurSel GVAR(rxAreaList);
    _areaIndex = parseNumber (GVAR(rxAreaList) lbData _index);
    GVAR(rxAreaList) lbDelete _index;
    _deleted = GVAR(rxAreas) deleteAt _areaIndex;
    deleteMarker (_deleted select 1);
};
