#include "script_component.hpp"
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

call FUNC(handleZeusSpeakPressUp);
[false] call EFUNC(api,setSpectator);
