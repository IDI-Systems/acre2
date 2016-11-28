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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_open;
 *
 * Public: No
 */

 if(isNil QGVAR(startDrawing)) then {
    with uiNamespace do {
        GVAR(mapDisplay) = (findDisplay 12);
        _mapCtrl = (GVAR(mapDisplay) displayCtrl 51);
        _mapCtrl ctrlAddEventHandler ["MouseButtonDown", QUOTE(_this call FUNC(onMapClick))];
        _mapCtrl ctrlAddEventHandler ["draw", QUOTE(_this call DFUNC(drawSignalSamples))];
    };
    GVAR(startDrawing) = true;
    [{ _this call FUNC(drawSignalMaps); }, 0, []] call cba_fnc_addPerFrameHandler;
};
[] call FUNC(drawMenu);
