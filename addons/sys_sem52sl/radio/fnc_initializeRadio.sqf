#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
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

TRACE_1("INITIALIZING ACRE_SEM52SL", _this);

params ["_radioId", "_event", "_eventData", "_radioData"];

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

SCRATCH_SET(_radioId, "currentTransmissions", []);

private _currentChannels = HASH_GET(_radioData,"channels");
if (isNil "_currentChannels") then {
    _currentChannels = [];
    HASH_SET(_radioData,"channels",_currentChannels);
};

for "_i" from 0 to (count _channels)-1 do {
    private _channelData = HASH_COPY(_channels select _i);
    TRACE_1("Setting " + QUOTE(RADIONAME) + " Init Channel Data", _channelData);
    PUSH(_currentChannels, _channelData);
};

HASH_SET(_radioData,"volume",1);
HASH_SET(_radioData,"radioOn",1);
HASH_SET(_radioData,"currentChannel",0);
HASH_SET(_radioData,"channelKnobPosition", 2); // Channel 1 (after on/off options)
HASH_SET(_radioData,"volumeKnobPosition", 0);// mid-way
HASH_SET(_radioData,"programmingStep", 0);
HASH_SET(_radioData,"lastActiveChannel",0);
HASH_SET(_radioData,"audioPath", "HEADSET");
