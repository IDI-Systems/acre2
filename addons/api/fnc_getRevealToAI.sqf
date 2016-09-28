/*
 * Author: ACRE2Team
 * Returns whether the player reveal to AI direct speech system is enabled.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * AI enabled <BOOLEAN>
 *
 * Example:
 * [] call acre_api_fnc_getRevealToAI;
 *
 * Public: Yes
 */
#include "script_component.hpp"

if(!isNil "ACRE_AI_ENABLED") exitWith {
    ACRE_AI_ENABLED
};

false
