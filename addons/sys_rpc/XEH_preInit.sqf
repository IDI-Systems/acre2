#include "script_component.hpp"

ADDON = false;

PREP(addProcedure);
PREP(callRemoteProcedure);
PREP(handleData);
PREP(sendResponse);
PREP(createID);

GVAR(procedures) = HASH_CREATE;
GVAR(pendingResponses) = HASH_CREATE;

DFUNC(formatNumber) = {
    private _ext = abs _this - (floor abs _this);
    private _str = "";
    for "_i" from 1 to 24 do {
        private _d = floor (_ext*10);
        _str = _str + (str _d);
        _ext = (_ext*10)-_d;
    };
    format["%1%2.%3", ["","-"] select (_this < 0), (floor (abs _this)), _str];
};

ADDON = true;
