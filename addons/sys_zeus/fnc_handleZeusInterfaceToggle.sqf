/*
 * Author: SynixeBrett
 * Handles the zeus interface being toggled.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call acre_sys_zeus_fnc_handleZeusInterfaceToggle
 *
 * Public: No
 */
#include "script_component.hpp"

call FUNC(handleZeusSpeakPressUp);
[false] call EFUNC(api,setSpectator);
