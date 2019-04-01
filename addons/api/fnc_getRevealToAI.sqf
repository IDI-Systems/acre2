#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns whether the player reveal to AI direct speech system is enabled. Return value is only valid on a player client.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * AI enabled <NUMBER>
 *
 * Example:
 * [] call acre_api_fnc_getRevealToAI;
 *
 * Public: Yes
 */

if (!isNil QEGVAR(sys_core,revealToAI)) exitWith {
    EGVAR(sys_core,revealToAI)
};

false
