#include "script_component.hpp"

private _category = format ["ACRE %1", localize "str_a3_cfghints_curator_curator_displayname"];

[_category, "ZeusTalkFromCamera",  [(LLSTRING(SpeakFromCamera)), (LLSTRING(SpeakFromCamera_description))],
    { call FUNC(handleZeusSpeakPress) },
    { call FUNC(handleZeusSpeakPressUp) },
[40, [false, false, false]]] call cba_fnc_addKeybind; //Default bound to `

// There is no EH for opening the zeus interface
(findDisplay 46) displayAddEventHandler ["KeyDown", {
    if (inputAction "CuratorInterface" > 0) then {
        call FUNC(handleZeusSpeakPressUp);
        [false] call EFUNC(api,setSpectator);
    };
    false
}];
