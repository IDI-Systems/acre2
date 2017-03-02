---
title: Custom Signal Processing
---

ACRE2 allows replacing its default signal strength calculator with a custom signal strength function: This can be done by using the following API function [`acre_api_fnc_setCustomSignalFunc`](https://github.com/IDI-Systems/acre2/blob/master/addons/api/fnc_setCustomSignalFunc.sqf). This page aims to assist in creating your own and provide examples.

The default signal calculator is sophisticated and complex and as such is largely calculated in the C++ extension. However this signal model doesn't always appeal to every community and it doesn't always afford possibilites for various mission mechanics such as radio jammers. This function is intended to be used by communities seeking a specific signal experience or for highly ambitious mission makers.

For the time being this command is highly experimental and is included as of dev-build 940. 

## Function Usage

You can see the default function [here](https://github.com/IDI-Systems/acre2/blob/master/addons/sys_signal/fnc_getSignal.sqf) but note this is mainly just a dispatcher that sends data to the C++ extension. It gives an idea as to what data might be useful. It does not provide insight into the default signal model that is used though.

### Input

The input to your custom function will be of the format: `[30, 5000, "ACRE_PRC343_ID_1", "ACRE_PRC343_ID_2"]`
- The first element is the frequency (megahertz) e.g. `30`. 
- The second element is the power of the transmitter (milliwatts) e.g. `5000`.
- Then the classname of the recieving radio e.g. `"ACRE_PRC343_ID_1"`.
- Lastly the classname of the broadcasting radio e.g. `"ACRE_PRC343_ID_2"`.

### Output

The output of your function should be an array of size 2 with two numerical values:
- The signal strength as a percentage (0-1). This value is what will be used by the TeamSpeak 3 plugin to adjust the audio of the player being heard on the radio.
- The decibel signal strength value (dBM). A typical value that is heard is between 0 to about -110 (radio specific). Lower values are not heard.

The decibel signal strength value value is used to determine if the specific radio is capable of hearing the transmission. This process is typically carried out in the `handleMultipleTransmissions` function for that particular radio radio (i.e. AN/PRC-148). Firstly there exists a minimum signal sensitivity that each radio can pick up - This can be thought of as the minimum signal strength the hardware is capable of registering. The minimum that is registered is typically around -100 (AN/PRC343) to -117 (AN/PRC-117F) which is defined in `configFile >> 'CfgAcreComponents' >> RADIO_BASECLASS >> 'sensitivityMin'`. Some radios also make use of Squelch - If you are curious to see this is all handled in the radio specific `handleMultipleTransmissions` function.

### Helper functions

The provided inputs are a bit lacking as they don't provide the position or any antenna information there are some handy functions you can use to retrieve these. Note these are internal functions and are subject to change. 

- `acre_sys_radio_fnc_getRadioObject` - In ACRE2 every radio is typically associated with a game object this returns the associated object. e.g. `["ACRE_PRC343_ID_1"] call acre_sys_radio_fnc_getRadioObject;`
- `acre_sys_radio_fnc_getRadioPos` - This will return the position (ASL) of a radio e.g. `["ACRE_PRC343_ID_1"] call acre_sys_radio_fnc_getRadioPos;`
- `acre_sys_components_fnc_findAntenna` - This will return data on all the attached antennas to a specified radio `["ACRE_PRC343_ID_1"] call acre_sys_components_fnc_findAntenna;`. The return format is an array of antennas where each antenna contains data on the antenna class name, its position and its orientation.

## Examples

### Simple calculation
Below is an example of a simple calculation that is based on how ACRE1 calculated signal loss. It is a largely based on [free-space path loss](https://en.wikipedia.org/wiki/Free-space_path_loss) over the distance which does not take into account terrain. It is also provides a bit of a boost to the signal strength of the AN/PRC-343. In this example the range of a AN/PRC-343 is around 500m and virtually all other radios will have no problems with Arma terrains (40km+).

```js
MY_CUSTOM_ACRE_FUNC = {
    params ["_f", "_mW", "_receiverClass", "_transmitterClass"];

    private _realRadioRx = toLower (configName (inheritsFrom (configFile >> "CfgWeapons" >> _receiverClass)));
    private _sinadRating = getNumber (configFile >> "CfgAcreComponents" >> _realRadioRx >> "sinadRating");

    private _txPos = [_receiverClass] call acre_sys_radio_fnc_getRadioPos;
    private _rxPos = [_transmitterClass] call acre_sys_radio_fnc_getRadioPos;
    private _distance = _txPos distance _rxPos; /*Add distance if terrain in the way */

    private _Lfs = -27.55 + 20*log(_f) + 20*log(_distance); /* Free Space Path Loss model */
    private _Ptx = 10 * (log ((_mW)/1000)) + 30; /* Transmitter Power (mW to dBm) */

    if (_realRadioRx isEqualTo "acre_prc343") then { // AN/PRC-343
        _Lfs = _Lfs - 17; // 17 dB boost.                   
    };

    private _ituLoss = 36; /* base loss level (based on empirical testing...) */

     /* Transmitter/Receiver cable/internal loss. */
    private _Ltx = 3; /* Transmitter */
    private _Lrx = 3; /* Receiver */

    /* Loss from fading, obstruction, noise, etc (including ITU model) */
    private _Lm = _ituLoss + ((random 1) - 0.5);

    /* Total Link Budget - SIGNAL STRENGTH */
    private _Lb = _Ptx - _Ltx - _Lfs - _Lm  - _Lrx; /* Assume antenna gain is 0 for both*/

    /* Signal percentage variables */
    private _Sl = (abs _sinadRating)/2;
    private _Slp = 0.075;

    /* Signal Percentage equation based on the dB value */
    private _bottom = _sinadRating - (_Sl*_Slp);
    private _Snd = abs ((_bottom - (_Lb max _bottom))/_Sl);
    private _Px = 100 min (0 max (_Snd*100)); 
    _Px = _Px/100;

    private _signal = _Lb;

    // Required to ensure the signal trace for RPT logging works.
    if (ACRE_SIGNAL_DEBUGGING > 0) then {
        private _signalTrace = missionNamespace getVariable [_transmitterClass + "_signal_trace", []];
        _signalTrace pushBack _signal;
        missionNamespace setVariable [_transmitterClass + "_signal_trace", _signalTrace];
    };

    [_Px, _signal];
};
[MY_CUSTOM_ACRE_FUNC] call acre_api_fnc_setCustomSignalFunc;
```

## Reset

To reset the signal handling to default simply call the function with empty code:

```js
[{}] call acre_api_fnc_setCustomSignalFunc;
```

## Debugging

See [Radio Signal Debugging](radio-signal-debugging)

