class RscControlsGroup;
class RscControlsGroupNoScrollbars;
class RscEdit;
class RscListNBox;

class RscDisplayAttributes {
    class Controls {
        class Background;
        class Title;
        class Content: RscControlsGroup {
            class controls;
        };
        class ButtonOk;
        class ButtonCancel;
    };
};

class GVAR(RscBabelLanguages): RscDisplayAttributes {
    onLoad = QUOTE([ARR_3('onLoad', _this, QQGVAR(RscBabelLanguages))] call FUNC(zeusAttributes));
    onUnload = QUOTE([ARR_3('onUnload', _this, QQGVAR(RscBabelLanguages))] call FUNC(zeusAttributes));
    class Controls: Controls {
        class Background: Background {};
        class Title: Title {};
        class Content: Content {
            class Controls {
                class babelLanguages: RscControlsGroupNoScrollbars {
                    onSetFocus = QUOTE(_this call FUNC(ui_babelLanguages));
                    idc = IDC_LANGUAGES;
                    x = 0;
                    y = 0;
                    w = POS_W(18);
                    h = POS_H(14.3);
                    class controls {
                        class List: RscListNBox {
                            idc = IDC_LIST;
                            x = 0;
                            y = 0;
                            w = POS_W(18);
                            h = POS_H(13);
                            disableOverflow = 1;
                        };
                        class IDBar: RscEdit {
                            idc = IDC_ID_BAR;
                            x = 0;
                            y = POS_H(13.3);
                            w = POS_W(2);
                            h = POS_H(1);
                            sizeEx = POS_H(0.9);
                        };
                        class NameBar: RscEdit {
                            idc = IDC_NAME_BAR;
                            x = POS_W(2.2);
                            y = POS_H(13.3);
                            w = POS_w(8);
                            h = POS_H(1);
                            sizeEx = POS_H(0.9);
                        };
                    };
                };
            };
        };
        class ButtonOK: ButtonOK {};
        class ButtonCancel: ButtonCancel {};
    };
};
