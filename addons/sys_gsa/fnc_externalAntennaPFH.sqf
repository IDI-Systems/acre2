#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Event handler to monitor if external radios can be still used by a specific player.
 *
 * - Disabled uses of external radios are:
 *   - Antenna is destroyed.
 *   - Distance between the antenna and the object holding the radio is greater than 10m.
 *   - Antenna is picked up.
 *
 * Arguments:
 *  0,0: Ground Spike Antenna <OBJECT>
 *  0,1: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[cursorTarget, "acre_prc152_id_1"]] call acre_sys_gsa_externalAntennaPFH
 *
 * Public: No
 */

params ["_params"];
_params params ["_gsa", "_radioId"];

private _unit = [_radioId] call EFUNC(sys_radio,getRadioObject);

if (
(!alive _gsa) 
|| {isNil "_unit"} // possible if radio was removed by script
|| {!alive _unit} 
|| {_unit isKindOf "CAManBase" && {!(isPlayer _unit)}}
|| {_radioId != (_gsa getVariable [QGVAR(connectedRadio), ""])}
|| {(_unit distance _gsa) > ANTENNA_MAXDISTANCE}
) then {
    [QGVAR(disconnectGsa), [_gsa, _unit, _radioId]] call CBA_fnc_localEvent;
};
