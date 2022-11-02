#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gives the ability to view attenuation behavior at runtime to diagnose issues with compartment configs.
 *
 * Example:
 * [ARGUMENTS] call acre_sys_attenuate_fnc_toggleDebugInfo;
 *
 * Public: No
 */
 
if (isNil {missionNameSpace getVariable "ACRE_SYS_ATTENUATE_DEBUG_DRAW"}) then {
	ACRE_SYS_ATTENUATE_DEBUG_DRAW = {
		private _speakers = allUnits;
		private _vehicleSpeakers = (_speakers) select {_x in (crew (vehicle acre_player))};
		private _outsideSpeakers = (_speakers - _vehicleSpeakers);

		private _hintMsg = format ["<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>ACRE Attenuation</t><br/><br />"];

		// Print player's vehicle role and compartment
		if (!isNull objectParent acre_player) then {
			_hintMsg = _hintMsg + format ["<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>Vehicle</t><br/>"];
			{
				_hintMsg = _hintMsg + format ["<t align='left' font='PuristaMedium'>%1</t><t align='right' font='PuristaBold'>%2</t><br/>", 
					format ["%1 (%2, %3)", name _x select [0, 10], [_x] call CBA_fnc_vehicleRole, [_x] call acre_sys_core_fnc_getCompartment],
					([_x] call acre_sys_attenuate_fnc_getUnitAttenuate)
				];
			} forEach _vehicleSpeakers;
		};

		// Print speakers or outside speakers and their roles
		private _fnc_getSpeakerText = {
			params ["_unit"];

			private _name = name _unit select [0, 10];
			if (!isNull objectParent _unit) then {
				_name = _name + format[" <t color='#0051a1'>(vehicle, %1)</t>", [_unit] call CBA_fnc_vehicleRole];
			};

			format ["<t align='left' font='PuristaMedium'>%1</t><t align='right' font='PuristaBold'>%2</t><br/>", 
				_name,
				([_unit] call acre_sys_attenuate_fnc_getUnitAttenuate)
			]
		};

		if (count _outsideSpeakers > 0) then {
			_hintMsg = _hintMsg + format["<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>%1</t><br/>", ["Outside", "Speakers"] select (isNull objectParent acre_player)];
			{
				_hintMsg = _hintMsg + ([_x] call _fnc_getSpeakerText);
			} forEach _outsideSpeakers;
		};

		_hintMsg = _hintMsg + "<br/>";

		// Print vehicle classname and compartment config values
		private _type = typeOf (vehicle acre_player);
		private _config = configFile >> "CfgVehicles" >> (typeOf (vehicle acre_player));
		private _compartments = ["Compartment1","Compartment2","Compartment3","Compartment4"] apply {
			if (isClass (_config >> "ACRE" >> "attenuation" >> _x)) then {
				_x
			} else {
				""
			};
		};
		_compartments = _compartments - [""];

		if (count _compartments > 0) then {
			_hintMsg = _hintMsg + format["<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>%1</t><br/>", _type];
		};

		{
			private _attConfig = _config >> "ACRE" >> "attenuation" >> _x;

			_hintMsg = _hintMsg + format ["<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>%1</t><br/>", _x];

			{
				private _attenuation = getNumber(_attConfig >> _x);
				if (_attenuation > 0) then {
					_hintMsg = _hintMsg + format ["<t align='left' font='PuristaMedium'>%1</t><t align='right' font='PuristaBold'>%2</t><br/>",  _x, _attenuation];
				};
			} forEach _compartments;
		} forEach _compartments;

		_compartmentsTurnedOut = ["Compartment1","Compartment2","Compartment3","Compartment4"] apply {
			if (isClass (_config >> "ACRE" >> "attenuationTurnedOut" >> _x)) then {
				_x
			} else {
				""
			};
		};
		_compartmentsTurnedOut = _compartmentsTurnedOut - [""];

		if (count _compartmentsTurnedOut > 0) then {
			_hintMsg = _hintMsg + format["<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>%1</t><br/>", "TURNED OUT"];
		};

		{
			private _attConfig = _config >> "ACRE" >> "attenuationTurnedOut" >> _x;

			_hintMsg = _hintMsg + format ["<t align='left' size='1.15' color='#68bbff' font='PuristaMedium'>%1</t><br/>", _x];

			{
				private _attenuation = getNumber(_attConfig >> _x);
				if (_attenuation > 0) then {
					_hintMsg = _hintMsg + format ["<t align='left' font='PuristaMedium'>%1</t><t align='right' font='PuristaBold'>%2</t><br/>", _x, _attenuation];
				};
			} forEach _compartmentsTurnedOut;
		} forEach _compartmentsTurnedOut;

		hintSilent parseText _hintMsg;

		// Draw attenuation values for all speakers
		{
			private _dir = (getDir (missionNamespace getVariable ["BIS_DEBUG_CAM", acre_player])) - (getDir _x);
			private _atten = [_x] call acre_sys_attenuate_fnc_getUnitAttenuate;
			private _color = [0, 1 - _atten, _atten, _atten + .6];
			private _text = format ["%1: %2", (name _x) select [0,10], _atten];
			drawIcon3D ["\a3\ui_f\data\gui\cfg\Hints\icon_text\group_1_ca.paa", _color, _x modelToWorldVisual [0,0,0], 1, 1, _dir, _text, 1, 0.04, "RobotoCondensed"];
		} forEach _speakers;
	};
};

private _drawEH = missionNamespace getVariable ["ACRE_SYS_ATTENUATE_DEBUG_DRAW_EH", -1];
if (_drawEH == -1) then {
	ACRE_SYS_ATTENUATE_DEBUG_DRAW_EH = addMissionEventHandler ["Draw3D", {call ACRE_SYS_ATTENUATE_DEBUG_DRAW}];
} else {
	removeMissionEventHandler ["Draw3D", ACRE_SYS_ATTENUATE_DEBUG_DRAW_EH];
	ACRE_SYS_ATTENUATE_DEBUG_DRAW_EH = -1;
};
