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

params ["_delayedFrameFunction", "_parameters"];
private _frameNo = diag_frameNo;

ADDPFH(DFUNC(delayFramePFH), 0, ARR_3(_delayedFrameFunction, _parameters, _frameNo));
