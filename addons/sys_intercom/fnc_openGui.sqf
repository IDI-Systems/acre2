#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Opens the intercom gui.
 *
 * Arguments:
 * 0: Intercom network <NUMBER> (default: -1)
 * 1: Open master statio <BOOL> (default: false)
 *
 * Return Value:
 * GUI successfully opened <BOOL>
 *
 * Example:
 * [1, true] call acre_sys_intercom_fnc_openGui
 *
 * Public: No
 */

params [["_intercomNetwork", -1], ["_openMasterStation", false]];

if (GVAR(guiOpened)) exitWith {
    closeDialog 0;
    true
};

private _vehicle = vehicle acre_player;
private _intercomNames = _vehicle getVariable [QGVAR(intercomNames), []];

if (_vehicle isEqualTo acre_player || {_intercomNames isEqualTo []}) exitWith {false};

if (_intercomNetwork != -1) then {
    GVAR(activeIntercom) = _intercomNetwork;
} else {
    private _getActiveIntercom = {
        params ["_vehicle"];

        private _activeIntercom = -1;
        {
            private _connectionStatus = [_vehicle, acre_player, _forEachIndex, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration);
            if (_connectionStatus > INTERCOM_DISCONNECTED) exitWith {
                _activeIntercom = _forEachIndex;
            }
        } forEach _intercomNames;

        _activeIntercom;
    };

    if (GVAR(activeIntercom) != -1) then {
        private _connectionStatus = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration);
        if (_connectionStatus == INTERCOM_DISCONNECTED) then {
            GVAR(activeIntercom) = [_vehicle] call _getActiveIntercom;
        };
    } else {
        GVAR(activeIntercom) = [_vehicle] call _getActiveIntercom;
    };
};

if (GVAR(activeIntercom) == -1) exitWith {false};

GVAR(guiOpened) = true;

[_vehicle, acre_player] call FUNC(updateVehicleInfoText);

disableSerialization;

// Get the intercom type
if (!_openMasterStation) then {
    createDialog "VIC3FFCS_IntercomDialog";
};

true
