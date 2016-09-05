//fnc_checkJVON.sqf
#include "script_component.hpp"
private["_retServer", "_retClient", "_status", "_statusClient", "_statusServer"];

_statusClient = false;
_statusServer = false;

// Check that the JVON files at least exist
_retClient = "ACRE2Arma" callExtension "9";
_retServer = "ACRE2Arma" callExtension "10";

diag_log text format["Status Responses: Client='%1', Server='%2'", _retClient, _retServer];

if(_retClient == "1") then { _statusClient = true; } else { _statusClient = false; };
if(_retServer == "1") then { _statusServer = true; } else { _statusServer = false; };


[_statusClient, _statusServer]