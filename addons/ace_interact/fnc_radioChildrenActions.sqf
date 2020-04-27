#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates a list of actions for using a radio in the player's inventory or externally used radios
 *
 * Arguments:
 * 0: Unit with ACRE2 radios <OBJECT>
 * 1: Active <BOOL>
 * 2: Array with additional parameters <ARRAY>
 *   0: Unique radio ID <STRING>
 *   1: Is Active <BOOL>
 *   2: PTT assigned radio IDs <ARRAY>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [acre_player, "", ["ACRE_PRC343_ID_1"]] call acre_ace_interact_fnc_radioChildrenActions
 *
 * Public: No
 */

params ["_target","","_params"];
_params params ["_radio", "_active", "_pttAssign"];

private _actions = [];

if (!(_radio in ACRE_EXTERNALLY_USED_PERSONAL_RADIOS)) then {
    private _spatial = [_radio] call EFUNC(api,getRadioSpatial);
    private _txt = localize LSTRING(bothEars);
    if (_spatial == "LEFT") then {
        _txt = localize LSTRING(leftEar);
    };
    if (_spatial == "RIGHT") then {
        _txt = localize LSTRING(rightEar);
    };

    private _action = [QGVAR(spatialRadio), _txt, "", {}, {true}, {_this call FUNC(generateSpatialChildrenActions);}, _params + [_spatial]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];

    if (!((_radio in ACRE_ACCESSIBLE_RACK_RADIOS && {isTurnedOut acre_player}) || _radio in ACRE_HEARABLE_RACK_RADIOS)) then {
        _action = [QGVAR(openRadio), localize ELSTRING(sys_gui,Open), "", {[((_this select 2) select 0)] call EFUNC(sys_radio,openRadio)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };

    _action = [QGVAR(makeActive), localize LSTRING(setAsActive), "", {[(_this select 2) select 0] call EFUNC(api,setCurrentRadio)}, {!((_this select 2) select 1)}, {}, [_radio, _active]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];

    // External radios. Show only options to share/stop sharing the radio if you are the actual owner and not an external user.
    if (!(_radio in ACRE_ACTIVE_EXTERNAL_RADIOS || {_radio in ACRE_HEARABLE_RACK_RADIOS})) then {
        _action = [QGVAR(shareRadio), localize ELSTRING(sys_external,shareRadio), "", {[(_this select 2) select 0, true] call EFUNC(sys_external,allowExternalUse)}, {!([(_this select 2) select 0] call EFUNC(sys_external,isRadioShared))}, {}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
        _action = [QGVAR(retrieveRadio), localize ELSTRING(sys_external,unshareRadio), "", {[(_this select 2) select 0, false] call EFUNC(sys_external,allowExternalUse)}, {[(_this select 2) select 0] call EFUNC(sys_external,isRadioShared)}, {}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };

    private _idx = _pttAssign find _radio;
    _txt = localize LSTRING(bindMultiPushToTalk);
    if ((_idx > -1) && (_idx < 3)) then {
        _txt = format [localize LSTRING(multiPushToTalk), (_idx + 1)];
    };

    _action = [QGVAR(mpttAssign), _txt, "", {}, {true}, {_this call FUNC(radioPTTChildrenActions);}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} else {
    private _action = [QGVAR(openRadio), localize ELSTRING(sys_gui,Open), "", {[((_this select 2) select 0)] call EFUNC(sys_radio,openRadio)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

if (GVAR(connectorsEnabled)) then {
    private _action = [QGVAR(connectors), "Connectors", "\idi\acre\addons\ace_interact\data\icons\connector4.paa", {}, {true}, {_this call FUNC(generateConnectors);}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions;
