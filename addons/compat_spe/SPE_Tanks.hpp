class Tank_F;

class SPE_Tank_base: Tank_F {
    // Adds a full crew intercom, and a radio configurable by the entire crew, and infantry phone is set up but disabled.
    // This isn't historically accurate, but will ensure that any new vehicles get comms even if they don't have a vehicle specific config

    acre_hasInfantryPhone = 0; // Should the infantry phone exist? 0 disabled, 1 enabled
    acre_infantryPhoneDisableRinging = 1; // Should the phone ring when the crew activate it? 0 will ring, 1 disabled, disable for now as WW2 tanks didn't ring as far as I know.
    // acre_infantryPhoneCustomRinging[] = {"xxxxx\xxxxx\xxxxx.wss", 7, 1, 1, 40}; // Custom ringing sound, no point for now as tank ringing is disabled above
    acre_infantryPhonePosition[] = {0, 0, 0}; // Location of ace interaction node for infantry phone, model relative.
    acre_infantryPhoneControlActions[] = {"all"}; // which units can control the ringing, all or an intercom classname
    acre_infantryPhoneIntercom[] = {"all"}; // all or list of intercoms that are connected to the phone

    class AcreIntercoms {
        class Intercom_1 {
            displayName = CSTRING(Intercom_Crew);
            shortName = CSTRING(Intercom_Short);
            allowedPositions[] = {"crew"};
            disabledPositions[] = {};
            limitedPositions[] = {};
            masterPositions[] = {"commander"};
            numLimitedPositions = 0;
            connectedByDefault = 1;
        };
    };

    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet);
            shortName = CSTRING(RadioSetShort);
            mountedRadio = "ACRE_PRC77"; // This is the only analog radio currently in ACRE and is the best fit for the WW2 time perios.
            componentname = "ACRE_VRC64"; // This is the rack that the radio attaches to, PRC 77 requires the VRC 64.
            defaultComponents[] = {}; // Not yet fully implemented in ACRE
            allowedPositions[] = {"crew"}; // which positions have full access to the radio, including listening (Rx), speaking (Tx), and configuration.
                                           // In the base config here we're allowing the entire crew, which will ensure that all tanks have a functional radio even if a custom implementation hasn't been created below.
            disabledPositions[] = {{"turnedout", "all"}}; // by default if you turn out you can't use the radio anymore
            isRadioRemovable = 0; // 0 prevents the radio from being removed and used as an infantry radio.
            intercom[] = {"intercom_1"}; // list of intercoms that can talk over the radio even if not a slot in allowedPositions
        };
    };

    class Turrets;
};

    // American
class SPE_M10_base: SPE_Tank_base {
    class AcreRacks {
        class Rack_1 {
            allowedPositions[] = {"commander", {"turret", {1}}}; // restrict configuration of the radio to only and radio operator (historically correct) and the the commander (for gameplay, even though the radio was in the hull)
        };
    };
};

class SPE_M18_Hellcat_Base: SPE_Tank_base {
    class AcreRacks {
        class Rack_1 {
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // restrict radio configuration to the commander, gunner, and loader, as the radio was in the turret
        };
    };
};

class SPE_Sherman_base: SPE_Tank_base {
    acre_hasInfantryPhone = 1; // The Sherman was the first tank to get an infantry phone
    acre_infantryPhoneDisableRinging = 1;
    acre_infantryPhonePosition[] = {0, -2.52, 0};

    class AcreRacks {
        class Rack_1 {
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
        };
    };
};

class SPE_M4A1_75;
class SPE_M4A1_75_Command: SPE_M4A1_75 {
    displayName = CSTRING(M4A1_75_Command);
    scope = 2;

    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_US);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_US);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
    };
};
class SPE_M4A1_75_Command_DVL: SPE_M4A1_75_Command {
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};

class SPE_FR_M4A1_75;
class SPE_FR_M4A1_75_Command: SPE_FR_M4A1_75 {
    displayName = CSTRING(M4A1_75_Command);
    scope = 2;

    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_US);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_US);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
    };
};
class SPE_FR_M4A1_75_Command_DVL: SPE_FR_M4A1_75_Command {
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};

class SPE_M4A1_76;
class SPE_M4A1_76_Command: SPE_M4A1_76 {
    displayName = CSTRING(M4A1_76_Command);
    scope = 2;

    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_US);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_US);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
    };
};
class SPE_M4A1_76_Command_DVL: SPE_M4A1_76_Command {
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};

class SPE_FR_M4A1_76;
class SPE_FR_M4A1_76_Command: SPE_FR_M4A1_76 {
    displayName = CSTRING(M4A1_76_Command);
    scope = 2;

    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_US);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_US);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
    };
};
class SPE_FR_M4A1_76_Command_DVL: SPE_FR_M4A1_76_Command {
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};

class SPE_M4A0_75_Early;
class SPE_M4A0_75_Early_Command: SPE_M4A0_75_Early {
    displayName = CSTRING(M4A0_75_Early_Command);
    scope = 2;

    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_US);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_US);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
    };
};
class SPE_M4A0_75_Early_Command_DVL: SPE_M4A0_75_Early_Command {
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};

class SPE_M4A0_75;
class SPE_M4A0_75_Command: SPE_M4A0_75 {
    displayName = CSTRING(M4A0_75_Command);
    scope = 2;

    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_US);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_US);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
    };
};
class SPE_M4A0_75_Command_DVL: SPE_M4A0_75_Command {
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};

class SPE_FR_M4A0_75_Early;
class SPE_FR_M4A0_75_Early_Command: SPE_FR_M4A0_75_Early {
    displayName = CSTRING(M4A0_75_Early_Command);
    scope = 2;

    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_US);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_US);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
    };
};
class SPE_FR_M4A0_75_Early_Command_DVL: SPE_FR_M4A0_75_Early_Command {
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};

class SPE_FR_M4A0_75_mid;
class SPE_FR_M4A0_75_mid_Command: SPE_FR_M4A0_75_mid {
    displayName = CSTRING(M4A0_75_Command);
    scope = 2;

    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_US);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_US);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
    };
};
class SPE_FR_M4A0_75_mid_Command_DVL: SPE_FR_M4A0_75_mid {
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};

    // German
//Panzer III
class SPE_PzKpfwIII_Base: SPE_Tank_base {
    class AcreRacks {
        class Rack_1 {
            allowedPositions[] = {"commander", {"turret", {1}}}; // commander and radio operator/machine gunner, radio in hull
        };
    };

    class Turrets;
};
class SPE_PzKpfwIII_M: SPE_PzKpfwIII_Base {
    class Turrets : Turrets {
        class kurs_MG_turret;
    };
};

class SPE_PzBefWgIII_K_Base: SPE_PzKpfwIII_M { //Command Tank Base, inherit from Panzer III Ausf M because that's the version the Ausf K was based on.
    scope = 1;

    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_GER);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", {"turret", {5}}}; // commander and radio operator/machine gunner, radio in hull
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_GER);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
    };

    //Remove the front MG and change machine gunner to radio operator
    class Turrets: Turrets {
        class kurs_MG_turret : kurs_MG_turret {
            weapons[] = {};
            magazines[] = {};
            gunnerName = CSTRING(RadioOperator);
        };
    };
};
class SPE_PzBefWgIII_K: SPE_PzBefWgIII_K_Base { //Werhmacht
    author = "Heavy Ordnance Works";
    dlc = "SPE";
    scope = 2;
    displayName = CSTRING(PzBefWgIII_K);
    //side = 1;
    //faction = "SPE_WEHRMACHT";
    //crew = "SPE_GER_tank_crew";
};
class SPE_PzBefWgIII_K_DLV: SPE_PzBefWgIII_K { //Werhmacht DVL
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};
class SPE_ST_PzBefWgIII_K: SPE_PzBefWgIII_K { //Sturmtroopers
    scope = 2;
    //crew = "SPE_sturmtrooper_tank_crew";
    //faction = "SPE_STURM";
};
class SPE_ST_PzBefWgIII_K_DLV: SPE_ST_PzBefWgIII_K { //Sturmtroopers DVL
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};

//Panzer IV
class SPE_PzKpfwIV_G_base: SPE_Tank_base {
    class AcreRacks {
        class Rack_1 {
            allowedPositions[] = {"commander", {"turret", {5}}}; // commander and radio operator/machine gunner, radio in hull
        };
    };
};

class SPE_PzBefWgIV_base: SPE_PzKpfwIV_G_base { //Command Tank Base
    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_GER);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", {"turret", {5}}}; // commander and radio operator/machine gunner, radio in hull
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_GER);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
    };
};
class SPE_PzBefWgIV: SPE_PzBefWgIV_base { //Werhmacht
    author = "Heavy Ordnance Works";
    dlc = "SPE";
    scope = 2;
    displayName = CSTRING(PzBefWgIV);
};
class SPE_PzBefWgIV_DLV: SPE_PzBefWgIV { //Werhmacht Driverless
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};
class SPE_ST_PzBefWgIV: SPE_PzBefWgIV { //Sturmtroopers
    scope = 2;
};
class SPE_ST_PzBefWgIV_DLV: SPE_ST_PzBefWgIV { //Sturmtroopers Driverless
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};

//Panzer VI (Tiger I)
class SPE_PzKpfwVI_H1_base: SPE_Tank_base {
    class AcreRacks {
        class Rack_1 {
            allowedPositions[] = {"commander", {"turret", {5}}}; // commander and radio operator/machine gunner, radio in hull
        };
    };
};

class SPE_PzBefWgVI_base: SPE_PzKpfwVI_H1_base { //Command Tank Base
    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_GER);
            shortName = CSTRING(RadioSet1_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", {"turret", {5}}}; // commander and radio operator/machine gunner, radio in hull
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
        class Rack_2 {
            displayName = CSTRING(RadioSet2_GER);
            shortName = CSTRING(RadioSet2_Short);
            mountedRadio = "ACRE_PRC77";
            componentname = "ACRE_VRC64";
            defaultComponents[] = {};
            allowedPositions[] = {"commander", "gunner", {"turret", {0,1}}}; // commander, gunner, and loader, radio in turret
            disabledPositions[] = {{"turnedout", "all"}};
            isRadioRemovable = 0;
            intercom[] = {"intercom_1"};
        };
    };
};
class SPE_PzBefWgVI: SPE_PzBefWgVI_base { //Werhmacht
    author = "Heavy Ordnance Works";
    dlc = "SPE";
    scope = 2;
    displayName = "PzBefWg VI";
};
class SPE_PzBefWgVI_DLV: SPE_PzBefWgVI { //Werhmacht Driverless
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};
class SPE_ST_PzBefWgVI: SPE_PzBefWgVI { //Sturmtroopers
    scope = 2;
};
class SPE_ST_PzBefWgVI_DLV: SPE_ST_PzBefWgVI { //Sturmtroopers Driverless
    vehicleClass = "Armored_DLV";
    editorSubCategory = "SPE_EdSubcat_Tanks_DLV";
    hasDriver = -1;
};

class SPE_Nashorn_base: SPE_Tank_base {
    class AcreRacks {
        class Rack_1 {
            displayName = CSTRING(RadioSet1_GER);
            shortName = CSTRING(RadioSet1_Short);
            allowedPositions[] = {"commander", "gunner", {"turret", {2}}}; // commander, gunner, loader, radio is in an open top fighting compartment
        };
        class Rack_2: Rack_1 {
            displayName = CSTRING(RadioSet2_GER);
            shortName = CSTRING(RadioSet2_Short);
            allowedPositions[] = {{"turret", {3}}}; // radio operator, radio in hull
            intercom[] = {};
        };
    };
};
