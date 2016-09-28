#include "script_component.hpp"

private["_unit", "_localUnitType"];
_unit = _this select 0;
_localUnitType = _this select 1;

["ACRE_PRC152", "default", "example1"] call acre_api_fnc_copyPreset;
["ACRE_PRC117F", "default", "example1"] call acre_api_fnc_copyPreset;

["ACRE_PRC152", "example1", 1, "description", "PLTNET 1"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "example1", 2, "description", "PLTNET 2"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "example1", 3, "description", "PLTNET 3"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "example1", 4, "description", "COY"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "example1", 5, "description", "CAS"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "example1", 6, "description", "FIRES"] call acre_api_fnc_setPresetChannelField;

["ACRE_PRC117F", "example1", 1, "name", "PLTNET 1"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "example1", 2, "name", "PLTNET 2"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "example1", 3, "name", "PLTNET 3"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "example1", 4, "name", "COY"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "example1", 5, "name", "CAS"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "example1", 6, "name", "FIRES"] call acre_api_fnc_setPresetChannelField;

["ACRE_PRC152", "example1"] call acre_api_fnc_setPreset;
["ACRE_PRC117F", "example1"] call acre_api_fnc_setPreset;

if(isDedicated) exitWith { false };

_this spawn {
    _unit = _this select 0;
    _localUnitType = _this select 1;

    waitUntil { !isNull player };
    if(_unit != player) exitWith { false };

    waitUntil { ([] call acre_api_fnc_isInitialized) };

    switch _localUnitType do {
        case 'ftl_leader_1': { [ (["ACRE_PRC343"] call getRadioByType), 1] call acre_api_fnc_setRadioChannel; };
        case 'ftl_leader_2': { [ (["ACRE_PRC343"] call getRadioByType), 2] call acre_api_fnc_setRadioChannel; };
        case 'ftl_leader_3': { [ (["ACRE_PRC343"] call getRadioByType), 3] call acre_api_fnc_setRadioChannel; };
        case 'ftl_leader_4': { [ (["ACRE_PRC343"] call getRadioByType), 4] call acre_api_fnc_setRadioChannel; };
        case 'ftl_leader_5': { [ (["ACRE_PRC343"] call getRadioByType), 5] call acre_api_fnc_setRadioChannel; };
        case 'ftl_leader_6': { [ (["ACRE_PRC343"] call getRadioByType), 6] call acre_api_fnc_setRadioChannel; };

        case 'squad_leader_1': {
            [ (["ACRE_PRC343"] call getRadioByType), 1] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC152"] call getRadioByType), 1] call acre_api_fnc_setRadioChannel;
        };
        case 'squad_leader_2': {
            [ (["ACRE_PRC343"] call getRadioByType), 2] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC152"] call getRadioByType), 1] call acre_api_fnc_setRadioChannel;
        };
        case 'squad_leader_3': {
            [ (["ACRE_PRC343"] call getRadioByType), 3] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC152"] call getRadioByType), 1] call acre_api_fnc_setRadioChannel;
        };
        case 'squad_leader_4': {
            [ (["ACRE_PRC343"] call getRadioByType), 4] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC152"] call getRadioByType), 2] call acre_api_fnc_setRadioChannel;
        };
        case 'squad_leader_5': {
            [ (["ACRE_PRC343"] call getRadioByType), 5] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC152"] call getRadioByType), 2] call acre_api_fnc_setRadioChannel;
        };
        case 'squad_leader_6': {
            [ (["ACRE_PRC343"] call getRadioByType), 6] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC152"] call getRadioByType), 2] call acre_api_fnc_setRadioChannel;
        };

        case 'platoon_hq_1':  { [ (["ACRE_PRC343"] call getRadioByType), 7] call acre_api_fnc_setRadioChannel; };
        case 'platoon_hq_2':  { [ (["ACRE_PRC343"] call getRadioByType), 8] call acre_api_fnc_setRadioChannel; };
        case 'company_hq':  { [ (["ACRE_PRC343"] call getRadioByType), 9] call acre_api_fnc_setRadioChannel; };

        case 'company_rto': {
            [ (["ACRE_PRC343"] call getRadioByType), 9] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC117F"] call getRadioByType), 4] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC152"] call getRadioByType), 1] call acre_api_fnc_setRadioChannel;
        };
        case 'company_commander': {
            [ (["ACRE_PRC343"] call getRadioByType), 9] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC152"] call getRadioByType), 4] call acre_api_fnc_setRadioChannel;
        };
        case 'platoon_leader_1': {
            [ (["ACRE_PRC343"] call getRadioByType), 7] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC152"] call getRadioByType), 1] call acre_api_fnc_setRadioChannel;
        };
        case 'platoon_leader_2': {
            [ (["ACRE_PRC343"] call getRadioByType), 8] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC152"] call getRadioByType), 2] call acre_api_fnc_setRadioChannel;
        };
        case 'platoon_rto_1': {
            [ (["ACRE_PRC343"] call getRadioByType), 7] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC117F"] call getRadioByType), 4] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC152"] call getRadioByType), 1] call acre_api_fnc_setRadioChannel;
        };
        case 'platoon_rto_2': {
            [ (["ACRE_PRC343"] call getRadioByType), 8] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC117F"] call getRadioByType), 4] call acre_api_fnc_setRadioChannel;
            [ (["ACRE_PRC152"] call getRadioByType), 2] call acre_api_fnc_setRadioChannel;
        };
    };
};