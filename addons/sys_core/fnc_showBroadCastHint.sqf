/*
 * Author: ACRE2Team
 * Shows the transmitting hint. Intended for use when transmitting.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

if ((count ([] call EFUNC(sys_data,getPlayerRadioList))) > 0) then {
    private _realRadio = configName ( inheritsFrom (configFile >> "CfgWeapons" >> ACRE_ACTIVE_RADIO) );
    private _name = getText (configFile >> "CfgAcreComponents" >> _realRadio >> "name");
    private _line2 = [ACRE_ACTIVE_RADIO, "getChannelDescription"] call EFUNC(sys_data,dataEvent);
    ["TRANSMITTING",_name,_line2,1] call EFUNC(sys_list,displayHint);
};
true
