/*
 * Author: ACRE2Team
 * Returns the radios that can be mounted into the radio.
 *
 * Arguments:
 * 0: Component ID <STRING>
 *
 * Return Value:
 * Connectors <ARRAY>
 *
 * Example:
 * ["ACRE_VRC110_ID_1",["ACRE_PRC152_ID_1"]] call acre_sys_components_fnc_getMountableRadios
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_rackId",["_radioList",[]]];

private _rackConnectors = [_rackId] call EFUNC(sys_components,getConnectorSpecification);
private _availableConnectors = [_rackId] call EFUNC(sys_components,getAllAvailableConnectors);
private _radios = [];

{
    private _connectable = [_rackId, "mountableRadio", _x] call EFUNC(sys_data,dataEvent);

    if (_connectable) then {
        _radios pushBack _x;
    };
} forEach _radioList;

_radios
