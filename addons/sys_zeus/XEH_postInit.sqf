#include "script_component.hpp"

["ACRE2", "ZeusTalkFromCamera",  [(LLSTRING(SpeakFromCamera)), (LLSTRING(SpeakFromCamera_description))],
    { call FUNC(handleZeusSpeakPress) },
    { call FUNC(handleZeusSpeakPressUp) },
[40, [false, false, false]]] call cba_fnc_addKeybind; //Default bound to `


// There is no EH for opening the zeus interface
(findDisplay 46) displayAddEventHandler ["KeyDown", {
	if (inputAction "CuratorInterface" > 0) then {
        call FUNC(handleZeusSpeakPressUp)
	};
	false
}];
