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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_setTxPositionEnd;
 *
 * Public: No
 */

if (_this select 1 == 0) then {
    [] call FUNC(clearOverlayMessage);
    private _ctrl = _this select 0;
    _ctrl ctrlRemoveEventHandler ["MouseButtonDown", GVAR(txSetPosEH)];

    private _x = _this select 2;
    private _y = _this select 3;
    private _pos = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [_x, _y];
    _pos set [2, getTerrainHeightASL _pos];
    with uiNamespace do {
        //IGNORE_PRIVATE_WARNING ["_pos"];
        GVAR(txPositionTxt) ctrlSetText format["%1,%2,%3", (_pos select 0) call FUNC(formatNumber), (_pos select 1) call FUNC(formatNumber), (_pos select 2) call FUNC(formatNumber)];
        GVAR(txPositionTxt) ctrlCommit 0;
        GVAR(txPosition) = _pos;
        deleteMarkerLocal QGVAR(txPosMarker);
        private _marker = createMarkerLocal [QGVAR(txPosMarker), _pos];
        _marker setMarkerTypeLocal "mil_dot_noshadow";
        _marker setMarkerTextLocal "Tx Pos";
        _marker setMarkerColorLocal "ColorGreen";
    };
};
