/*
 * Sample of setting up RTO's for a company signals setup.
 *
 * Called by: [this, "platoon_rto"] call compile preprocessFileLineNumbers "mission_setupCompanySignals.sqf";
 *
 * This setup assumes that each RTO has a single PRC-152 and a single PRC-117F.
 * Each platoon command and the company commander has not been configured in this config,
 * but canFire easily be added to the switch statement below.
 *
 * The order of operations is documented in the script below.
 */

params ["_unit", "_localUnitType"];

/*
 * First we copy the presets. This is not required, but for this example a seperate
 * preset called example1 is being used just for this example.
 *
 * !! Keep in mind, each radio has its own set of presets. So when we operate on a radios preset,
 * they can have the same names but they are different presets due to the fact its a different radio.
 */

["ACRE_PRC148", "default", "example1"] call acre_api_fnc_copyPreset;
["ACRE_PRC152", "default", "example1"] call acre_api_fnc_copyPreset;
["ACRE_PRC117F", "default", "example1"] call acre_api_fnc_copyPreset;

/*
 * Below, we simply name all the channels for each radio, to matching names. This will make the radios
 * in game (and in the popup hint) show the NAME of the channel they are speaking on.
 * Next, we rename the first 6 channels on each radios preset. The field names are different for each
 * radio type because they are dependent of the radio's programming and configuration. This was done
 * in ACRE2 because the actual field names match the technical specifications of how these radios
 * internally handle their data.
 *
 * Although the names are different, they serve the same purpose. "name", "description" and "label" are
 * the 3 different ways the 148, 152 and 117 reference their internal channel naming schemes.
 */

["ACRE_PRC152", "default", 1, "description", "PLTNET 1"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "default", 2, "description", "PLTNET 2"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "default", 3, "description", "PLTNET 3"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "default", 4, "description", "COY"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "default", 5, "description", "CAS"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "default", 6, "description", "FIRES"] call acre_api_fnc_setPresetChannelField;

["ACRE_PRC148", "default", 1, "label", "PLTNET 1"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC148", "default", 2, "label", "PLTNET 2"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC148", "default", 3, "label", "PLTNET 3"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC148", "default", 4, "label", "COY"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC148", "default", 5, "label", "CAS"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC148", "default", 6, "label", "FIRES"] call acre_api_fnc_setPresetChannelField;

["ACRE_PRC117F", "default", 1, "name", "PLTNET 1"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "default", 2, "name", "PLTNET 2"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "default", 3, "name", "PLTNET 3"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "default", 4, "name", "COY"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "default", 5, "name", "CAS"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "default", 6, "name", "FIRES"] call acre_api_fnc_setPresetChannelField;

if (!hasInterface || {player != _unit}) exitWith {false};

[{
    call acre_api_fnc_isInitialized
}, {
    params ["", "_localUnitType"];

    switch (_localUnitType) do {
        case "platoon_rto": {
            [["ACRE_PRC117F"] call acre_api_fnc_getRadioByType, 4] call acre_api_fnc_setRadioChannel;
            [["ACRE_PRC152"] call acre_api_fnc_getRadioByType, 1] call acre_api_fnc_setRadioChannel;
        };
        case "company_rto": {
            [["ACRE_PRC117F"] call acre_api_fnc_getRadioByType, 4] call acre_api_fnc_setRadioChannel;
            [["ACRE_PRC152"] call acre_api_fnc_getRadioByType, 1] call acre_api_fnc_setRadioChannel;
        };
        case "forward_observer": {
            [["ACRE_PRC117F"] call acre_api_fnc_getRadioByType, 6] call acre_api_fnc_setRadioChannel;
            [["ACRE_PRC152"] call acre_api_fnc_getRadioByType, 4] call acre_api_fnc_setRadioChannel;
        };
        case "JTAC": {
            [["ACRE_PRC117F"] call acre_api_fnc_getRadioByType, 5] call acre_api_fnc_setRadioChannel;
            [["ACRE_PRC152"] call acre_api_fnc_getRadioByType, 4] call acre_api_fnc_setRadioChannel;
        };
    };
}, _this] call CBA_fnc_waitUntilAndExecute;
