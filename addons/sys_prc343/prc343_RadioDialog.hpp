#define CODE_SPACING    0.0245

#define CONTROL_SetRelativePos(xpos,ypos) x = H_OFFSET + (xpos * 0.001); y = H_OFFSET + (ypos * 0.001);
#define CONTROL_SetDimensions(width, height) w = width * 0.001; h = height * 0.001;

#define BEGIN_CONTROL(name, parent, idval) class name: parent { idc = idval;
#define END_CONTROL        };

#define NEW_SCALE 0.85
#define SCALE (NEW_SCALE/0.8)


class PRC343_RadioDialog {
    idd = 31337;
    MovingEnable = 0;
    onUnload = QUOTE(['closeGui'] call GUI_INTERACT_EVENT);
    onLoad = QUOTE(_this call FUNC(render));
    controlsBackground[] = {"PRC343Background"};
    objects[] = {};
    class PRC343Background {
        type = CT_STATIC;
        idc = 99999;
        style = QUOTE(ST_PICTURE + ST_KEEP_ASPECT_RATIO);
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {1, 1, 1, 1};
        font = FontM;
        sizeEx = 0.04;
        /*x = SafeZoneY;
        y = ((0.5-((0.8*SafeZoneH)/2)));
        w = 1*SafeZoneH;
        h = 0.8*SafeZoneH;*/

        x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
        y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
        w = QUOTE(NEW_SCALE*safeZoneH);
        h = QUOTE(NEW_SCALE*safeZoneH);

        text = QPATHTOF(Data\static\prc343_ui_backplate.paa);
    };
    class controls {
        BEGIN_CONTROL(ChannelKnob,Prc343_RscPicture,106)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE*safeZoneH);
            h = QUOTE(NEW_SCALE*safeZoneH);
            text = QPATHTOF(Data\knobs\channel\prc343_ui_pre_1.paa);
        END_CONTROL

        BEGIN_CONTROL(ChannelKnobButton,Prc343_RscButton,201)
            x = QUOTE((((((0.416+0.085)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.28-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE(SCALE*0.072*SafeZoneH);
            h = QUOTE(SCALE*0.1*SafeZoneH);
            colorBackground[] = {1, 0, 0, 0};
            text = "";
            onMouseButtonUp = "[_this,0] call acre_sys_prc343_fnc_onChannelKnobPress";
            toolTip = ECSTRING(sys_radio,ui_ChangeChannel);
        END_CONTROL

        BEGIN_CONTROL(VolumeKnob,Prc343_RscPicture,107)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))));
            w = QUOTE(NEW_SCALE*safeZoneH);
            h = QUOTE(NEW_SCALE*safeZoneH);
            text = QPATHTOF(Data\knobs\volume\prc343_ui_vol_5.paa);
        END_CONTROL

        BEGIN_CONTROL(VolumeKnobButton,Prc343_RscButton,202)
            x = QUOTE(((((0.416-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.28-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE(SCALE*0.072*SafeZoneH);
            h = QUOTE(SCALE*0.1*SafeZoneH);
            colorBackground[] = {0, 1, 0, 0};
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onVolumeKnobPress));
            toolTip = ECSTRING(sys_radio,ui_ChangeVolume);
        END_CONTROL

        BEGIN_CONTROL(PTTHandleButton,Prc343_RscButton,203)
            x = QUOTE(((((0.255-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.377-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE(SCALE*0.07*SafeZoneH);
            h = QUOTE(SCALE*0.4*SafeZoneH);
            //colorBackground[] = {0, 0, 1, 0.2};
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onPTTHandlePress));
            toolTip = QUOTE(Detach Handle);
        END_CONTROL

        BEGIN_CONTROL(ChannelBlockButton,Prc343_RscButton,204)
            x = QUOTE(((((0.515-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            y = QUOTE(((((0.6-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE(SCALE*0.03*SafeZoneH);
            h = QUOTE(SCALE*0.05*SafeZoneH);
            //colorBackground[] = {1, 1, 1, 0.2};
            text = "";
            onMouseButtonUp = "[_this,1] call acre_sys_prc343_fnc_onChannelKnobPress";
            toolTip = QUOTE(Current channel block: 1);
        END_CONTROL
    };
};
