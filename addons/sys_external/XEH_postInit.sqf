#include "script_component.hpp"

ADDPFH(FUNC(externalRadioPFH), 0.91, []);

if (!hasInterface) exitWith {};

[QGVAR(startUsingRadioLocal), {
    params ["_message", "_radioId"];

    // Manpack radios can also be used by the owner if they are not rack radios
    if ([_radioId] call EFUNC(sys_radio,isManpackRadio) && ([_radioId] call EFUNC(sys_rack,getRackFromRadio) == "")) then {
        ACRE_EXTERNALLY_USED_MANPACK_RADIOS pushBackUnique _radioId;
    } else {
        // fnc_stopUsingRadio cannot be used here since radio is in player's inventory
        // If it is the active radio
        if (ACRE_ACTIVE_RADIO isEqualTo _radioId) then {
            // Otherwise cleanup
            if (ACRE_ACTIVE_RADIO == ACRE_BROADCASTING_RADIOID) then {
                // Simulate a key up event to end the current transmission
                [] call EFUNC(sys_core,handleMultiPttKeyPressUp);
            };
            // Switch active radio, but first reset it
            ACRE_ACTIVE_RADIO = "";
            ACRE_ACTIVE_RADIO = ([] call EFUNC(sys_data,getPlayerRadioList)) select 0;
        };
        ACRE_EXTERNALLY_USED_PERSONAL_RADIOS pushBackUnique _radioId;
    };

    [_message, ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
}] call CBA_fnc_addEventHandler;

[QGVAR(stopUsingRadioLocal), {
    params ["_message", "_radioId"];

    // Manpack radios can also be used by the owner if they are not rack radios
    if ([_radioId] call EFUNC(sys_radio,isManpackRadio) && ([_radioId] call EFUNC(sys_rack,getRackFromRadio) == "")) then {
        ACRE_EXTERNALLY_USED_MANPACK_RADIOS = ACRE_EXTERNALLY_USED_MANPACK_RADIOS - [_radioId];
    } else {
        ACRE_EXTERNALLY_USED_PERSONAL_RADIOS = ACRE_EXTERNALLY_USED_PERSONAL_RADIOS - [_radioId];
    };

    [_message, ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
}] call CBA_fnc_addEventHandler;

[QGVAR(giveRadioLocal), {
    params ["_message"];
    [_message, ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
}] call CBA_fnc_addEventHandler;

[QGVAR(giveRadioAction), {_this call FUNC(startUsingExternalRadio)}] call CBA_fnc_addEventHandler;
