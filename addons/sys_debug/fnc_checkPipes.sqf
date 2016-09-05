//fnc_checkPipes.sqf
#include "script_component.hpp"
private["_tsPipeStatus", "_jvonPipeStatus"];

DFUNC(checkPipe) = {
    private["_extCmd", "_ret", "_status"];
    _extCmd = _this select 0;
    _status = false;
    
    if(!acre_sys_io_serverStarted) then {
        _ret = "ACRE2Arma" callExtension _extCmd;
        diag_log text format["Pipe Response: '%1'", _ret];
        if(_ret == "1") then {
            _status = true;
            GVAR(pipeClosed) = false;
            _res = "ACRE2Arma" callExtension "1";
            GVAR(pipeClosed) = true;
        } else {
            GVAR(pipeClosed) = true;
        };
    } else {
        GVAR(pipeClosed) = true;
        _status = true;
    };
    
    _status
};

GVAR(pipeClosed) = false;
_tsPipeStatus = ["0ts"] call FUNC(checkPipe);
waitUntil { GVAR(pipeClosed) };
_jvonPipeStatus = ["0jvon"] call FUNC(checkPipe);
waitUntil { GVAR(pipeClosed) };

[_tsPipeStatus, _jvonPipeStatus]

