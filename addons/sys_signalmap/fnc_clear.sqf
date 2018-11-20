#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_clear;
 *
 * Public: No
 */

with uiNamespace do {
    {
        deleteMarker (_x select 1);
    } forEach GVAR(rxAreas);
    GVAR(rxAreas) = [];
    {
        private _tile = GVAR(mapTiles) select _forEachIndex;
        _tile ctrlSetText "";
        _tile ctrlShow false;
        _tile ctrlCommit 0;
    } forEach GVAR(completedAreas);
    GVAR(completedAreas) = [];
    GVAR(txPosition) = nil;
    deleteMarker QGVAR(txPosMarker);
    lbClear GVAR(rxAreaList);
    GVAR(rxAreaList) ctrlCommit 0;
    GVAR(sampleData) = [];
};

[] call FUNC(modify);
