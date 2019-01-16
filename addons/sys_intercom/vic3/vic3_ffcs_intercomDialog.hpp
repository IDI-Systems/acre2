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
    //onUnload = QUOTE(['closeGui'] call GUI_INTERACT_EVENT);
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
    };
};
