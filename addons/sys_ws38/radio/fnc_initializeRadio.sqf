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

private _channelInfo = [_frequencyTx] call FUNC(getChannelForFrequency);
private _dialPosition = (_channelInfo select 0);
_frequencyTx = _channelInfo select 1;


SCRATCH_SET(_radioId, "currentTransmissions", []);

//Radio Settings
HASH_SET(_radioData,"volume",EGVAR(sys_core,defaultRadioVolume)); //0-1
HASH_SET(_radioData,"function",0); //0 - OFF, 1 - RECV, 2 - SEND
HASH_SET(_radioData,"radioOn",0); //0 - OFF, 1 - ON
HASH_SET(_radioData,"currentChannel",_dialPosition);
HASH_SET(_radioData,"powerSource", "BAT");

//Common Channel Settings
HASH_SET(_radioData,"frequencyTX",_frequencyTx);
HASH_SET(_radioData,"frequencyRX",_frequencyTx);
HASH_SET(_radioData,"power",200);
HASH_SET(_radioData,"mode","singleChannel");
HASH_SET(_radioData,"modulation","AM");
HASH_SET(_radioData,"encryption",0);
HASH_SET(_radioData,"TEK","");
HASH_SET(_radioData,"trafficRate",0);
HASH_SET(_radioData,"syncLength",0);
HASH_SET(_radioData,"squelch",3);
