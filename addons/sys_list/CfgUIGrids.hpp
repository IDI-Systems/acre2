class CfgUIGrids {
    class IGUI {
        class Presets {
            class Arma3 {
                class Variables {
                    grid_ACRE_notification[] = {
                        {
                            "(SafeZoneX + SafeZoneW) - 0.352",
                            "(SafeZoneY + SafeZoneH) - 0.128",
                            "0.352",
                            "0.128"
                        },
                        "((safezoneW / safezoneH) min 1.2) / 40",
                        "(((safezoneW / safezoneH) min 1.2) / 1.2) / 25"
                    };
                };
            };
        };

        class Variables {
            class grid_ACRE_notification {
                displayName = CSTRING(NotificationGrid);
                description = CSTRING(NotificationGridDesc);
                preview = QPATHTOF(data\ui\IGUI_notification_preview_ca.paa);
                saveToProfile[] = {0,1,2,3};
                canResize = 0;
            };
        };
    };
};
