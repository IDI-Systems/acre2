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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_clearOverlayMessage;
 *
 * Public: No
 */
#include "script_component.hpp"

with uiNamespace do {
    GVAR(ctrlGroup) ctrlShow true;
    GVAR(ctrlGroup) ctrlCommit 0;
    ctrlDelete GVAR(overlayMessageGrp);
};
