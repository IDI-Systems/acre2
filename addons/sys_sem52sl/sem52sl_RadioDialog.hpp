#define CODE_SPACING    0.0245

#define CONTROL_SetRelativePos(xpos,ypos) x = H_OFFSET + (xpos * 0.001); y = H_OFFSET + (ypos * 0.001);
#define CONTROL_SetDimensions(width, height) w = width * 0.001; h = height * 0.001;

#define BEGIN_CONTROL(name, parent, idval) class name: parent { idc = idval;
#define END_CONTROL        };

#define NEW_SCALE 1.8963
#define SCALE (NEW_SCALE*1.8963)

class SEM52SL_RadioDialog {
    idd = 31532;
    MovingEnable = 0;
    onUnload = QUOTE(['closeGui'] call GUI_INTERACT_EVENT);
    onLoad = QUOTE(_this call FUNC(render));
    controlsBackground[] = {};
    objects[] = {};
    class controls {

        BEGIN_CONTROL(RadioBackground, SEM52SL_RscPicture, 300)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/2.8 * safeZoneH));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/8 * safeZoneH));
            w = QUOTE(NEW_SCALE*safeZoneH);
            h = QUOTE(NEW_SCALE*safeZoneH);
            text = QPATHTOF(data\ui\sem52slui_ca.paa);
        END_CONTROL

        BEGIN_CONTROL(Backlight, SEM52SL_RscPicture, 109)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/2.8 * safeZoneH));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/8 * safeZoneH));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = "";
        END_CONTROL

        BEGIN_CONTROL(Display1, SEM52SL_RscPicture, 301)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/2.8 * safeZoneH));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/8 * safeZoneH));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = "";
        END_CONTROL

        BEGIN_CONTROL(Display2, SEM52SL_RscPicture, 302)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/2.8 * safeZoneH));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/8 * safeZoneH));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = "";
        END_CONTROL

        BEGIN_CONTROL(Display3, SEM52SL_RscPicture, 303)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/2.8 * safeZoneH));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/8 * safeZoneH));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = "";
        END_CONTROL

        BEGIN_CONTROL(Display4, SEM52SL_RscPicture, 304)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/2.8 * safeZoneH));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/8 * safeZoneH));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = "";
        END_CONTROL

        BEGIN_CONTROL(Display5, SEM52SL_RscPicture, 305)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/2.8 * safeZoneH));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/8 * safeZoneH));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = "";
        END_CONTROL


        BEGIN_CONTROL(ChannelKnob, SEM52SL_RscPicture, 106)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/2.8 * safeZoneH));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/8 * safeZoneH));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(data\knobs\channel\ch_01.paa);
        END_CONTROL

        BEGIN_CONTROL(VolumeKnob, SEM52SL_RscPicture, 107)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/2.8 * safeZoneH));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/8 * safeZoneH));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = QPATHTOF(Data\knobs\volume\vol_1000.paa);
        END_CONTROL

        BEGIN_CONTROL(PTTButtonImage, SEM52SL_RscPicture, 108)
            x = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/2.8 * safeZoneH));
            y = QUOTE(((0.5-(NEW_SCALE*(safeZoneH)/2))) - (1/8 * safeZoneH));
            w = QUOTE(NEW_SCALE * SafeZoneH);
            h = QUOTE(NEW_SCALE * SafeZoneH);
            text = "";
        END_CONTROL
        // Do the buttons last so they come on top.
        BEGIN_CONTROL(ChannelKnobButton, SEM52SL_RscButton, 201)
            x = QUOTE(((((0.466-0.615)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY + (1/24 * safeZoneH));
            y = QUOTE(((((0.595-0.5)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onChannelKnobPress));
            toolTip = ECSTRING(sys_radio,ui_ChangeChannel);
        END_CONTROL

        BEGIN_CONTROL(VolumeKnobButton, SEM52SL_RscButton, 202)
            x = QUOTE(((((0.466-0.487)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY + (1/24 * safeZoneH));
            y = QUOTE(((((0.595-0.5)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.35/0.8)*0.050*SafeZoneH);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onVolumeKnobPress));
            toolTip = ECSTRING(sys_radio,ui_ChangeVolume);
        END_CONTROL

        BEGIN_CONTROL(PTTButton, SEM52SL_RscButton, 203)
            x = QUOTE(((((0.466-0.543)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY + (1/24 * safeZoneH));
            y = QUOTE(((((0.595-0.5)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.15/0.8)*0.050*SafeZoneH * 4/3);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onPTTButtonPress));
            toolTip = QUOTE(PTT);
        END_CONTROL

        BEGIN_CONTROL(AudioCableButton, SEM52SL_RscButton, 204)
            x = QUOTE(((((0.466-0.687)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY + (1/24 * safeZoneH));
            y = QUOTE(((((0.595-0.6)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY);
            w = QUOTE((1.15/0.8)*0.050*SafeZoneH * 4/3);
            h = QUOTE((1.15/0.8)*0.050*SafeZoneH);
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(onAudioSocketPress));
            toolTip = QUOTE(Plug/Unplug headset);
        END_CONTROL

    };
};
