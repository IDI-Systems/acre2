#include "script_component.hpp"
/*
 * Author: ACRETeam
 * Initalizes the "Babel Languages" Zeus module display.
 *
 * Arguments:
 * 0: babelLanguages controls group <CONTROL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_control"];

// Generic Init
private _display = ctrlParent _control;
private _ctrlButtonOk = _display displayCtrl IDC_OK;

_control ctrlRemoveAllEventHandlers "setFocus";

private _listbox = _display displayCtrl IDC_LIST;
{
    // ex: _x == ["en", "English"];
    _listbox lnbAddRow _x;
} forEach EGVAR(sys_core,languages);

GVAR(languageEH) = ["acre_babel_languageAdded", {
    params ["_key", "_name"];
    _thisArgs = params ["_listbox"];
    _listbox lnbAddRow [_key, _name];
}, [_listbox]] call CBA_fnc_addEventHandlerArgs;

private _fnc_onConfirm = {
    params [["_ctrlButtonOK", controlNull, [controlNull]]];

    private _display = ctrlparent _ctrlButtonOK;
    if (isNull _display) exitWith {};

    private _id_bar = _display displayCtrl IDC_ID_BAR;
    private _id = ctrlText _id_bar;

    private _name_bar = _display displayCtrl IDC_NAME_BAR;
    private _name = ctrlText _name;

    [_id, _name, count EGVAR(sys_core,languages)] remoteExecCall [QEFUNC(sys_core,addLanguageTypeJIP), 0, true];
};
_ctrlButtonOK ctrlAddEventHandler ["buttonclick", _fnc_onConfirm];

private _fnc_onUnload = {
    private _logic = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objnull];
    if (isNull _logic) exitWith {};
    deleteVehicle _logic;

    ["acre_babel_languageAdded", GVAR(languageEH)] call CBA_fnc_removeEventHandler;
};
_display displayAddEventHandler ["unload", _fnc_onUnload];
