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
    private _rackClass = [_radioRack] call EFUNC(sys_rack,getRackBaseClassname);
    getText (configFile >> "CfgAcreComponents" >> _rackClass >> "name")
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
private _radioClass = [_radioId] call EFUNC(sys_radio,getRadioBaseClassname);

private _text = switch (_radioClass) do {
    case "ACRE_PRC77": {
        // Display frequency for single-channel radios (e.g. AN/PRC-77)
        private _txData = [_radioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
        private _currentFreq = HASH_GET(_txData,"frequencyTX");
        format ["%1 %2 MHz", _name, [_currentFreq, 1, 2] call CBA_fnc_formatNumber]
    };
    case "ACRE_PRC343": {
        private _channelRaw = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
        private _block = floor (_channelRaw / 16) + 1;
        private _channel = (_channelRaw % 16) + 1;
        format [LELSTRING(ace_interact,channelBlockShort), _name, _block, _channel]
    };
    case "ACRE_SEM52SL": {
        private _channel = _radioId call EFUNC(api,getRadioChannel);
        _channel = switch (_channel) do {
            case 13: { "H" };
            case 14: { "P" };
            default { _channel };
        };
        format [LELSTRING(ace_interact,channelShort), _name, _channel]
    };
    case "ACRE_SEM70": {
        private _hashData = [_radioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
        private _description = if (HASH_GET(_hashData,"mode") == "singleChannel") then {
            // HW (Manual Channel) Mode
            format ["%1 MHz", [HASH_GET(_hashData,"frequencyTX"), 1, 3] call CBA_fnc_formatNumber]
        } else {
            // AKW (Automatic Channel) Mode
            private _channelNumber = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
            format [LELSTRING(ace_interact,channelNetIDShort), (_channelNumber), HASH_GET(_hashData,"networkID")]
        };
        format ["%1 %2", _name, _description]
    };
    default {
        format [LELSTRING(ace_interact,channelShort), _name, _radioId call EFUNC(api,getRadioChannel)]
    };
};

// Display radio keys in front of those which are bound
private _pttAssign = [] call EFUNC(api,getMultiPushToTalkAssignment);
private _radioKey = (_pttAssign find _radioId) + 1;

if (_radioKey > 0 && {_radioKey < 4}) then {
    _text = format ["%1: %2", _radioKey, _text];
};

_text
