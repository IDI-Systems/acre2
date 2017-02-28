/*
 * Author: ACRE2Team
 * Sends a message to the TeamSpeak plugin via extension.
 *
 * Arguments:
 * 0: Message <STRING>
 *
 * Return Value:
 * Successful <BOOL>
 *
 * Example:
 * ["getPluginVersion:,"] call acre_sys_io_fnc_sendMessage
 *
 * Public: No
 */
#include "script_component.hpp"

if (GVAR(pipeCode) == "1") exitWith {
    private _ret = "ACRE2Arma" callExtension ("2" + _this);
    true;
};

false;
