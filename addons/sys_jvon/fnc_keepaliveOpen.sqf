private["_ret"];

diag_log text format["Sending keepalive pipe request"];
_ret = "ACRE2Arma" callExtension format["11"];

diag_log text format["keepaliveOpen returned: '%1'", _ret];

_ret