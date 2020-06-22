#include "script_component.hpp"

["ACRE2", QGVAR(clearRadios), [LSTRING(ClearRadios), LSTRING(ClearRadios_Description)], {
    // Keybind usage is handled manually for spectator displays
}, {}, [DIK_R, [true, true, false]]] call CBA_fnc_addKeybind; // Default: CTRL + SHIFT + R

// Support for ACE Spectator display
["ace_spectator_displayLoaded", LINKFUNC(spectatorACEDisplayLoad)] call CBA_fnc_addEventHandler;
