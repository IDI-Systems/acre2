#define CODE_SPACING    0.0245

#define CONTROL_SetRelativePos(xpos,ypos) x = H_OFFSET + (xpos * 0.001); y = H_OFFSET + (ypos * 0.001);
#define CONTROL_SetDimensions(width, height) w = width * 0.001; h = height * 0.001;

#define BEGIN_CONTROL(name, parent, idval) class name: parent { idc = idval;
#define END_CONTROL        };

#define NEW_SCALE 1
#define SCALE (NEW_SCALE/0.9)


class WS38_RadioDialog {
    idd = 31337;
    MovingEnable = 0;
    onUnload = QUOTE(['closeGui'] call GUI_INTERACT_EVENT);
    onLoad = QUOTE(_this call FUNC(render));
    controlsBackground[] = {"WS38Background"};
    objects[] = {};
    class WS38Background {
        type = CT_STATIC;
        idc = 99999;
        style = QUOTE(ST_PICTURE + ST_KEEP_ASPECT_RATIO);
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {1, 1, 1, 1};
        font = FontM;
        sizeEx = 0.04;
        x = "safezoneX";
        y = QUOTE((0.5-((1*safezoneW)/2)));
        w = QUOTE(1*safezoneW);
        h = QUOTE(1*safezoneW);

        text = QPATHTOF(Data\static\ws38_ui_backplate.paa);
    };
    class controls {
        BEGIN_CONTROL(ModeKnob,Ws38_RscPicture,106)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\knobs\mode\ws38_mode_0.paa);
        END_CONTROL

        BEGIN_CONTROL(ModeKnobButton,Ws38_RscButton,-1)
            x = QUOTE((0.605 * safeZoneW) + safeZoneX);
            y = QUOTE((0.305 * safeZoneW) + safeZoneX);
            w = QUOTE(0.1*SafeZoneW);
            h = QUOTE(0.19*SafeZoneW);
            colorBackground[] = {1, 0, 0, 0};
            text = "";
            onMouseButtonUp = QUOTE(_this call acre_sys_ws38_fnc_onFunctionKnobPress);
            toolTip = ECSTRING(sys_radio,ui_RadioMode);
        END_CONTROL

        BEGIN_CONTROL(FrequencyDial,Ws38_RscPicture,107)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\dials\frequency\ws38_frequency_0.paa);
        END_CONTROL

        BEGIN_CONTROL(FrequencyDialButton,Ws38_RscButton,-1)
            x = QUOTE((0.409 * safeZoneW) + safeZoneX);
            y = QUOTE((0.305 * safeZoneW) + safeZoneX);
            w = QUOTE(0.20*SafeZoneW);
            h = QUOTE(0.25*SafeZoneW);
            colorBackground[] = {1, 0, 0, 0};
            text = "";
            onMouseButtonUp = QUOTE(_this call acre_sys_ws38_fnc_onFrequencyDialPress);
            toolTip = ECSTRING(sys_radio,ui_changeFrequency);
        END_CONTROL
    };
};
