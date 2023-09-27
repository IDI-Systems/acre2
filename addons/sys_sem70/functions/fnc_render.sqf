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
 * [ARGUMENTS] call acre_sys_sem70_fnc_render
 *
 * Public: No
 */
#define RADIO_CTRL(var1) (_display displayCtrl var1)

params ["_display"];

TRACE_1("Render",_display);

//private _channelKnobPosition = GET_STATE("channelKnobPosition");
private _mainKnobPosition = GET_STATE("mainKnobPosition");
private _functionKnobPosition = GET_STATE("functionKnobPosition");
private _manualChannelSelection = GET_STATE("manualChannelSelection");
private _channelStepPosition = GET_STATE("channelSpacingKnobPosition");
private _volumeKnobPosition = GET_STATE("volumeKnobPosition");
private _kHzKnobPosition = GET_STATE("kHzKnobPosition");
private _MHzKnobPosition = GET_STATE("MHzKnobPosition");
private _memorySlotKnobPosition = GET_STATE("MemorySlotKnobPosition");
private _networkKnobPosition = GET_STATE("NetworkKnobPosition");


private _displayButton = 0;
if (GVAR(displayButtonPressed)) then {
    _displayButton = 1;
};


// Main knob
private _mainImages = [
    QPATHTOF(data\knobs\main\lstg_aus.paa),
    QPATHTOF(data\knobs\main\lstg_kl.paa),
    QPATHTOF(data\knobs\main\lstg_gr.paa)
];

// Function knob
private _functionImages = [
    QPATHTOF(data\knobs\function\bs_akw_rl.paa),
    QPATHTOF(data\knobs\function\bs_akw.paa),
    QPATHTOF(data\knobs\function\bs_hw.paa),
    QPATHTOF(data\knobs\function\bs_rsp.paa),
    QPATHTOF(data\knobs\function\bs_hw_rl.paa)
];

// Channel Step knob
private _channelStepImages = [
    QPATHTOF(data\knobs\cs\ka_25mhz_pil.paa),
    QPATHTOF(data\knobs\cs\ka_25mhz.paa),
    QPATHTOF(data\knobs\cs\ka_50mhz.paa),
    QPATHTOF(data\knobs\cs\ka_50mhz_pil.paa)
];

// Volume knob
private _volImages = [
    QPATHTOF(data\knobs\volume\vol_00.paa),
    QPATHTOF(data\knobs\volume\vol_20.paa),
    QPATHTOF(data\knobs\volume\vol_40.paa),
    QPATHTOF(data\knobs\volume\vol_60.paa),
    QPATHTOF(data\knobs\volume\vol_80.paa),
    QPATHTOF(data\knobs\volume\vol_100.paa)
];

// kHz Knob
private _kHzKnobImages = [
    QPATHTOF(data\knobs\khz\kHz_0.paa),
    QPATHTOF(data\knobs\khz\kHz_1.paa),
    QPATHTOF(data\knobs\khz\kHz_2.paa),
    QPATHTOF(data\knobs\khz\kHz_3.paa),
    QPATHTOF(data\knobs\khz\kHz_4.paa),
    QPATHTOF(data\knobs\khz\kHz_5.paa),
    QPATHTOF(data\knobs\khz\kHz_6.paa),
    QPATHTOF(data\knobs\khz\kHz_7.paa),
    QPATHTOF(data\knobs\khz\kHz_8.paa),
    QPATHTOF(data\knobs\khz\kHz_9.paa),
    QPATHTOF(data\knobs\khz\kHz_10.paa),
    QPATHTOF(data\knobs\khz\kHz_11.paa),
    QPATHTOF(data\knobs\khz\kHz_12.paa),
    QPATHTOF(data\knobs\khz\kHz_13.paa),
    QPATHTOF(data\knobs\khz\kHz_14.paa),
    QPATHTOF(data\knobs\khz\kHz_15.paa)
];

// MHz Knob
private _MHzKnobImages = [
    QPATHTOF(data\knobs\mhz\MHz_0.paa),
    QPATHTOF(data\knobs\mhz\MHz_1.paa),
    QPATHTOF(data\knobs\mhz\MHz_2.paa),
    QPATHTOF(data\knobs\mhz\MHz_3.paa),
    QPATHTOF(data\knobs\mhz\MHz_4.paa),
    QPATHTOF(data\knobs\mhz\MHz_5.paa),
    QPATHTOF(data\knobs\mhz\MHz_6.paa),
    QPATHTOF(data\knobs\mhz\MHz_7.paa),
    QPATHTOF(data\knobs\mhz\MHz_8.paa),
    QPATHTOF(data\knobs\mhz\MHz_9.paa),
    QPATHTOF(data\knobs\mhz\MHz_10.paa),
    QPATHTOF(data\knobs\mhz\MHz_11.paa),
    QPATHTOF(data\knobs\mhz\MHz_12.paa),
    QPATHTOF(data\knobs\mhz\MHz_13.paa),
    QPATHTOF(data\knobs\mhz\MHz_14.paa),
    QPATHTOF(data\knobs\mhz\MHz_15.paa)
];

// MemorySlot Knob
private _memorySlotKnobImages = [
    QPATHTOF(data\knobs\sp\sp_0.paa),
    QPATHTOF(data\knobs\sp\sp_1.paa),
    QPATHTOF(data\knobs\sp\sp_2.paa),
    QPATHTOF(data\knobs\sp\sp_3.paa),
    QPATHTOF(data\knobs\sp\sp_4.paa),
    QPATHTOF(data\knobs\sp\sp_5.paa),
    QPATHTOF(data\knobs\sp\sp_6.paa),
    QPATHTOF(data\knobs\sp\sp_7.paa),
    QPATHTOF(data\knobs\sp\sp_8.paa),
    QPATHTOF(data\knobs\sp\sp_9.paa),
    QPATHTOF(data\knobs\sp\sp_10.paa),
    QPATHTOF(data\knobs\sp\sp_11.paa),
    QPATHTOF(data\knobs\sp\sp_12.paa),
    QPATHTOF(data\knobs\sp\sp_13.paa),
    QPATHTOF(data\knobs\sp\sp_14.paa),
    QPATHTOF(data\knobs\sp\sp_15.paa)
];

// Network1 Knob
private _network1KnobImages = [
    QPATHTOF(data\knobs\fk\fk1_0.paa),
    QPATHTOF(data\knobs\fk\fk1_1.paa),
    QPATHTOF(data\knobs\fk\fk1_2.paa),
    QPATHTOF(data\knobs\fk\fk1_3.paa),
    QPATHTOF(data\knobs\fk\fk1_4.paa),
    QPATHTOF(data\knobs\fk\fk1_5.paa),
    QPATHTOF(data\knobs\fk\fk1_6.paa),
    QPATHTOF(data\knobs\fk\fk1_7.paa),
    QPATHTOF(data\knobs\fk\fk1_8.paa),
    QPATHTOF(data\knobs\fk\fk1_9.paa),
    QPATHTOF(data\knobs\fk\fk1_10.paa),
    QPATHTOF(data\knobs\fk\fk1_11.paa),
    QPATHTOF(data\knobs\fk\fk1_12.paa),
    QPATHTOF(data\knobs\fk\fk1_13.paa),
    QPATHTOF(data\knobs\fk\fk1_14.paa),
    QPATHTOF(data\knobs\fk\fk1_15.paa)
];

// Network2 Knob
private _network2KnobImages = [
    QPATHTOF(data\knobs\fk\fk2_0.paa),
    QPATHTOF(data\knobs\fk\fk2_1.paa),
    QPATHTOF(data\knobs\fk\fk2_2.paa),
    QPATHTOF(data\knobs\fk\fk2_3.paa),
    QPATHTOF(data\knobs\fk\fk2_4.paa),
    QPATHTOF(data\knobs\fk\fk2_5.paa),
    QPATHTOF(data\knobs\fk\fk2_6.paa),
    QPATHTOF(data\knobs\fk\fk2_7.paa),
    QPATHTOF(data\knobs\fk\fk2_8.paa),
    QPATHTOF(data\knobs\fk\fk2_9.paa),
    QPATHTOF(data\knobs\fk\fk2_10.paa),
    QPATHTOF(data\knobs\fk\fk2_11.paa),
    QPATHTOF(data\knobs\fk\fk2_12.paa),
    QPATHTOF(data\knobs\fk\fk2_13.paa),
    QPATHTOF(data\knobs\fk\fk2_14.paa),
    QPATHTOF(data\knobs\fk\fk2_15.paa)
];

// Network3 Knob
private _network3KnobImages = [
    QPATHTOF(data\knobs\fk\fk3_0.paa),
    QPATHTOF(data\knobs\fk\fk3_1.paa),
    QPATHTOF(data\knobs\fk\fk3_2.paa),
    QPATHTOF(data\knobs\fk\fk3_3.paa),
    QPATHTOF(data\knobs\fk\fk3_4.paa),
    QPATHTOF(data\knobs\fk\fk3_5.paa),
    QPATHTOF(data\knobs\fk\fk3_6.paa),
    QPATHTOF(data\knobs\fk\fk3_7.paa),
    QPATHTOF(data\knobs\fk\fk3_8.paa),
    QPATHTOF(data\knobs\fk\fk3_9.paa),
    QPATHTOF(data\knobs\fk\fk3_10.paa),
    QPATHTOF(data\knobs\fk\fk3_11.paa),
    QPATHTOF(data\knobs\fk\fk3_12.paa),
    QPATHTOF(data\knobs\fk\fk3_13.paa),
    QPATHTOF(data\knobs\fk\fk3_14.paa),
    QPATHTOF(data\knobs\fk\fk3_15.paa)
];

// Display Button
private _displayButtonImages = [
    QPATHTOF(data\knobs\display\anzeige_aus.paa),
    QPATHTOF(data\knobs\display\anzeige_ein.paa)
];

RADIO_CTRL(106) ctrlSetText (_volImages select _volumeKnobPosition);
RADIO_CTRL(107) ctrlSetText (_mainImages select _mainKnobPosition);
RADIO_CTRL(108) ctrlSetText (_functionImages select _functionKnobPosition);
RADIO_CTRL(109) ctrlSetText (_channelStepImages select _channelStepPosition);

RADIO_CTRL(110) ctrlSetText (_kHzKnobImages select (_kHzKnobPosition%16));
RADIO_CTRL(111) ctrlSetText (_MHzKnobImages select (_MHzKnobPosition%16));

RADIO_CTRL(112) ctrlSetText (_displayButtonImages select _displayButton);

RADIO_CTRL(113) ctrlSetText (_memorySlotKnobImages select _memorySlotKnobPosition);
RADIO_CTRL(114) ctrlSetText (_network1KnobImages select (_networkKnobPosition select 0));
RADIO_CTRL(115) ctrlSetText (_network2KnobImages select (_networkKnobPosition select 1));
RADIO_CTRL(116) ctrlSetText (_network3KnobImages select (_networkKnobPosition select 2));

//display
if (GVAR(backlightOn) || {GVAR(displayButtonPressed)}) then {
    [_display] call FUNC(renderDisplay);
} else {
    [_display] call FUNC(clearDisplay);
};

//rack
private _isMounted = [GVAR(currentRadioId)] call EFUNC(sys_rack,getRackFromRadio);
if (_isMounted == "") then {
    [_display,false] call FUNC(renderRack);
} else {
    [_display,true] call FUNC(renderRack);
};

true
