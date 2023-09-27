#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_clearDisplay
 *
 * Public: No
 */

private _display = uiNamespace getVariable [QGVAR(currentDisplay), displayNull];

FUNC(_internalClearDisplay) = {
    params ["_row", "_columns"];

    for "_i" from 0 to _columns do {
        private _id = ((_row * 1000) +1) + _i;
        private _ctrl = (_display displayCtrl _id);
        _ctrl ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0];
        _ctrl ctrlSetTextColor [0.1, 0.1, 0.1, 1];
        _ctrl ctrlSetText "";
        _ctrl ctrlCommit 0;
    };
};

[ROW_SMALL_1, COLUMNS_SMALL] call FUNC(_internalClearDisplay);
[ROW_SMALL_2, COLUMNS_SMALL] call FUNC(_internalClearDisplay);
[ROW_SMALL_3, COLUMNS_SMALL] call FUNC(_internalClearDisplay);
[ROW_SMALL_4, COLUMNS_SMALL] call FUNC(_internalClearDisplay);
[ROW_SMALL_5, COLUMNS_SMALL] call FUNC(_internalClearDisplay);

[ROW_LARGE_1, COLUMNS_LARGE] call FUNC(_internalClearDisplay);
[ROW_LARGE_2, COLUMNS_LARGE] call FUNC(_internalClearDisplay);
[ROW_LARGE_3, COLUMNS_LARGE] call FUNC(_internalClearDisplay);
[ROW_LARGE_4, COLUMNS_LARGE] call FUNC(_internalClearDisplay);

[ROW_XLARGE_1, COLUMNS_XLARGE] call FUNC(_internalClearDisplay);
[ROW_XLARGE_2, COLUMNS_XLARGE] call FUNC(_internalClearDisplay);

[ROW_XXLARGE_1, COLUMNS_XXLARGE] call FUNC(_internalClearDisplay);

//[ICON_KNOB, false] call FUNC(toggleIcon);
[ICON_LOADING, false] call FUNC(toggleIcon);
[ICON_LOGO, false] call FUNC(toggleIcon);
[ICON_BATTERY, false] call FUNC(toggleIcon);
[ICON_VOLUME, false] call FUNC(toggleIcon);
[ICON_TRANSMIT, false] call FUNC(toggleIcon);
[ICON_TRANSMITBAR, false] call FUNC(toggleIcon);
[ICON_UP, false] call FUNC(toggleIcon);
[ICON_DOWN, false] call FUNC(toggleIcon);
[ICON_UPDOWN, false] call FUNC(toggleIcon);
[ICON_SCROLLBAR, false] call FUNC(toggleIcon);
