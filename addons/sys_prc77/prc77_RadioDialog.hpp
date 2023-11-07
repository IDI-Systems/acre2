#define CODE_SPACING    0.0245

#define CONTROL_SetRelativePos(xpos,ypos) x = H_OFFSET + (xpos * 0.001); y = H_OFFSET + (ypos * 0.001);
#define CONTROL_SetDimensions(width, height) w = width * 0.001; h = height * 0.001;

#define BEGIN_CONTROL(name, parent, idval) class name: parent { idc = idval;
#define END_CONTROL        };

class PRC77_RadioDialog {
    idd = 31337;
    MovingEnable = 0;
    onUnload = QUOTE(['closeGui'] call GUI_INTERACT_EVENT);
    onLoad = QUOTE(_this call FUNC(render));
    controlsBackground[] = {"PRC77Background"};
    objects[] = {};
    class PRC77Background {
        type = CT_STATIC;
        idc = 99999;
        style = QUOTE(ST_PICTURE + ST_KEEP_ASPECT_RATIO);
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {1, 1, 1, 0};
        font = FontM;
        sizeEx = 0.04;
        x = "safezoneX";
        y = QUOTE((0.5-((1*safezoneW)/2)));
        w = QUOTE(1*safezoneW);
        h = QUOTE(1*safezoneW);
        text = "";
    };
    class controls {
        BEGIN_CONTROL(DialBackground,Prc77_RscPicture,201)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\images\dials\PRC77_dial_background.paa);
        END_CONTROL

        BEGIN_CONTROL(MHzDial,Prc77_RscPicture,202)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\images\dials\prc77_ui_disc_MHz_100.paa);
        END_CONTROL

        BEGIN_CONTROL(kHzDial,Prc77_RscPicture,203)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\images\dials\prc77_ui_disc_KHz_00.paa);
        END_CONTROL

        BEGIN_CONTROL(DialSlider,Prc77_RscPicture,204)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\images\dials\PRC77_display_0.paa);
        END_CONTROL

        /*BEGIN_CONTROL(DialCover,Prc77_RscPicture,205)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\images\dials\PRC77_dial_cover.paa);
        END_CONTROL*/

        BEGIN_CONTROL(FrontPlate,Prc77_RscPicture,210)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\images\PRC77_frame.paa);
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {1, 1, 1, 1};
        END_CONTROL

        BEGIN_CONTROL(MHzDialKnob,Prc77_RscPicture,2021)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\images\knob\prc77_ui_knob_MHz_0.paa);
        END_CONTROL

        BEGIN_CONTROL(kHzDialKnob,Prc77_RscPicture,2031)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\images\knob\prc77_ui_knob_KHz_0.paa);
        END_CONTROL

        BEGIN_CONTROL(MHzTuneKnobButton,Prc77_RscButton,-1)
            x = QUOTE((0.425 * safeZoneW) + safeZoneX);
            y = QUOTE((0.44 * safeZoneW) + safeZoneX);
            w = QUOTE(0.085*SafeZoneW);
            h = QUOTE(0.1*SafeZoneW);
            text = "";
            onMouseButtonDown = QUOTE(_this call FUNC(onMHzTuneKnobPress));
        END_CONTROL

        BEGIN_CONTROL(kHzTuneKnobButton,Prc77_RscButton,-1)
            x = QUOTE((0.585 * safeZoneW) + safeZoneX);
            y = QUOTE((0.44 * safeZoneW) + safeZoneX);
            w = QUOTE(0.085*SafeZoneW);
            h = QUOTE(0.1*SafeZoneW);
            text = "";
            onMouseButtonDown = QUOTE(_this call FUNC(onkHzTuneKnobPress));
        END_CONTROL

        BEGIN_CONTROL(VolumeKnob,Prc77_RscPicture,108)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\images\volume\PRC77_volume_0.paa);
        END_CONTROL

        BEGIN_CONTROL(VolumeKnobButton,Prc77_RscButton,-1)
            x = QUOTE((0.715 * safeZoneW) + safeZoneX);
            y = QUOTE((0.43 * safeZoneW) + safeZoneX);
            w = QUOTE(0.062*SafeZoneW);
            h = QUOTE(0.072*SafeZoneW);
            text = "";
            onMouseButtonDown = QUOTE(_this call FUNC(onVolumeKnobPress));
        END_CONTROL

        BEGIN_CONTROL(BandSelectorKnob,Prc77_RscPicture,109)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\images\band\PRC77_bandselector_0.paa);
        END_CONTROL

        BEGIN_CONTROL(BandSelectorKnobButton,Prc77_RscButton,-1)
            x = QUOTE((0.33 * safeZoneW) + safeZoneX);
            y = QUOTE((0.51 * safeZoneW) + safeZoneX);
            w = QUOTE(0.082*SafeZoneW);
            h = QUOTE(0.1*SafeZoneW);
            text = "";
            onMouseButtonDown = QUOTE(_this call FUNC(onBandSelectorKnobPress));
        END_CONTROL

        BEGIN_CONTROL(FunctionKnob,Prc77_RscPicture,105)
            x = "safezoneX";
            y = QUOTE((0.5-((1*safezoneW)/2)));
            w = QUOTE(1*safezoneW);
            h = QUOTE(1*safezoneW);
            text = QPATHTOF(Data\images\function\PRC77_function_0.paa);
        END_CONTROL

        BEGIN_CONTROL(FunctionKnobButton,Prc77_RscButton,-1)
            x = QUOTE((0.71 * safeZoneW) + safeZoneX);
            y = QUOTE((0.52 * safeZoneW) + safeZoneX);
            w = QUOTE(0.062*SafeZoneW);
            h = QUOTE(0.085*SafeZoneW);
            text = "";
            onMouseButtonDown = QUOTE(_this call FUNC(onFunctionKnobPress));
        END_CONTROL

        BEGIN_CONTROL(Preset1Button,Prc77_RscButton,-1)
            x = QUOTE((0.478 * safeZoneW) + safeZoneX);
            y = QUOTE((0.408 * safeZoneW) + safeZoneX);
            w = QUOTE(0.023*SafeZoneW);
            h = QUOTE(0.03*SafeZoneW);
            text = "";
            onMouseButtonDown = "[_this,0] call acre_sys_prc77_fnc_onPresetKnobPress";
            tooltip = QUOTE(Preset 1);
        END_CONTROL

        BEGIN_CONTROL(Preset2Button,Prc77_RscButton,-1)
            x = QUOTE((0.61 * safeZoneW) + safeZoneX);
            y = QUOTE((0.408 * safeZoneW) + safeZoneX);
            w = QUOTE(0.023*SafeZoneW);
            h = QUOTE(0.03*SafeZoneW);
            text = "";
            onMouseButtonDown = "[_this,1] call acre_sys_prc77_fnc_onPresetKnobPress";
            tooltip = QUOTE(Preset 2);
        END_CONTROL
/*        BEGIN_CONTROL(DisplayDarken,Prc77_RscPicture,301)
            x = "safezoneX";
            y = "safezoneY";
            w = "safezoneW";
            h = "safezoneH";
            text = QPATHTOF(Data\images\darken\PRC77_display_darken.paa);
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {1, 1, 1, 0};
        END_CONTROL

        BEGIN_CONTROL(FrameDarken,Prc77_RscPicture,302)
            x = "safezoneX";
            y = "safezoneY";
            w = "safezoneW";
            h = "safezoneH";
            text = QPATHTOF(Data\images\darken\PRC77_frame_darken.paa);
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {1, 1, 1, 0};
        END_CONTROL*/
    };
};
