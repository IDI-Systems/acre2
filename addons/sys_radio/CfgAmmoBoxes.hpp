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

    model = QPATHOF(data\models\acre_radiobox.p3d);
    author[] = {"RanTa"};

    class TransportWeapons {};
    class TransportMagazines {};
};

