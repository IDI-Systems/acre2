#define CODE_SPACING 0.0245

#define CONTROL_SetRelativePos(xpos,ypos) x = H_OFFSET + (xpos * 0.001); y = H_OFFSET + (ypos * 0.001);
#define CONTROL_SetDimensions(width, height) w = width * 0.001; h = height * 0.001;

#define BEGIN_CONTROL(name, parent, idval) class name: parent { idc = idval;
#define END_CONTROL };

#define NEW_SCALE 1.4
#define SCALE (NEW_SCALE*1)

class VIC3FFCS_IntercomDialog {
    idd = 31337;
    MovingEnable = 0;
    onUnload = QUOTE(_this call FUNC(closeGui));
    onLoad = QUOTE(_this call FUNC(vic3ffcsRender));
    controlsBackground[] = {/*VIC3FFCSBackground*/};
    objects[] = {};

    /*
    class VIC3FFCSBackground {
        type = CT_STATIC;
        idc = 99999;
        style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {1, 1, 1, 0};
        font = FontM;
        sizeEx = 0.04;
        x=safezoneX;
        y=(0.5-((1*safezoneW)/2));
        w=1*safezoneW;
        h=1*safezoneW;
        text = QPATHTOF(vic3\data\ui\vic3_ffcs.paa);
    };*/

    class controls {
        BEGIN_CONTROL(Vic3ffcsBackground, VIC3FFCS_RscPicture, 100)
            x=safeZoneX + safeZoneW - NEW_SCALE * SafeZoneH + 1/32 * safeZoneW;
            y=SafeZoneY + SafeZoneH - NEW_SCALE * SafeZoneH + 1/8 * safeZoneW;
            w=NEW_SCALE * SafeZoneH;
            h=NEW_SCALE * SafeZoneH;
            text = QPATHTOF(vic3\data\ui\vic3_ffcs.paa);
        END_CONTROL

        BEGIN_CONTROL(IntercomKnob, VIC3FFCS_RscPicture, 101)
            x=safeZoneX + safeZoneW - NEW_SCALE * SafeZoneH + 1/32 * safeZoneW;
            y=SafeZoneY + SafeZoneH - NEW_SCALE * SafeZoneH + 1/8 * safeZoneW;
            w=NEW_SCALE * SafeZoneH;
            h=NEW_SCALE * SafeZoneH;
            text = QPATHTOF(vic3\data\knobs\intercom\intercom_0.paa);
        END_CONTROL

        BEGIN_CONTROL(MonitorKnob, VIC3FFCS_RscPicture, 102)
            x=safeZoneX + safeZoneW - NEW_SCALE * SafeZoneH + 1/32 * safeZoneW;
            y=SafeZoneY + SafeZoneH - NEW_SCALE * SafeZoneH + 1/8 * safeZoneW;
            w=NEW_SCALE * SafeZoneH;
            h=NEW_SCALE * SafeZoneH;
            text = QPATHTOF(vic3\data\knobs\monitor\monitor_0.paa);
        END_CONTROL

        BEGIN_CONTROL(VolumeKnob, VIC3FFCS_RscPicture, 103)
            x=safeZoneX + safeZoneW - NEW_SCALE * SafeZoneH + 1/32 * safeZoneW;
            y=SafeZoneY + SafeZoneH - NEW_SCALE * SafeZoneH + 1/8 * safeZoneW;
            w=NEW_SCALE * SafeZoneH;
            h=NEW_SCALE * SafeZoneH;
            text = QPATHTOF(vic3\data\knobs\volume\volume_10.paa);
        END_CONTROL

        BEGIN_CONTROL(WorkKnob, VIC3FFCS_RscPicture, 104)
            x=safeZoneX + safeZoneW - NEW_SCALE * SafeZoneH + 1/32 * safeZoneW;
            y=SafeZoneY + SafeZoneH - NEW_SCALE * SafeZoneH + 1/8 * safeZoneW;
            w=NEW_SCALE * SafeZoneH;
            h=NEW_SCALE * SafeZoneH;
            text = QPATHTOF(vic3\data\knobs\work\work_0.paa);
        END_CONTROL

        // Do the buttons last so they come on top.
        BEGIN_CONTROL(IntercomKnobButton, VIC3FFCS_RscButton, 201)
            x=((((0.466-0.44)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY + (1/24 * safeZoneH);
            y=((((0.595-0.515)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY;
            w=(1.15/0.8)*0.050*SafeZoneH;
            h=(1.15/0.8)*0.050*SafeZoneH;
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(vic3ffcsOnIntercomKnobPress));
            toolTip = QUOTE(Change intercom activation);
        END_CONTROL

        BEGIN_CONTROL(MonitorKnobButton, VIC3FFCS_RscButton, 202)
            x=((((0.466-0.44)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY + (1/24 * safeZoneH);
            y=((((0.595-0.65)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY;
            w=(1.15/0.8)*0.050*SafeZoneH;
            h=(1.15/0.8)*0.050*SafeZoneH;
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(vic3ffcsOnMonitorKnobPress));
            toolTip = QUOTE(Change monitored radio);
        END_CONTROL

        BEGIN_CONTROL(VolumeKnobButton, VIC3FFCS_RscButton, 203)
            x=((((0.466-0.587)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY + (1/24 * safeZoneH);
            y=((((0.595-0.515)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY;
            w=(1.15/0.8)*0.050*SafeZoneH * 4/3;
            h=(1.15/0.8)*0.050*SafeZoneH;
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(vic3ffcsOnVolumeKnobPress));
            toolTip = QUOTE(Change volume);
        END_CONTROL

        BEGIN_CONTROL(WorkKnobButton, VIC3FFCS_RscButton, 204)
            x=((((0.466-0.587)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY + (1/24 * safeZoneH);
            y=((((0.595-0.65)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY;
            w=(1.15/0.8)*0.050*SafeZoneH * 4/3;
            h=(1.15/0.8)*0.050*SafeZoneH;
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(vic3ffcsOnWorkKnobPress));
            toolTip = QUOTE(Select transmitting radio);
        END_CONTROL
    };
};
