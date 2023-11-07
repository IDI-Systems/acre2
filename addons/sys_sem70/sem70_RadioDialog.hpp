#define CODE_SPACING 0.0245

#define CONTROL_SetRelativePos(xpos,ypos) x = H_OFFSET + (xpos * 0.001); y = H_OFFSET + (ypos * 0.001);
#define CONTROL_SetDimensions(width, height) w = width * 0.001; h = height * 0.001;

#define BEGIN_CONTROL(name, parent, idval) class name: parent { idc = idval;
#define END_CONTROL };

#define NEW_SCALE 1.4
#define SCALE (NEW_SCALE*1)


class SEM70_RadioDialog {
    idd = 31532;
    MovingEnable = 0;
    onUnload = QUOTE(['closeGui'] call GUI_INTERACT_EVENT);
    onLoad = QUOTE(_this call FUNC(render));
    controlsBackground[] = {/*SEM70Background*/};
    objects[] = {};
    /*class SEM70Background {
        type = CT_STATIC;
        idc = 99999;
        style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {1, 1, 1, 1};
        font = FontM;
        sizeEx = 0.04;

        x=safeZoneX + safeZoneW - NEW_SCALE * SafeZoneH + 1/32 * safeZoneW;
        y=SafeZoneY + SafeZoneH - NEW_SCALE * SafeZoneH + 1/8 * safeZoneW;
        w=NEW_SCALE * SafeZoneH;
        h=NEW_SCALE * SafeZoneH;

        text = QPATHTOF(data\ui\sem70ui_ca.paa);
    };*/
    class controls {

        BEGIN_CONTROL(RadioBackground,SEM70_RscPicture,300)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(data\ui\sem70ui_ca.paa);
        END_CONTROL

        /*BEGIN_CONTROL(Backlight,SEM70_RscPicture,109)
            x=safeZoneX + safeZoneW - NEW_SCALE * SafeZoneH + 1/32 * safeZoneW;
            y=SafeZoneY + SafeZoneH - NEW_SCALE * SafeZoneH + 1/8 * safeZoneW;
            w=NEW_SCALE * SafeZoneH;
            h=NEW_SCALE * SafeZoneH;
            text = "";
        END_CONTROL*/

        BEGIN_CONTROL(Display1,SEM70_RscPicture,301)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = "";
        END_CONTROL

        BEGIN_CONTROL(Display2,SEM70_RscPicture,302)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = "";
        END_CONTROL

        BEGIN_CONTROL(Display3,SEM70_RscPicture,303)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = "";
        END_CONTROL

        BEGIN_CONTROL(Display4,SEM70_RscPicture,304)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = "";
        END_CONTROL

        BEGIN_CONTROL(Display5,SEM70_RscPicture,305)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = "";
        END_CONTROL


        BEGIN_CONTROL(VolumeKnob,SEM70_RscPicture,106)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(data\knobs\volume\vol_100.paa);
        END_CONTROL

        BEGIN_CONTROL(MainKnob,SEM70_RscPicture,107)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\main\lstg_gr.paa);
        END_CONTROL

        BEGIN_CONTROL(FunctionKnob,SEM70_RscPicture,108)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\function\bs_hw.paa);
        END_CONTROL

        BEGIN_CONTROL(ChannelStepKnob,SEM70_RscPicture,109)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\cs\ka_25mhz.paa);
        END_CONTROL

        BEGIN_CONTROL(khzKnob,SEM70_RscPicture,110)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\khz\khz_0.paa);
        END_CONTROL

        BEGIN_CONTROL(mhzKnob,SEM70_RscPicture,111)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\mhz\mhz_0.paa);
        END_CONTROL

        BEGIN_CONTROL(displayKnob,SEM70_RscPicture,112)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\display\anzeige_aus.paa);
        END_CONTROL

        BEGIN_CONTROL(memorySlotKnob,SEM70_RscPicture,113)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\sp\sp_0.paa);
        END_CONTROL

        BEGIN_CONTROL(network1Knob,SEM70_RscPicture,114)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\fk\fk1_0.paa);
        END_CONTROL

        BEGIN_CONTROL(network2Knob,SEM70_RscPicture,115)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\fk\fk2_0.paa);
        END_CONTROL

        BEGIN_CONTROL(network3Knob,SEM70_RscPicture,116)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\fk\fk3_0.paa);
        END_CONTROL

        BEGIN_CONTROL(displayGP,SEM70_RscPicture,117)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\display\gp80_display_0.paa);
        END_CONTROL

        BEGIN_CONTROL(ledBetr,SEM70_RscPicture,118)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\led\led_betr_sp_an.paa);
        END_CONTROL

        BEGIN_CONTROL(ledGer2,SEM70_RscPicture,119)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\led\led_ger2_aus.paa);
        END_CONTROL

        BEGIN_CONTROL(ledGer13,SEM70_RscPicture,120)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\led\led_ger13_aus.paa);
        END_CONTROL




        // Do the buttons last so they come on top.
        BEGIN_CONTROL(VolumeButton,SEM70_RscButton,201)
            x = QUOTE(((((0.416-0.25)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.595-0.72)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            colorBackground[] = {1, 0, 0, 0};
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onVolumeKnobTurn));
            toolTip = ECSTRING(sys_radio,ui_ChangeVolume);
        END_CONTROL

        BEGIN_CONTROL(MainButton,SEM70_RscButton,202)
            x = QUOTE(((((0.416-0.615)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.595-0.72)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            colorBackground[] = {0, 1, 0, 0};
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onMainKnobTurn));
            toolTip = QUOTE(Change Power);
        END_CONTROL

        BEGIN_CONTROL(FunctionButton,SEM70_RscButton,203)
            x = QUOTE(((((0.416-0.3)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.595-0.72)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            colorBackground[] = {0, 0, 1, 0};
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onFunctionKnobTurn));
            toolTip = QUOTE(Change Mode);
        END_CONTROL

        BEGIN_CONTROL(ChannelStepButton,SEM70_RscButton,204)
            x = QUOTE(((((0.416-0.565)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.595-0.7)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            colorBackground[] = {1, 0, 1, 0};
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onChannelStepKnobTurn));
            toolTip = QUOTE(Change Frequency Spacing);
        END_CONTROL

        BEGIN_CONTROL(MHzButton,SEM70_RscButton,205)
            x = QUOTE(((((0.416-0.515)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.595-0.72)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.05/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            colorBackground[] = {1, 0, 0, 0};
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onMHzKnobTurn));
            toolTip = QUOTE(Change MHz);
        END_CONTROL

        BEGIN_CONTROL(kHzButton,SEM70_RscButton,206)
            x = QUOTE(((((0.416-0.35)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.595-0.72)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.05/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            colorBackground[] = {0, 0, 1, 0};
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onkHzKnobTurn));
            toolTip = QUOTE(Change kHz);
        END_CONTROL

        BEGIN_CONTROL(displayButton,SEM70_RscButton,207)
            x = QUOTE(((((0.416-0.565)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.595-0.75)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.05/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            colorBackground[] = {0, 0, 1, 0};
            text = "";
            onMouseButtonDown = QUOTE(_this call FUNC(onDisplayButtonPress));
            toolTip = QUOTE(Lit Display);
        END_CONTROL

        BEGIN_CONTROL(memorySlotButton,SEM70_RscButton,208)
            x = QUOTE(((((0.416-0.4)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.595-0.62)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.05/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            colorBackground[] = {0, 0, 1, 0};
            text = "";
            onMouseButtonDown = QUOTE(_this call FUNC(onMemorySlotKnobTurn));
            toolTip = QUOTE(Change Memory Slot);
        END_CONTROL

        BEGIN_CONTROL(network1Button,SEM70_RscButton,209)
            x = QUOTE(((((0.416-0.35)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.595-0.62)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.05/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            colorBackground[] = {0, 1, 0, 0};
            text = "";
            onMouseButtonDown = QUOTE(_this call FUNC(onNetworkKnobTurn));
            toolTip = QUOTE(Network 1);
        END_CONTROL

        BEGIN_CONTROL(network2Button,SEM70_RscButton,210)
            x = QUOTE(((((0.416-0.3)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.595-0.62)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.05/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            colorBackground[] = {1, 0, 0, 0};
            text = "";
            onMouseButtonDown = QUOTE(_this call FUNC(onNetworkKnobTurn));
            toolTip = QUOTE(Network 2);
        END_CONTROL

        BEGIN_CONTROL(network3Button,SEM70_RscButton,211)
            x = QUOTE(((((0.416-0.25)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.595-0.62)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.05/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            colorBackground[] = {1, 0, 1, 0};
            text = "";
            onMouseButtonDown = QUOTE(_this call FUNC(onNetworkKnobTurn));
            toolTip = QUOTE(Network 3);
        END_CONTROL
    };
};

//class RscTitles
//{
//    class GVAR(volumeKnobPicture)
//    {
//        idd = 19008;
//        MovingEnable = 0;
//        name = QUOTE(GVAR(volumeKnobPicture));
//        duration = 2;
//        fadein = 0;
//        onLoad = QUOTE([(_this select 0)] call FUNC(_showVolumeKnob));
//        class controls
//        {
//            BEGIN_CONTROL(volumeKnobPictureControl,SEM70_RscPicture,1071)
//                x = (((((0.416+0.057)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
//                y = ((((0.15-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
//                w = SCALE*0.1*SafeZoneH;
//                h = SCALE*0.1*SafeZoneH;
//                text = QPATHTOF(Data\knobs\volume\vol_0000.paa);
//                colorText[]= {1,1,1,1};
//            END_CONTROL
//        };
//    };
//};
