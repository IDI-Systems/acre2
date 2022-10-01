#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initializes the inventory display by hiding the radio slot and
 * monitoring item movement to hold off radio item checks.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [DISPLAY] call acre_sys_gui_fnc_initDisplayInventory
 *
 * Public: No
 */

params ["_display"];

// Hide the ItemRadio slot
private _ctrlRadioSlot = _display displayCtrl IDC_FG_RADIO;
_ctrlRadioSlot ctrlSetPosition [0, 0, 0, 0];
_ctrlRadioSlot ctrlCommit 0;

// Ground
private _ctrlGroundItems = _display displayCtrl IDC_FG_GROUND_ITEMS;

_ctrlGroundItems ctrlAddEventHandler ["MouseButtonDown", {
    _this call FUNC(inventoryListMouseDown);
}];

_ctrlGroundItems ctrlAddEventHandler ["MouseButtonUp", {
    // Make sure any moved ItemRadio is actually fully moved before resetting hold off
    [FUNC(inventoryListMouseUp), _this, 1] call CBA_fnc_waitAndExecute;
}];

// Container
private _ctrlContainerItems = _display displayCtrl IDC_FG_CHOSEN_CONTAINER;

_ctrlContainerItems ctrlAddEventHandler ["MouseButtonDown", {
    _this call FUNC(inventoryListMouseDown);
}];

_ctrlContainerItems ctrlAddEventHandler ["MouseButtonUp", {
    // Make sure any moved ItemRadio is actually fully moved before resetting hold off
    [FUNC(inventoryListMouseUp), _this, 1] call CBA_fnc_waitAndExecute;
}];

// Show channel/frequency information for radios
private _fnc_update = {
    params ["_display"];

    private _pttAssign = [] call EFUNC(api,getMultiPushToTalkAssignment);

    {
        private _ctrl = _display displayCtrl _x;

        for "_i" from 0 to (lbSize _ctrl - 1) do {
            private _item = _ctrl lbData _i;

            if (_item call EFUNC(api,isRadio)) then {
                private _name = _item call EFUNC(api,getDisplayName);

                // Display frequency for single-channel radios (e.g. AN/PRC-77)
                private _maxChannels = [_item, "getState", "channels"] call EFUNC(sys_data,dataEvent);

                private _text = if (isNil "_maxChannels") then {
                    private _txData = [_item, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
                    private _currentFreq = HASH_GET(_txData, "frequencyTX");
                    format ["%1 %2 MHz", _name, _currentFreq];
                } else {
                    format [LELSTRING(ace_interact,channelShort), _name, _item call EFUNC(api,getRadioChannel)]
                };

                // Display radio keys in front of bound radios
                // Case-insentive since PTT API function returns radio class in lower case while
                // inventory display provides it in config case
                private _radioKey = (_pttAssign findIf {_x == _item}) + 1;

                if (_radioKey > 0 && {_radioKey < 4}) then {
                    _text = format ["%1: %2", _radioKey, _text];
                };

                _ctrl lbSetText [_i, _text];
            };
        };
    } forEach [
        IDC_FG_UNIFORM_CONTAINER,
        IDC_FG_VEST_CONTAINER,
        IDC_FG_BACKPACK_CONTAINER,
        IDC_FG_GROUND_ITEMS,
        IDC_FG_CHOSEN_CONTAINER
    ];
};

_display displayAddEventHandler ["MouseHolding", _fnc_update];
_display displayAddEventHandler ["MouseMoving", _fnc_update];
