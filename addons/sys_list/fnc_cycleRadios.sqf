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
 * [ARGUMENTS] call acre_sys_list_fnc_cycleRadios
 *
 * Public: No
 */

LOG("HIT CYCLE RADIO");
if (!dialog) then {
    params ["_direction"];
    private _radios = [];
    private _count = 0;
    private _newRadioIndex = 0;
    // populate from local radio list
    private _radioList = ([] call EFUNC(sys_data,getPlayerRadioList));
    {
        private _radioClass = _x;
        private _listInfo = [_radioClass, "getListInfo"] call EFUNC(sys_data,dataEvent);
        private _radioRack = [_radioClass] call EFUNC(sys_rack,getRackFromRadio);
        private _realRadio = "";
        if (_radioRack == "") then {
            _realRadio = [_radioClass] call EFUNC(sys_radio,getRadioBaseClassname);
        } else {
            _realRadio = [_radioRack] call EFUNC(sys_rack,getRackBaseClassname);
        };
        private _typeName = getText (configFile >> "CfgAcreComponents" >> _realRadio >> "name");
        private _radio = [_typeName, _listInfo, _radioClass];
        TRACE_2("heh",_radioClass,ACRE_ACTIVE_RADIO);
        if (_radioClass == ACRE_ACTIVE_RADIO) then {
            TRACE_1("found index",_count);
            _newRadioIndex = _count;
        };
        _radios pushBack _radio;
        _count = _count + 1;
    } foreach _radioList;
    TRACE_1("index was",_newRadioIndex);
    TRACE_1("Active was",ACRE_ACTIVE_RADIO);
    if ((count _radios) > 1) then {
        if (_direction == 1) then {
            if (_newRadioIndex >= (count _radios)-1) then {
                _newRadioIndex = 0;
            } else {
                _newRadioIndex = _newRadioIndex + 1;
            };
        } else {
            if (_newRadioIndex <= 0) then {
                _newRadioIndex = (count _radios) - 1;
            } else {
                _newRadioIndex = _newRadioIndex - 1;
            };
        };
        TRACE_1("radios are",_radios);
        TRACE_1("index is",_newRadioIndex);
        private _activateRadio = _radios select _newRadioIndex;
        TRACE_1("Active is now",_activateRadio);
        [(_activateRadio select 2)] call EFUNC(sys_radio,setActiveRadio);
        ["acre_cycleRadio", (_activateRadio select 0), (_activateRadio select 1), "", 1, GVAR(CycleRadiosColor)] call FUNC(displayHint);
    };
};

false
