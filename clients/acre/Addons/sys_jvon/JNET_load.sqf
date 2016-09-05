//JNET_load.sqf
private["_jvonServer", "_server", "_name", "_password", "_pttKey", "_cbaKeybinds", "_addon", "_addonName", "_json", "_jsonFormat", "_tryingId", "_result"];

_uiChecker = uiNamespace getVariable ["acre_jvon_uiCheckerEH", -1];
if(_uiChecker != -1) then {
	removeMissionEventHandler ["Draw3D", _uiChecker];
};
_uiChecker = addMissionEventHandler ["Draw3D", {
	_serverListDisplayed = !isNull(findDisplay 8);
	_mainMenuDisplayed = !isNull(findDisplay 0);
	_slotScreenDisplayed = !isNull(findDisplay 70);
	_missionSelectDisplayed = !isNull(findDisplay 17);
	if(isNull(findDisplay 46)) then {
		if((_mainMenuDisplayed || _serverListDisplayed) && !_missionSelectDisplayed && !_slotScreenDisplayed) then {
			diag_log text "Disconnecting JVON";
			[] call (compile preprocessFileLineNumbers 'idi\clients\acre\addons\sys_jvon\fnc_keepaliveClose.sqf');
			_uiChecker = uiNamespace getVariable ["acre_jvon_uiCheckerEH", -1];
			if(_uiChecker != -1) then {
				removeMissionEventHandler ["Draw3D", _uiChecker];
			};
		};
	} else {
		//diag_log text "Removing JVON UI checker";
		_uiChecker = uiNamespace getVariable ["acre_jvon_uiCheckerEH", -1];
		if(_uiChecker != -1) then {
			removeMissionEventHandler ["Draw3D", _uiChecker];
		};
	};
}];
uiNamespace setVariable ["acre_jvon_uiCheckerEH", _uiChecker];

// Only attempt finding JVON servers for JNET multiplayer sessions
// Does this work in slotting screen? I think so.
diag_log text format["ENTER: isMultiplayer=%1, JNET_connected=%2, JVON_launched=%3, JVON_connected=%4", 
	isMultiplayer,
	(uiNamespace getVariable ["JNET_connected", false]),
	(uiNamespace getVariable ["JVON_launched", false]),
	(uiNamespace getVariable ["JVON_connected", false])
	];

// Flag connected as false if we are not on a server
_server = "jnet" callExtension "getCurrentServer:";
if(_server == "") then {
	[] call (compile preprocessFileLineNumbers 'idi\clients\acre\addons\sys_jvon\fnc_keepaliveClose.sqf');
	uiNamespace setVariable ["JNET_connected", false]; 
};

if(!(uiNamespace getVariable ["JVON_launched", false])) then {
	//diag_log text format["Initializing Jv"];
	
	_tryingId = uiNamespace getVariable ["JVON_tryingId", scriptNull];
	uiNamespace setVariable ["JVON_attemptNumber", 0]; 
	if(scriptDone _tryingId) then {
		_tryingId = [] spawn {
			_server = "NOCONN";
			while {_server == "NOCONN" || _server == ""} do {
				_attemptNumber = uiNamespace getVariable ["JVON_attemptNumber", 0];
				_attemptNumber = _attemptNumber + 1;
				_server = "jnet" callExtension "getCurrentServer:";
				//diag_log text format["JNET RESPONSE: '%1'", _server];
				uiNamespace setVariable ["JNET_connected", false]; 
				if(_server == "NOCONN" || _server == "") then {
					uiSleep 0.25;
				};
				
				// Reset JNET after 20 failed attempts, to re-rank servers and try again
				if(_attemptNumber % 20 == 0) then {
					_server = "jnet" callExtension "reset";
				};
				if(_attemptNumber > 100) exitWith {
					// Fail on the jvon server
					diag_log text format["Ending JVON discovery phase, falling back."];
				};
				uiNamespace setVariable ["JVON_attemptNumber", _attemptNumber]; 
			};
		
			uiNamespace setVariable ["JNET_connected", true];
			_jvonEnabled = "jnet" callExtension "getServerConfig:jvon_enabled";
			diag_log text format["JVON Enabled: '%1'", _jvonEnabled];
			if(_jvonEnabled == "true" || _jvonEnabled == "1") then {
				_jvonServer = "jnet" callExtension "getServerConfig:jvon_server_address";
				_password = "jnet" callExtension "getServerConfig:jvon_password";
				_name = profileName;
				
				diag_log text format["Found JVON Server! %1 - %2", _jvonServer, _password];
				
				_cbaKeybinds = profileNamespace getVariable ["cba_keybinding_registryNew", []];
                _pttKey = [0x0F, false, false, false];
                if((count _cbaKeybinds) > 0) then {
                    {
                        if(_x == "JVON") exitWith {
                            _modIndex = _forEachIndex;
                            {
                                if(_x == "DefaultPTTKey") exitWith {
                                    _pttKey = ((((_cbaKeybinds select 1) select _modIndex) select 1) select _forEachIndex) select 1;
                                    if((_pttKey select 1) isEqualType []) then {
                                        private["_convertPttKey"];
                                        _convertPttKey = [_pttKey select 0, 
                                                    ((_pttKey select 1) select 0), 
                                                    ((_pttKey select 1) select 1),
                                                    ((_pttKey select 1) select 2)];
                                        _pttKey = _convertPttKey;
                                    };
                                };
                            } forEach (((_cbaKeybinds select 1) select _modIndex) select 0);
                        };
                    } forEach (_cbaKeybinds select 0);
                };
				_result = [_jvonServer, _password, _name, _pttKey] call (compile preprocessFileLineNumbers 'idi\clients\acre\addons\sys_jvon\fnc_launch.sqf');
				if(!_result) then {
					diag_log text format["!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"];
					diag_log text format["!!         JVON BOOTSTRAP FAILED                    !!"];
					diag_log text format["!!             LAUNCH FAILED                        !!"];
					diag_log text format["!! JVON_errorString = '%1'", (uiNamespace getVariable ["JVON_errorString", ""]) ];
					diag_log text format["!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"];

				} else {
					[] call (compile preprocessFileLineNumbers 'idi\clients\acre\addons\sys_jvon\fnc_keepaliveOpen.sqf');
				}
			};
		};
		uiNamespace setVariable ["JVON_tryingId", _tryingId];
	};
};