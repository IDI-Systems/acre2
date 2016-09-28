/*class GVAR(buttonBase) {
    idc = -1;
    type = CT_BUTTON;
    style = ST_LEFT;
    default = false;
    font = FontM;
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
        idd = 19099;
        movingEnable = 0;
        name = QUOTE(GVAR(radioCycleDisplayBG));
        duration = 0.15;
        fadein = 0;
        class controlsBackground {
            class GVAR(CycleDialogBackgroundYellow) {
                idc = -1;
                type = CT_STATIC;  // defined constant
                style = ST_CENTER;  // defined constant
                colorText[] = { 0, 0, 0, 1 };
                colorBackground[] = { RGB_YELLOW };
                font = FontM;  // defined constant
                sizeEx = 0.023;
                x = SafeZoneX+SafeZoneW-.352;
                y = SafeZoneY+SafeZoneH-.128;
                w = .352;
                h = .128;
                text = "";
            };
        };
        class objects { };

        class controls { };

        //onLoad = QUOTE(GVAR(hintIDD) = (_this select 0));
    };
    class GVAR(radioCycleDisplay) {
        idd = 19099;
        movingEnable = 0;
        name = QUOTE(GVAR(radioCycleDisplay));
        duration = 2;
        fadein = 0;

        //onLoad = QUOTE(GVAR(hintIDD) = (_this select 0));
        onLoad = QUOTE([(_this select 0)] call FUNC(_showHintBox));
        class controlsBackground {
            class GVAR(CycleDialogBackgroundYellow) {
                idc = -1;
                type = CT_STATIC;  // defined constant
                style = ST_CENTER;  // defined constant
                colorText[] = { 0, 0, 0, 1 };
                colorBackground[] = { 1, 1, 0, 0.2 };
                font = FontM;  // defined constant
                sizeEx = 0.023;
                x = SafeZoneX+SafeZoneW-.352;
                y = SafeZoneY+SafeZoneH-.128;
                w = .352;
                h = .128;
                text = "";
            };
            class GVAR(CycleDialogBackgroundBlack) {
                idc = -1;
                type = CT_STATIC;  // defined constant
                style = ST_CENTER;  // defined constant
                colorText[] = { 0, 0, 0, 0.25 };
                colorBackground[] = { RGB_BLACK };
                font = FontM;  // defined constant
                sizeEx = 0.023;
                x = SafeZoneX+SafeZoneW-.350;
                y = SafeZoneY+SafeZoneH-.125;
                w = .350;
                h = .125;
                text = "";
            };
        };

        class objects { };

        class controls {
            class GVAR(CycleDialogTitle) {
                idc = 19100;
                type = CT_STATIC;  // defined constant
                style = ST_LEFT;  // defined constant
                colorText[] = { RGB_YELLOW };
                colorBackground[] = { 1,1,1,0 };
                font = FontM;  // defined constant
                sizeEx = 0.06;
                x = SafeZoneX+SafeZoneW-.350+0.004;
                y = SafeZoneY+SafeZoneH-.125-0.004;
                w = .350;
                h = .063;
                text = "";
            };
            class GVAR(CycleDialogLine1) {
                idc = 19101;
                type = CT_STATIC;  // defined constant
                style = ST_LEFT;  // defined constant
                colorText[] = { RGB_YELLOW };
                colorBackground[] = { 1,1,1,0 };
                font = FontM;  // defined constant
                sizeEx = 0.03;
                x = SafeZoneX+SafeZoneW-.350+0.004;
                y = SafeZoneY+SafeZoneH-.125+0.054;
                w = .350;
                h = .023;
                text = "";
            };
            class GVAR(CycleDialogLine2) {
                idc = 19102;
                type = CT_STATIC;  // defined constant
                style = ST_LEFT;  // defined constant
                colorText[] = { RGB_YELLOW };
                colorBackground[] = { 1,1,1,0 };
                font = FontM;  // defined constant
                sizeEx = 0.03;
                x = SafeZoneX+SafeZoneW-.350+0.004;
                y = SafeZoneY+SafeZoneH-.125+0.084;
                w = .350;
                h = .023;
                text = "";
            };
        };
    };
};
