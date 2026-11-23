#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Radios the local player can hear: their own (or spectator) radios, and nearby radios playing
 * on a loudspeaker.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Radio IDs <ARRAY>
 *
 * Example:
 * [] call acre_sys_core_fnc_getHearableRadios
 *
 * Public: No
 */

private _radios = [] call EFUNC(sys_data,getPlayerRadioList);

private _nearExternal = ([ACRE_LISTENER_POS, NEAR_RADIO_RANGE] call EFUNC(sys_radio,nearRadios)) select {
    [_x, "isExternalAudio"] call EFUNC(sys_data,dataEvent)
};
_radios append _nearExternal;

(_radios arrayIntersect _radios) select {
    ([_x, "getOnOffState"] call EFUNC(sys_data,dataEvent)) == 1
}
