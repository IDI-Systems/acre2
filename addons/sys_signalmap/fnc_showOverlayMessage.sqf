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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_showOverlayMessage;
 *
 * Public: No
 */

with uiNamespace do {
    GVAR(ctrlGroup) ctrlShow false;
    GVAR(ctrlGroup) ctrlCommit 0;
    GVAR(overlayMessageGrp) = GVAR(mapDisplay) ctrlCreate ["RscControlsGroupNoScrollbars", 13119];
    GVAR(signal_debug) pushBack GVAR(overlayMessageGrp);
    GVAR(overlayMessageGrp) ctrlSetPosition [safezoneX + safezoneW - 0.5, safezoneY + safezoneH - 1, 0.5, 0.75];
    GVAR(overlayMessageGrp) ctrlCommit 0;
    ctrlSetFocus GVAR(overlayMessageGrp);

    private ["_bg", "_customText"];
    CTRLOVERLAY(_bg,"RscBackground");
    _bg ctrlSetPosition [0, 0, 0.5, 0.75];
    _bg ctrlCommit 0;
    CTRLOVERLAY(_customText,"RscStructuredText");
    _customText ctrlSetPosition [0, 0.3, 0.5, 0.75/2];
    _customText ctrlSetStructuredText (parseText (_this select 0));
    _customText ctrlCommit 0;
};
