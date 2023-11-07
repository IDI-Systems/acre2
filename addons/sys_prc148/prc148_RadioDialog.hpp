#define NEW_SCALE 1
#define SCALE (NEW_SCALE/0.9)

#define V_OFFSET        0.0
#define H_OFFSET        0.0
#define CODE_SPACING    0.0245

#define CONTROL_SetRelativePos(xpos,ypos) x = QUOTE(H_OFFSET + (xpos * 0.001)); y = QUOTE(H_OFFSET + (ypos * 0.001));
#define CONTROL_SetDimensions(width, height) w = QUOTE(width * 0.001); QUOTE(h = height * 0.001);

#define BEGIN_CONTROL(name, parent, idval) class name: parent { idc = idval;
#define END_CONTROL        };

#define BUTTON_W     0.037
#define BUTTON_H    0.0248
#define BUTTONSIZE w = QUOTE(SCALE*BUTTON_W*SafeZoneH); h = QUOTE(SCALE*BUTTON_H*SafeZoneH)

#define BUTTON_X    0.430
#define BUTTON_Y    0.420

#define BUTTON_OFFX     0.014
#define BUTTON_OFFY     0.0135

#define BUTTON_GRID(BX,BY)  x = QUOTE(((((BUTTON_X - 0.5)*SCALE)+0.5) * safeZoneH) + (((BUTTON_OFFX*safeZoneH* SCALE) + (BUTTON_W*safeZoneH* SCALE)) * BX) + safeZoneY);\
                            y = QUOTE(((((BUTTON_Y - 0.5)*SCALE)+0.5) * safeZoneH) + (((BUTTON_OFFY*safeZoneH* SCALE) + (BUTTON_H*safeZoneH* SCALE)) * BY) + safeZoneY);\
                            colorBackground[] = {ClrWhite, 0}


#define ROW_SMALL_X            0.442
#define ROW_SMALL_Y         0.313
#define ROW_SMALL_W         0.012*0.52
#define ROW_SMALL_H         0.015*0.79
#define ROW_SMALL_OFFX         0.009*0.52
#define ROW_SMALL_OFFY         0.016*0.84
#define ROW_SMALL_FONT_SIZE 0.021*0.64

#define ROW_LARGE_X            0.442
#define ROW_LARGE_Y         0.313
#define ROW_LARGE_W         0.012*0.53
#define ROW_LARGE_H         0.015*0.82
#define ROW_LARGE_OFFX         0.009*0.72
#define ROW_LARGE_OFFY         0.016*1
#define ROW_LARGE_FONT_SIZE 0.021*0.80




#define COMBINE(x,y) x##y

#define TEXT_ROW_ELEMENT(CONTROL_ID,WIDTH,HEIGHT,TEXT_X,TEXT_OFFSETX,OFFSET_NUMX,TEXT_Y,TEXT_OFFSETY,OFFSET_NUMY,FONT_SIZE,FONT_FACE)\
    BEGIN_CONTROL(CONTROL_ID,Prc148_RscText,CONTROL_ID)\
        x = QUOTE(((((TEXT_X - 0.5)*SCALE)+0.5)* safeZoneH ) + ((TEXT_OFFSETX*safeZoneH * SCALE) * OFFSET_NUMX) + (safeZoneY));\
        y = QUOTE(((((TEXT_Y - 0.5)*SCALE)+0.5)* safeZoneH ) + ((TEXT_OFFSETY*safeZoneH * SCALE) * OFFSET_NUMY) + (safeZoneY));\
        w = QUOTE(SCALE*WIDTH*SafeZoneH);\
        h = QUOTE(SCALE*HEIGHT*SafeZoneH);\
        colorText[] = {0, 0, 0, 1};\
        colorBackground[] = {1,0,0,0};\
        sizeEx = QUOTE(SCALE*FONT_SIZE*SafeZoneH);\
        text = "";\
        font = FONT_FACE;\
    END_CONTROL



#define TEXT_ROW_SMALL(ROW_ID,ROW_X,ROW_Y,ROW_NUMBER,ROW_W,ROW_H,ROW_OFFSETX,ROW_OFFSETY,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,001),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,0,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,002),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,1,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,003),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,2,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,004),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,3,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,005),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,4,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,006),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,5,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,007),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,6,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,008),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,7,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,009),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,8,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,010),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,9,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,011),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,10,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,012),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,11,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,013),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,12,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,014),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,13,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,015),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,14,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,016),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,15,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,017),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,16,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,018),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,17,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,019),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,18,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,020),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,19,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,021),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,20,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,022),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,21,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,023),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,22,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,024),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,23,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,025),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,24,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)


#define TEXT_ROW_LARGE(ROW_ID,ROW_X,ROW_Y,ROW_NUMBER,ROW_W,ROW_H,ROW_OFFSETX,ROW_OFFSETY,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,001),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,0,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,002),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,1,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,003),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,2,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,004),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,3,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,005),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,4,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,006),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,5,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,007),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,6,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,008),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,7,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,009),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,8,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,010),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,9,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,011),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,10,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,012),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,11,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,013),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,12,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,014),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,13,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,015),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,14,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,016),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,15,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,017),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,16,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)\
    TEXT_ROW_ELEMENT(COMBINE(ROW_ID,018),ROW_W,ROW_H,ROW_X,ROW_OFFSETX,17,ROW_Y,ROW_OFFSETY,ROW_NUMBER,FONT_SIZE,FONT_FACE)



#define BG_WIDTH    0.067



class PRC148_RadioDialog {
    idd = 31337;
    MovingEnable = 0;
    onUnload = QUOTE(['closeGui'] call GUI_INTERACT_EVENT);
    onLoad = QUOTE(_this call FUNC(render));

    controlsBackground[] = {"PRC148Background"};
    objects[] = {};

    class PRC148Background: Prc148_RscBackground {
        type = CT_STATIC;
        idc = 999;
        style = QUOTE(ST_PICTURE + ST_KEEP_ASPECT_RATIO);
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {1, 1, 1, 1};
        x = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
        y = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
        w = QUOTE(NEW_SCALE*safeZoneH);
        h = QUOTE(NEW_SCALE*safeZoneH);

        text = "";//QPATHTOF(Data\static\prc148_ui_backplate.paa);
    };

    class controls {

        BEGIN_CONTROL(ChannelKnobImage,Prc148_RscPicture,99902)
            x = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            y = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            w = QUOTE(NEW_SCALE*safeZoneH);
            h = QUOTE(NEW_SCALE*safeZoneH);
            colorText[] = {1,1,1,1};
            text = QPATHTOF(Data\knobs\channel\prc148_ui_chan_0.paa);
        END_CONTROL

        BEGIN_CONTROL(VolumeKnobImage,Prc148_RscPicture,99903)
            x = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            y = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            w = QUOTE(NEW_SCALE*safeZoneH);
            h = QUOTE(NEW_SCALE*safeZoneH);
            colorText[] = {1,1,1,1};
            text = QPATHTOF(Data\knobs\volume\prc148_ui_vol_0.paa);
        END_CONTROL

        BEGIN_CONTROL(FrontPanel,Prc148_RscPicture,99910)
            x = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            y = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            w = QUOTE(NEW_SCALE*safeZoneH);
            h = QUOTE(NEW_SCALE*safeZoneH);
            colorText[] = {1,1,1,1};
            text = QPATHTOF(Data\static\prc148_ui_backplate.paa);
        END_CONTROL

        BEGIN_CONTROL(Display,Prc148_RscPicture,99911)
            x = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            y = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            w = QUOTE(NEW_SCALE*safeZoneH);
            h = QUOTE(NEW_SCALE*safeZoneH);
            colorText[] = {1,1,1,1};
            text = QPATHTOF(Data\static\prc148_ui_display.paa);
        END_CONTROL

        BEGIN_CONTROL(KeypadImage,Prc148_RscPicture,99901)
            x = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            y = QUOTE((0.5-(NEW_SCALE*(safeZoneH)/2)));
            w = QUOTE(NEW_SCALE*safeZoneH);
            h = QUOTE(NEW_SCALE*safeZoneH);
            colorText[] = {1,1,1,1};
            text = QPATHTOF(Data\knobs\keypad\prc148_ui_keys_default.paa);
        END_CONTROL


        // EtelkaNarrowMediumPro broke with 1.72 hotfix, can revert back to that font if fixed (following 9 uses of PuristaSemibold)
        TEXT_ROW_SMALL(54,ROW_SMALL_X,ROW_SMALL_Y,0,ROW_SMALL_W,ROW_SMALL_H,ROW_SMALL_OFFX,ROW_SMALL_OFFY,ROW_SMALL_FONT_SIZE,"PuristaSemibold")
        TEXT_ROW_SMALL(55,ROW_SMALL_X,ROW_SMALL_Y,1,ROW_SMALL_W,ROW_SMALL_H,ROW_SMALL_OFFX,ROW_SMALL_OFFY,ROW_SMALL_FONT_SIZE,"PuristaSemibold")
        TEXT_ROW_SMALL(56,ROW_SMALL_X,ROW_SMALL_Y,2,ROW_SMALL_W,ROW_SMALL_H,ROW_SMALL_OFFX,ROW_SMALL_OFFY,ROW_SMALL_FONT_SIZE,"PuristaSemibold")
        TEXT_ROW_SMALL(57,ROW_SMALL_X,ROW_SMALL_Y,3,ROW_SMALL_W,ROW_SMALL_H,ROW_SMALL_OFFX,ROW_SMALL_OFFY,ROW_SMALL_FONT_SIZE,"PuristaSemibold")
        TEXT_ROW_SMALL(58,ROW_SMALL_X,ROW_SMALL_Y,4,ROW_SMALL_W,ROW_SMALL_H,ROW_SMALL_OFFX,ROW_SMALL_OFFY,ROW_SMALL_FONT_SIZE,"PuristaSemibold")


        TEXT_ROW_LARGE(50,ROW_LARGE_X,ROW_LARGE_Y,0,ROW_LARGE_W,ROW_LARGE_H,ROW_LARGE_OFFX,ROW_LARGE_OFFY,ROW_LARGE_FONT_SIZE,"PuristaSemibold")
        TEXT_ROW_LARGE(51,ROW_LARGE_X,ROW_LARGE_Y,1,ROW_LARGE_W,ROW_LARGE_H,ROW_LARGE_OFFX,ROW_LARGE_OFFY,ROW_LARGE_FONT_SIZE,"PuristaSemibold")
        TEXT_ROW_LARGE(52,ROW_LARGE_X,ROW_LARGE_Y,2,ROW_LARGE_W,ROW_LARGE_H,ROW_LARGE_OFFX,ROW_LARGE_OFFY,ROW_LARGE_FONT_SIZE,"PuristaSemibold")
        TEXT_ROW_LARGE(53,ROW_LARGE_X,ROW_LARGE_Y,3,ROW_LARGE_W,ROW_LARGE_H,ROW_LARGE_OFFX,ROW_LARGE_OFFY,ROW_LARGE_FONT_SIZE,"PuristaSemibold")


        class BatteryImage: Prc148_RscPicture {
            x = QUOTE((((((0.430)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE((((((0.316)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE(SCALE*0.05*SafeZoneH);
            h = QUOTE(SCALE*0.055*SafeZoneH);

            text = QPATHTOF(Data\battery2_ca.paa);
            idc = 12011;
        };

        class BatteryStrength: Prc148_RscText {
            x = QUOTE((((((0.4465)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE((((((0.326)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE(SCALE*0.0135*SafeZoneH);
            h = QUOTE(SCALE*0.0338*SafeZoneH);
            text = "";
            colorText[] = {0, 0, 0, 1};
            colorBackground[] = {0,0,0,1};
            idc = 12010;
        };

        class SquelchImage: Prc148_RscPicture {
            x = QUOTE((((((0.441)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE((((((0.4145)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE(SCALE*0.022*SafeZoneH);
            h = QUOTE(SCALE*0.022*SafeZoneH);
            text = QPATHTOF(Data\squelch2_ca.paa);
            idc = 12012;
        };

        class ExternalAudio: Prc148_RscPicture {
            x = QUOTE((((((0.542)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE((((((0.313)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE(SCALE*0.008*SafeZoneH);
            h = QUOTE(SCALE*0.013*SafeZoneH);
            text = QPATHTOF(Data\external_audio_ca.paa);
            idc = 12013;
        };

        class SideConnector: Prc148_RscPicture {
            x = QUOTE((((((0.546)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE((((((0.314)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE(SCALE*0.013*SafeZoneH);
            h = QUOTE(SCALE*0.013*SafeZoneH);
            text = QPATHTOF(Data\side_connector_ca.paa);
            idc = 12014;
        };

        class Cursor: Prc148_Cursor {
            idc = 99212;
            w = 0;
            h = 0;
            x = 0;
            y = 0;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0, 0, 0, 1};
            text = "";
        };

        BEGIN_CONTROL(BUTTON_MODE,Prc148_RscButton,"12010+104")
            BUTTON_GRID(0,0);
            BUTTONSIZE;
            text = "";
            onMouseButtonUp = QUOTE((['MODE'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_GR,Prc148_RscButton,"12010+105")
            BUTTON_GRID(1,0);
            BUTTONSIZE;
            text = "";
            onMouseButtonUp = QUOTE((['GR'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_DOWN,Prc148_RscButton,"12010+106")
            BUTTON_GRID(0,1);
            BUTTONSIZE;
            text = "";
            onMouseButtonUp = QUOTE((['DOWN'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_UP,Prc148_RscButton,"12010+107")
            BUTTON_GRID(1,1);
            BUTTONSIZE;
            text = "";
            onMouseButtonUp = QUOTE((['UP'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_ESC,Prc148_RscButton,"12010+108")
            BUTTON_GRID(2,0);
            BUTTONSIZE;
            text = "";
            onMouseButtonUp = QUOTE((['ESC'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_ENT,Prc148_RscButton,"12010+109")
            BUTTON_GRID(2,1);
            BUTTONSIZE;
            text = "";
            onMouseButtonUp = QUOTE((['ENT'] + _this) call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_ALT,Prc148_RscButton,"12010+110")
            BUTTON_GRID(0,2);
            w = QUOTE(SCALE*0.029*SafeZoneH);
            h = QUOTE(SCALE*0.037*SafeZoneH);
            text = "";
            onMouseButtonUp = QUOTE(['ALT'] call FUNC(onButtonPress));
        END_CONTROL

        BEGIN_CONTROL(BUTTON_VOLUME,Prc148_RscButton,"12010+201")
            x = QUOTE(((((0.41-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.1-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE(SCALE*0.0435*SafeZoneH);
            h = QUOTE(SCALE*0.042*SafeZoneH);
            text = "";
            colorText[] = {ClrWhite,1};
            colorBackground[] = {ClrGray, 0};
            colorFocused[] = {ClrGray,0};
            sizeEx = QUOTE(SCALE*0.0205*SafeZoneH);
            colorShadow[] = {ClrGray,0};
            colorBorder[] = {ClrGray,0};
            colorBackgroundActive[] = {ClrGray,0};
            colorDisabled[] = {ClrGray, 0};
            colorBackgroundDisabled[] = {ClrGray,0};

            onMouseEnter = "[_this, 'Volume'] call acre_sys_prc148_fnc_onKnobMouseEnter;";
            onMouseExit = "[_this, 'Volume'] call acre_sys_prc148_fnc_onKnobMouseExit;";
            onMouseButtonUp = "_this call acre_sys_prc148_fnc_onVolumeKnobPress;";
            toolTip = QUOTE(Current volume: 100%);
        END_CONTROL

        BEGIN_CONTROL(BUTTON_CHANNEL,Prc148_RscButton,"12010+202")
            x = QUOTE(((((0.480-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.1-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE(SCALE*0.0435*SafeZoneH);
            h = QUOTE(SCALE*0.052*SafeZoneH);
            text = "";
            colorText[] = {ClrWhite,1};
            colorBackground[] = {ClrGray, 0};
            colorFocused[] = {ClrGray,0};
            sizeEx = QUOTE(SCALE*0.0205*SafeZoneH);
            colorShadow[] = {ClrGray,0};
            colorBorder[] = {ClrGray,0};
            colorBackgroundActive[] = {ClrGray,0};
            colorDisabled[] = {ClrGray, 0};
            colorBackgroundDisabled[] = {ClrGray,9};

            onMouseEnter = "[_this, 'Channel'] call acre_sys_prc148_fnc_onKnobMouseEnter;";
            onMouseExit = "[_this, 'Channel'] call acre_sys_prc148_fnc_onKnobMouseExit;";
            onMouseButtonUp = "_this call acre_sys_prc148_fnc_onChannelKnobPress;";
            toolTip = ECSTRING(sys_radio,ui_ChangeChannel);
        END_CONTROL
    };

};
