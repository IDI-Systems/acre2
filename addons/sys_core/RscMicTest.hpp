// Microphone test (Escape → Options → ACRE Microphone Test, or acre_api_fnc_openMicrophoneTest).
class RscText;
class RscStructuredText;
class RscButtonMenu;
class RscProgress;

#define MICTEST_X (0.3 * safezoneW + safezoneX)
#define MICTEST_W (0.4 * safezoneW)
#define MICTEST_Y(n) ((0.28 + (n)) * safezoneH + safezoneY)

class GVAR(MicTest) {
    idd = -1;
    movingEnable = 0;
    onLoad = QUOTE(_this call FUNC(micTestLoad));
    onUnload = QUOTE(_this call FUNC(micTestUnload));

    class controlsBackground {
        class Background: RscText {
            idc = -1;
            x = QUOTE(MICTEST_X);
            y = QUOTE(MICTEST_Y(0.04));
            w = QUOTE(MICTEST_W);
            h = QUOTE(0.4 * safezoneH);
            colorBackground[] = {0, 0, 0, 0.85};
        };
        class Title: RscText {
            idc = -1;
            text = CSTRING(micTest_title);
            x = QUOTE(MICTEST_X);
            y = QUOTE(MICTEST_Y(0));
            w = QUOTE(MICTEST_W);
            h = QUOTE(0.04 * safezoneH);
            colorBackground[] = {
                "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",
                1
            };
        };
    };

    class controls {
        class Instructions: RscStructuredText {
            idc = 100;
            x = QUOTE(MICTEST_X + 0.01 * safezoneW);
            y = QUOTE(MICTEST_Y(0.06));
            w = QUOTE(MICTEST_W - 0.02 * safezoneW);
            h = QUOTE(0.22 * safezoneH);
        };
        class Meter: RscProgress {
            idc = 101;
            x = QUOTE(MICTEST_X + 0.01 * safezoneW);
            y = QUOTE(MICTEST_Y(0.29));
            w = QUOTE(MICTEST_W - 0.02 * safezoneW);
            h = QUOTE(0.025 * safezoneH);
            colorFrame[] = {1, 1, 1, 0.5};
            colorBar[] = {0.3, 0.8, 0.3, 1};
            texture = "#(argb,8,8,3)color(1,1,1,1)";
        };
        class MeterText: RscText {
            idc = 102;
            x = QUOTE(MICTEST_X + 0.01 * safezoneW);
            y = QUOTE(MICTEST_Y(0.32));
            w = QUOTE(MICTEST_W - 0.02 * safezoneW);
            h = QUOTE(0.03 * safezoneH);
        };
        class ButtonStart: RscButtonMenu {
            idc = 110;
            text = CSTRING(micTest_start);
            onButtonClick = QUOTE([] call FUNC(micTestStart));
            x = QUOTE(MICTEST_X);
            y = QUOTE(MICTEST_Y(0.445));
            w = QUOTE(0.13 * safezoneW);
            h = QUOTE(0.035 * safezoneH);
        };
        class ButtonApply: RscButtonMenu {
            idc = 111;
            text = CSTRING(micTest_apply);
            onButtonClick = QUOTE([] call FUNC(micTestApply));
            x = QUOTE(MICTEST_X + 0.135 * safezoneW);
            y = QUOTE(MICTEST_Y(0.445));
            w = QUOTE(0.13 * safezoneW);
            h = QUOTE(0.035 * safezoneH);
        };
        class ButtonClose: RscButtonMenu {
            idc = 112;
            text = CSTRING(micTest_close);
            onButtonClick = "(ctrlParent (_this select 0)) closeDisplay 2";
            x = QUOTE(MICTEST_X + 0.27 * safezoneW);
            y = QUOTE(MICTEST_Y(0.445));
            w = QUOTE(0.13 * safezoneW);
            h = QUOTE(0.035 * safezoneH);
        };
    };
};
