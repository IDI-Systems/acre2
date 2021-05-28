#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds a unique radio to a AI unit
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Radio Base class <STRING>
 * 2: Preset (optional) <STRING>
 *
 * Return Value:
 * Added <BOOL>
 *
 * Example:
 * [q2, "acre_prc343"] call acre_sys_headless_fnc_addRadio
 *
 * Public: No
 */
[{
    params ["_unit", "_radioBaseClass", ["_preset", "", [""]]];
    TRACE_3("addRadio",_unit,_radioBaseClass,_preset);

    if (!isServer) exitWith { ERROR_1("only use on server - %1",_this); false };
    if (!alive _unit) exitWith { ERROR_1("bad unit - %1",_this); false };
    if (!([_radioBaseClass] call EFUNC(api,isBaseRadio))) exitWith { ERROR_1("bad radio - %1",_this); false };
    if (!([_unit, _radioBaseClass] call CBA_fnc_canAddItem)) exitWith { ERROR_1("cannot add radio - %1",_this); false };

    GVAR(newUniqueRadio) = ""; // Because this is all running on the server, this gvar will be set by the EH in-line
    
    private _tempEH = [QEGVAR(sys_radio,returnRadioId), {
        params ["_unit", "_class"];
        TRACE_2("returnRadioId tempEH",_unit,_class);
        GVAR(newUniqueRadio) = _class;
    }] call CBA_fnc_addEventHandler;

    ["acre_getRadioId", [_unit, _radioBaseClass, QEGVAR(sys_radio,returnRadioId)]] call CBA_fnc_serverEvent;

    TRACE_2("after getRadioID",_tempEH,GVAR(newUniqueRadio));
    [QEGVAR(sys_radio,returnRadioId), _tempEH] call CBA_fnc_removeEventHandler;

    if (GVAR(newUniqueRadio) == "") exitWith {
        ERROR_1("failed to get radio ID - %1",_this); 
        false
    };

    _unit addItem GVAR(newUniqueRadio);

    // initialize the new radio
    if (_preset == "") then {
        _preset = [_radioBaseClass] call EFUNC(sys_data,getRadioPresetName);
        TRACE_2("got default preset",_radioBaseClass,_preset);
    };
    [GVAR(newUniqueRadio), _preset] call EFUNC(sys_radio,initDefaultRadio);

    ["acre_acknowledgeId", [GVAR(newUniqueRadio), _unit]] call CBA_fnc_serverEvent;

    true
}, _this] call CBA_fnc_directCall;
