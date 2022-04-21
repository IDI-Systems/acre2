#define CODE_SPACING    0.0245

#define CONTROL_SetRelativePos(xpos,ypos) x = H_OFFSET + (xpos * 0.001); y = H_OFFSET + (ypos * 0.001);
#define CONTROL_SetDimensions(width, height) w = width * 0.001; h = height * 0.001;

#define BEGIN_CONTROL(name, parent, idval) class name: parent { idc = idval;
#define END_CONTROL        };

#define NEW_SCALE 0.85
#define SCALE (NEW_SCALE/0.8)


class BF888S_RadioDialog {
    idd = 31337;
    MovingEnable = 0;
    onUnload = QUOTE(['closeGui'] call GUI_INTERACT_EVENT);
    onLoad = QUOTE(_this call FUNC(render));
    controlsBackground[] = {BF888SBackground};
    objects[] = {};
    class BF888SBackground {
        type = CT_STATIC;
        idc = 99999;
        style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {1, 1, 1, 1};
        font = FontM;
        sizeEx = 0.04;
        /*x = SafeZoneY;
        y = ((0.5-((0.8*SafeZoneH)/2)));
        w = 1*SafeZoneH;
        h = 0.8*SafeZoneH;*/

        x = ((0.5-(NEW_SCALE*(safeZoneH)/2)));
        y = ((0.5-(NEW_SCALE*(safeZoneH)/2)));
        w = NEW_SCALE*safeZoneH;
        h = NEW_SCALE*safeZoneH;

        text = QPATHTOF(Data\static\bf888s_ui_backplate.paa);
    };
    class controls {
        BEGIN_CONTROL(ChannelKnob, BF888S_RscPicture, 106)
            x = ((0.5-(NEW_SCALE*(safeZoneH)/2)));
            y = ((0.5-(NEW_SCALE*(safeZoneH)/2)));
            w = NEW_SCALE*safeZoneH;
            h = NEW_SCALE*safeZoneH;
            text = QPATHTOF(Data\knobs\channel\bf888s_ui_pre_1.paa);
        END_CONTROL

        // x 1048, y 927
        BEGIN_CONTROL(ChannelKnobButton, BF888S_RscButton, 201)
            x = (((((0.410+0.085)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
            y = ((((0.38-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
            w = SCALE*0.04*SafeZoneH;
            h = SCALE*0.1*SafeZoneH;
            colorBackground[] = {1, 0, 0, 0};
            text = "";
            onMouseButtonUp = "[_this,0] call acre_sys_bf888s_fnc_onChannelKnobPress";
            toolTip = QUOTE(Change channel);
        END_CONTROL

        BEGIN_CONTROL(VolumeKnob, BF888S_RscPicture, 107)
            x = ((0.5-(NEW_SCALE*(safeZoneH)/2)));
            y = ((0.5-(NEW_SCALE*(safeZoneH)/2)));
            w = NEW_SCALE*safeZoneH;
            h = NEW_SCALE*safeZoneH;
            text = QPATHTOF(Data\knobs\volume\bf888s_ui_vol_5.paa);
        END_CONTROL

        // x 1186, y 922
        BEGIN_CONTROL(VolumeKnobButton, BF888S_RscButton, 202)
            x = (((((0.450+0.085)-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
            y = ((((0.38-0.5)*SCALE)+0.5) * SafeZoneH) + SafeZoneY;
            w = SCALE*0.04*SafeZoneH;
            h = SCALE*0.1*SafeZoneH;
            colorBackground[] = {0, 1, 0, 0};
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onVolumeKnobPress));
            toolTip = QUOTE(Change volume);
        END_CONTROL
    };
};
