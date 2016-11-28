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
 * [ARGUMENTS] call acre_sys_server_fnc_doAddComponentCargo;
 *
 * Public: No
 */
#include "script_component.hpp"

params["_container","_type","_preset","_player","_callBack","_failCallback"];

diag_log text format["this: %1", _this];
_hasUnique = getNumber(configFile >> "CfgWeapons" >> _type >> "acre_hasUnique");

if(_hasUnique == 1) then {
    _ret = [_type] call FUNC(getRadioId);
    if(_ret != -1) then {
         _uniqueComponent = format["%1_id_%2", tolower(_type), _ret];
         if(!(_uniqueComponent in GVAR(masterIdList))) then {
             PUSH(GVAR(masterIdList), _uniqueComponent);
             _dataHash = HASH_CREATE;
             HASH_SET(acre_sys_data_radioData,_uniqueComponent,_dataHash);
             PUSH(GVAR(unacknowledgedIds), _uniqueComponent);
             HASH_SET(GVAR(masterIdTable), _uniqueComponent, [ARR_2(_container,_container)]);
             _container addItemCargoGlobal [_uniqueComponent, 1];
             [_uniqueComponent, "initializeComponent", [_type, _preset]] call EFUNC(sys_data,dataEvent);
             if(_callBack != "") then {
                 [_callBack, [_uniqueComponent]+_this] call CALLSTACK(CBA_fnc_globalEvent);
             };
             _fnc = {
                 _uniqueComponent = _this;
                 GVAR(unacknowledgedIds) = GVAR(unacknowledgedIds) - [_uniqueComponent];
             };
             [_fnc, _uniqueComponent] call CBA_fnc_execNextFrame;
             // GVAR(waitingForIdAck) = true;
         };
     } else {
         if(_failCallback != "") then {
             [_failCallback, _this] call CALLSTACK(CBA_fnc_globalEvent);
         };
     };
} else {
     if(_failCallback != "") then {
         [_failCallback, _this] call CALLSTACK(CBA_fnc_globalEvent);
     };
};
