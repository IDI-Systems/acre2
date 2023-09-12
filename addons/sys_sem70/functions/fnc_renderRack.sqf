#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_sem70_fnc_renderRack
 *
 * Public: No
 */
#define RADIO_CTRL(var1) (_display displayCtrl var1)

params ["_display","_isMounted"];

private _backgroundImages = [
    QPATHTOF(data\ui\sem70ui_ca.paa),
    QPATHTOF(data\ui\sem90ui_ca.paa)
];

private _displayGPImages = [
    QPATHTOF(data\display\gp80_display_0.paa),
    QPATHTOF(data\display\gp80_display_off.paa)
];

private _ledBetrImages = [
    QPATHTOF(data\knobs\led\led_betr_sp_an.paa),
    QPATHTOF(data\knobs\led\led_betr_sp_aus.paa)
];

private _ledGer2Images = [
    QPATHTOF(data\knobs\led\led_ger2_an.paa),
    QPATHTOF(data\knobs\led\led_ger2_aus.paa)
];

private _ledGer13Images = [
    QPATHTOF(data\knobs\led\led_ger13_an.paa),
    QPATHTOF(data\knobs\led\led_ger13_aus.paa)
];

if (_isMounted) then {
    RADIO_CTRL(300) ctrlSetText (_backgroundImages select 1);
    RADIO_CTRL(117) ctrlSetText (_displayGPImages select 0);
    RADIO_CTRL(118) ctrlSetText (_ledBetrImages select 0);
    RADIO_CTRL(119) ctrlSetText (_ledGer2Images select 1);
    RADIO_CTRL(120) ctrlSetText (_ledGer13Images select 1);
} else {
    RADIO_CTRL(300) ctrlSetText (_backgroundImages select 0);
    RADIO_CTRL(117) ctrlSetText "";
    RADIO_CTRL(118) ctrlSetText "";
    RADIO_CTRL(119) ctrlSetText "";
    RADIO_CTRL(120) ctrlSetText "";
};

true
