class B_SPE_AssaultPack_Base;

// American
class B_SPE_US_Radio: B_SPE_AssaultPack_Base {
    class TransportItems {
        class _xx_ACRE_PRC77 {
            count = 1;
            name = "ACRE_PRC77";
        };
    };
};

// German
class B_SPE_GER_Radio: B_SPE_AssaultPack_Base {
    class TransportItems {
        class _xx_ACRE_PRC77 {
            count = 1;
            name = "ACRE_PRC77";
        };
    };
};

/*
class B_SPE_GER_Radio_battery: B_SPE_GER_Radio {
    //This is just a battery, no radio, remove class TransportItems to prevent inheriting ACRE_PRC77?
};
*/

//Vichy France
class B_SPE_Milice_Radio: B_SPE_AssaultPack_Base {
    class TransportItems {
        class _xx_ACRE_PRC77 {
            count = 1;
            name = "ACRE_PRC77";
        };
    };
};

/*
class B_SPE_Milice_Radio_battery: B_SPE_Milice_Radio {
    //This is just a battery, no radio, remove class TransportItems to prevent inheriting ACRE_PRC77?
};
*/
