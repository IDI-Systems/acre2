#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Wrapper function for calling the signal calculation (extension).
 * Calls custom signal function if defined, core (default) signal function otherwise.
 *
 * Arguments:
 * 0: Frequency <NUMBER> (passed-through)
 * 1: Power <NUMBER> (passed-through)
 * 2: Receiving Radio ID <STRING> (passed-through)
 * 3: Transmitting Radio ID <STRING> (passed-through)
 *
 * Return Value:
 * Tuple of power and maximum signal strength <ARRAY>
 *
 * Example:
 * [30, 5000, "ACRE_PRC343_ID_1", "ACRE_PRC343_ID_2"] call acre_sys_signal_fnc_getSignal
 *
 * Public: No
 */

if (!isNil QGVAR(customSignalFunc)) exitWith {
    _this call GVAR(customSignalFunc);
};

_this call FUNC(getSignalCore)
