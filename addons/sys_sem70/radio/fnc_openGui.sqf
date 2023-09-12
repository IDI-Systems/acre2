#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_sem70_fnc_openGui
 *
 * Public: No
 */

/*
 *     On a command to open the radio this function will be called.
 *
 *    Type of Event:
 *        Interact
 *    Event:
 *        openGui
 *    Event raised by:
 *        - Double Click on Radio in inventory
 *        - Press of keybinding of the "open radio" action
 *
 *     Parsed parameters:
 *        0:    Active Radio ID
 *        1:    Event (-> "openGui")
 *        2:    Eventdata (-> [])
 *        3:    Radiodata (-> [])
 *        4:    Remote Call (-> false)
 *
 *    Returned parameters:
 *        true
*/

params ["_radioId", "", "", "", ""];

// Prevent radio from being opened if it is externally used or it is not accessible
if !([_radioId] call EFUNC(sys_radio,canOpenRadio)) exitWith { false };

//PARAMS_1(GVAR(currentRadioId))
GVAR(currentRadioId) = _radioId;
GVAR(lastAction) = time;
createDialog "SEM70_RadioDialog";

// Support reserved keybinds on dialog (eg. Tab)
MAIN_DISPLAY call (uiNamespace getVariable "CBA_events_fnc_initDisplayCurator");

[_radioId, true] call EFUNC(sys_radio,setRadioOpenState);

TRACE_2("OpenGui",GVAR(currentRadioId),GVAR(lastAction));

// Use this to turn off the backlight display//also to save last channel

[{
    params ["_input", "_pfhID"];

    if (GVAR(currentRadioId) isEqualTo -1) then {_input set [1, false]}; // Remove PFH on exit.
    _input params ["_radioId", "_open"];
    if (_open) then { _input set [2, GVAR(lastAction)]; };
    private _lastAction = _input select 2;

    if ((_lastAction + 5) < time) then {
        if (GVAR(backlightOn) && {!GVAR(displayButtonPressed)}) then {
            GVAR(backlightOn) = false;

            if (_open) then {
                [MAIN_DISPLAY] call FUNC(clearDisplay);
            };
        };
        if (!_open) then { [_pfhID] call CBA_fnc_removePerFrameHandler; };
    };
}, 1, [GVAR(currentRadioId), true, 0]] call CBA_fnc_addPerFrameHandler;
true
