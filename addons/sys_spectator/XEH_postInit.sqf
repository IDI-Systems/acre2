#include "script_component.hpp"

["ACRE2", QGVAR(clearRadios), [LSTRING(ClearRadios), LSTRING(ClearRadios_Description)], {
    // Keybind usage is handled manually for spectator displays
}, {}, [DIK_R, [true, true, false]]] call CBA_fnc_addKeybind; // Default: CTRL + SHIFT + R
