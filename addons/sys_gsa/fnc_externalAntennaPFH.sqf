#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Eventhandler to monitor if external radios can be still used by a specific player.
 *
 * - Disabled uses of external radios are:
 *   - Antenna is destroyed.
 *   - Distance between the antenna and the object holding the radio is greater than 10m.
 *   - Antenna is picked up.
 *
 * Arguments:
 * 0: Ground Spike Antenna <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, "acre_prc152_id_1"] call acre_sys_gsa_externalAntennaPFH
 *
 * Public: No
 */

params ["_params"];
_params params ["_gsa", "_radioId"];

private _unit = objNull;
if (_radioId != "") then {
    _unit = [_radioId] call EFUNC(sys_radio,getRadioObject);
};

if (!alive _gsa || {!alive _unit} || {_unit isKindOf "CAManBase" && !(isPlayer _unit)} || {_radioId isEqualTo ""}) then {
    [QGVAR(disconnectGsa), [_gsa, _unit]] call CBA_fnc_localEvent;
} else {
    private _connectedRadioId = _gsa getVariable [QGVAR(connectedRadio), ""];

    if (_connectedRadioId isEqualTo _radioId) then {
        if ((_unit distance _gsa) > ANTENNA_MAXDISTANCE) then {
            [QGVAR(disconnectGsa), [_gsa, _unit]] call CBA_fnc_localEvent;
        };
    } else {
        [QGVAR(disconnectGsa), [_gsa, _unit]] call CBA_fnc_localEvent;
    };
};
