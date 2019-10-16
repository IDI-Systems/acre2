// Signal model
[
    QGVAR(signalModel),
    "LIST",
    localize LSTRING(signalModel_displayName),
    "ACRE2",
    [
        [SIGNAL_MODEL_CASUAL, SIGNAL_MODEL_LOS_SIMPLE, SIGNAL_MODEL_LOS_MULTIPATH, SIGNAL_MODEL_ITM],
        ["Arcade", "LOS Simple", "LOS Multipath", "Longley-Rice (ITM) Experimental"],
        2
    ],
    true,
    {
        private _signalModel = ["Arcade", "LOS Simple", "LOS Multipath", "Longley-Rice (ITM) Experimental"] select  GVAR(signalModel);
        INFO_1("Using radio propagation model: %1",_signalModel);
    } // TODO: Do not allow changing after signal map is loaded?
] call CBA_fnc_addSetting;
