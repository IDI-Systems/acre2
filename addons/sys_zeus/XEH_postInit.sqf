#include "script_component.hpp"

private _category = format ["ACRE2 %1", localize "str_a3_cfghints_curator_curator_displayname"];

[_category, "ZeusTalkFromCamera",  [(LLSTRING(SpeakFromCamera)), (LLSTRING(SpeakFromCamera_description))],
    { call FUNC(handleZeusSpeakPress) },
    { call FUNC(handleZeusSpeakPressUp) },
[41, [false, false, false]]] call CBA_fnc_addKeybind; //Default bound to `

if (hasInterface && {isClass (configFile >> "CfgPatches" >> "ace_interact_menu")}) then {
    private _acreNode = ["ACRE_ZeusEars", "ACRE", "", {}, { true }] call ace_interact_menu_fnc_createAction;
    [["ACE_ZeusActions"], _acreNode] call ace_interact_menu_fnc_addActionToZeus;

    private _spectatorEars = [
        "ACRE_SpectatorEars", LLSTRING(spectatorEars), "",
        { [true] call EFUNC(api,setSpectator) },
        { GVAR(zeusCanSpectate) && {!ACRE_IS_SPECTATOR} }
    ] call ace_interact_menu_fnc_createAction;
    [["ACE_ZeusActions", "ACRE_ZeusEars"], _spectatorEars] call ace_interact_menu_fnc_addActionToZeus;
    private _zeusEars = [
        "ACRE_ZeusEars", LLSTRING(zeusEars), "",
        { [false] call EFUNC(api,setSpectator) },
        { GVAR(zeusCanSpectate) && {ACRE_IS_SPECTATOR} }
    ] call ace_interact_menu_fnc_createAction;
    [["ACE_ZeusActions", "ACRE_ZeusEars"], _zeusEars] call ace_interact_menu_fnc_addActionToZeus;
};
