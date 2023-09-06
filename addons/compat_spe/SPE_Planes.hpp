 // see SPE_Tanks.hpp for explanation of values

class Plane_Base_F;

class SPE_Plane_base: Plane_Base_F {
    acre_hasInfantryPhone = 0;
    acre_infantryPhoneDisableRinging = 1;

    class AcreIntercoms {
        class Intercom_1 {
            displayName = CSTRING(Intercom_Crew);
            shortName = CSTRING(Intercom_Short);
            allowedPositions[] = {"crew"};
            disabledPositions[] = {};
            limitedPositions[] = {{"cargo", "all"}};
            masterPositions[] = {"crew"};
            numLimitedPositions = 1;
            connectedByDefault = 1;
        };
    };

    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_US);
            shortName = CSTRING(RadioSet1_Short);
            componentname = "ACRE_VRC64";
            allowedPositions[] = {"driver","copilot"};
            disabledPositions[] = {};
            defaultComponents[] = {};
            mountedRadio = "ACRE_PRC77";
            isRadioRemovable = 0;
            intercom[] = {"none"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_US);
            shortName = CSTRING(RadioSet2_Short);
            componentname = "ACRE_VRC64";
            allowedPositions[] = {"driver","copilot"};
            disabledPositions[] = {};
            defaultComponents[] = {};
            mountedRadio = "ACRE_PRC77";
            isRadioRemovable = 0;
            intercom[] = {"none"};
        };
    };
};

//American
class SPE_US_Plane_base;

class SPE_P47: SPE_US_Plane_base {
    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_US);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            allowedPositions[] = {"driver"};
            disabledPositions[] = {};
            defaultComponents[] = {};
            isRadioRemovable = 0;
            intercom[] = {"none"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_US);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            allowedPositions[] = {"driver"};
            disabledPositions[] = {};
            defaultComponents[] = {};
            isRadioRemovable = 0;
            intercom[] = {"none"};
        };
    };
};

//German
class SPE_GER_Plane_base;

class SPE_FW190F8: SPE_GER_Plane_base {
    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_GER);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            allowedPositions[] = {"driver"};
            disabledPositions[] = {};
            defaultComponents[] = {};
            isRadioRemovable = 0;
            intercom[] = {"none"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_GER);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            allowedPositions[] = {"driver"};
            disabledPositions[] = {};
            defaultComponents[] = {};
            isRadioRemovable = 0;
            intercom[] = {"none"};
        };
    };
};
