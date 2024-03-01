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
 * [ARGUMENTS] call acre_sys_sem70_fnc_initializeRadio
 *
 * Public: No
 */

/*
 *    This function is called when a radio is initialized.
 *    Initialization happens only once for each Radio ID.
 *    During the initialization the parsed preset is copied
 *    and together with other default values, the radio (id) is
 *    set to its initial state.
 *
 *    Type of Event:
 *        Data
 *    Event:
 *        initializeComponent
 *    Event raised by:
 *        - Uninitialized Radio is in invetory of player
 *
 *     Parsed parameters:
 *        0:    Radio ID
 *        1:    Event (-> "initializeComponent")
 *        2:    Eventdata
 *            2.0:    Baseclass of Radio
 *            2.1:    Preset
 *        3:    Radiodata (-> [])
 *        4:    Remote Call (-> false)
 *
 *    Returned parameters:
 *        nil
*/

TRACE_1("INITIALIZING ACRE_SEM70",_this);

params ["_radioId", "", "_eventData", "_radioData"];

_eventData params ["_baseName", "_preset"];

/*
 *    To set the correct data for all available channels,
 *    the data from the preset hash must be transferred to
 *    the radioData hash.
 *    In addition to that it is ensured that no transmission
 *    is registered to the radio ID.
 *    The last action is to write default values to the radioData
 *    hash, like "is the radio on?" or "default channel" etc.
*/

private _presetData = [_baseName, _preset] call EFUNC(sys_data,getPresetData);
private _channels = HASH_GET(_presetData,"channels");

SCRATCH_SET(_radioId,"currentTransmissions",[]);

private _currentChannels = HASH_GET(_radioData,"channels");
if (isNil "_currentChannels") then {
    _currentChannels = [];
    HASH_SET(_radioData,"channels",_currentChannels);
};

for "_i" from 0 to (count _channels)-1 do {
    private _channelData = HASH_COPY(_channels select _i);
    TRACE_1("Setting " + QUOTE(RADIONAME) + " Init Channel Data",_channelData);
    PUSH(_currentChannels,_channelData);
};


// General
HASH_SET(_radioData,"radioOn",1);
HASH_SET(_radioData,"volume",EGVAR(sys_core,defaultRadioVolume));
HASH_SET(_radioData,"currentChannel",GVAR(manualChannel)); // Manual Channel
//HASH_SET(_radioData,"lastActiveChannel",GVAR(manualChannel));
HASH_SET(_radioData,"audioPath","HEADSET");
HASH_SET(_radioData,"powerSource","BAT");

// Channel
//HASH_SET(_radioData,"mode","singleChannel"); // or "sem70AKW"
HASH_SET(_radioData,"manualChannelSelection",1); // Manual Frequency Selection Flag
HASH_SET(_radioData,"power",4000);
HASH_SET(_radioData,"channelSpacing",0); // 0: 25kHz, 1: 50kHz
HASH_SET(_radioData,"CTCSS",0);
HASH_SET(_radioData,"modulation","FM");
HASH_SET(_radioData,"encryption",0);
HASH_SET(_radioData,"squelch",0);

//HASH_SET(_radioData,"networkID",0);

// Knobs
HASH_SET(_radioData,"mainKnobPosition",2); // High Power Setting
HASH_SET(_radioData,"functionKnobPosition",2); // Manual Frequency Selection (no Relais)
HASH_SET(_radioData,"volumeKnobPosition",EGVAR(sys_core,defaultRadioVolume) * 5);
HASH_SET(_radioData,"channelSpacingKnobPosition",1); // 0-3
HASH_SET(_radioData,"kHzKnobPosition",0);
HASH_SET(_radioData,"MHzKnobPosition",0);
HASH_SET(_radioData,"MemorySlotKnobPosition",0);
HASH_SET(_radioData,"NetworkKnobPosition",[ARR_3(1,2,3)]);

// Spacing
// Auto Channel
