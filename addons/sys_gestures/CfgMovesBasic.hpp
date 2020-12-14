class CfgMovesBasic {
    class DefaultDie;
    class ManActions {
        GVAR(helmet) = QGVAR(helmet);
        GVAR(helmet_noADS) = QGVAR(helmet_noADS);
        GVAR(vest) = QGVAR(vest);
        GVAR(vest_noADS) = QGVAR(vest_noADS);
        GVAR(stop) = QGVAR(stop);
    };
    class Actions {
        class Default;
        class NoActions: ManActions {
            GVAR(helmet)[] = {QGVAR(helmet), "Gesture"};
            GVAR(helmet_noADS)[] = {QGVAR(helmet_noADS), "Gesture"};
            GVAR(vest)[] = {QGVAR(vest), "Gesture"};
            GVAR(vest_noADS)[] = {QGVAR(vest_noADS), "Gesture"};
            GVAR(stop)[] = {QGVAR(stop), "Gesture"};
        };
    };
};
