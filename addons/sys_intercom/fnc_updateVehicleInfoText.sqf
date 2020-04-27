#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Updates the Vehicle Info UI in vehicles.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * NONE
 *
 * Example:
 * [vehicle player, player] call acre_sys_intercom_fnc_updateVehicleInfoText
 *
 * Public: No
 */

params ["_vehicle", "_unit"];

#define GRAY  "#737373"
#define WHITE "#ffffff"
#define GREEN "#008000"

if (vehicle _unit == _unit) exitWith {
    [false] call EFUNC(sys_gui,showVehicleInfo); // Hide
};

private _intercomNames = _vehicle getVariable [QEGVAR(sys_intercom,intercomNames), []];
private _infoLine = "";
private _elements = count _intercomNames;
private _colorfnc = {
    params ["_idx"];

    private _color = WHITE;
    if (GVAR(activeIntercom) == _idx && {GVAR(guiOpened)}) then {
        _color = GREEN;
    };

    _color
};

{
    private _hasAccess = [_vehicle, _unit, _forEachIndex, INTERCOM_STATIONSTATUS_HASINTERCOMACCESS] call FUNC(getStationConfiguration);
    if (_hasAccess) then {
        private _connectionStatus = [_vehicle, _unit, _forEachIndex, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration);
        private _isBroadcasting = ((_vehicle getVariable [QGVAR(broadcasting), [false, objNull]]) select _forEachIndex) params ["_isBroadcasting", "_broadcastingUnit"];
        private _isVoiceActive = [_vehicle, _unit, _forEachIndex, INTERCOM_STATIONSTATUS_VOICEACTIVATION] call FUNC(getStationConfiguration);


        private _color = "";
        private _textStatus = "";
        private _displayName = _x select 2;
        switch (_connectionStatus) do {
            case INTERCOM_DISCONNECTED: {
                _color = GRAY;
            };
            case INTERCOM_RX_ONLY: {
                _color = [_forEachIndex] call _colorfnc;
                _textStatus = format ["<t font='PuristaBold' color='%1' size='0.6'>(R) </t>", _color];
            };
            case INTERCOM_TX_ONLY: {
                _color = [_forEachIndex] call _colorfnc;
                if (_isBroadcasting && {_broadcastingUnit == acre_player}) then {
                    _textStatus = format ["<t font='PuristaBold' color='%1' size='0.6'>(B) </t>", _color];
                } else {
                    if (_isVoiceActive) then { // PTT activation
                        _textStatus = format ["<t font='PuristaBold' color='%1' size='0.6'>(T) </t>", _color];
                    } else {
                        if (_unit getVariable [QGVAR(intercomPTT), false]) then {
                            _textStatus = format ["<t font='PuristaBold' color='%1' size='0.6'>(P) </t>", _color];
                        } else {
                            _textStatus = format ["<t font='PuristaBold' color='#737373' size='0.6'>(P) </t>"];
                        };
                    };
                };
            };
            case INTERCOM_RX_AND_TX: {
                _color = [_forEachIndex] call _colorfnc;
                if (_isBroadcasting && {_broadcastingUnit == acre_player}) then {
                    _textStatus = format ["<t font='PuristaBold' color='%1' size='0.6'>(R/B) </t>", _color];
                } else {
                    if (_isVoiceActive) then { // PTT activation
                        _textStatus = format ["<t font='PuristaBold' color='%1' size='0.6'>(R/T) </t>", _color];
                    } else {
                        if (_unit getVariable [QGVAR(intercomPTT), false]) then {
                            _textStatus = format ["<t font='PuristaBold' color='%1' size='0.6'>(R/P) </t>", _color];
                        } else {
                            _textStatus = format ["<t font='PuristaBold' color='%1' size='0.6'>(R/</t>", _color];
                            _textStatus = format ["%1<t font='PuristaBold' color='#737373' size='0.6'>P</t>", _textStatus];
                            _textStatus = format ["%1<t font='PuristaBold' color='%2' size='0.6'>) </t>", _textStatus, _color];
                        };
                    };
                };
            };
        };

        _infoLine = format ["%1<t font='PuristaBold' color='%2' size='0.8'>%3 </t>%4", _infoLine, _color, _displayName, _textStatus];
    };
} forEach _intercomNames;

if !(_intercomNames isEqualTo []) then {
    _infoLine = format ["%1<t font='PuristaBold' color='#ffffff' size='0.8'>| </t>", _infoLine];
};

{
    if ([_x, _unit] call EFUNC(sys_rack,isRackAccessible) || [_x, _unit] call EFUNC(sys_rack,isRackHearable)) then {
        private _rackClassName = _x;
        private _displayName = [_rackClassName, "getState", "shortName"] call EFUNC(sys_data,dataEvent);
        private _mountedRadio = [_rackClassName] call EFUNC(sys_rack,getMountedRadio);
        private _color = GRAY;
        private _textStatus = "";
        if (_mountedRadio in ACRE_ACCESSIBLE_RACK_RADIOS || {_mountedRadio in ACRE_HEARABLE_RACK_RADIOS}) then {
            _color = WHITE;
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

        _infoLine = format ["%1<t font='PuristaBold' color='%2' size='0.8'>%3 </t>", _infoLine, _color, _displayName];
        _infoLine = format ["%1<t font='PuristaBold' color='%2' size='0.6'>%3 </t>", _infoLine, _color, _textStatus];

        _elements = _elements + 1;
    };
} forEach ([_vehicle] call EFUNC(sys_rack,getVehicleRacks));

#ifdef DEBUG_VEHICLE_INFO
private _color = WHITE;
private _textStatus = format ["<t font='PuristaBold' color='%1' size='0.6'>(R/B) </t>", _color];
_infoLine = "";

{
    _infoLine = format ["%1<t font='PuristaBold' color='%2' size='0.8'>%3 </t>%4", _infoLine, _color, _x, _textStatus];
} forEach ["Crew", "Crew", "Crew", "Crew", "Crew", "Crew", "Crew", "Crew", "Crew", "Crew"];

_infoLine = format ["%1<t font='PuristaBold' color='#ffffff' size='0.8'>| </t>", _infoLine];

{
    _textStatus = "(R/T)";
    _infoLine = format ["%1<t font='PuristaBold' color='%2' size='0.8'>%3 </t>", _infoLine, _color, _x];
    _infoLine = format ["%1<t font='PuristaBold' color='%2' size='0.6'>%3 </t>", _infoLine, _color, _textStatus];
} forEach ["Dash", "Dash", "Dash", "Dash", "Dash", "Dash", "Dash", "Dash", "Dash", "Dash"];

_elements = 20;
#endif

// Show or hide vehicle info UI based on available access (hide if nothing is accessible)
if (_infoLine == "") then {
    [false] call EFUNC(sys_gui,showVehicleInfo); // Hide
} else {
    TRACE_2("vehicle info text",_infoLine,_elements);
    [true] call EFUNC(sys_gui,showVehicleInfo); // Show
    [_infoLine, _elements] call EFUNC(sys_gui,updateVehicleInfo); // Must be visible first
};
