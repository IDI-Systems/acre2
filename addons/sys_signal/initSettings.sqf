// Signal model
[
    QGVAR(signalModel),
    "LIST",
    localize LSTRING(signalModel_displayName),
    "ACRE2",
    [
        [SIGNAL_ENUMS],
        [SIGNAL_NAMES],
        SIGNAL_MODEL_LOS_MULTIPATH // Default
    ],
    true,
    {
        params ["_value"];
        private _signalModel = [SIGNAL_NAMES] select _value;
        INFO_1("Using radio propagation model: %1",_signalModel);
    }
] call CBA_fnc_addSetting;

// Signal model for Backpack Radios
[
    QGVAR(signalModelLR),
    "LIST",
    localize LSTRING(signalModelLR_displayName),
    "ACRE2",
    [
        [SIGNAL_ENUMS],
        [SIGNAL_NAMES],
        SIGNAL_MODEL_LOS_MULTIPATH // Default
    ],
    true,
    {
        params ["_value"];
        private _signalModelLR = [SIGNAL_NAMES] select _value;
        INFO_1("Using Long-Range radio propagation model: %1",_signalModelLR);
    }
] call CBA_fnc_addSetting;

// Do backpack radios use signalModelLR
[
    QGVAR(radiopacksLR),
    "CHECKBOX",
    localize LSTRING(radiopacksLR_displayName),
    "ACRE2",
    true,
    true
] call CBA_fnc_addSetting;

// Do vehicle racks use signalModelLR
[
    QGVAR(racksLR),
    "CHECKBOX",
    localize LSTRING(racksLR_displayName),
    "ACRE2",
    true,
    true
] call CBA_fnc_addSetting;

// Does the ground spike antenna use signalModelLR
[
    QGVAR(groundSpikeLR),
    "LIST",
    localize LSTRING(groundSpikeLR_displayName),
    "ACRE2",
    [
        [0, 1, 2],
        ["None", "Only GSA with Mast", "Both"],
        1 // Default
    ],
    true
] call CBA_fnc_addSetting;
