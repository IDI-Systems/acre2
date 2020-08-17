private _allRadios = [] call EFUNC(api,getAllRadios);
private _radioClasses = [""] + _allRadios # 0;
private _radioNames = ["None"] + _allRadios # 1;

[
    QGVAR(defaultItemRadioType),
    "LIST",
    [
        LLSTRING(DefaultItemRadioType_DisplayName),
        LLSTRING(DefaultItemRadioType_Description)
    ],
    "ACRE2",
    [
        _radioClasses,
        _radioNames,
        (_radioClasses find "ACRE_PRC343") max 0
    ],
    true
] call CBA_fnc_addSetting;
