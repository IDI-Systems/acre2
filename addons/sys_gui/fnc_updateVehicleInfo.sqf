#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Updates the text on the Vehicle Info UI.
 *
 * Arguments:
 * 0: Structured text to show <STRING>
 * 1: Amount of elements <NUMBER> (default: 1)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE", 3] call acre_sys_gui_fnc_updateVehicleInfo
 *
 * Public: No
 */

params ["_str", ["_elements", 1]];

private _ctrlGroup = uiNamespace getVariable ["ACRE_VehicleInfo", controlNull];
if (isNull _ctrlGroup) exitWith {};

private _ctrlBackground = _ctrlGroup controlsGroupCtrl 1;
private _ctrlText = _ctrlGroup controlsGroupCtrl 2;

// Set text
_ctrlText ctrlSetStructuredText parseText _str;

// Calculate new height (3 elements per row)
private _rows = ceil ((1 max _elements) / 3);
private _newBaseH = (((safezoneW / safezoneH) min 1.2) / 1.2) / 25;
private _newH = _newBaseH * _rows;
private _newContainerH = (0.8 * _newH) + 0.001;
TRACE_4("vehicle info height",_elements,_rows,_newH,_newContainerH);

// Resize controls group
private _ctrlGroupPos = ctrlPosition _ctrlGroup;
_ctrlGroupPos set [3, _newContainerH];
_ctrlGroup ctrlSetPosition _ctrlGroupPos;

// Resize background area
private _ctrlBackgroundPos = ctrlPosition _ctrlBackground;
_ctrlBackgroundPos set [3, _newContainerH];
_ctrlBackground ctrlSetPosition _ctrlBackgroundPos;

// Resize text area
private _ctrlTextPos = ctrlPosition _ctrlText;
_ctrlTextPos set [3, _newH];
_ctrlText ctrlSetPosition _ctrlTextPos;

_ctrlGroup ctrlCommit 0;
_ctrlBackground ctrlCommit 0;
_ctrlText ctrlCommit 0;
