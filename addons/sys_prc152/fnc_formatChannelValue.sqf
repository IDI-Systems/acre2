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
 * [ARGUMENTS] call acre_sys_prc152_fnc_formatChannelValue
 *
 * Public: No
 */

params ["_name","_value"];

#define SQUELCH_NOISE 0
#define SQUELCH_CTCSS 3

#define GET_RADIO_VALUE(x) [x] call FUNC(CURRENT_RADIO_VALUE)
#define GET_CHANNEL_DATA [] call FUNC(CURRENT_RADIO_CHANNEL);

TRACE_1("Formatting",_this);

switch _name do {
    case "frequency": {
        _value = [_value, 3, 4] call CBA_fnc_formatNumber;
    };
    case "frequencytx": {
        _value = [_value, 3, 4] call CBA_fnc_formatNumber;
    };
    case "frequencyrx": {
        _value = [_value, 3, 4] call CBA_fnc_formatNumber;
    };
    case "encryption": {
        if (_value == 1) then { _value = "VINSON CT"; } else { _value = "------ PT"; };
    };
    case "channelmode": {
        switch _value do {
            case "BASIC": { _value = "VULOS"; }
        };
    };
    case "tek": {
        switch _value do {
            if (_value < 10) then { _value = format["0%1",_value]; } else { };
        };
    };
    case "squelch": {
        private _channel = GET_CHANNEL_DATA;
        private _ctcss = HASH_GET(_channel,"CTCSSTx");

        if (_value > 0) then {
            _value = "TON";
            if (_ctcss != 150) then {
                _value = "TCS";
            };
            if (_ctcss == 0) then {
                _value = "NOI";
            };
        } else{
            _value = "OFF";
        };
    };
};

if !(_value isEqualType "") then {
    _value = format["%1", _value];
};
TRACE_1("Output",_value);

_value

/*
    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",5000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode","BASIC");
    HASH_SET(_channel,"name",format["%1-FMVINVOC",str(_i+1)]);
    HASH_SET(_channel,"CTCSSTx",250.3);
    HASH_SET(_channel,"CTCSSRx",250.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"TEK",1);
    HASH_SET(_channel,"RPTR",0.2);
    HASH_SET(_channel,"fade",2);
    HASH_SET(_channel,"phase",256);
    HASH_SET(_channel,"squelch",3);

    // 152 specific channel settings
    HASH_SET(_channel,"deviation",8.0);
    HASH_SET(_channel,"optionCode",201);    // 200 for AM
    */
