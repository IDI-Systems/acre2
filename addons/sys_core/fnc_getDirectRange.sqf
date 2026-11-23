#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * How far the voice server should send our direct speech. Listeners still attenuate it by the
 * voice curve; this only has to cover the distance at which it becomes inaudible.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Range in metres <NUMBER>
 *
 * Example:
 * [] call acre_sys_core_fnc_getDirectRange
 *
 * Public: No
 */

if (ACRE_VOICE_CURVE_MODEL == ACRE_CURVE_MODEL_SELECTABLE_B) then {
    // The table curve is silent past 150 m at curve scale 1.
    (150 * GVAR(curveScale)) max 10
} else {
    // The inverse curve never quite reaches zero; ACRE has always muted beyond 300 m.
    300
};
