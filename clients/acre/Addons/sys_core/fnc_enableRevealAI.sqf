//#define DEBUG_MODE_FULL 
#include "script_component.hpp"

#define ACRE_REVEAL_AMOUNT 1.6

DFUNC(monitorAI_PFH) = {
	//if(time < 10) exitWith {};
	if(isNull acre_player) exitWith {};
	if(ACRE_IS_SPECTATOR) exitWith {};
	if(!alive acre_player) exitWith {};
	//if(! ACRE_LOCAL_SPEAKING ) exitWith {};
	if(!(acre_player in GVAR(speakers))) exitWith {};
	if(isNil "acre_api_selectableCurveScale" ) exitWith {};
	
	//soundFactor is how loud the local player is speaking.
	private _soundFactor = acre_api_selectableCurveScale; // typically 0.1 -> 1.3
	private _multiplier = 250*(_soundFactor^2);
	
	private _nearUnits = (getPosATL acre_player) nearEntities ["CAManBase", (130 * _soundFactor)];
	private _startTime = diag_tickTime;
	{
        if(diag_tickTime - _startTime > 0.002) exitWith {};
		private _curUnit = _x;
		
		if(!isPlayer _curUnit) then {
			// Scale revealing to be a better and better chance over time
			// and based on distance
			private _distance = (eyePos _curUnit) vectorDistance ACRE_LISTENER_POS;
			if (_distance == 0) exitWith {}; // Zeus remote control fix.
			
			// _occlusion = 1;//[eyePos _curUnit, ACRE_LISTENER_POS, _curUnit] call FUNC(findOcclusion);
			//_occlusion = [eyePos _curUnit, ACRE_LISTENER_POS, _curUnit] call FUNC(findOcclusion);
			
			// Cheaper approximation for AI
			private _intersectObjects = lineIntersectsObjs [eyePos _curUnit, ACRE_LISTENER_POS, _curUnit, acre_player, false, 6];
			private _occlusion = ((0.1+_soundFactor)/2)^(count _intersectObjects); // - Occlusion make harsher the quieter the player is.
			
			// Calculate the probability of revealing.
			// y=\frac{250\cdot \left(\left(1.3\right)^2\right)}{\left(x\right)^2}
			// 1.3 is standing in for the value of selectableCurveScale
			
			private _chance = _occlusion * (_multiplier  / _distance);
			TRACE_4("", _curUnit, _distance, _occlusion, _chance);
			if((random 1) < _chance) then {
				TRACE_2("REVEAL!", _curUnit, acre_player);
				// 15 second block before revealing again.
				private _lastRevealed = _curUnit getVariable[QGVAR(lastRevealed), -15];
				if(_lastRevealed + 15 < time) then {
					TRACE_2("Calling reveal event", _curUnit, _hasRevealed);
					_curUnit setVariable[QGVAR(lastRevealed), time, false];
					[QGVAR(onRevealUnit), [acre_player, _curUnit, ACRE_REVEAL_AMOUNT ] ] call CALLSTACK(LIB_fnc_globalEvent);
				};
			};
		};
	} forEach _nearUnits;

	if(!ACRE_AI_ENABLED) then {
		[(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
	};
};

GVAR(monitorAIHandle) = ADDPFH(DFUNC(monitorAI_PFH), 0.5, []);
