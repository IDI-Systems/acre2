#include "script_component.hpp"

if (!hasInterface) exitWith {};

// CBA Event Handlers
[QGVAR(startSpeaking), {
    params ["_speakingUnit"];

    // Debug
    if (GVAR(speakingGods) find _speakingUnit != -1) then {
        ERROR_1("Tryied to add an already speaking God....",_speakingUnit);
    };

    GVAR(speakingGods) pushBackUnique _speakingUnit;

    if (GVAR(rxNotification)) then {
        GVAR(rxNotificationLayer) = [format ["RX: %1", localize LSTRING(god)], name _speakingUnit, "", -1, GVAR(notificationColor)] call EFUNC(sys_list,displayHint);
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(stopSpeaking), {
    params ["_speakingUnit"];

    // Debug
    if (GVAR(speakingGods) isEqualTo []) then {
        ERROR_1("Empty speaking Gods array while trying to delete God %1!",_speakingUnit);
    };

    GVAR(speakingGods) deleteAt (GVAR(speakingGods) find _speakingUnit);

    if (GVAR(rxNotificationLayer) != "") then {
        [GVAR(rxNotificationLayer)] call EFUNC(sys_list,hideHint);
        GVAR(rxNotificationLayer) = "";
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(showText), {
    params ["_text"];

    private _fontColor = GVAR(notificationColor) call BIS_fnc_colorRGBAtoHTML;
    systemChat format ["<font color='%1'>God:</font> %2", _fontColor, _text];
}] call CBA_fnc_addEventHandler;

// Keybinds - God Mode
private _category = format ["ACRE2 %1", localize LSTRING(godMode)];
[_category, "GodModePTTKeyCurrentChannel", [localize LSTRING(currentChannelPttKey), localize LSTRING(currentChannelPttKey_description)], {
    [GODMODE_CURRENTCHANNEL] call FUNC(handlePttKeyPress)
}, {
    [GODMODE_CURRENTCHANNEL] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;

[_category, "GodModePTTKeyGroup1", [localize LSTRING(group1PttKey), localize LSTRING(group1PttKey_description)], {
    [GODMODE_GROUP1] call FUNC(handlePttKeyPress)
}, {
    [GODMODE_GROUP1] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;

[_category, "GodModePTTKeyGroup2", [localize LSTRING(group2PttKey), localize LSTRING(group2PttKey_description)], {
    [GODMODE_GROUP2] call FUNC(handlePttKeyPress)
}, {
    [GODMODE_GROUP2] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;

[_category, "GodModePTTKeyGroup3", [localize LSTRING(group3PttKey), localize LSTRING(group3PttKey_description)], {
    [GODMODE_GROUP3] call FUNC(handlePttKeyPress)
}, {
    [GODMODE_GROUP3] call FUNC(handlePttKeyPressUp)
}] call CBA_fnc_addKeybind;
