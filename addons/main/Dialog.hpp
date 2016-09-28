class ACRE_VERSION_MISMATCH {
    idd = 666123666;
       movingEnable =  1;
       duration     =  99999999;
       fadein       =  0.5;
       fadeout      =  0.5;
       name = "ACRE_VERSION_MISMATCH";
    // playSound goes here
    onLoad = "with uiNameSpace do { ACRE_VERSION_MISMATCH = _this select 0 }; ";
    controls[] = { "ACRE_VERSION_MISMATCH_BG", "ACRE_VERSION_MISMATCH_TITLE", "ACRE_VERSION_MISMATCH_TEXT", "ACRE_VERSION_MISMATCH_BUTT", "ACRE_VERSION_MISMATCH_LINE", "ACRE_VERSION_MISMATCH_HTML", "ACRE_VERSION_MISMATCH_LINE2" };
    class ACRE_VERSION_MISMATCH_BG {
        moving = 1;
        idc = 101;
        type = 0;
        colorText[] = { 0, 1, 0, 0.5 };
        font = "TahomaB";
        colorBackground[] = { 0.1882, 0.2588, 0.149, 0.76 };
        text = "";
        style = 128;
        sizeEx = 0.015;
        size = 0.015;
        x = __X + 0.2;y = __Y + 0.4;
        w = 0.6;h = 0.35;
    };
    class ACRE_VERSION_MISMATCH_TITLE {
        access = 0;
        type = 13;
        idc = 4112;
        style = 2 + 16;
        lineSpacing = 1;
        x = __X + 0.21;y = __Y + 0.41;
        w = 0.5;h = 0.12;
          sizeEx = 0.035;
        size = 0.035;
           colorBackground[] = { 0.1882, 0.2588, 0.149, 0 };
           colorText[] = { 0, 0, 0, 1 };
           text = "ACRE Version Mismatch";
           font = "TahomaB";
           class Attributes {
            font = "TahomaB";
            color = "#FF0F00";
            align = "left";
            shadow = false;
            };
        };
        class ACRE_VERSION_MISMATCH_LINE {
               idc = -1;
               type = 0;
               style = 176;
               x = __X + 0.2 + 0.01;y = __Y + 0.445;
            w = 0.58;h = 0.0;
            colorText[] = { 1, 1, 1, 1 };
            colorBackground[] = { 0.1882, 0.2588, 0.149, 0 };
            font = "TahomaB";
            sizeEx = 0.04;
            size = 0.04;
            text = "";
        };
    class ACRE_VERSION_MISMATCH_TEXT: ACRE_VERSION_MISMATCH_TITLE {
        idc = 114113;
        style = 0x00 ; // defined constant
        x = __X + 0.2;y = __Y + 0.446;
        w = 0.6;h = 0.25;
        sizeEx = 0.027;
        size = 0.027;
        text = "";
        class Attributes {
            font = "TahomaB";
            color = "#000000";
            align = "center";
            valign = "middle";
            shadow = false;
            shadowColor = "#ff0000";
            size = "1";
        };
    };
    class ACRE_VERSION_MISMATCH_LINE2 : ACRE_VERSION_MISMATCH_LINE {
           y = __Y + 0.65;
    };
    class ACRE_VERSION_MISMATCH_BUTT {
        idc = 114114;
        type = 11;
        style = 0x00;
        x = __X + 0.7;
        y = __Y + 0.7;
        w = 0.1;
        h = 0.035;
        font = "TahomaB";
        sizeEx = 0.018;
        size = 0.018;
        color[] = { 1, 1, 1, 1 };
        colorActive[] = { 1, 0.2, 0.2, 1 };
        soundEnter[] = { "", 0, 1 }; // no sound
        soundPush[] = { "", 0, 1 };
        soundClick[] = { "", 0, 1 };
        soundEscape[] = { "", 0, 1 };
        action = "closedialog 0";
        text = "";
        default = true;
    };
    class ACRE_VERSION_MISMATCH_HTML: ACRE_VERSION_MISMATCH_TITLE {
        idc = -1;
        x = __X + 0.2;y = __Y + 0.7;
        w = 0.575;h = 0.05;
        size = 0.027;
        colorText[] = { 1, 1, 1, 1 };
        sizeEx = 0.027;
        text = "http://dev-heaven.net/projects/activity/a2ts3";
        class Attributes {};
    };
};
