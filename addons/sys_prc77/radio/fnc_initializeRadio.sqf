#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Initialises a radio by givint it a radio ID. This only happens once and the default
 * preset (configuration) is copied.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "initializeRadio" <STRING> (Unused)
 * 2: Event data [baseclass, preset] <ARRAY>
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC77_ID_1", "initializeRadio", ["ACRE_PRC77_base", default1], [], false] call acre_sys_prc77_fnc_initializeRadio
 *
 * Public: No
 */

params ["_radioId", "", "_eventData", "_radioData", ""];
TRACE_1("INITIALIZING RADIO 77", _this);

// Function to convert frequency to knob positions.
private _frequencyToKnobPositions = {
    params ["_frequency"];
    private _basedFrequncy = _frequency - 30;
    if (_frequency >= 53) then {
        _basedFrequncy = _frequency - 53;
    };
    private _floor = floor _basedFrequncy;
    private _dif = _basedFrequncy - _floor;
    private _twentyiths = (round (_dif * 20));

    +[_floor,_twentyiths];
};

_eventData params ["_baseName", "_preset"];
private _presetData = [_baseName, _preset] call EFUNC(sys_data,getPresetData);
private _channels = HASH_GET(_presetData,"channels");

private _channelData = HASH_COPY(_channels select 0);
private _frequencyTx = HASH_GET(_channelData,"frequencyTX");
_frequencyTx = ((round (_frequencyTx * 20))/20);

private _secondChannelData = HASH_COPY(_channels select 1);
private _secondPresetFrequency = HASH_GET(_secondChannelData,"frequencyTX");
_secondPresetFrequency = ((round (_secondPresetFrequency * 20))/20);

//Finding the MHz
//interpreting the band selector

// Band is the 30-52,53-75 selector
private _band = 0;
if (_frequencyTx >= 53) then {
    _band = 1;
};

private _knobPositions = ([_frequencyTx] call _frequencyToKnobPositions);
private _secondPresetKnobPositions = ([_secondPresetFrequency] call _frequencyToKnobPositions);


SCRATCH_SET(_radioId, "currentTransmissions", []);

//Radio Settings
HASH_SET(_radioData,"volume",EGVAR(sys_core,defaultRadioVolume)); //0-1
HASH_SET(_radioData,"function",2); //0 - OFF, 1 - ON, 2 - SQUELCH, 3 - RETRANS, 4 - LITE (Temp)
HASH_SET(_radioData,"radioOn",1); //0 - OFF, 1 - ON
HASH_SET(_radioData,"band",_band); //{0,1}
HASH_SET(_radioData,"currentPreset",[ARR_2(_knobPositions,_secondPresetKnobPositions)]); //Array of Presetarrays (KnobPositions)
HASH_SET(_radioData,"currentChannel",_knobPositions);
HASH_SET(_radioData,"powerSource", "BAT");

//Common Channel Settings
HASH_SET(_radioData,"frequencyTX",_frequencyTx);
HASH_SET(_radioData,"frequencyRX",_frequencyTx);
HASH_SET(_radioData,"power",3500);
HASH_SET(_radioData,"mode","singleChannel");
HASH_SET(_radioData,"CTCSSTx", 150);
HASH_SET(_radioData,"CTCSSRx", 150);
HASH_SET(_radioData,"modulation","FM");
HASH_SET(_radioData,"encryption",0);
HASH_SET(_radioData,"TEK","");
HASH_SET(_radioData,"trafficRate",0);
HASH_SET(_radioData,"syncLength",0);
HASH_SET(_radioData,"squelch",3);
