/*
 * Author: ACRE2Team
 * This overrides the signal calculation function in ACRE2 with a defined function.
 * It is recommended to read this documentation page for further details and some examples - TODO
 * The arguments passed to the function are the frequency (MHz), power of transmitter (mA), classname of recieving radio, classname of broadcasting radio. Example - [30, 5000, "ACRE_PRC343_ID_1", "ACRE_PRC343_ID_2"]
 * The expected return of the function is [_signalStrengthPercent,_signalStrengthDBm] - where signal strength is a value between 0 and 1, and DBm strength of the radiosignal for the receiving radio.
 * Calling the function with an empty array will remove the custom signal function.
 *
 * Arguments:
 * 0: Function to use <CODE>
 *
 * Return Value:
 * None
 *
 * Example:
 * [mySignalFunc] call acre_api_fnc_setCustomSignalFunc
 *
 */
#include "script_component.hpp"

params ["_code"];

if (!(_code isEqualType {})) exitWith {
    ERROR("acre_api_fnc_setCustomSignalFunc called with invalid argument.");
};

EGVAR(sys_signal,customSignalFunc) = _code;
