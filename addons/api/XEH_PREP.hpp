// Helpers
PREP(mapChannelFieldName);

// Obsolete
OBSOLETE_SYS(FUNC(setItemRadioReplacement),{params ['_radioType']; [QEGVAR(sys_radio,defaultItemRadioType), _radioType, 1, "mission"] call CBA_settings_fnc_set;});
