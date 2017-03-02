#include "script_component.hpp"

class ReammoBox;
class ACRE_RadioBox_Base: ReammoBox {
    scope = 1;
    displayName = "ACRE Base Box";
    vehicleClass = "ACRE_Radio_Box";
};

class ACRE_RadioBox: ACRE_RadioBox_Base {
    scope = 2;
    displayName = "All Radio Crate";

    model = "\Ca\misc\Misc_cargo_cont_tiny";

    class TransportWeapons {
    };
    class TransportMagazines {
    };
};

// create
