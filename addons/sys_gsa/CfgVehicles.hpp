class CBA_Extended_EventHandlers;

class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ACE_Equipment {
                class GVAR(placeSpike) {
                    displayName = CSTRING(placeSpike);
                    condition = QUOTE([ARR_2(_player,'ACRE_VHF30108SPIKE')] call EFUNC(sys_core,hasItem) || [ARR_2(_player,'ACRE_VHF30108')] call EFUNC(sys_core,hasItem));
                    statement = QUOTE([ARR_3(_player,'ACRE_VHF30108SPIKE',false)] call FUNC(deploy));
                    showDisabled = 0;
                    icon = QPATHTOF(data\vhf30108\ui\icon_antenna_ca.paa);
                };

                class GVAR(placeSpikeMast) {
                    displayName = CSTRING(placeSpikeMast);
                    condition = QUOTE([ARR_2(_player,'ACRE_VHF30108')] call EFUNC(sys_core,hasItem));
                    statement = QUOTE([ARR_3(_player,'ACRE_VHF30108',true)] call FUNC(deploy));
                    showDisabled = 0;
                    icon = QPATHTOF(data\vhf30108\ui\icon_antenna_ca.paa);
                };

                class GVAR(placeAntenna) {
                    displayName = CSTRING(placeAntenna);
                    condition = QUOTE([ARR_2(_player,'ACRE_12FT_ANTENNA')] call EFUNC(sys_core,hasItem));
                    statement = QUOTE([ARR_3(_player,'ACRE_12FT_ANTENNA',false)] call FUNC(deploy));
                    showDisabled = 0;
                    icon = QPATHTOF(data\vhf30108\ui\icon_antenna_ca.paa);
                };
            };
        };
    };

    class House;
    class vhf30108Item: House {
        class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {};
        };

        scope = 2;
        scopeCurator = 2;
        scopeArsenal = 2;
        displayName = "ACRE VHF30108 GSM";
        model = QPATHTOF(data\vhf30108\models\vhf30108.p3d);
        icon = QPATHTOF(data\vhf30108\ui\icon_antenna_ca.paa);
        editorPreview = QPATHTOF(data\vhf30108\ui\spikeMast.jpg);
        vehicleClass = "Items";

        class AcreComponents {
            componentName = "ACRE_643CM_VHF_TNC";
            mountedAntenna = "vhf30108spike";
            mastMount[] = {};
        };

        class ACE_Actions {
            class ACE_MainActions {
                selection = "interaction_point";
                distance  = 5;
                condition = "(true)";

                class ACRE_pickup {
                    selection = "";
                    displayName = CSTRING(pickUp);
                    distance = 10;
                    condition = "true";
                    statement = QUOTE([ARR_2(_player,_target)] call DFUNC(pickUp));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    //icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };

                class ACRE_removeMast {
                    selection = "";
                    displayName = CSTRING(removeMast);
                    distance = 10;
                    condition = "true";
                    statement = QUOTE([ARR_3(_player,_target,false)] call DFUNC(handleMast));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    //icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };

                class ACRE_connect {
                    selection = "";
                    displayName = CSTRING(connect);
                    distance = 10;
                    condition = QUOTE(!([ARR_2(_player,_target)] call DFUNC(isAntennaConnected)) && {[ARR_2(_player,_target)] call DFUNC(hasCompatibleRadios)});
                    statement = QUOTE(true);
                    insertChildren = QUOTE([ARR_2(_player,_target)] call DFUNC(connectChildrenActions));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };

                class ACRE_disconnect {
                    selection = "";
                    displayName = CSTRING(disconnect);
                    distance = 10;
                    condition = QUOTE([ARR_2(_player,_target)] call DFUNC(isAntennaConnected));
                    statement = QUOTE([ARR_2(_player,_target)] call DFUNC(disconnect));
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
        model = QPATHTOF(data\vhf30108\models\vhf30108spike.p3d);
        icon = QPATHTOF(data\vhf30108\ui\icon_antenna_ca.paa);
        editorPreview = QPATHTOF(data\vhf30108\ui\spike.jpg);
        vehicleClass = "Items";

        class AcreComponents {
            componentName = "ACRE_243CM_VHF_TNC";
            mountedAntenna = "";
            mastMount[] = {"vhf30108Item"};
        };

        class ACE_Actions {
            class ACE_MainActions {
                selection = "interaction_point";
                distance = 10;
                condition = "(true)";

                class ACRE_pickup {
                    selection = "";
                    displayName = CSTRING(pickUp);
                    distance = 10;
                    condition = "true";
                    statement = QUOTE([ARR_2(_player,_target)] call DFUNC(pickUp));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    //icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };

                class ACRE_mountMast {
                    selection = "";
                    displayName = CSTRING(mountMast);
                    distance = 10;
                    condition = QUOTE([ARR_2(_player,'ACRE_VHF30108MAST')] call DEFUNC(sys_core,hasItem) || [ARR_2(_player,'ACRE_VHF30108')] call DEFUNC(sys_core,hasItem));
                    statement = QUOTE([ARR_3(_player,_target,true)] call DFUNC(handleMast));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    //icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };

                class ACRE_connect {
                    selection = "";
                    displayName = CSTRING(connect);
                    distance = 10;
                    condition = QUOTE(!([ARR_2(_player,_target)] call DFUNC(isAntennaConnected)));
                    statement = QUOTE(true);
                    insertChildren = QUOTE([ARR_2(_player,_target)] call DFUNC(connectChildrenActions));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };

                class ACRE_disconnect {
                    selection = "";
                    displayName = CSTRING(disconnect);
                    distance = 10;
                    condition = QUOTE([ARR_2(_player,_target)] call DFUNC(isAntennaConnected));
                    statement = QUOTE([ARR_2(_player,_target)] call DFUNC(disconnect));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };
            };
        };
    };

    class ws38_12ft_antenna: House {
        class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {};
        };

        scope = 2;
        scopeCurator = 2;
        scopeArsenal = 2;
        displayName = "ACRE WS38 12 feet antenna";
        model = QPATHTOEF(sys_ws38,data\Models\ws38_radio_antenna.p3d);
        icon = QPATHTOF(data\vhf30108\ui\icon_antenna_ca.paa);
        editorPreview = QPATHTOF(data\ws38_antenna\ui\12ft_antenna.jpg);
        vehicleClass = "Items";
        ace_dragging_canCarry = 1;
        ace_dragging_carryPosition[] = {-0.2, 1, 1.3};
        ace_dragging_carryDirection = 0;
        ace_dragging_ignoreWeightCarry = 1;

        class AcreComponents {
            componentName = "ACRE_12FT_AERIAL_ROD";
            mountedAntenna = "";
            mastMount[] = {};
        };

        class ACE_Actions {
            class ACE_MainActions {
                selection = "interaction_point";
                distance = 10;
                condition = "(true)";
                position = "[0.2,0.0,-1.5]";

                class ACRE_pickup {
                    selection = "";
                    displayName = CSTRING(pickUp);
                    distance = 10;
                    condition = "true";
                    statement = QUOTE([ARR_2(_player,_target)] call DFUNC(pickUp));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    //icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };

                class ACRE_connect {
                    selection = "";
                    displayName = CSTRING(connect);
                    distance = 10;
                    condition = QUOTE(!([ARR_2(_player,_target)] call DFUNC(isAntennaConnected)));
                    statement = QUOTE(true);
                    insertChildren = QUOTE([ARR_2(_player,_target)] call DFUNC(connectChildrenActions));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };

                class ACRE_disconnect {
                    selection = "";
                    displayName = CSTRING(disconnect);
                    distance = 10;
                    condition = QUOTE([ARR_2(_player,_target)] call DFUNC(isAntennaConnected));
                    statement = QUOTE([ARR_2(_player,_target)] call DFUNC(disconnect));
                    showDisabled = 0;
                    exceptions[] = {};
                    priority = 5;
                    icon = "\idi\acre\addons\ace_interact\data\icons\antenna.paa";
                };
            };
        };
    };
};
