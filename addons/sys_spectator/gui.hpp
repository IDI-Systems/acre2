class RscText;
class ctrlListbox;
class RscControlsGroupNoScrollbars;

class RscStructuredText {
    class Attributes;
};

class GVAR(RscRadios): RscControlsGroupNoScrollbars {
    idc = IDC_RADIOS_GROUP;
    x = 0;
    y = QUOTE(POS_H(3.6));
    w = QUOTE(POS_W(15.9));
    h = QUOTE(POS_H(3.5));
    class controls {
        class Background: RscText {
            idc = IDC_RADIOS_BACKGROUND;
            style = ST_CENTER;
            x = 0;
            y = 0;
            w = QUOTE(POS_W(15.9));
            h = QUOTE(POS_H(3.5));
            colorBackground[] = {0, 0, 0, 0.75};
        };
        class NoRadios: Background {
            idc = IDC_RADIOS_NONE;
            text = CSTRING(NoRadios);
            sizeEx = QUOTE(POS_H(1.1));
            colorText[] = {1, 1, 1, 0.5};
            colorBackground[] = {0, 0, 0, 0};
        };
        class List: ctrlListbox {
            idc = IDC_RADIOS_LIST;
            x = 0;
            y = 0;
            w = QUOTE(POS_W(15.9));
            h = QUOTE(POS_H(3.5));
            colorBackground[] = {0, 0, 0, 0};
            colorSelectBackground[] = {0, 0, 0, 0};
            colorSelectBackground2[] = {0, 0, 0, 0};
        };
    };
};

class GVAR(RscSpeaking): RscStructuredText {
    idc = IDC_SPEAKING;
    x = QUOTE(safeZoneX + safeZoneW - POS_W(25.1));
    y = QUOTE(safeZoneY + POS_H(0.2));
    w = QUOTE(POS_W(25));
    h = QUOTE(safeZoneH - POS_H(12.2));
    size = QUOTE(POS_H(0.85));
    class Attributes: Attributes {
        align = "right";
    };
};

class RscDisplayEGSpectator {
    class Controls {
        class FocusInfo: RscControlsGroupNoScrollbars {
            y = QUOTE(POS_Y(21));
            h = QUOTE(POS_H(7.1));
            class controls {
                class GVAR(radios): GVAR(RscRadios) {};
            };
        };
        class GVAR(speaking): GVAR(RscSpeaking) {};
    };
};
