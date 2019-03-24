// Signal model
[
    QGVAR(signalModel),
    "LIST",
    localize LSTRING(signalModel_displayName),
    "ACRE2",
    [
        [SIGNAL_MODEL_ARCADE, SIGNAL_MODEL_LOS_MULTIPATH],
        ["Arcade", "LOS Multipath"],
        1
    ],
    true,
    {} // TODO: Do not allow changing after signal map is loaded.
] call CBA_Settings_fnc_init;
