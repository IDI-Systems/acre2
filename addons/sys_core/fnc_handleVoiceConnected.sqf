#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Called when connected to the voice server. Publishes our voice peer ID on our unit (which is
 * how other players map speakers to units) and makes sure the extension gets our state afresh.
 *
 * Arguments:
 * 0: Voice peer ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [3] call acre_sys_core_fnc_handleVoiceConnected
 *
 * Public: No
 */

params ["_peerId"];

private _oldId = GVAR(ts3id);
GVAR(ts3id) = _peerId;
if (!isNull acre_player) then {
    acre_player setVariable [QGVAR(ts3id), _peerId, true];
};

// Spectators are tracked by peer ID on the server: move the registration to the new ID.
if (ACRE_IS_SPECTATOR && {_oldId != _peerId} && {_oldId != -1}) then {
    [QEGVAR(sys_server,onSetSpector), [_oldId, 0, clientOwner]] call CALLSTACK(CBA_fnc_serverEvent);
    [QEGVAR(sys_server,onSetSpector), [_peerId, 1, clientOwner]] call CALLSTACK(CBA_fnc_serverEvent);
};

GVAR(lastDirectTx) = [];
GVAR(lastRxChannels) = [];
GVAR(lastExtraPositions) = [];
