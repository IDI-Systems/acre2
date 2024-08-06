 // see SPE_Tanks.hpp for explanation of values

class Car_F;
class SPE_Car_base: Car_F { // Get rid of any inherited values ACRE may have added for modern vehicles
    acre_hasInfantryPhone = 0;
    acre_infantryPhoneDisableRinging = 1;
    acre_infantryPhonePosition[] = {0, 0, 0};
    acre_infantryPhoneControlActions[] = {};
    acre_infantryPhoneintercom[] = {};

    class AcreIntercoms {};
    class AcreRacks {};
};

class Truck_F;
class SPE_Truck_base: Truck_F { // Get rid of any inherited values
    acre_hasInfantryPhone = 0;
    acre_infantryPhoneDisableRinging = 1;
    acre_infantryPhonePosition[] = {0, 0, 0};
    acre_infantryPhoneControlActions[] = {};
    acre_infantryPhoneintercom[] = {};

    class AcreIntercoms {};
    class AcreRacks {};
};

class Wheeled_APC_F;
class SPE_ArmoredCar_base: Wheeled_APC_F { // Get rid of any inherited values
    acre_hasInfantryPhone = 0;
    acre_infantryPhoneDisableRinging = 1;
    acre_infantryPhonePosition[] = {0, 0, 0};
    acre_infantryPhoneControlActions[] = {};
    acre_infantryPhoneintercom[] = {};

    class AcreIntercoms {};
    class AcreRacks {};
};

class SPE_Halftrack_base;

class SPE_WheeledTracked_APC_base;

//American
class SPE_M8_LAC_base: SPE_ArmoredCar_base {
    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet);
            shortName = CSTRING(RadioSetShort);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            allowedPositions[] = {"driver", {"turret", {1}}}; // radio operator is in the front with the driver.
            disabledPositions[] = {};
            defaultComponents[] = {};
            isRadioRemovable = 0;
            intercom[] = {"none"};
        };
    };
};

class SPE_M20_AUC_Base: SPE_ArmoredCar_base {
    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_US);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            allowedPositions[] = {"driver", {"turret", {1}}}; // radio operator is in the front with the driver.
            disabledPositions[] = {};
            defaultComponents[] = {};
            isRadioRemovable = 0;
            intercom[] = {"none"};
        };
    };
    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet2_US);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            allowedPositions[] = {{"turret", {0}}, {"cargo", 0, 1, 2, 3}}; // Command radio accessible to the gunner and those around him
            disabledPositions[] = {};
            defaultComponents[] = {};
            isRadioRemovable = 0;
            intercom[] = {"none"};
        };
    };
};

class SPE_US_M16_Halftrack_base: SPE_Halftrack_base {
    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet);
            shortName = CSTRING(RadioSetShort);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            allowedPositions[] = {"driver", {"cargo", 0}}; // driver, and the passenger next to the driver can all probably reach the radio
            disabledPositions[] = {};
            defaultComponents[] = {};
            isRadioRemovable = 0;
            intercom[] = {"none"};
        };
    };
};

// German
class SPE_SdKfz250_base;

class SPE_SdKfz250_1: SPE_SdKfz250_base {
    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet);
            shortName = CSTRING(RadioSetShort);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            allowedPositions[] = {"driver", "commander", {"cargo", 0}}; // driver, commander (who is the gunner), and the passenger next to the driver can all probably reach the radio
            disabledPositions[] = {};
            defaultComponents[] = {};
            isRadioRemovable = 0;
            intercom[] = {"none"};
        };
    };
};
