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
        BEGIN_CONTROL(Vic3ffcsBackground, VIC3FFCS_RscPicture,300)
            x=safeZoneX + safeZoneW - NEW_SCALE * SafeZoneH + 1/32 * safeZoneW;
            y=SafeZoneY + SafeZoneH - NEW_SCALE * SafeZoneH + 1/8 * safeZoneW;
            w=NEW_SCALE * SafeZoneH;
            h=NEW_SCALE * SafeZoneH;
            text = QPATHTOF(vic3\data\ui\vic3_ffcs.paa);
        END_CONTROL

        BEGIN_CONTROL(IntercomKnobButton, VIC3FFCS_RscButton, 301)
            x=((((0.466-0.487)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY + (1/24 * safeZoneH);
            y=((((0.595-0.5)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY;
            w=(1.35/0.8)*0.050*SafeZoneH;
            h=(1.15/0.8)*0.050*SafeZoneH;
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(vic3ffcsOnIntercomKnobPress));
            toolTip = QUOTE(Change intercom activation);
        END_CONTROL

            BEGIN_CONTROL(MonitorKnobButton, VIC3FFCS_RscButton, 302)
            x=((((0.466-0.487)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY + (1/24 * safeZoneH);
            y=((((0.595-0.5)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY;
            w=(1.35/0.8)*0.050*SafeZoneH;
            h=(1.15/0.8)*0.050*SafeZoneH;
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(vic3ffcsOnMonitorKnobPress));
            toolTip = QUOTE(Change monitor radio);
        END_CONTROL

        BEGIN_CONTROL(VolumeKnobButton, VIC3FFCS_RscButton, 303)
            x=((((0.466-0.487)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY + (1/24 * safeZoneH);
            y=((((0.595-0.5)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY;
            w=(1.35/0.8)*0.050*SafeZoneH;
            h=(1.15/0.8)*0.050*SafeZoneH;
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(vic3ffcsOnVolumeKnobPress));
            toolTip = QUOTE(Change volume);
        END_CONTROL

        BEGIN_CONTROL(WorkKnobButton, VIC3FFCS_RscButton, 304)
            x=((((0.466-0.487)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY + (1/24 * safeZoneH);
            y=((((0.595-0.5)*(1.15/0.8))+0.5) * SafeZoneH) + SafeZoneY;
            w=(1.35/0.8)*0.050*SafeZoneH;
            h=(1.15/0.8)*0.050*SafeZoneH;
            text = "";
            onMouseButtonUp = QUOTE(_this call FUNC(vic3ffcsOnWorkKnobPress));
            toolTip = QUOTE(Select transmit radio/intercom);
        END_CONTROL

    };
};
