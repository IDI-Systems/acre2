//#define DEBUG_MODE_FULL
#include "script_component.hpp"

DFUNC(changeValueAck_End) = {
    params ["_radioId"];

    TRACE_1("",_this);
    if(diag_tickTime > GVAR(changeValueAckTimer)) then {
        _lastMenu = SCRATCH_GET_DEF(_radioId, "lastMenu", nil);
        if(isNil "_lastMenu") then { _lastMenu = GVAR(VULOSHOME); };
        
        if(!isNil "acre_sys_radio_currentRadioDialog") then {
            if(acre_sys_radio_currentRadioDialog == _radioId) then {
                TRACE_1("ChangeMenu","");
                [_lastMenu] call FUNC(changeMenu);
            } else {
                [_radioId, "setState", ["currentMenu",_lastMenu]] call EFUNC(sys_data,dataEvent);
            };
        } else {
            [_radioId, "setState", ["currentMenu",_lastMenu]] call EFUNC(sys_data,dataEvent);
        };
    };
};

// Save the current menu and display
// Push the ack menu render and then swap back after 3 seconds
// For volume, we should just by-hand render the display with the bar, and PFH break from it
// [fromMenu, [ValueType, Value]]



params["_menu","_valuePair"];
_valuePair params ["_valueType","_value"];

if(isNil QUOTE(GVAR(currentRadioId)) || isNil QUOTE(acre_sys_radio_currentRadioDialog) ) exitWith {
    false
};
if(acre_sys_radio_currentRadioDialog != GVAR(currentRadioId)) exitWith {
    false
};

[] call FUNC(clearDisplay);

TRACE_2("ENTER", _valueType, _value);

switch _valueType do {
    case 'VOLUME': {
        _lastMenu = SCRATCH_GET_DEF(GVAR(currentRadioId), "lastMenu", nil);
        if(isNil "_lastMenu") then {
            SCRATCH_SET(GVAR(currentRadioId), "lastMenu", _menu);
        };

        GVAR(changeValueAckTimer) = diag_tickTime + 3.5;
        [GVAR(currentRadioId), DFUNC(changeValueAck_End), 3.5] call DFUNC(delayFunction);
        
        [GVAR(VOLUME)] call FUNC(changeMenu);
    };
};

true