#include "script_component.hpp"
NO_DEDICATED;

_components = configFile >> "CfgAcreComponents";

for "_i" from 0 to (count _components)-1 do {
    _component = _components select _i;
    if(isClass _component) then {
        _type = getNumber(_component >> "type");
        if(_type == ACRE_COMPONENT_ANTENNA) then {
            _binaryGainFile = getText(_component >> "binaryGainFile");
            if(_binaryGainFile != "") then {
                _res = ["load_antenna", [(configName _component), _binaryGainFile]] call EFUNC(sys_core,callExt);
                diag_log text format["ACRE: Loaded Binary Antenna Data for %1 [%2]: %3", (configName _component), _binaryGainFile, _res];
            };
        };
    };
};

// this function does setVariables on units to assign their current attenuation volumes
