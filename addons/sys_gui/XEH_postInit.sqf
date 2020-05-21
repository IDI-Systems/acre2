#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

if (!hasInterface) exitWith {};


// Volume Control - keybind, unit change event, and scroll wheel EH
["ACRE2", "VolumeControl", localize LSTRING(VolumeControl),
    LINKFUNC(volumeKeyDown),
    LINKFUNC(volumeKeyUp),
[DIK_TAB, [false, false, false]], true] call CBA_fnc_addKeybind;

["unit", LINKFUNC(volumeKeyUp)] call CBA_fnc_addPlayerEventHandler;
["MouseZChanged", LINKFUNC(onMouseZChanged)] call CBA_fnc_addDisplayHandler;

[] call FUNC(antennaElevationDisplay);


// Inventory
["CAManBase", "InventoryOpened", {
    [{
        !isNull INVENTORY_DISPLAY
    }, FUNC(handleInventoryOpened), [], 10] call CBA_fnc_waitUntilAndExecute; // Make sure inventory UI is created
}] call CBA_fnc_addClassEventHandler;

["#Item", ["GROUND", "CARGO", "CONTAINER"], LSTRING(Open), [], ICON_RADIO_CALL,
    [
        {true},
        {
            params ["", "", "_item"];
            _item call EFUNC(sys_radio,isUniqueRadio)
        }
    ],
    {
        params ["", "", "_item"];
        [_item] call FUNC(openRadio);
        false // Close menu
    }
] call CBA_fnc_addItemContextMenuOption;
