#include "script_component.hpp"

[QGVAR(disconnectGsa), {
    params ["_gsa", "_unit"];

    private _success = false;
    private _radioId = _gsa getVariable [QGVAR(connectedRadio), ""];
    if (_radioId isEqualTo "") exitWith {
        ERROR("Emtpy unique radio ID");
        _success
    };

    private _connectedUnit = [_radioId] call EFUNC(sys_radio,getRadioObject);
    if (isNull _connectedUnit) exitWith {
        ERROR("Null connected object returned");
        _success
    };

    private _parentComponentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_radioId);
    {
        _x params ["", "_component"];

        private _componentType = getNumber (configFile >> "CfgAcreComponents" >> _component >> "type");
        if (_componentType == ACRE_COMPONENT_ANTENNA) then {
            _success = [_radioId, 0, _component, HASH_CREATE, true] call EFUNC(sys_components,attachSimpleComponent);
            if (_success) exitWith {
                _gsa setVariable [QGVAR(connectedRadio), "", true];
                [_radioId, "setState", ["externalAntennaConnected", [false, objNull]]] call EFUNC(sys_data,dataEvent);

                // Support for having several radios connected to GSA
                private _pfh = [GVAR(gsaPFH), _radioId, _pfh] call CBA_fnc_hashGSet;
                if !(isNil "_pfh") then {
                    [_pfh] call CBA_fnc_removePerFrameHandler;
                };

                if (_connectedUnit isKindOf "CAManBase" || {!(crew _connectedUnit isEqualTo [])}) then {
                    if (_connectedUnit isKindOf "CAManBase") then {
                        [QGVAR(notifyPlayer), [localize LSTRING(disconnected)], _connectedUnit] call CBA_fnc_targetEvent;
                    } else {
                        {
                            [QGVAR(notifyPlayer), [localize LSTRING(disconnected)], _connectedUnit] call CBA_fnc_targetEvent;
                        } forEach (crew _connectedUnit);
                    };
                };

                if (_connectedUnit != _unit && {_connectedUnit isKindOf "CAManBase"}) then {
                    // The unit that disconnected the antenna is different from the unit that was connected to it
                    private _text = format [localize LSTRING(disconnectedUnit), name _unit];
                    [QGVAR(notifyPlayer), [_text], _unit] call CBA_fnc_targetEvent;
                };
            };
        };
    } forEach (getArray (_parentComponentClass >> "defaultComponents"));
}] call CBA_fnc_addEventHandler;

[QGVAR(connectGsa), {
    params ["_gsa", "_radioId", "_player"];

    private _classname = typeOf _gsa;
    private _componentName = getText (configFile >> "CfgVehicles" >> _classname >> "AcreComponents" >> "componentName");

    // Check if the antenna was connected somewhere else
    private _connectedGsa = [_radioId, "getState", "externalAntennaConnected"] call EFUNC(sys_data,dataEvent);

    // Do nothing if the antenna is already connected
    if (_connectedGsa select 0) exitWith {
        [QGVAR(notifyPlayer), [localize LSTRING(alreadyConnected)], _player] call CBA_fnc_targetEvent;
    };

    // Force attach the ground spike antenna
    [_radioId, 0, _componentName, HASH_CREATE, true] call EFUNC(sys_components,attachSimpleComponent);

    _gsa setVariable [QGVAR(connectedRadio), _radioId, true];
    [_radioId, "setState", ["externalAntennaConnected", [true, _gsa]]] call EFUNC(sys_data,dataEvent);

    [QGVAR(notifyPlayer), [localize LSTRING(connected)], _player] call CBA_fnc_targetEvent;

    // Support for having several radios connected to GSA
    private _pfh = [DFUNC(externalAntennaPFH), 1.0, [_gsa, _radioId]] call CBA_fnc_addPerFrameHandler;
    [GVAR(gsaPFH), _radioId, _pfh] call CBA_fnc_hashSet;
}] call CBA_fnc_addEventHandler;

[QGVAR(notifyPlayer), {
    params ["_text"];

    [[ICON_RADIO_CALL], [_text]] call CBA_fnc_notify;
}] call CBA_fnc_addEventHandler;
