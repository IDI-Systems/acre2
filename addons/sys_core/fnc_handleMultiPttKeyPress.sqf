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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

TRACE_1("got ptt press", _this);

if (ACRE_IS_SPECTATOR) exitWith { true };

if ( GVAR(pttKeyDown) && ! isNil QGVAR(delayReleasePTT_Handle) ) then {
    [[ACRE_BROADCASTING_RADIOID, true]] call DFUNC(doHandleMultiPttKeyPressUp);
} else {
    if (GVAR(pttKeyDown)) exitWith { true };
};

if (ACRE_ACTIVE_PTTKEY == -2) then {

    ACRE_ACTIVE_PTTKEY = _this select 0;
    private _sendRadio = "";
    if (ACRE_ACTIVE_PTTKEY == -1) then {
        _sendRadio = ACRE_ACTIVE_RADIO;
    } else {
        private _radioList = [] call EFUNC(sys_data,getPlayerRadioList);
        if (ACRE_ACTIVE_PTTKEY <= (count _radioList)-1) then {
            if ( (count ACRE_ASSIGNED_PTT_RADIOS) > 0) then {
                private _sortList = [ACRE_ASSIGNED_PTT_RADIOS, _radioList] call EFUNC(sys_data,sortRadioList);
                // This will handle cleanup automatically too
                ACRE_ASSIGNED_PTT_RADIOS = _sortList select 0;
                _radioList = _sortList select 1;

            };
            _sendRadio = _radioList select ACRE_ACTIVE_PTTKEY;
            [_sendRadio] call EFUNC(sys_radio,setActiveRadio);
        };
    };

    if (_sendRadio != "") then {
        private _on = [_sendRadio, "getOnOffState"] call EFUNC(sys_data,dataEvent);
        if (_on == 1) then {
            private _initiateRadio = [_sendRadio, "handlePTTDown"] call EFUNC(sys_data,transEvent);

            if (_initiateRadio) then {
                ACRE_BROADCASTING_RADIOID = _sendRadio;
                // diag_log text format["ASSIGNED ACRE_BROADCASTING_RADIOID KEYDOWN: %1", ACRE_BROADCASTING_RADIOID];
                GVAR(pttKeyDown) = true;

                ["startRadioSpeaking", _sendRadio] call EFUNC(sys_rpc,callRemoteProcedure);
                [] call FUNC(showBroadCastHint);
            };
        };
    };
};

true
