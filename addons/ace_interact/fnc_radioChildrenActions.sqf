#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates a list of actions for using a radio in the player's inventory or externally used radios
 *
 * Arguments:
 * 0: Unit with ACRE2 radios <OBJECT>
 * 1: Player <OBJECT>
 * 2: Array with additional parameters <ARRAY>
 *   0: Unique radio ID <STRING>
 *   1: Is Active <BOOL>
 *   2: PTT assigned radio IDs <ARRAY>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [acre_player, acre_player, ["ACRE_PRC343_ID_1"]] call acre_ace_interact_fnc_radioChildrenActions
 *
 * Public: No
 */

params ["_target", "", "_params"];
_params params ["_radio", "_active", "_pttAssign"];

private _actions = [];

if (!(_radio in ACRE_EXTERNALLY_USED_PERSONAL_RADIOS)) then {
    private _spatial = [_radio] call EFUNC(api,getRadioSpatial);
    private _text = LLSTRING(bothEars);
    private _icon = QPATHTOF(data\icons\both_ears.paa);
    if (_spatial == "LEFT") then {
        _text = LLSTRING(leftEar);
        _icon = QPATHTOF(data\icons\left_ear.paa);
    };
    if (_spatial == "RIGHT") then {
        _text = LLSTRING(rightEar);
        _icon = QPATHTOF(data\icons\right_ear.paa);
    };

    private _action = [
        QGVAR(spatialRadio),
        _text,
        _icon,
        {},
        {true},
        LINKFUNC(generateSpatialChildrenActions),
        _params + [_spatial]
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];

    if (!((_radio in ACRE_ACCESSIBLE_RACK_RADIOS && {isTurnedOut acre_player}) || _radio in ACRE_HEARABLE_RACK_RADIOS)) then {
        _action = [
            QGVAR(openRadio),
            LELSTRING(sys_gui,Open),
            QPATHTOF(data\icons\open.paa),
            {[((_this select 2) select 0)] call EFUNC(sys_radio,openRadio)},
            {true},
            {},
            _params
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };

    _action = [
        QGVAR(makeActive),
        LLSTRING(setAsActive),
        QPATHTOF(data\icons\active.paa),
        {[(_this select 2) select 0] call EFUNC(api,setCurrentRadio)},
        {!((_this select 2) select 1)},
        {},
        [_radio, _active]
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];

    // External radios. Show only options to share/stop sharing the radio if you are the actual owner and not an external user.
    if (!(_radio in ACRE_ACTIVE_EXTERNAL_RADIOS || {_radio in ACRE_HEARABLE_RACK_RADIOS})) then {
        _action = [
            QGVAR(shareRadio),
            LELSTRING(sys_external,shareRadio),
            QPATHTOF(data\icons\share.paa),
            {[(_this select 2) select 0, true] call EFUNC(sys_external,allowExternalUse)},
            {!([(_this select 2) select 0] call EFUNC(sys_external,isRadioShared))},
            {},
            _params
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];

        _action = [
            QGVAR(retrieveRadio),
            LELSTRING(sys_external,unshareRadio),
            QPATHTOF(data\icons\unshare.paa),
            {[(_this select 2) select 0, false] call EFUNC(sys_external,allowExternalUse)},
            {[(_this select 2) select 0] call EFUNC(sys_external,isRadioShared)},
            {},
            _params
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };

    private _idx = _pttAssign find _radio;
    _text = LLSTRING(bindMultiPushToTalk);
    _icon = QPATHTOF(data\icons\ptt.paa);
    if ((_idx > -1) && (_idx < 3)) then {
        _text = format [LLSTRING(multiPushToTalk), _idx + 1];
        _icon = format [QPATHTOF(data\icons\ptt_%1.paa), _idx + 1];
    };

    _action = [
        QGVAR(mpttAssign),
        _text,
        _icon,
        {},
        {true},
        LINKFUNC(radioPTTChildrenActions),
        _params
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} else {
    private _action = [
        QGVAR(openRadio),
        LELSTRING(sys_gui,Open),
        QPATHTOF(data\icons\open.paa),
        {[((_this select 2) select 0)] call EFUNC(sys_radio,openRadio)},
        {true},
        {},
        _params
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

if (GVAR(connectorsEnabled)) then {
    private _action = [
        QGVAR(connectors),
        LLSTRING(connectors),
        QPATHTOF(data\icons\connector4.paa),
        {},
        {true},
        LINKFUNC(generateConnectors),
        _params
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
