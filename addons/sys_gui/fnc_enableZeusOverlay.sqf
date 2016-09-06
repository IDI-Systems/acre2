/*
 * Author: AUTHOR
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

DFUNC(getCurators) = {
    private["_curatorPlayers", "_curatorObject", "_curatorPlayer"];
    _curatorPlayers = [];
    {
        _curatorObject = _x;
        _curatorPlayer = getAssignedCuratorUnit _curatorObject;
        _curatorPlayers pushBack [_curatorPlayer, _curatorObject];
    } forEach allCurators;

    _curatorPlayers
};

DFUNC(isUnitCurator) = {
    private["_curators", "_result"];

    _result = false;
    _curators = [] call FUNC(getCurators);

    {
        if((_x select 0) == acre_player) exitWith {
            _result = true;
            _result
        };
    } forEach _curators;

    _result
};
/*
[] spawn {

while { true } do {
    // If theres a zues acre_player, give him the ACRE overlay
    waitUntil { !isNull acre_player && { diag_tickTime > 0 } };

    if([acre_player] call FUNC(isUnitCurator)) then {
        // Curator is local acre_player

        //"RscDisplayCurator" call bis_fnc_rscLayer;
        //opencuratorinterface;
    };

Sleep 2;
};

};*/
