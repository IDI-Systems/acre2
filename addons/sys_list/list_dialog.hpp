/*class GVAR(buttonBase) {
    idc = -1;
    type = CT_BUTTON;
    style = ST_LEFT;
    default = false;
    font = "RobotoCondensed";
    sizeEx = 0.025;
    colorText[] = { 0, 0, 0, 1 };
    colorFocused[] = { 1, 0, 0, 1 };   // border color for focused state
    colorDisabled[] = { 0, 0, 1, 0.7 };   // text color for disabled state
    colorBackground[] = { 1, 1, 1, 0.8 };
    colorBackgroundDisabled[] = { 1, 1, 1, 0.5 };   // background color for disabled state
    colorBackgroundActive[] = { 1, 1, 1, 1 };   // background color for active state
    offsetX = 0.003;
    offsetY = 0.003;
    offsetPressedX = 0.002;
    offsetPressedY = 0.002;
    colorShadow[] = { 0, 0, 0, 0.5 };
    colorBorder[] = { 0, 0, 0, 1 };
    borderSize = 0;
    soundEnter[] = { "", 0, 1 };  // no sound
    soundPush[] = { "", 0.1, 1 };
    soundClick[] = { "", 0, 1 };  // no sound
    soundEscape[] = { "", 0, 1 };  // no sound
};*/


class RscTitles {
    class GVAR(radioCycleDisplayBG) {
        idd = IDD_DISPLAYBACKGROUND;
        movingEnable = 0;
        name = QGVAR(radioCycleDisplayBG);
        duration = 0.15;
        fadein = 0;

        onLoad = "[(_this select 0), 0, acre_sys_list_hintBufferPointer] call acre_sys_list_fnc_showHintBox";
        class controlsBackground {
            class GVAR(CycleDialogBackgroundColor) {
                idc = IDC_CONTROLBACKGROUNDCOLOR;
                type = CT_STATIC;  // defined constant
                style = ST_CENTER;  // defined constant
                colorText[] = { 0, 0, 0, 1 };
                colorBackground[] = { RGB_YELLOW };
                font = "RobotoCondensed";  // defined constant
                sizeEx = 0.023;
                x = "profileNamespace getVariable ['IGUI_grid_ACRE_notification_X', SafeZoneX + SafeZoneW - .352]";
                y = "profileNamespace getVariable ['IGUI_grid_ACRE_notification_Y', SafeZoneY + SafeZoneH - .128]";
                w = .352;
                h = .128;
                text = "";
            };
        };
        class objects { };

        class controls { };

        //onLoad = QGVAR(hintIDD) = (_this select 0);
    };
    class GVAR(radioCycleDisplay) {
        idd = IDD_DISPLAY;
        movingEnable = 0;
        name = QGVAR(radioCycleDisplay);
        duration = 60;
        fadein = 0;

        //onLoad = QGVAR(hintIDD) = (_this select 0);
        onLoad = "[(_this select 0), 1, acre_sys_list_hintBufferPointer] call acre_sys_list_fnc_showHintBox";
        class controlsBackground {
            class GVAR(CycleDialogBackgroundColor) {
                idc = IDC_CONTROLBACKGROUNDCOLOR;
                type = CT_STATIC;  // defined constant
                style = ST_CENTER;  // defined constant
                colorText[] = { 0, 0, 0, 1 };
                colorBackground[] = { 1, 0.8, 0, 0.2 };
                font = "RobotoCondensed";  // defined constant
                sizeEx = 0.023;
                x = "profileNamespace getVariable ['IGUI_grid_ACRE_notification_X', SafeZoneX + SafeZoneW - .352]";
                y = "profileNamespace getVariable ['IGUI_grid_ACRE_notification_Y', SafeZoneY + SafeZoneH - .128]";
                w = .352;
                h = .128;
                text = "";
            };
            class GVAR(CycleDialogBackgroundBlack) {
                idc = IDC_CONTROLBACKGROUNDBLACK;
                type = CT_STATIC;  // defined constant
                style = ST_CENTER;  // defined constant
                colorText[] = { 0, 0, 0, 0.25 };
                colorBackground[] = { 0, 0, 0, 0.8 };
                font = "RobotoCondensed";  // defined constant
                sizeEx = 0.023;
                x = "(profileNamespace getVariable ['IGUI_grid_ACRE_notification_X', SafeZoneX + SafeZoneW - .352]) + .002";
                y = "(profileNamespace getVariable ['IGUI_grid_ACRE_notification_Y', SafeZoneY + SafeZoneH - .128]) + .003";
                w = .350;
                h = .125;
                text = "";
            };
        };

        class objects { };

        class controls {
            class GVAR(CycleDialogTitle) {
                idc = IDC_CONTROLTITLE;
                type = CT_STATIC;  // defined constant
                style = ST_LEFT;  // defined constant
                colorText[] = { 1, 0.8, 0, 0.8 };
                colorBackground[] = { 1,1,1,0 };
                font = "RobotoCondensed";  // defined constant
                sizeEx = 0.06;
                x = "(profileNamespace getVariable ['IGUI_grid_ACRE_notification_X', SafeZoneX + SafeZoneW - .352]) + .002 + 0.004";
                y = "(profileNamespace getVariable ['IGUI_grid_ACRE_notification_Y', SafeZoneY + SafeZoneH - .128]) + .003 - 0.004";
                w = .350;
                h = .063;
                text = "";
            };
            class GVAR(CycleDialogLine1) {
                idc = IDC_CONTROLLINE1;
                type = CT_STATIC;  // defined constant
                style = ST_LEFT;  // defined constant
                colorText[] = { 1, 0.8, 0, 0.8 };
                colorBackground[] = { 1,1,1,0 };
                font = "RobotoCondensed";  // defined constant
                sizeEx = 0.03;
                x = "(profileNamespace getVariable ['IGUI_grid_ACRE_notification_X', SafeZoneX + SafeZoneW - .352]) + .002 + 0.004";
                y = "(profileNamespace getVariable ['IGUI_grid_ACRE_notification_Y', SafeZoneY + SafeZoneH - .128]) + .003 + 0.054";
                w = .350;
                h = .023;
                text = "";
            };
            class GVAR(CycleDialogLine2) {
                idc = IDC_CONTROLLINE2;
                type = CT_STATIC;  // defined constant
                style = ST_LEFT;  // defined constant
                colorText[] = { 1, 0.8, 0, 0.8 };
                colorBackground[] = { 1,1,1,0 };
                font = "RobotoCondensed";  // defined constant
                sizeEx = 0.03;
                x = "(profileNamespace getVariable ['IGUI_grid_ACRE_notification_X', SafeZoneX + SafeZoneW - .352]) + .002 + 0.004";
                y = "(profileNamespace getVariable ['IGUI_grid_ACRE_notification_Y', SafeZoneY + SafeZoneH - .128]) + .003 + 0.084";
                w = .350;
                h = .023;
                text = "";
            };
        };
    };
};
