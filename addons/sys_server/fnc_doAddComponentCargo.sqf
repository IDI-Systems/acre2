#include "script_component.hpp"
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

params ["_container","_type","_preset","_player","_callBack","_failCallback"];

diag_log text format ["this: %1", _this];
private _hasUnique = _type call EFUNC(sys_radio,isBaseClassRadio);

if (_hasUnique) then {
    private _ret = [_type] call FUNC(getRadioId);
    if (_ret != -1) then {
         private _uniqueComponent = format ["%1_id_%2", tolower _type, _ret];
         if !(_uniqueComponent in GVAR(masterIdListd)) then {
             GVAR(masterIdList) pushBack _uniqueComponent;
             private _dataHash = HASH_CREATE;
             HASH_SET(EGVAR(sys_data,radioData),_uniqueComponent,_dataHash);
             GVAR(unacknowledgedIds) pushBack _uniqueComponent;
             HASH_SET(GVAR(unacknowledgedTable),_uniqueComponent,time);
             HASH_SET(GVAR(masterIdTable),_uniqueComponent,[ARR_2(_container,_container)]);
             _container addItemCargoGlobal [_uniqueComponent, 1];
             [_uniqueComponent, "initializeComponent", [_type, _preset]] call EFUNC(sys_data,dataEvent);
             if (_callBack != "") then {
                 [_callBack, [_uniqueComponent]+_this] call CALLSTACK(CBA_fnc_globalEvent);
             };
             private _fnc = {
                 private _uniqueComponent = _this;
                 GVAR(unacknowledgedIds) deleteAt (GVAR(unacknowledgedIds) find _uniqueComponent);
                 HASH_REM(GVAR(unacknowledgedTable),_uniqueComponent);
             };
             [_fnc, _uniqueComponent] call CBA_fnc_execNextFrame;
             // GVAR(waitingForIdAck) = true;
         };
     } else {
         if (_failCallback != "") then {
             [_failCallback, _this] call CALLSTACK(CBA_fnc_globalEvent);
         };
     };
} else {
     if (_failCallback != "") then {
         [_failCallback, _this] call CALLSTACK(CBA_fnc_globalEvent);
     };
};
