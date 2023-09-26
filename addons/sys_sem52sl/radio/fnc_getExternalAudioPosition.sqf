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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_getExternalAudioPosition
 *
 * Public: No
 */

/*
 *  This function is called when a radio has an internal speaker
 *  and this radio is receiving a transmission or making sounds.
 *  It shall define the ingame position where the speaker is
 *  located for correct 3d Audio playback
 *
 *  Type of Event:
 *      Physical
 *  Event:
 *      getExternalAudioPosition
 *  Event raised by:
 *      - Incoming Transmission and Speaker activated
 *      - Radio is playing a sound and Speaker activated
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "getExternalAudioPosition")
 *      2:  Eventdata (-> [])
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Return parameters:
 *      - Position of Radio Speaker
*/

/*
 *  If the radio is equiped with an internal speaker,
 *  a position on the right shoulder is used as
 *  return value
*/

params ["_radioId", "", "", ""];

private _obj = [_radioId] call EFUNC(sys_radio,getRadioObject);
private _pos = getPosASL _obj;
if (_obj isKindOf "Man") then {
    _pos = AGLtoASL (_obj modelToWorldVisual (_obj selectionPosition "RightShoulder"));
};

_pos;
