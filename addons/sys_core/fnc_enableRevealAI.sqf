#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Enables AI hearing of direct speech.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_enableRevealAI
 *
 * Public: No
 */

#define ACRE_REVEAL_AMOUNT 1.6

DFUNC(monitorAI_PFH) = {
    //if (time < 10) exitWith {};
    if (!alive acre_player) exitWith {}; // alive returns false for objNull
    if (ACRE_IS_SPECTATOR) exitWith {};
    //if (! ACRE_LOCAL_SPEAKING ) exitWith {};
    if (!(acre_player in GVAR(speakers))) exitWith {};
    if (isNil QEGVAR(api,selectableCurveScale)) exitWith {};

    //soundFactor is how loud the local player is speaking.
    private _soundFactor = EGVAR(api,selectableCurveScale); // typically 0.1 -> 1.3
    private _multiplier = GVAR(revealToAI) * 100 * (_soundFactor ^ 2);

    private _nearUnits = (getPosATL acre_player) nearEntities ["CAManBase", (130 * _soundFactor)];
    private _startTime = diag_tickTime;
    {
        if (diag_tickTime - _startTime > 0.002) exitWith {};
        private _curUnit = _x;

        if (!isPlayer _curUnit) then {
            // Scale revealing to be a better and better chance over time
            // and based on distance
            private _distance = (eyePos _curUnit) vectorDistance ACRE_LISTENER_POS;
            if (_distance == 0) exitWith {}; // Zeus remote control fix.

            // _occlusion = 1;//[eyePos _curUnit, ACRE_LISTENER_POS, _curUnit] call FUNC(findOcclusion);
            //_occlusion = [eyePos _curUnit, ACRE_LISTENER_POS, _curUnit] call FUNC(findOcclusion);

            // Cheaper approximation for AI
            private _intersectObjects = lineIntersectsObjs [eyePos _curUnit, ACRE_LISTENER_POS, _curUnit, acre_player, false, 6];
            private _occlusion = ((0.1 + _soundFactor) / 2) ^ (count _intersectObjects); // - Occlusion make harsher the quieter the player is.

            // Calculate the probability of revealing.
            // y=\frac{250\cdot \left(\left(1.3\right)^2\right)}{\left(x\right)^2}
            // 1.3 is standing in for the value of selectableCurveScale

            private _chance = _occlusion * (_multiplier  / _distance);
            TRACE_4("", _curUnit, _distance, _occlusion, _chance);
            if ((random 1) < _chance) then {
                TRACE_2("REVEAL!", _curUnit, acre_player);
                // 15 second block before revealing again.
                private _lastRevealed = _curUnit getVariable [QGVAR(lastRevealed), -15];
                if (_lastRevealed + 15 < time) then {
                    TRACE_2("Calling reveal event", _curUnit, _hasRevealed);
                    _curUnit setVariable [QGVAR(lastRevealed), time, false];
                    [QGVAR(onRevealUnit), [acre_player, _curUnit, ACRE_REVEAL_AMOUNT ] ] call CALLSTACK(CBA_fnc_globalEvent);
                };
            };
        };
    } forEach _nearUnits;

    if (GVAR(revealToAI) isEqualTo 0) then {
        [(_this select 1)] call CBA_fnc_removePerFrameHandler;
    };
};

GVAR(monitorAIHandle) = ADDPFH(DFUNC(monitorAI_PFH), 0.5, []);
