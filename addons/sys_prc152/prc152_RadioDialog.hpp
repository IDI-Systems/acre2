class Prc152_RadioDialog {
    idd = 31337;
    MovingEnable = 0;
    onUnload = QUOTE(['closeGui'] call GUI_INTERACT_EVENT);
    onLoad = QUOTE(_this call FUNC(render));
    controlsBackground[] = {"Prc152Background"};
    objects[] = {};

    class Prc152Background: Prc152_RscBackground {
        type = CT_STATIC;
        idc = -1;
        style = QUOTE(ST_PICTURE + ST_KEEP_ASPECT_RATIO);
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {1, 1, 1, 1};
        font = "PixelSplitterBold";
        sizeEx = 0.03;
        x = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
        y = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
        w = QUOTE(NEW_SCALE*safeZoneH);
        h = QUOTE(NEW_SCALE*safeZoneH);
        text = QPATHTOF(Data\prc152c_ui.paa);
    };
    class controls {
        class BatteryBar {
            idc = 99991;
            //(((TEXT_X - 0.5)*SCALE)+0.5)

            x = QUOTE((((((0.435+(0.0038*6))-0.5)*SCALE)+0.5) * safeZoneH) + safeZoneY);
            y = QUOTE((((((0.415 + 0.0004)-0.5)*SCALE)+0.5) * safeZoneH)  + safeZoneY);
            h = QUOTE(SCALE*0.007*safeZoneH);
            w = QUOTE(SCALE*(0.00438*6)*safeZoneH);
            type = 8;
            style = 0;
            colorFrame[] = {0.2, 0.2, 0.2, 1};
            colorBar[] = {0.2, 0.2, 0.2, 1};
            texture = "#(argb,8,8,3)color(1,1,1,1)";
            tooltip = "ST_HORIZONTAL";
        };


        class VolumeBar {
            idc = 99994;
            x = QUOTE((((((0.435+(0.0038*6))-0.5)*SCALE)+0.5) * safeZoneH) + safeZoneY);
            y = QUOTE((((((0.415 + 0.0004)-0.5)*SCALE)+0.5) * safeZoneH)  + safeZoneY); // 0.0007
            h = QUOTE(SCALE*0.007*safeZoneH);
            w = QUOTE(SCALE*(0.00438*6)*safeZoneH);
            type = 8;
            style = 0;
            colorFrame[] = {0.2, 0.2, 0.2, 1};
            colorBar[] = {0.2, 0.2, 0.2, 1};
            texture = "#(argb,8,8,3)color(1,1,1,1)";
            tooltip = "ST_HORIZONTAL";
        };


        class LoadingBar {
            idc = 99992;
            x = QUOTE((((((0.435+(0.0038*3))-0.5)*SCALE)+0.5) * safeZoneH) + safeZoneY);
            y = QUOTE((((((0.415+ (0.01105*2.25))-0.5)*SCALE)+0.5) * safeZoneH)  + safeZoneY);
            h = QUOTE(SCALE*0.00805*safeZoneH);
            w = QUOTE(SCALE*(0.0057*16)*safeZoneH);
            type = 8;
            style = 0;
            colorFrame[] = {0.2, 0.2, 0.2,1};
            colorBar[] = {0.2, 0.2, 0.2, 1};
            texture = "#(argb,8,8,3)color(1,1,1,1)";
            tooltip = "ST_HORIZONTAL";
        };



        class LogoIcon: Prc152_RscPicture {
            idc = 99993;
            x = QUOTE((((((0.435+(0.1254/2)-0.07)-0.5)*SCALE)+0.5) * safeZoneH) + safeZoneY);
            y = QUOTE((((((0.415 +(0.02/2)-0.05)-0.5)*SCALE)+0.5) * safeZoneH)  + safeZoneY);
            w = QUOTE(SCALE*0.12*safeZoneH);
            h = QUOTE(SCALE*0.12*safeZoneH);
            text = QPATHTOF(Data\icons\acre_logo.paa);
            colorText[] = {1,1,1,1};
        };

        class KnobImage: Prc152_RscPicture {
            idc = 99901;
            x = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            y = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            w = QUOTE(NEW_SCALE*safeZoneH);
            h = QUOTE(NEW_SCALE*safeZoneH);
            text = QPATHTOF(Data\Knobs\channelknob\prc152c_ui_knob_1.paa);
            colorText[] = {1,1,1, 1};
        };
        class TransmitBar {
            idc = 99995;
            x = QUOTE(((((0.496-0.5 + (0.0933/2.42))*SCALE)+0.5) * safeZoneH) + safeZoneY); // 2.55
            y = QUOTE(((((0.4211 + 0.005 -0.5)*SCALE)+0.5) * safeZoneH)  + safeZoneY); // 0.005
            w = QUOTE(SCALE*(0.0933/4.25)*safeZoneH); //4.22
            h = QUOTE(SCALE*(0.00438*1.7)*safeZoneH); //0.01105, 3
            type = 8;
            style = 0;
            colorFrame[] = {0.2, 0.2, 0.2,1};
            colorBar[] = {0.2, 0.2, 0.2, 1};
            texture = "#(argb,8,8,3)color(1,1,1,1)";
            tooltip = "ST_HORIZONTAL";
        };

        // Lower down for render order.
        class TransmitIcon: Prc152_RscPicture {
            idc = 99902;
            x = QUOTE(((((0.496-0.5)*SCALE)+0.5) * safeZoneH) + safeZoneY); // 0.50 -> 0.49 -> 0.493
            y = QUOTE(((((0.4211-0.5)*SCALE)+0.5) * safeZoneH)  + safeZoneY); // 0.426 -> 0.41 -> 0.42
            w = QUOTE(SCALE*0.0933*safeZoneH); //0.05, 0.07
            h = QUOTE(SCALE*(0.00438*4)*safeZoneH); //0.01105, 3
            colorText[] = { 0, 0, 0, 1 };
            text = QPATHTOF(Data\icons\icon_transmit.paa);
        };


        class UpIcon: Prc152_RscPicture {
            idc = 99903;
            x = QUOTE(((((0.28-0.5)*SCALE)+0.5) * safeZoneH) + safeZoneY);
            y = QUOTE(((((0.6-0.5)*SCALE)+0.5) * safeZoneH)  + safeZoneY);
            w = QUOTE(SCALE*0.05*safeZoneH);
            h = QUOTE(SCALE*0.01105*safeZoneH);
            text = QPATHTOF(Data\icons\icon_up.paa);
            colorText[] = { 0, 0, 0, 1  };
            colorBackground[] = {1,1,1,0};
        };

        class DownIcon: Prc152_RscPicture {
            idc = 99904;
            x = QUOTE(((((0.28-0.5)*SCALE)+0.5) * safeZoneH) + safeZoneY);
            y = QUOTE(((((0.6-0.5)*SCALE)+0.5) * safeZoneH)  + safeZoneY);
            w = QUOTE(SCALE*0.05*safeZoneH);
            h = QUOTE(SCALE*0.01105*safeZoneH);
            text = QPATHTOF(Data\icons\icon_down.paa);
            colorText[] = { 0, 0, 0, 1 };
        };

        class UpDownIcon: Prc152_RscPicture {
            idc = 99905;
            x = QUOTE(((((0.2-0.5)*SCALE)+0.5) * safeZoneH) + safeZoneY);
            y = QUOTE(((((0.7-0.5)*SCALE)+0.5) * safeZoneH)  + safeZoneY);
            w = QUOTE(SCALE*0.05*safeZoneH);
            h = QUOTE(SCALE*0.01105*safeZoneH);
            text = QPATHTOF(Data\icons\icon_updown.paa);
            colorText[] = { 0, 0, 0, 1 };
        };

        class ScrollbarIcon: Prc152_RscPicture {
            idc = 99906;
            x = QUOTE((((((0.556-0.0115)-0.5)*SCALE)+0.5) * safeZoneH) + safeZoneY);
            y = QUOTE(((((0.425-0.5)*SCALE)+0.5) * safeZoneH)  + safeZoneY);
            w = QUOTE(SCALE*0.030*safeZoneH);
            h = QUOTE(SCALE*0.032*safeZoneH);
            text = QPATHTOF(Data\icons\icon_scrollbar.paa);
            colorText[] = { 0, 0, 0, 1 };
        };

        TEXT_ROW_LARGE(21,ROW_LARGE_X,ROW_LARGE_Y,0,ROW_LARGE_W,ROW_LARGE_H,ROW_LARGE_OFFX,ROW_LARGE_OFFY,ROW_LARGE_FONT_SIZE)
        TEXT_ROW_LARGE(22,ROW_LARGE_X,ROW_LARGE_Y,1,ROW_LARGE_W,ROW_LARGE_H,ROW_LARGE_OFFX,ROW_LARGE_OFFY,ROW_LARGE_FONT_SIZE)
        TEXT_ROW_LARGE(23,ROW_LARGE_X,ROW_LARGE_Y,2,ROW_LARGE_W,ROW_LARGE_H,ROW_LARGE_OFFX,ROW_LARGE_OFFY,ROW_LARGE_FONT_SIZE)
        TEXT_ROW_LARGE(24,ROW_LARGE_X,ROW_LARGE_Y,3,ROW_LARGE_W,ROW_LARGE_H,ROW_LARGE_OFFX,ROW_LARGE_OFFY,ROW_LARGE_FONT_SIZE)

        TEXT_ROW_XLARGE(31,ROW_XLARGE_X,ROW_XLARGE_Y,0,ROW_XLARGE_W,ROW_XLARGE_H,ROW_XLARGE_OFFX,ROW_XLARGE_OFFY,ROW_XLARGE_FONT_SIZE)
        TEXT_ROW_XLARGE(32,ROW_XLARGE_X,ROW_XLARGE_Y,1,ROW_XLARGE_W,ROW_XLARGE_H,ROW_XLARGE_OFFX,ROW_XLARGE_OFFY,ROW_XLARGE_FONT_SIZE)

        TEXT_ROW_XXLARGE(41,ROW_XXLARGE_X,ROW_XXLARGE_Y,0,ROW_XXLARGE_W,ROW_XXLARGE_H,ROW_XXLARGE_OFFX,ROW_XXLARGE_OFFY,ROW_XXLARGE_FONT_SIZE)

        TEXT_ROW_SMALL(11,ROW_SMALL_X,ROW_SMALL_Y,0,ROW_SMALL_W,ROW_SMALL_H,ROW_SMALL_OFFX,ROW_SMALL_OFFY,ROW_SMALL_FONT_SIZE)
        TEXT_ROW_SMALL(12,ROW_SMALL_X,ROW_SMALL_Y,1,ROW_SMALL_W,ROW_SMALL_H,ROW_SMALL_OFFX,ROW_SMALL_OFFY,ROW_SMALL_FONT_SIZE)
        TEXT_ROW_SMALL(13,ROW_SMALL_X,ROW_SMALL_Y,2,ROW_SMALL_W,ROW_SMALL_H,ROW_SMALL_OFFX,ROW_SMALL_OFFY,ROW_SMALL_FONT_SIZE)
        TEXT_ROW_SMALL(14,ROW_SMALL_X,ROW_SMALL_Y,3,ROW_SMALL_W,ROW_SMALL_H,ROW_SMALL_OFFX,ROW_SMALL_OFFY,ROW_SMALL_FONT_SIZE)
        TEXT_ROW_SMALL(15,ROW_SMALL_X,ROW_SMALL_Y,4,ROW_SMALL_W,ROW_SMALL_H,ROW_SMALL_OFFX,ROW_SMALL_OFFY,ROW_SMALL_FONT_SIZE)

        BEGIN_CONTROL(CIPHER_ICON,Prc152_RscPicture,99907)
            x = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            y = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            w = QUOTE(NEW_SCALE*safeZoneH);
            h = QUOTE(NEW_SCALE*safeZoneH);
            colorText[] = {1,1,1,1};
            text = QPATHTOF(Data\Knobs\functionknob\prc152c_ui_swtch_0.paa);
        END_CONTROL

        /*BEGIN_CONTROL(CHIPHER_KNOB,Prc152_RscButton,222)
            x = QUOTE((0.53 * safeZoneH) + safeZoneY);
            y = QUOTE((0.525 * safeZoneH) + safeZoneY);
            w = QUOTE(0.068235*safeZoneH);
            h = QUOTE(0.090647*safeZoneH);
            text = "";
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            //onMouseButtonUp = QUOTE((['MODE_KNOB'] + _this) call FUNC(onButtonPress));
        END_CONTROL*/

        BEGIN_CONTROL(BUTTON_ICON,Prc152_RscPicture,1000)
            x = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            y = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            w = QUOTE(NEW_SCALE*safeZoneH);
            h = QUOTE(NEW_SCALE*safeZoneH);
            colorText[] = {1,1,1,1};
            text = QPATHTOF(Data\Knobs\keypad\prc152c_ui_default.paa);
        END_CONTROL

        BEGIN_CONTROL(BUTTON_ONE,Prc152_RscButton,"99902+101")
            BUTTON_GRID(0,0);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['1'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_TWO,Prc152_RscButton,"99902+102")
            BUTTON_GRID(1,0);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['2'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_THREE,Prc152_RscButton,"99902+103")
            BUTTON_GRID(2,0);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['3'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_FOUR,Prc152_RscButton,"99902+104")
            BUTTON_GRID(0,1);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['4'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_FIVE,Prc152_RscButton,"99902+105")
            BUTTON_GRID(1,1);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['5'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_SIX,Prc152_RscButton,"99902+106")
            BUTTON_GRID(2,1);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['6'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_SEVEN,Prc152_RscButton,"99902+107")
            BUTTON_GRID(0,2);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['7'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_EIGHT,Prc152_RscButton,"99902+108")
            BUTTON_GRID(1,2);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['8'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_NINE,Prc152_RscButton,"99902+109")
            BUTTON_GRID(2,2);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['9'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_ZERO,Prc152_RscButton,"99902+100")
            BUTTON_GRID(0,3);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['0'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_CLR,Prc152_RscButton,"99902+110")
            BUTTON_GRID(3,0);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['CLR'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_ENT,Prc152_RscButton,"99902+111")
            BUTTON_GRID(3,1);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['ENT'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_PRE_UP,Prc152_RscButton,"99902+112")
            BUTTON_GRID(3,2);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['PRE_UP'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_PRE_DOWN,Prc152_RscButton,"99902+113")
            BUTTON_GRID(3,3);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['PRE_DOWN'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_LEFT,Prc152_RscButton,"99902+114")
            BUTTON_GRID(1,3);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['LEFT'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_RIGHT,Prc152_RscButton,"99902+115")
            BUTTON_GRID(2,3);
            BUTTONSIZE;
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseButtonUp = QUOTE((['RIGHT'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(KNOB_BUTTON,Prc152_RscButton,"99902+116")
            x = QUOTE(((((0.47-0.5)*SCALE)+0.5) * safeZoneH) + safeZoneY);
            y = QUOTE(((((0.16-0.5)*SCALE)+0.5) * safeZoneH)  + safeZoneY);
            w = QUOTE(SCALE*0.05*safeZoneH);
            h = QUOTE(SCALE*0.046*safeZoneH);
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            text = "";
            onMouseButtonUp = QUOTE((['KNOB'] + _this) call FUNC(onButtonPress));
            toolTip = ECSTRING(sys_radio,ui_ChangeChannel);
        END_CONTROL


        BEGIN_CONTROL(BUTTON_VOLUME,Prc152_RscButton,"99902+117")
            x = QUOTE(((((0.40-0.5)*SCALE)+0.5) * safeZoneH) + safeZoneY);
            y = QUOTE(((((0.30-0.5)*SCALE)+0.5) * safeZoneH)  + safeZoneY);
            w = QUOTE(SCALE*0.015*safeZoneH);
            h = QUOTE(SCALE*0.045*safeZoneH);
            sizeEx = 0.014;
            color[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            onMouseEnter = QUOTE((['VOLUME'] + _this) call FUNC(onKnobMouseEnter));
            onMouseExit = QUOTE((['VOLUME'] + _this) call FUNC(onKnobMouseExit));
            onMouseButtonUp = QUOTE((['VOLUME'] + _this) call FUNC(onButtonPress));
            toolTip = ECSTRING(sys_radio,ui_ChangeVolume);
        END_CONTROL

    };
};
