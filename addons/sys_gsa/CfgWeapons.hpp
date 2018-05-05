#include "script_component.hpp"

class CfgWeapons {
    class CBA_MiscItem;
    class CBA_MiscItem_ItemInfo;

    class acre2_vhf30108: CBA_MiscItem {
        author[] = {"Raspu"};
        scope = 2;
        displayName = "VHF30108 GSM";
        descriptionShort = "VHF30108 Ground Spike Antenna with Mast";
        //model = QPATHTOF(vhf30108\data\model\vhf30108.p3d);
        //picture = QPATHTOF(data\icons\icon_rf3080.paa);
        //editorPreview = QPATHTOF(data\icons\icon_rf3080.paa);

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 58;
        };
    };
    class acre2_vhf30108spike: CBA_MiscItem {
        author[] = {"Raspu"};
        scope = 2;
        displayName = "VHF30108 GS";
        descriptionShort = "VHF30108 Ground Spike Antenna";
        //model = QPATHTOF(vhf30108\data\model\vhf30108.p3d);
        //picture = QPATHTOF(data\icons\icon_rf3080.paa);
        //editorPreview = QPATHTOF(data\icons\icon_rf3080.paa);

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 58;
        };
    };

    class acre2_vhf30108mast: CBA_MiscItem {
        author[] = {"Raspu"};
        scope = 2;
        displayName = "VHF30108 Mast";
        descriptionShort = "VHF30108 Mast";
        //model = QPATHTOF(vhf30108\data\model\vhf30108.p3d);
        //picture = QPATHTOF(data\icons\icon_rf3080.paa);
        //editorPreview = QPATHTOF(data\icons\icon_rf3080.paa);

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 58;
        };
    };
};
