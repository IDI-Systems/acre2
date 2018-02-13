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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

LOG("HIT CALLBACK");

params ["_player", "_class", "_returnIdNumber", "_replacementId"];

private _dataHash = HASH_CREATE;

// diag_log text format["acre_sys_data_radioData: %1", acre_sys_data_radioData];

HASH_SET(EGVAR(sys_data,radioData),_class,_dataHash);
private _idRelation = [_player, _player];
HASH_SET(EGVAR(sys_server,objectIdRelationTable), _class, _idRelation);
if (_replacementId != "") then {
    private _radioData = HASH_GET(EGVAR(sys_data,radioData), _replacementId);
    HASH_SET(EGVAR(sys_data,radioData), _class, HASH_COPY(_radioData));
};
if (_player == acre_player) then {
    private _baseRadio = _replacementId;
    if (_baseRadio == "") then {
        _baseRadio = BASECLASS(_class);
    };
    private _weapons = [acre_player] call EFUNC(sys_core,getGear);

    //if (_baseRadio in _weapons || ("ItemRadio" in _weapons && _baseRadio == GVAR(defaultItemRadioType) ) ) then {
    TRACE_2("Check inventory", _baseRadio, _weapons);
    if ((toLower _baseRadio) in _weapons) then {
        // Add a new radio based on the id we just got
        TRACE_3("Adding radio", _class, _baseRadio, _replacementId);

        if (_replacementId == "") then {
            // initialize the new radio
            private _preset = [BASECLASS(_class)] call EFUNC(sys_data,getRadioPresetName);
            [_class, _preset] call FUNC(initDefaultRadio);

            [acre_player, _baseRadio, _class] call EFUNC(sys_core,replaceGear);
            [_class] call EFUNC(sys_radio,setActiveRadio);
        } else {
            [acre_player, _replacementId, _class] call EFUNC(sys_core,replaceGear);
            if (_replacementId == ACRE_ACTIVE_RADIO) then {
                if (!isDedicated && isServer) then {
                    // need to delay setting the active radio out a frame because
                    // on a self hosted, this executes before the last gear check
                    // and Arma delays comitting gear changes till the next frame
                    // so currently, even though we removed the old radio, it will
                    // still show up in the gear list in this frame.
                    [{
                        [_this] call EFUNC(sys_radio,setActiveRadio);
                    }, _class] call CBA_fnc_execNextFrame;
                } else {
                    [_class] call EFUNC(sys_radio,setActiveRadio);
                };
            };
        };
    }  else {
        // if the radio is not added to the acre_player, the garbage collector will collect it when the
        // radio id is acknowledged below because the ID became unassociated with any world object.
        // I wish there was a more clean way to do this, but I can't think of it now, and hopefully
        // mission makers will use proper gear scripts.
        WARNING_3("Radio ID %1 was returned for a non-existent base class (%2) in inventory! Possibly removed by a gear script while requesting ID: %3!",_class,_baseRadio,_weapons);
    };
    GVAR(requestingNewId) = false;
    ["acre_acknowledgeId", [_class, acre_player]] call CALLSTACK(CBA_fnc_serverEvent);
};
