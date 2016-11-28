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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_setRxAreaBegin;
 *
 * Public: No
 */

if(_this select 1 == 0) then {
    [] call FUNC(clearOverlayMessage);
    ["<t align='center'>Now, click elsewhere on the map to set the end of the Rx sampling area.</t>"] call FUNC(showOverlayMessage);
    _ctrl = _this select 0;
    _ctrl ctrlRemoveEventHandler ["MouseButtonDown", GVAR(rxSetEH)];

    _x = _this select 2;
    _y = _this select 3;
    _pos = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [_x, _y];
    _pos set[2, 0];
    with uiNamespace do {
        GVAR(rxAreaStart) = _pos;
        deleteMarkerLocal QGVAR(rxAreaStartMarker);
        _marker = createMarkerLocal [QGVAR(rxAreaStartMarker), _pos];
        _marker setMarkerTypeLocal "mil_dot_noshadow";
        _marker setMarkerTextLocal "Rx Area Begin";
        _marker setMarkerColorLocal "ColorRed";
    };
    GVAR(rxSetEH) = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(setRxAreaEnd))];
};
