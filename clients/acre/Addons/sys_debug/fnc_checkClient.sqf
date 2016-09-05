//fnc_testClient.sqf
#include "script_component.hpp"
private["_pipe", "_jnet", "_jvon", "_outputJVON", "_outputACRE", "_outputJNET"];

diag_log text format["ACRE Setup Test"];
diag_log text format["666"];

// We need to make sure the extensions are all loaded. Then, make sure some file paths exists
// 0ts or 0jvon

_jvon = [] call FUNC(checkJVON);
_pipes = [] call FUNC(checkPipes);
_jnet = [] call FUNC(checkJNET);

diag_log text format["JVON status: {client=%1, server=%2}",  (_jvon select 0), (_jvon select 1)];
diag_log text format["JNET status: {%1}", _jnet];
diag_log text format["TS3 Pipe Status: {%1}", (_pipes select 0)];
diag_log text format["JVON Pipe Status: {%1}", (_pipes select 1)];

_outputJVON = "";
_outputACRE = "";
_outputJNET = "";

if(!(_jvon select 0)) then {
    _outputJVON = "File Not Found";
} else {
    _outputJVON = "JVON OK ";
};

if(!_jnet) then {
    _outputJNET = "Extension Not Found";
} else {
    _outputJNET = "JNET OK ";
};

if(!(_pipes select 0) && !(_pipes select 1)) then {
    _outputACRE = "No ACRE Client Found";
} else {
    if((_pipes select 0) && (_pipes select 1)) then {
        _outputACRE = "JVON OK  TS3 OK ";
    } else {
        if((_pipes select 0)) then {
            _outputACRE = _outputACRE + " TS3 OK ";
        };
        if((_pipes select 1)) then {
            _outputACRE = _outputACRE + " JVON OK ";
        };
    };
};

//[    "ACRE Status",
//    format["ACRE: %1", _outputACRE],
//    format["JVON: %1 JNET: %2", _outputJVON, _outputJNET],
//    1] 
//call EFUNC(sys_list,displayHint);

[_pipes, _jnet, _jvon, [_outputACRE, _outputJVON, _outputJNET]]