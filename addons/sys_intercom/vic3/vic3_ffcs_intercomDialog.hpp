class VIC3FFCS_IntercomDialog {
    idd = 31337;
    MovingEnable = 0;
    onUnload = QUOTE(['closeGui'] call GUI_INTERACT_EVENT);
    onLoad = QUOTE(_this call FUNC(render));
    controlsBackground[] = {VIC3FFCSBackground};
    objects[] = {};
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
        text = "";
    };
};
