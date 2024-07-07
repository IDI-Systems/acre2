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
 * [ARGUMENTS] call acre_sys_prc152_fnc_getChannelData
 *
 * Public: No
 */

params ["_radioId", "_event", "_eventData", "_radioData"];

private _channelNumber = _eventData;
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
            HASH_SET(_return,"power",VRC110_RACK_POWER);
        };
        HASH_SET(_return,"CTCSSTx",HASH_GET(_channel,"CTCSSTx"));
        HASH_SET(_return,"CTCSSRx",HASH_GET(_channel,"CTCSSRx"));
        HASH_SET(_return,"modulation",HASH_GET(_channel,"modulation"));
        HASH_SET(_return,"encryption",HASH_GET(_channel,"encryption"));
        HASH_SET(_return,"TEK",HASH_GET(_channel,"tek"));
        HASH_SET(_return,"trafficRate",HASH_GET(_channel,"trafficRate"));
        HASH_SET(_return,"syncLength",HASH_GET(_channel,"phase"));
        HASH_SET(_return,"optioncode",HASH_GET(_channel,"optioncode"));
        HASH_SET(_return,"rxonly",HASH_GET(_channel,"rxonly"));
        HASH_SET(_return,"squelch",HASH_GET(_channel,"squelch"));
        HASH_SET(_return,"channelmode",HASH_GET(_channel,"channelmode"));
        HASH_SET(_return,"deviation",HASH_GET(_channel,"deviation"));
        HASH_SET(_return,"description",HASH_GET(_channel,"description"));
    };
};
_return
