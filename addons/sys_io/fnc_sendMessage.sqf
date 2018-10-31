#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sends a message to the TeamSpeak plugin via the ACRE2Arma extension.
 *
 * Arguments:
 * 0: Message <STRING>
 *
 * Return Value:
 * Successful Sending <BOOL>
 *
 * Example:
 * ["getPluginVersion:,"] call acre_sys_io_fnc_sendMessage
 *
 * Public: No
 */

if (GVAR(pipeCode) == "1") exitWith {
    private _ret = "ACRE2Arma" callExtension ("2" + _this);
    true
};

false
