//fnc_debugOverlay.sqf
#include "script_component.hpp"

if(ACRE_OVERLAY_ENABLED) then {
	_allUnits = playableUnits + ACRE_getAllCuratorObjects;
	{
		_unit = _x;
		if(_unit != acre_player) then {
			_pos = visiblePosition _unit;
			_pos set[2, 1.8];
			_screenPos = worldToScreen _pos;
			if(count _screenPos > 0) then {
				_scale = (75/((acre_player distance _unit) max 75));
				if(_scale < 0.25) then {
					_scale = 0;
				};
				
				// hintSilent format["screenPos: %1", _screenPos];
				_ctrlLabel = (ACRE_DEBUG_OVERLAYS select _forEachIndex) select 0;
				_ctrlSideBar = (ACRE_DEBUG_OVERLAYS select _forEachIndex) select 1;
				
				_micColor = "#ffffff";
				if(_unit in acre_sys_core_speakers) then {
					_micColor = "#ff0000";
				};
				
				_radioColor = "#ffffff";
				if(_unit in acre_sys_core_keyedMicRadios) then {
					_radioColor = "#ff0000";
				};
				
				_ctrlLabel ctrlSetStructuredText parseText 	(
															format["<img size='2' color='%1' image='\a3\ui_f\data\IGUI\RscIngameUI\RscDisplayVoiceChat\microphone_ca.paa' />", _micColor] + 
															format["<img size='2.5' color='%1' image='\a3\ui_f\data\gui\cfg\CommunicationMenu\call_ca.paa' /> %2<br />", _radioColor, name _unit] + 
															format["TS3ID: %1 NETID: %2<br />", _unit getVariable ["acre_sys_core_ts3id", -1], netId _unit]  +
															format["LOV: %1<br />", _unit getVariable ["ACRE_OCCLUSION_VAL", "N/A"]] +
															format["TXID: %1<br />", _unit getVariable ["acre_sys_core_currentSpeakingRadio", ""]]
															);
														

			
				_ctrlLabel ctrlSetPosition [(_screenPos select 0), (_screenPos select 1)-0.4*_scale, 0.5, 0.4];
				_ctrlSideBar ctrlSetPosition [(_screenPos select 0), (_screenPos select 1)-0.4*_scale, 0.0025, 0.4];
				_ctrlSideBar ctrlSetBackgroundColor [1, 1, 1, 1];
				_ctrlLabel ctrlSetBackgroundColor [0, 0, 0, 0.25];
				_ctrlLabel ctrlSetScale _scale;
				_ctrlSideBar ctrlSetScale _scale;
				_ctrlLabel ctrlCommit 0;
				_ctrlSideBar ctrlCommit 0;
			};
		};
	} forEach _allUnits;
} else {
	[(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
};