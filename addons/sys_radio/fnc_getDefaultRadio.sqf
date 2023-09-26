#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returs the default ItemRadio replacement class and display name.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 0: Radio Class Name <ARRAY>
 * 1: Radio Display Name <ARRAY>
 *
 * Example:
 * [] call acre_sys_radio_fnc_getDefaultRadio
 *
 * Public: No
 */

[
    (GVAR(defaultRadios) select 0) select GVAR(defaultRadio),
    (GVAR(defaultRadios) select 1) select GVAR(defaultRadio)
]
