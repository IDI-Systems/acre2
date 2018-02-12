class RscControlsGroupNoScrollbars;
//class RscText; // Defined in VolumeControl
class RscStructuredText;

class GVAR(VehicleInfo): RscControlsGroupNoScrollbars {
    x = "0 * (((safezoneW / safezoneH) min 1.2) / 40) + (profilenamespace getvariable [""IGUI_GRID_VEHICLE_X"", (safezoneX + 0.5 * (((safezoneW / safezoneH) min 1.2) / 40))])";
    y = "4.3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (profilenamespace getvariable [""IGUI_GRID_VEHICLE_Y"", (safezoneY + 0.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))])";
    w = "10 * (((safezoneW / safezoneH) min 1.2) / 40)";
    h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
    idc = -1;
    class Controls {
        class ACRE_VEHICLE_INFO_BACKGROUND: RscText {
            idc = -1;
            x = 0;
            y = 0;
            w = "10 * (((safezoneW / safezoneH) min 1.2) / 40)";
            h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            colorBackground[] = {
                "(profilenamespace getvariable ['IGUI_BCG_RGB_R', 0])",
                "(profilenamespace getvariable ['IGUI_BCG_RGB_G', 1])",
                "(profilenamespace getvariable ['IGUI_BCG_RGB_B', 1])",
                "(profilenamespace getvariable ['IGUI_BCG_RGB_A', 0.8])"
            };
        };
        class ACRE_VEHICLE_INFO: RscStructuredText {
            onLoad = "uiNamespace setVariable [""ACRE_VEHICLE_INFO"", _this select 0]";
            idc=-1;
            x=0;
            y=0;
            w="9.8 * (((safezoneW / safezoneH) min 1.2) / 40)";
            h="0.8 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
        };
    };
};


