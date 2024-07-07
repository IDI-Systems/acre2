#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets a descriptive name for a radio ID.
 * Includes current channel/frequency, PTT key, and owner (for external radios).
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * Descriptive Radio Name <STRING>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_core_fnc_getDescriptiveName
 *
 * Public: No
 */

params [["_radioId", "", [""]]];

// Convert to lower case since ACRE functions/variables use this instead of config case
_radioId = toLower _radioId;

// Get the radio's name
private _name = if (_radioId in ACRE_ACCESSIBLE_RACK_RADIOS || {_radioId in ACRE_HEARABLE_RACK_RADIOS}) then {
    private _radioRack = [_radioId] call EFUNC(sys_rack,getRackFromRadio);
    private _radioClass = [_radioRack] call EFUNC(sys_rack,getRackBaseClassname);
    getText (configFile >> "CfgAcreComponents" >> _radioClass >> "name")
} else {
    // Include the owner's name for external radios
    private _owner = if (_radioId in ACRE_ACTIVE_EXTERNAL_RADIOS) then {
        format [" (%1)", name (_radioId call EFUNC(sys_external,getExternalRadioOwner))]
    } else {
        ""
    };

    format ["%1%2", _radioId call EFUNC(api,getDisplayName), _owner]
};

// Display current radio channel
private _maxChannels = [_radioId, "getState", "channels"] call EFUNC(sys_data,dataEvent);

private _text = if (isNil "_maxChannels") then {
    // Display frequency for single-channel radios (e.g. AN/PRC-77)
    private _txData = [_radioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
    private _currentFreq = HASH_GET(_txData,"frequencyTX");
    format ["%1 %2 MHz", _name, _currentFreq];
} else {
    format [LELSTRING(ace_interact,channelShort), _name, _radioId call EFUNC(api,getRadioChannel)]
};

// Display radio keys in front of those which are bound
private _pttAssign = [] call EFUNC(api,getMultiPushToTalkAssignment);
private _radioKey = (_pttAssign find _radioId) + 1;

if (_radioKey > 0 && {_radioKey < 4}) then {
    _text = format ["%1: %2", _radioKey, _text];
};

_text
