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
#include "script_component.hpp"

params ["_radioId", "", "", "_radioData", ""];
TRACE_1("INITIALIZING RADIO 77", _this);

SCRATCH_SET(_radioId, "currentTransmissions", []);


//Radio Settings
HASH_SET(_radioData,"volume",1); //0-1
HASH_SET(_radioData,"function",2); //0 - OFF, 1 - ON, 2 - SQUELCH, 3 - RETRANS, 4 - LITE (Temp)
HASH_SET(_radioData,"radioOn",1); //0 - OFF, 1 - ON
HASH_SET(_radioData,"band",0); //{0,1}
HASH_SET(_radioData,"currentPreset",[ARR_2([ARR_2(0,0)],[ARR_2(0,0)])]); //Array of Presetarrays (KnobPositions)
HASH_SET(_radioData,"currentChannel",[ARR_2(0,0)]);


//Common Channel Settings
HASH_SET(_radioData,"frequencyTX",30);
HASH_SET(_radioData,"frequencyRX",30);
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
