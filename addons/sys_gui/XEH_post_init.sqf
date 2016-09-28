#include "script_component.hpp"

NO_DEDICATED;

[] call FUNC(enableZeusOverlay);

// TODO - Look into this below.
acre_player addEventHandler ["take", {
    params ["","_container","_itemType"];

    _simulationType = getText(configFile >> "CfgWeapons" >> _itemType >> "simulation");

    if(_simulationType == "ItemRadio") then {
        // _allowedSlots = getArray(configFile >> "CfgWeapons" >> _itemType >> "itemInfo" >> "allowedSlots");
        // acre_player sideChat format["this: %1", acre_player canAdd _itemType];
        if(!(acre_player canAdd _itemType)) then {
            // acre_player sideChat format["items: %1", items acre_player];
            if(!(_itemType in (items acre_player))) then {
                _container addItemCargoGlobal [_itemType, 1];
            };
        };
        // acre_player assignItem "ItemRadioAcreFlagged";
    };
}];


// Register volume control key handlers
["ACRE2", "VolumeControl", "Volume Control", FUNC(onVolumeControlKeyPress), FUNC(onVolumeControlKeyPressUp), [15, [false, false, false]]] call cba_fnc_addKeybind;
