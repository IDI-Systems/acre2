#include "script_component.hpp"
private["_dialog"];

disableSerialization;
createDialog "ACRE_OmnibusWizardMain";

// Call the check functionality and wait for it to return
ACRE_OmnibusResultsDone = false;



[] spawn {
	diag_log text format["ctrl = %1", ((findDisplay 80085) displayCtrl 1001)];

	[] spawn {
		private["_result"];
		
		["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);
		_result = [] call FUNC(checkClient);
		waitUntil { ! isNil "acre_sys_core_pluginVersion" };

		ACRE_OmnibusResults = _result;
		ACRE_OmnibusResultsDone = true;
	};
	
	for "_i" from 0 to 100 do {
		((findDisplay 80085) displayCtrl 1000) progressSetPosition _i * 0.01;
		
		sleep 0.01;
	};
	
	waitUntil { ACRE_OmnibusResultsDone };

	diag_log text format["DONE!"];
	
	private["_acreType", "_acreStatus", "_acreReadStatus", "_acreWriteStatus", "_lastErrorString", "_keepaliveStatus", "_currentServer", "_jvonServer"];
	_acreType = "";
	_acreStatus = "";
	_acreWriteStatus = "";
	_acreReadStatus = "";
	_lastErrorString = "";
	_bootStatus = "";
	_keepaliveStatus = "";
	_currentServer = "";
	_jvonServer = "";
	
	_jvonServer = "jnet" callExtension "getServerConfig:jvon_server_address";
	
	_lastErrorString = ((ACRE_OmnibusResults select 3) select 0) + ((ACRE_OmnibusResults select 3) select 1) + ((ACRE_OmnibusResults select 3) select 2);
	
	if((uiNamespace getVariable ["JVON_connected", false])) then { 
		_acreType = "JVON";
		if((uiNamespace getVariable ["JVON_errorString", ""]) != "") then {
			_bootStatus = "ERROR";
			_lastErrorString = uiNamespace getVariable ["JVON_errorString", ""];
		} else { 
			_bootStatus = "OK"; 
			_keepaliveStatus = "OK";
			if(([] call EFUNC(sys_jvon,keepaliveStatus))) then { _keepaliveStatus = "OK"; } else { _keepaliveStatus = "ERROR"; };
		};
		_currentServer = "jnet" callExtension "getCurrentServer:";
	} else {  
	_acreType = "TS3"; 
	};
	if(acre_sys_io_serverStarted) then { 
		_acreStatus = "OK Connected"; 
		_acreReadStatus = "Read OK"; 
		_acreWriteStatus = "Write OK"; 
	} else {  
		_acreStatus = "Not Connected"; 
		_acreReadStatus = "Read ERROR"; 
		_acreWriteStatus = "Write ERROR"; 
	};
	
	((findDisplay 80085) displayCtrl 999) ctrlSetText " Click a status for details or help";
	((findDisplay 80085) displayCtrl 1001) ctrlSetText format["Addon Version:  %1", QUOTE(VERSION)];
	((findDisplay 80085) displayCtrl 1002) ctrlSetText format["Plugin Version:  %1", acre_sys_core_pluginVersion];
	((findDisplay 80085) displayCtrl 1003) ctrlSetText format["Server Version:  %1", ACRE_FULL_SERVER_VERSION];
	((findDisplay 80085) displayCtrl 1004) ctrlSetText format["ACRE2 Type:  %1", _acreType];
	((findDisplay 80085) displayCtrl 1005) ctrlSetText format["ACRE2 Status:  %1", _acreStatus];
	((findDisplay 80085) displayCtrl 1006) ctrlSetText format["Pipe Status:    %1, %2", _acreReadStatus, _acreWriteStatus];
	((findDisplay 80085) displayCtrl 1007) ctrlSetText format["Boot Status:    %1", _bootStatus];
	((findDisplay 80085) displayCtrl 1008) ctrlSetText format["Keep Status:    %1", _keepaliveStatus];
	((findDisplay 80085) displayCtrl 1009) ctrlSetText format["JNET Status:    NOT_IMPL"];
	((findDisplay 80085) displayCtrl 1010) ctrlSetText format["JVON Status:    NOT_IMPL"];
	((findDisplay 80085) displayCtrl 1011) ctrlSetText format["JNET Server: %1", _currentServer ];
	((findDisplay 80085) displayCtrl 1012) ctrlSetText format["JVON Server:  %1", _jvonServer ];
	((findDisplay 80085) displayCtrl 1013) ctrlSetText "Last Error:";
	((findDisplay 80085) displayCtrl 1014) ctrlSetText format[" '%1'", _lastErrorString];
};



