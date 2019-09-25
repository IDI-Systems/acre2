class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class ModuleDescription {
            class AnyPlayer;
            class AnyBrain;
            class EmptyDetector;
        };
    };

    class GVAR(Module_Base): Module_F {
        mapSize = 1;
        author = "ACRE2Team";
        vehicleClass = "Modules";
        category = "ACRE_BABEL";

        scope = 1;
        scopeCurator = 1;

        displayName = "ACRE Babel Module Base";

        function = "";
        functionPriority = 1;
        isGlobal = 2;
        isTriggerActivated = 0;
        isDisposable = 0;

        class Arguments {};
        class ModuleDescription: ModuleDescription {
            description = "ACRE Babel Module Base";
        };
    };

    class GVAR(Module_BabelLanguages): GVAR(Module_Base) {
        scopeCurator = 2;
        displayName = "Languages";
        curatorInfoType = QGVAR(RscBabelLanguages);
    };
};
