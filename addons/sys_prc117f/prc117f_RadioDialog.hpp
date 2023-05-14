class Prc117f_RadioDialog {
    idd = 31337;
    MovingEnable = 0;
    onUnload = QUOTE(['closeGui'] call GUI_INTERACT_EVENT);
    onLoad = QUOTE(_this call FUNC(render));
    controlsBackground[] = {"Prc117fBackground"};
    objects[] = {};

    class Prc117fBackground: Prc117f_RscBackground {
        type = CT_STATIC;
        idc = -1;
        style = QUOTE(ST_PICTURE + ST_KEEP_ASPECT_RATIO);
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {1, 1, 1, 1};
        font = "PixelSplitterBold";
        sizeEx = 0.03;
        x = "SafeZoneX";
        y = QUOTE((0.5-((1*safezoneW)/2)));
        w = QUOTE(1*SafeZoneW);
        h = QUOTE(1*SafeZoneW);
        text = QPATHTOF(Data\prc117f_ui.paa);
    };
    class controls {

        BEGIN_CONTROL(DisplayBackground, Prc117f_RscBackground, 99990)
            style = 0x800;
            x = QUOTE(((0.33 * safeZoneW) + safeZoneX));
            y = QUOTE(((0.392 * safeZoneW) + safeZoneX));
            w = QUOTE(((0.00438 * 32) + 0.0043)*SafeZoneW);
            h = QUOTE(((0.011 * 4) + 0.011)*SafeZoneW);
            colorBackground[] = {0.9, 0.96, 0.2, 0};
            text = "";
        END_CONTROL


        class BatteryBar {
            idc = 99991;
            x = QUOTE((( (0.33+(0.00438*6)) * safeZoneW) + safeZoneX));
            y = QUOTE((((0.392 + 0.00175) * safeZoneW) + safeZoneX));
            h = QUOTE(0.007*SafeZoneW);
            w = QUOTE((0.00438*3)*SafeZoneW);
            type = 8;
            style = 0;
            colorFrame[] = {0.2, 0.2, 0.2, 1};
            colorBar[] = {0.2, 0.2, 0.2, 1};
            texture = "#(argb,8,8,3)color(1,1,1,1)";
            tooltip = "ST_HORIZONTAL";
        };

        class VolumeBar {
            idc = 99994;
            x = QUOTE((( (0.33+(0.00438*6)) * safeZoneW) + safeZoneX));
            y = QUOTE((((0.392 + 0.00175) * safeZoneW) + safeZoneX));
            h = QUOTE(0.007*SafeZoneW);
            w = QUOTE((0.00438*3)*SafeZoneW);
            type = 8;
            style = 0;
            colorFrame[] = {0.2, 0.2, 0.2, 1};
            colorBar[] = {0.2, 0.2, 0.2, 1};
            texture = "#(argb,8,8,3)color(1,1,1,1)";
            tooltip = "ST_HORIZONTAL";
        };

        class TransmitBar {
            idc = 99995;
            x = QUOTE(((ROW_LARGE_X * safeZoneW) + ((ROW_LARGE_OFFX*safeZoneW) * 19) + safeZoneX)); //19th Character
            y = QUOTE(((ROW_LARGE_Y * safeZoneW) + ((ROW_LARGE_OFFY*safeZoneW) * 1) + safeZoneX)); // 1first row
            h = QUOTE(0.9*ROW_LARGE_H*SafeZoneW);
            w = QUOTE((3*ROW_LARGE_W)*SafeZoneW);
            type = 8;
            style = 0;
            colorFrame[] = {0.2, 0.2, 0.2, 1};
            colorBar[] = {0.2, 0.2, 0.2, 1};
            texture = "#(argb,8,8,3)color(1,1,1,1)";
            tooltip = "ST_HORIZONTAL";
        };

        class LoadingBar {
            idc = 99992;
            x = QUOTE((( (0.33+(0.00438*7.5)) * safeZoneW) + safeZoneX));
            y = QUOTE((((0.392+ (0.01375*2.5)) * safeZoneW) + safeZoneX));
            h = QUOTE(0.005*SafeZoneW);
            w = QUOTE((0.00438*16)*SafeZoneW);
            type = 8;
            style = 0;
            colorFrame[] = {0.2, 0.2, 0.2,1};
            colorBar[] = {0.2, 0.2, 0.2, 1};
            texture = "#(argb,8,8,3)color(1,1,1,1)";
            tooltip = "ST_HORIZONTAL";
        };

        class LogoIcon: Prc117f_RscPicture {
            idc = 99993;
            x = QUOTE((((0.33+(0.14454/2)-0.06) * safeZoneW) + safeZoneX));
            y = QUOTE((((0.392+(0.055/2)-0.06) * safeZoneW) + safeZoneX));
            w = QUOTE(0.12*SafeZoneW);
            h = QUOTE(0.12*SafeZoneW);
            text = QPATHTOF(Data\icons\acre_logo.paa);
            colorText[] = {0,0,0,1};
        };

        class TransmitIcon: Prc117f_RscPicture {
            idc = 99902;
            x = QUOTE(((0.5315 * safeZoneW) + safeZoneX));
            y = QUOTE(((0.3905 * safeZoneW) + safeZoneX));
            w = QUOTE(0.05*SafeZoneW);
            h = QUOTE(0.01105*SafeZoneW);
            colorText[] = { 0, 0, 0, 1 };
            text = QPATHTOF(Data\icons\icon_transmit.paa);
        };

        class UpIcon: Prc117f_RscPicture {
            idc = 99903;
            x = QUOTE(((0.3 * safeZoneW) + safeZoneX));
            y = QUOTE(((0.52 * safeZoneW)  + safeZoneX));
            w = QUOTE(0.05*SafeZoneW);
            h = QUOTE(0.01105*SafeZoneW);
            text = QPATHTOF(Data\icons\icon_up.paa);
            colorText[] = { 0, 0, 0, 1  };
        };

        class DownIcon: Prc117f_RscPicture {
            idc = 99904;
            x = QUOTE(((0.3 * safeZoneW) + safeZoneX));
            y = QUOTE(((0.52 * safeZoneW)  + safeZoneX));
            w = QUOTE(0.05*SafeZoneW);
            h = QUOTE(0.01105*SafeZoneW);
            text = QPATHTOF(Data\icons\icon_down.paa);
            colorText[] = { 0, 0, 0, 1 };
        };

        class UpDownIcon: Prc117f_RscPicture {
            idc = 99905;
            x = QUOTE(((0.3 * safeZoneW) + safeZoneX));
            y = QUOTE(((0.52 * safeZoneW)  + safeZoneX));
            w = QUOTE(0.05*SafeZoneW);
            h = QUOTE(0.01105*SafeZoneW);
            text = QPATHTOF(Data\icons\icon_updown.paa);
            colorText[] = { 0, 0, 0, 1 };
        };

        class ScrollbarIcon: Prc117f_RscPicture {
            idc = 99906;
            x = QUOTE((((0.556-0.005) * safeZoneW) + safeZoneX));
            y = QUOTE(((0.39 * safeZoneW)  + safeZoneX));
            w = QUOTE(0.030*SafeZoneW);
            h = QUOTE(0.032*SafeZoneW);
            text = QPATHTOF(Data\icons\icon_scrollbar.paa);
            colorText[] = { 0, 0, 0, 1 };
        };




        TEXT_ROW_LARGE(21, ROW_LARGE_X, ROW_LARGE_Y, 0, ROW_LARGE_W, ROW_LARGE_H, ROW_LARGE_OFFX, ROW_LARGE_OFFY, ROW_LARGE_FONT_SIZE)
        TEXT_ROW_LARGE(22, ROW_LARGE_X, ROW_LARGE_Y, 1, ROW_LARGE_W, ROW_LARGE_H, ROW_LARGE_OFFX, ROW_LARGE_OFFY, ROW_LARGE_FONT_SIZE)
        TEXT_ROW_LARGE(23, ROW_LARGE_X, ROW_LARGE_Y, 2, ROW_LARGE_W, ROW_LARGE_H, ROW_LARGE_OFFX, ROW_LARGE_OFFY, ROW_LARGE_FONT_SIZE)
        TEXT_ROW_LARGE(24, ROW_LARGE_X, ROW_LARGE_Y, 3, ROW_LARGE_W, ROW_LARGE_H, ROW_LARGE_OFFX, ROW_LARGE_OFFY, ROW_LARGE_FONT_SIZE)

        TEXT_ROW_XLARGE(31, ROW_XLARGE_X, ROW_XLARGE_Y, 0, ROW_XLARGE_W, ROW_XLARGE_H, ROW_XLARGE_OFFX, ROW_XLARGE_OFFY, ROW_XLARGE_FONT_SIZE)
        TEXT_ROW_XLARGE(32, ROW_XLARGE_X, ROW_XLARGE_Y, 1, ROW_XLARGE_W, ROW_XLARGE_H, ROW_XLARGE_OFFX, ROW_XLARGE_OFFY, ROW_XLARGE_FONT_SIZE)

        TEXT_ROW_XXLARGE(41, ROW_XXLARGE_X, ROW_XXLARGE_Y, 0, ROW_XXLARGE_W, ROW_XXLARGE_H, ROW_XXLARGE_OFFX, ROW_XXLARGE_OFFY, ROW_XXLARGE_FONT_SIZE)

        TEXT_ROW_SMALL(11, ROW_SMALL_X, ROW_SMALL_Y, 0, ROW_SMALL_W, ROW_SMALL_H, ROW_SMALL_OFFX, ROW_SMALL_OFFY, ROW_SMALL_FONT_SIZE)
        TEXT_ROW_SMALL(12, ROW_SMALL_X, ROW_SMALL_Y, 1, ROW_SMALL_W, ROW_SMALL_H, ROW_SMALL_OFFX, ROW_SMALL_OFFY, ROW_SMALL_FONT_SIZE)
        TEXT_ROW_SMALL(13, ROW_SMALL_X, ROW_SMALL_Y, 2, ROW_SMALL_W, ROW_SMALL_H, ROW_SMALL_OFFX, ROW_SMALL_OFFY, ROW_SMALL_FONT_SIZE)
        TEXT_ROW_SMALL(14, ROW_SMALL_X, ROW_SMALL_Y, 3, ROW_SMALL_W, ROW_SMALL_H, ROW_SMALL_OFFX, ROW_SMALL_OFFY, ROW_SMALL_FONT_SIZE)
        TEXT_ROW_SMALL(15, ROW_SMALL_X, ROW_SMALL_Y, 4, ROW_SMALL_W, ROW_SMALL_H, ROW_SMALL_OFFX, ROW_SMALL_OFFY, ROW_SMALL_FONT_SIZE)

        BEGIN_CONTROL(MODE_ICON, Prc117f_RscPicture, 99901)
            x = QUOTE(SafeZoneX);
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*SafeZoneW);
            h = QUOTE(1*SafeZoneW);
            colorText[] = {1,1,1,1};
            text = QPATHTOF(Data\knobs\switch\prc117f_ui_swtch1_01.paa);
        END_CONTROL

        BEGIN_CONTROL(MODE_KNOB, Prc117f_RscButton, "99902+222")
            x = QUOTE((0.53 * safeZoneW) + safeZoneX);
            y = QUOTE((0.525 * safeZoneW) + safeZoneX);
            w = QUOTE(0.068235*SafeZoneW);
            h = QUOTE(0.090647*SafeZoneW);
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['MODE_KNOB'] + _this) call FUNC(onButtonPress));
        END_CONTROL



        BEGIN_CONTROL(BUTTON_ICON, Prc117f_RscPicture, 1000)
            x = QUOTE(SafeZoneX);
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*SafeZoneW);
            h = QUOTE(1*SafeZoneW);
            colorText[] = {1,1,1,1};
            text = QPATHTOF(Data\knobs\prc117f_ui_keys_default.paa);
        END_CONTROL

        BEGIN_CONTROL(BUTTON_ZERO, Prc117f_RscButton, "99902+100")
            BUTTON_GRID(0,0);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['0'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_ONE, Prc117f_RscButton, "99902+101")
            BUTTON_GRID(1,0);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['1'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_TWO, Prc117f_RscButton, "99902+102")
            BUTTON_GRID(2,0);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['2'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_THREE, Prc117f_RscButton, "99902+103")
            BUTTON_GRID(3,0);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['3'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_FOUR, Prc117f_RscButton, "99902+104")
            BUTTON_GRID(1,1);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['4'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_FIVE, Prc117f_RscButton, "99902+105")
            BUTTON_GRID(2,1);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['5'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_SIX, Prc117f_RscButton, "99902+106")
            BUTTON_GRID(3,1);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['6'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_SEVEN, Prc117f_RscButton, "99902+107")
            BUTTON_GRID(1,2);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['7'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_EIGHT, Prc117f_RscButton, "99902+108")
            BUTTON_GRID(2,2);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['8'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_NINE, Prc117f_RscButton, "99902+109")
            BUTTON_GRID(3,2);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['9'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_VOLUME_UP, Prc117f_RscButton, "99902+110")
            BUTTON_GRID(0,1);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['VOLUME_UP'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_VOLUME_DOWN, Prc117f_RscButton, "99902+111")
            BUTTON_GRID(0,2);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['VOLUME_DOWN'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_LEFT, Prc117f_RscButton, "99902+112")
            BUTTON_GRID(4,0);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['LEFT'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_RIGHT, Prc117f_RscButton, "99902+113")
            BUTTON_GRID(5,0);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['RIGHT'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_CLR, Prc117f_RscButton, "99902+114")
            BUTTON_GRID(4,1);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['CLR'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_ENT, Prc117f_RscButton, "99902+115")
            BUTTON_GRID(4,2);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['ENT'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_PRE_UP, Prc117f_RscButton, "99902+116")
            BUTTON_GRID(5,1);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['PRE_UP'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_PRE_DOWN, Prc117f_RscButton, "99902+117")
            BUTTON_GRID(5,2);
            BUTTONSIZE;
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['PRE_DOWN'] + _this) call FUNC(onButtonPress));
        END_CONTROL

    };
};
