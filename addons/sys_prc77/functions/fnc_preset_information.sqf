#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Initialises and registers the default presets with the initial values of transmitting and receiving frequencies for each of the channels.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_prc77_fnc_preset_information
 *
 * Public: No
 */

// AN/PRC-77 
// Frequency Range 30.00 to 75.95 Mhz

// channel information
///Default
private _presetData = HASH_CREATE;
private _channels = HASHLIST_CREATELIST(["frequencyTX"]);

private _channel = HASHLIST_CREATEHASH(_channels);
HASH_SET(_channel,"frequencyTX",30);
HASHLIST_PUSH(_channels,_channel);

_channel = HASHLIST_CREATEHASH(_channels); // 2nd Preset button
HASH_SET(_channel,"frequencyTX",30.50);
HASHLIST_PUSH(_channels,_channel);

HASH_SET(_presetData,"channels",_channels);
["ACRE_PRC77","default",_presetData] call EFUNC(sys_data,registerRadioPreset);

///Default2
_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);

_channel = HASHLIST_CREATEHASH(_channels);
HASH_SET(_channel,"frequencyTX",35.50);
HASHLIST_PUSH(_channels,_channel);

_channel = HASHLIST_CREATEHASH(_channels); // 2nd Preset button
HASH_SET(_channel,"frequencyTX",35.75);
HASHLIST_PUSH(_channels,_channel);

HASH_SET(_presetData,"channels",_channels);
["ACRE_PRC77","default2",_presetData] call EFUNC(sys_data,registerRadioPreset);

///Default3
_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);

_channel = HASHLIST_CREATEHASH(_channels);
HASH_SET(_channel,"frequencyTX",41.25);
HASHLIST_PUSH(_channels,_channel);

_channel = HASHLIST_CREATEHASH(_channels); // 2nd Preset button
HASH_SET(_channel,"frequencyTX",41.65);
HASHLIST_PUSH(_channels,_channel);

HASH_SET(_presetData,"channels",_channels);
["ACRE_PRC77","default3",_presetData] call EFUNC(sys_data,registerRadioPreset);

///Default4
_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);

_channel = HASHLIST_CREATEHASH(_channels);
HASH_SET(_channel,"frequencyTX",62.85);
HASHLIST_PUSH(_channels,_channel);

_channel = HASHLIST_CREATEHASH(_channels); // 2nd Preset button
HASH_SET(_channel,"frequencyTX",64.65);
HASHLIST_PUSH(_channels,_channel);

HASH_SET(_presetData,"channels",_channels);
["ACRE_PRC77","default4",_presetData] call EFUNC(sys_data,registerRadioPreset);
