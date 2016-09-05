private["_ret", "_res"];

_res = "ACRE2Arma" callExtension format["13"];

if(_res == "1") then { _ret = true; } else { _ret = false };
_ret