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
 * [ARGUMENTS] call acre_sys_prc148_fnc_getChannelDataInternal
 *
 * Public: No
 */

params ["_channelNumber", "_radioData"];

private _channels = HASH_GET(_radioData,"channels");
private _powerSource = HASH_GET(_radioData,"powerSource");
private _channel = HASHLIST_SELECT(_channels,_channelNumber);

private _channelType = HASH_GET(_channel,"channelMode");
private _return = HASH_CREATE;

switch _channelType do {
    case "BASIC": {
        HASH_SET(_return,"mode","singleChannel");
        HASH_SET(_return,"frequencyTX",HASH_GET(_channel,"frequencyTX"));
        HASH_SET(_return,"frequencyRX",HASH_GET(_channel,"frequencyRX"));
        if (_powerSource == "BAT") then {
            HASH_SET(_return,"power",HASH_GET(_channel,"power"));
        } else { // RACK BOOST
            HASH_SET(_return,"power",VRC111_RACK_POWER);
        };
        HASH_SET(_return,"CTCSSTx",HASH_GET(_channel,"CTCSSTx"));
        HASH_SET(_return,"CTCSSRx",HASH_GET(_channel,"CTCSSRx"));
        HASH_SET(_return,"modulation",HASH_GET(_channel,"modulation"));
        HASH_SET(_return,"encryption",HASH_GET(_channel,"encryption"));
        HASH_SET(_return,"TEK",HASH_GET(_channel,"tek"));
        HASH_SET(_return,"trafficRate",HASH_GET(_channel,"trafficRate"));
        HASH_SET(_return,"syncLength",HASH_GET(_channel,"phase"));
    };
};
_return
