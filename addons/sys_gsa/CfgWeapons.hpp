#include "script_component.hpp"

class CfgWeapons {
    class CBA_MiscItem;
    class CBA_MiscItem_ItemInfo;

    class tfw_vhf30108: CBA_MiscItem {
        author[] = {"Raspu"};
        scope = 2;
        displayName = "VHF30108 GSM";
        descriptionShort = "VHF30108 Ground Spike Antenna with Mast";
        model = QPATHTOF(vhf30108\data\model\vhf30108.p3d);
        picture = PATHTOF(data\icons\icon_rf3080.paa);
        editorPreview = PATHTOF(data\icons\icon_rf3080.paa);

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 58;
        };
    };
    class tfw_vhf30108spike: CBA_MiscItem {
        author[] = {"Raspu"};
        scope = 2;
        displayName = "VHF30108 GS";
        descriptionShort = "VHF30108 Ground Spike Antenna";
        model = QPATHTOF(vhf30108\data\model\vhf30108spike.p3d);
        picture = PATHTOF(data\icons\icon_rf3080.paa);
        editorPreview = PATHTOF(data\icons\icon_rf3080.paa);

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 58;
        };
    };
};
