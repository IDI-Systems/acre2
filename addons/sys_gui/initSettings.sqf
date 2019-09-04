[
    QGVAR(volumeColorScale),
    "LIST",
    [LSTRING(VolumeColorScale_DisplayName), LSTRING(VolumeColorScale_Description)],
    ELSTRING(sys_core,CategoryUI),
    [
        [
            VOLUME_COLOR_SCALE_YELLOW_ORANGE_RED,
            VOLUME_COLOR_SCALE_GREEN_ORANGE_RED,
            VOLUME_COLOR_SCALE_BLUE_MAGENTA_RED
        ],
        [
            LSTRING(YellowOrangeRed),
            LSTRING(GreenOrangeRed),
            LSTRING(BlueMagentaRed)
        ],
        0
    ],
    false
] call CBA_fnc_addSetting;
