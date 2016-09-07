#include "script_component.hpp"

NO_DEDICATED;

ADDON = false;

// Volume control
PREP(openVolumeControl);
PREP(closeVolumeControl);
PREP(onVolumeControlAdjust);
PREP(onVolumeControlKeyPress);
PREP(onVolumeControlKeyPressUp);
PREP(onVolumeControlSliderChanged);
PREP(setVolumeSliderColor);

PREP(enableZeusOverlay);
PREP(setZeusOverlayDetail);
PREP(disableZeusOverlay);

PREP(openInventory);
PREP(closeInventory);

PREP(onInventoryRadioSelected);
PREP(onInventoryRadioDoubleClick);

ACRE_HOLD_OFF_ITEMRADIO_CHECK = false;
DFUNC(inventoryListMouseDown) = {
    if((_this select 1) == 1) then {
        ACRE_HOLD_OFF_ITEMRADIO_CHECK = true;
        acre_player unassignItem "ItemRadioAcreFlagged";
        acre_player removeItem "ItemRadioAcreFlagged";
    };
};

DFUNC(inventoryListMouseUp) = {
    if((_this select 1) == 1) then {
        ACRE_HOLD_OFF_ITEMRADIO_CHECK = false;
    };
};

//[] call FUNC(initializeVolumeControl);

DVAR(ACRE_CustomVolumeControl) = nil;
GVAR(VolumeControl_Level) = 0; // range of -2 to +2
GVAR(keyBlock) = false;

ADDON = true;
