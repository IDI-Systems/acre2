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
["CAManBase", "Take", {_this call FUNC(handleTake)}] call CBA_fnc_addClassEventHandler;

["#Item", ["GROUND", "CARGO", "CONTAINER"], "Open Radio", [], ICON_RADIO_CALL,
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
    }
] call CBA_fnc_addItemContextMenuOption;


// Vehicle Info
// Show display when entering vehicle or moving to different slot
["vehicle", {
    params ["_player", "_newVehicle"];
    [_player, _newVehicle] call FUNC(enterVehicle);
}, true] call CBA_fnc_addPlayerEventHandler;
["turret", {
    params ["_player"];
    [_player, vehicle _player] call FUNC(enterVehicle);
}, true] call CBA_fnc_addPlayerEventHandler;

// Hide display when entering a feature camera
["featureCamera", {
    params ["_player", "_featureCamera"];

    if (_featureCamera isEqualTo "") then {
        [_player, vehicle _player] call FUNC(enterVehicle);
    } else {
        (QGVAR(vehicleInfo) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
    };
}, true] call CBA_fnc_addPlayerEventHandler;
