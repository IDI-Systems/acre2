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
