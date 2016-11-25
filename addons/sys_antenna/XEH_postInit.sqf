#include "script_component.hpp"
NO_DEDICATED;

private _components = configFile >> "CfgAcreComponents";

for "_i" from 0 to (count _components)-1 do {
    private _component = _components select _i;
    if(isClass _component) then {
        private _type = getNumber(_component >> "type");
        if(_type == ACRE_COMPONENT_ANTENNA) then {
            private _binaryGainFile = getText(_component >> "binaryGainFile");
            if(_binaryGainFile != "") then {
                private _res = ["load_antenna", [(configName _component), _binaryGainFile]] call EFUNC(sys_core,callExt);
                INFO_3("Loaded Binary Atenna Data for %1 [%2]: %3",configName _component,_binaryGainFile,_res);
            };
        };
    };
};

// this function does setVariables on units to assign their current attenuation volumes
