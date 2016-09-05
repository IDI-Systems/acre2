//fnc_handleEscButton.sqf
#include "script_component.hpp"

if(GET_STATE(editEntry)) then {
    SET_STATE(editEntry, false);
    SET_STATE(currentEditEntry, "");
} else {
    
};
