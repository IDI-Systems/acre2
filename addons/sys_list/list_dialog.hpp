class RscText;
class RscControlsGroupNoScrollbars;

class GVAR(radioCycleDisplayFlash): RscControlsGroupNoScrollbars {
    x = "profileNamespace getVariable ['IGUI_grid_ACRE_notification_X', SafeZoneX + SafeZoneW - .352]";
    y = "profileNamespace getVariable ['IGUI_grid_ACRE_notification_Y', SafeZoneY + SafeZoneH - .128]";
    w = 0.352;
    h = 0.128;

    class controls {
        class CycleDialogBackgroundColor: RscText {
            idc = IDC_CONTROLFLASH;
            style = ST_CENTER;
            colorText[] = {0, 0, 0, 1};
            colorBackground[] = {RGB_YELLOW};
            font = "RobotoCondensed";
            sizeEx = 0.023;
            x = 0;
            y = 0;
            w = 0.352;
            h = 0.128;
        };
    };
};

class GVAR(radioCycleDisplay): RscControlsGroupNoScrollbars {
    x = "profileNamespace getVariable ['IGUI_grid_ACRE_notification_X', SafeZoneX + SafeZoneW - .352]";
    y = "profileNamespace getVariable ['IGUI_grid_ACRE_notification_Y', SafeZoneY + SafeZoneH - .128]";
    w = 0.352;
    h = 0.128;

    class controls {
        class CycleDialogBackgroundColor: RscText {
            idc = IDC_CONTROLBACKGROUNDCOLOR;
            style = ST_CENTER;
            colorText[] = {0, 0, 0, 1};
            colorBackground[] = {1, 0.8, 0, 0.2};
            font = "RobotoCondensed";
            sizeEx = 0.023;
            x = 0;
            y = 0;
            w = 0.352;
            h = 0.128;
        };
        class CycleDialogBackgroundBlack: CycleDialogBackgroundColor {
            idc = IDC_CONTROLBACKGROUNDBLACK;
            colorText[] = {0, 0, 0, 0.25};
            colorBackground[] = {0, 0, 0, 0.8};
            x = 0.002;
            y = 0.003;
            w = 0.350;
            h = 0.125;
        };

        class CycleDialogTitle: RscText {
            idc = IDC_CONTROLTITLE;
            style = ST_LEFT;
            colorText[] = {1, 0.8, 0, 0.8};
            colorBackground[] = {1, 1, 1, 0};
            font = "RobotoCondensed";
            sizeEx = 0.06;
            x = "0.002 + 0.004";
            y = "0.003 - 0.004";
            w = 0.350;
            h = 0.063;
        };
        class CycleDialogLine1: CycleDialogTitle {
            idc = IDC_CONTROLLINE1;
            sizeEx = 0.03;
            x = "0.002 + 0.004";
            y = "0.003 + 0.054";
            w = 0.350;
            h = 0.023;
        };
        class CycleDialogLine2: CycleDialogLine1 {
            idc = IDC_CONTROLLINE2;
            x = "0.002 + 0.004";
            y = "0.003 + 0.084";
            w = 0.350;
            h = 0.023;
        };
    };
};
