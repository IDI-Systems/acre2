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
 * [] call acre_sys_ws38_fnc_preset_information
 *
 * Public: No
 */

// WirelessSet No. 38
// Frequency Range 7.4-9.0 MHz (30-46 MHz using 77 Frequencies for the range)

// channel information
///Default
private _presetData = HASH_CREATE;
private _channels = HASHLIST_CREATELIST(["frequencyTX"]);

private _channel = HASHLIST_CREATEHASH(_channels);
HASH_SET(_channel,"frequencyTX",30.00);
HASH_SET(_channel,"encryption",1);
HASH_SET(_channel,"TEK",1);
HASHLIST_PUSH(_channels,_channel);


HASH_SET(_presetData,"channels",_channels);
["ACRE_WS38","default",_presetData] call EFUNC(sys_data,registerRadioPreset);

///Default2
_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);

_channel = HASHLIST_CREATEHASH(_channels);
HASH_SET(_channel,"frequencyTX",31.00);
HASH_SET(_channel,"encryption",1);
HASH_SET(_channel,"TEK",1);
HASHLIST_PUSH(_channels,_channel);

HASH_SET(_presetData,"channels",_channels);
["ACRE_WS38","default2",_presetData] call EFUNC(sys_data,registerRadioPreset);

///Default3
_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);

_channel = HASHLIST_CREATEHASH(_channels);
HASH_SET(_channel,"frequencyTX",32.00);
HASH_SET(_channel,"encryption",1);
HASH_SET(_channel,"TEK",1);
HASHLIST_PUSH(_channels,_channel);

HASH_SET(_presetData,"channels",_channels);
["ACRE_WS38","default3",_presetData] call EFUNC(sys_data,registerRadioPreset);

///Default4
_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);

_channel = HASHLIST_CREATEHASH(_channels);
HASH_SET(_channel,"frequencyTX",33.00);
HASH_SET(_channel,"encryption",1);
HASH_SET(_channel,"TEK",1);
HASHLIST_PUSH(_channels,_channel);

HASH_SET(_presetData,"channels",_channels);
["ACRE_WS38","default4",_presetData] call EFUNC(sys_data,registerRadioPreset);
