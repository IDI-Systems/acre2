// Signal model
[
    QGVAR(signalModel),
    "LIST",
    localize LSTRING(signalModel_displayName),
    "ACRE2",
    [
        [SIGNAL_MODEL_ARCADE, SIGNAL_MODEL_LOS_SIMPLE, SIGNAL_MODEL_LOS_MULTIPATH, SIGNAL_MODEL_ITM],
        ["Arcade", "LOS", "LOS Multipath", "Longley-Rice (ITM)"],
        3
    ],
    false,
    {} // TODO: Do not allow changing after signal map is loaded.
] call CBA_Settings_fnc_init;
