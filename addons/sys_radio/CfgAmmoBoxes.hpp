#include "script_component.hpp"

class ReammoBox;
class ACRE_RadioBox_Base: ReammoBox {
    scope = 1;
    displayName = CSTRING(acreBaseBox);
    vehicleClass = "ACRE_Radio_Box";
};

class ACRE_RadioBox: ACRE_RadioBox_Base {
    scope = 2;
    displayName = CSTRING(allRadioCrate);

    model = QPATHOF(data\models\acre_radiobox.p3d);
    author[] = {"RanTa"};

    class TransportWeapons {};
    class TransportMagazines {};
};
