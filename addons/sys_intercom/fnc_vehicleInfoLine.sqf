/*
 * Author: ACRE2Team
 * Check if intercom option is available on infantry units.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * NONE
 *
 * Example:
 * [vehicle player, player] call acre_sys_intercom_fnc_vehicleInfoLine
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit"];

private _intercomNames = _vehicle getVariable [QEGVAR(sys_intercom,intercomNames), []];
private _infoLine = "";
{
    private _connectionStatus = [_vehicle, _unit, _forEachIndex, INTERCOM_STATIONSTATUS_CONNECTION] call EFUNC(sys_intercom,getStationConfiguration);
    private _color = "";
    private _textStatus = "";
    private _displayName = _x select 2;
    switch (_connectionStatus) do {
        case INTERCOM_DISCONNECTED: {
            _color = "#737373";
        };
        case INTERCOM_RX_ONLY: {
            _color = "#ffffff";
            _textStatus = "(R)";
        };
        case INTERCOM_TX_ONLY: {
            _color = "#ffffff";
            _textStatus = "(T)";
        };
        case INTERCOM_RX_AND_TX: {
            _color = "#ffffff";
            _textStatus = "(R/T)";
        };
    };

    private _voiceActivation = [_vehicle, _unit, _forEachIndex, INTERCOM_STATIONSTATUS_VOICEACTIVATION] call EFUNC(sys_intercom,getStationConfiguration);

    _infoLine = _infoLine + format ["<t font='PuristaBold' color='%1' size='0.8'>%2 </t>", _color, _displayName];
    _infoLine = _infoLine + format ["<t font='PuristaBold' color='%1' size='0.6'>%2 </t>", _color, _textStatus];
} forEach _intercomNames;

_infoLine = _infoLine + format ["<t font='PuristaBold' color='#737373' size='0.6'>| </t>"];

{
    if ([_x, _unit] call EFUNC(sys_rack,isRackAccessible) || [_x, _unit] call EFUNC(sys_rack,isRackHearable)) then {
        private _rackClassName = _x;
        private _config = ConfigFile >> "CfgVehicles" >> _rackClassName;
        private _displayName = [_rackClassName, "getState", "name"] call EFUNC(sys_data,dataEvent);
        private _mountedRadio = [_rackClassName] call EFUNC(sys_rack,getMountedRadio);
        private _color = "#737373";
        private _textStatus = "";
        if (_mountedRadio in ACRE_ACCESSIBLE_RACK_RADIOS || {_mountedRadio in ACRE_HEARABLE_RACK_RADIOS}) then {
            _color = "#ffffff";
            _textStatus = "(R/T)";
            if ([_x, _unit] call EFUNC(sys_rack,isRackHearable)) then {

                private _connectionStatus = ["", _vehicle, _unit, _x] call FUNC(getRackRxTxCapabilities);
                switch (_connectionStatus) do {
                    case RACK_NO_MONITOR: {
                        _textStatus = "";
                    };
                    case RACK_RX_ONLY: {
                        _textStatus = "(R)";
                    };
                    case RACK_TX_ONLY: {
                        _textStatus = "(T)";
                    };
                    case RACK_RX_AND_TX: {
                        _textStatus = "(R/T)";
                    };
                };
            };
        };

        _infoLine = _infoLine + format ["<t font='PuristaBold' color='%1' size='0.8'>%2 </t>", _color, _displayName];
        _infoLine = _infoLine + format ["<t font='PuristaBold' color='%1' size='0.6'>%2 </t>", _color, _textStatus];
    };
} forEach ([_vehicle] call EFUNC(sys_rack,getVehicleRacks));

[_infoLine] call EFUNC(sys_gui,updateVehInfo);
