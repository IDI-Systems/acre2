#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the connected ground spike antenna object
 *
 * Arguments:
 * 0: Unique Radio ID <STRING>
 *
 * Return Value:
 * Connected GSA or objNull if none is connected <OBJECT>
 *
 * Example:
 * ["acre_prc_152_id_1"] call acre_sys_gsa_fnc_getConnectedGsa
 *
 * Public: No
 */

params ["_radioId"];

private _connectedAntenna = objNull;
private _state = [_radioId, "getState", "externalAntennaConnected"] call EFUNC(sys_data,dataEvent);

if (_state select 0) then {
    _connectedAntenna = _state select 1;
};

_connectedAntenna
