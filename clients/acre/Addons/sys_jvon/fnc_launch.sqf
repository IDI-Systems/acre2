private["_jsonFormat", "_json", "_ret", "_res"];

#define BOOL2INT(bool) ((bool) call { _ret = 0; if(_this) then { _ret = 1; }; _ret })

if((count _this) >= 4) then {
    params["_jvonServer", "_password", "_name", "_pttKey"];

    // Close any current JVON on a valid launch command
    [] call (compile preprocessFileLineNumbers 'idi\clients\acre\addons\sys_jvon\fnc_keepaliveClose.sqf');
    
    _jsonFormat = "{'server':'%1','password':'%2','name':'%3','ptt':%4,'modifiers':{'shift':%5,'ctrl':%6,'alt':%7}}";
            diag_log text format["_pttKey=%1", _pttKey];
            
            _json = format[_jsonFormat,
                                _jvonServer,
                                _password,
                                _name,
                                _pttKey select 0,
                                BOOL2INT(_pttKey select 1),
                                BOOL2INT(_pttKey select 2),
                                BOOL2INT(_pttKey select 3)
                        ];
            diag_log format["Launching: '%1'", _json];
            _ret = "ACRE2Arma" callExtension format["5%1", _json];
} else {
    _ret = "ACRE2Arma" callExtension format["5"];
};

if(_ret == "1") then {     
    uiNamespace setVariable ["JVON_errorString", ""];
    uiNamespace setVariable ["JVON_connected", true];    // TODO: THIS IS A PLACEHOLDER UNTIL WE ACTUALLY TRACK CONNECTION
    uiNamespace setVariable ["JVON_launched", true];
    _res = true; 
} else {         
    uiNamespace setVariable ["JVON_errorString", _ret];
    uiNamespace setVariable ["JVON_connected", false];
    uiNamespace setVariable ["JVON_launched", false];
    _res = false; 
};


_res
