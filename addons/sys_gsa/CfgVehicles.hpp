class CBA_Extended_EventHandlers;

class CfgVehicles {
    class House;
    class vhf30108Item: House {
        class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {};
        };
        scope = 2;
        scopeCurator = 2;
        scopeArsenal = 2;
        displayName = "ACRE VHF30108 GSM";
        model = QPATHTOF(vhf30108\data\model\vhf30108.p3d);
        icon = QPATHTOF(vhf30108\data\ui\icon_antenna_ca.paa);
        editorPreview = "";
        vehicleClass = "Items";

        class ACE_Actions {
            class ACE_MainActions {
                selection = "interaction_point";
                distance = 5;
                condition = "(true)";

                class ACRE_pickup {
                    selection = "";
                    displayName = CSTRING(pickUp);
                    distance = 10;
                    condition = "{systemChat format ['testing']; true";
                    statement = //QUOTE([ARR_2(_player,_target)] call FUNC(pickup));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    //icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };

                class ACRE_mountMast {
                    selection = "";
                    displayName = CSTRING(removeMast);
                    distance = 10;
                    condition = "{systemChat format ['testing']; true";
                    statement = //QUOTE([ARR_2(_player,_target)] call FUNC(pickup));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    //icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };

                class ACRE_connect {
                    selection = "";
                    displayName = CSTRING(connect);
                    distance = 10;
                    condition = "(true)";
                    //wait a frame to handle "Do When releasing action menu key" option:
                    statement = //QUOTE([ARR_2({_this call FUNC(adjust)}, [ARR_2(_player,_target)])] call CBA_fnc_execNextFrame);
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };
            };
        };
    };
    class vhf30108spike: House {
        class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {};
        };

        scope = 2;
        scopeCurator = 2;
        scopeArsenal = 2;
        displayName = "ACRE VHF30108 GS";
        model = QPATHTOF(vhf30108\data\model\vhf30108spike.p3d);
        icon = QPATHTOF(vhf30108\data\ui\icon_antenna_ca.paa);
        editorPreview = "";
        vehicleClass = "Items";

        class ACE_Actions {
            class ACE_MainActions {
                selection = "interaction_point";
                distance = 5;
                condition = "(true)";

                class ACRE_pickup {
                    selection = "";
                    displayName = CSTRING(pickUp);
                    distance = 10;
                    condition = "{systemChat format ['testing']; true";
                    statement = //QUOTE([ARR_2(_player,_target)] call FUNC(pickup));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    //icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };

                class ACRE_mountMast {
                    selection = "";
                    displayName = CSTRING(mountMast);
                    distance = 10;
                    condition = "{systemChat format ['testing']; true";
                    statement = //QUOTE([ARR_2(_player,_target)] call FUNC(pickup));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    //icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };

                class ACRE_connect {
                    selection = "";
                    displayName = CSTRING(connect);
                    distance = 10;
                    condition = "(true)";
                    //wait a frame to handle "Do When releasing action menu key" option:
                    statement = //QUOTE([ARR_2({_this call FUNC(adjust)}, [ARR_2(_player,_target)])] call CBA_fnc_execNextFrame);
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };
            };
        };
    };
};
