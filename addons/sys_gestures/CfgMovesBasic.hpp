class CfgMovesBasic {
    class DefaultDie;
    class ManActions {
        acre_radio_helmet = "acre_radio_helmet";
        acre_radio_vest = "acre_radio_vest";
        acre_radio_stop = "acre_radio_stop";
    };
    class Actions {
        class Default;
        class NoActions: ManActions {
            acre_radio_helmet[] = {"acre_radio_helmet","Gesture"};
            acre_radio_vest[] = {"acre_radio_vest","Gesture"};
            acre_radio_stop[] = {"acre_radio_stop","Gesture"};
        };
    };
};