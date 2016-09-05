/*
    Copyright © 2016, International Development & Integration Systems, LLC
    All rights reserved.
    http://www.idi-systems.com/

    For personal use only. Military or commercial use is STRICTLY
    prohibited. Redistribution or modification of source code is
    STRICTLY prohibited.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
*/
#include "script_component.hpp"

params ["","_key"];

GVAR(backlightOn) = true;
GVAR(lastAction) = time;

private _currentDirection = -1;
if(_key == 0) then {
    // left click
    _currentDirection = 1;
};

private _knobPosition = ["getState", "channelKnobPosition"] call GUI_DATA_EVENT;
private _newKnobPosition = ((_knobPosition + _currentDirection) max 0) min 15;


if(_knobPosition != _newKnobPosition) then {
    ["setState", ["channelKnobPosition",_newKnobPosition]] call GUI_DATA_EVENT;
    private _currentChannel = ["getState", "currentChannel"] call GUI_DATA_EVENT;
    
    switch _newKnobPosition do {
        case 0: { // Off
            // Turn off
            [GVAR(currentRadioId), "setOnOffState", 0] call EFUNC(sys_data,dataEvent);
            
            // Erase Channel H (index=12)
            private _channels = GET_STATE(channels);
            private _channel = _channels select 12; // CHANNEL H
            HASH_SET(_channel,"frequencyRX",100);
            HASH_SET(_channel,"frequencyTX",100);
            ["setChannelData", [12, _channel]] call GUI_DATA_EVENT;
            
            GVAR(backlightOn) = false; // turn backlight off.
        };
        case 15: { // P - Programming
            // reset step
            
            private _isOn = ["getState", "radioOn"] call GUI_DATA_EVENT;
            if (_isOn == 1) then {
                [GVAR(currentRadioId), "setOnOffState", 0] call EFUNC(sys_data,dataEvent); // Turn Off (Disables incoming signals).
            };
            
            [GVAR(currentRadioId), "setState", ["programmingStep",0]] call EFUNC(sys_data,dataEvent);
            
            GVAR(selectionDir) = 0;
            GVAR(selectedChannel) = 12;
            GVAR(newFrequency) = 46;
            GVAR(alternate) = false;
            
            // ADD a PFH to keep things working.
            [{
                if (GVAR(currentRadioId) isEqualTo -1) exitWith {}; // While UI is closed hide.
                params ["","_handler"];
                // if we have left the programming mode exit.
                
                if  (([GVAR(currentRadioId), "getState", "channelKnobPosition"] call EFUNC(sys_data,dataEvent)) != 15) exitWith { [_handler] call CBA_fnc_removePerFrameHandler;}; //
                //blink.
                GVAR(alternate) = !GVAR(alternate);
                
                private _step = [GVAR(currentRadioId), "getState", "programmingStep"] call EFUNC(sys_data,dataEvent);
                switch (_step) do {
                    case 0: {
                        if (!GVAR(alternate)) then {
                            GVAR(selectedChannel) = GVAR(selectedChannel) + GVAR(selectionDir);
                            if (GVAR(selectionDir) != 0) then {
                                GVAR(alternate) = true; // if changing show on render and update faster.
                            };
                            if (GVAR(selectedChannel) < 0) then {
                                GVAR(selectedChannel) = 12;
                            };
                            if (GVAR(selectedChannel) > 12) then {
                                GVAR(selectedChannel) = 0;
                            };
                        };
                    };
                    case 1: { // MHZ cycle
                        if (!GVAR(alternate)) then {
                            GVAR(newFrequency) = GVAR(newFrequency) + GVAR(selectionDir);
                            if (GVAR(selectionDir) != 0) then {
                                GVAR(alternate) = true; // if changing show on render and update faster.
                            };
                            if (GVAR(newFrequency) < 46) then {
                                GVAR(newFrequency) = GVAR(newFrequency) + 20;
                            };
                            if (GVAR(newFrequency) >= 66) then {
                                GVAR(newFrequency) = GVAR(newFrequency) - 20;
                            };
                        };
                    };
                    case 2: { // KHZ Cycle
                        if (!GVAR(alternate)) then {
                            if (GVAR(selectionDir) != 0) then {
                                GVAR(alternate) = true; // if changing show on render and update faster.
                            };
                            private _floor = floor (GVAR(newFrequency));
                            private _dif = GVAR(newFrequency) - _floor;
                            _dif = _dif + GVAR(selectionDir)*0.025;
                            if (_dif >= 1) then {
                                _dif = 0;
                            };
                            if (_dif < 0) then {
                                _dif = 0.975;
                            };
                            GVAR(newFrequency) = _floor + _dif;
                        };
                    };
                };
                
                
                [MAIN_DISPLAY] call FUNC(render);
            },  0.55] call CBA_fnc_addPerFrameHandler;
        };
        default { // Handle all channels (1-12, H and EIN) in here for shortest code
    
        
            private _newChanNumber = (_newKnobPosition - 2);
            private _isOn = ["getState", "radioOn"] call GUI_DATA_EVENT;
            
            if (_newKnobPosition == 1) then { // EIN (ON)
                _newChanNumber = GET_STATE(lastActiveChannel); // use last active channel.
                
                if (_knobPosition == 0) then { //Last position was OFF
                    GVAR(booting) = true;
                    // Booting
                    [{
                        private _radioId = _this;
                        GVAR(booting) = false;

                        private _knobPosition = ["getState", "channelKnobPosition"] call GUI_DATA_EVENT;
                        private _currentChannel = ([_radioId, "getState", "currentChannel"] call EFUNC(sys_data,dataEvent));
                        private _channels = ([_radioId, "getState", "channels"] call EFUNC(sys_data,dataEvent));
                        private _channel = _channels select _currentChannel;
                        private _freq = HASH_GET(_channel,"frequencyRX");
                        
                        if (_freq < 69 && _knobPosition > 0 && _knobPosition < 15 && !(_knobPosition == 1 and {_currentChannel == 12 })) then {
                            [_radioId, "setOnOffState", 1] call EFUNC(sys_data,dataEvent); 
                        };
                        
                        if (GVAR(currentRadioId) isEqualTo _radioId) then {
                            [MAIN_DISPLAY] call FUNC(render);
                        };
                    }, GVAR(currentRadioId), 1.1] call CBA_fnc_waitAndExecute;
                };
            };
    
            private _channels = GET_STATE(channels);
            private _channel = _channels select _newChanNumber;
            private _freq = HASH_GET(_channel,"frequencyRX");
            
            if (!GVAR(booting)) then { // Don't change on/off while booting
                if (_freq > 70) then { // Invalid Freq (Turn off to prevent use.)
                    if (_isOn == 1) then {
                        [GVAR(currentRadioId), "setOnOffState", 0] call EFUNC(sys_data,dataEvent);
                    };
                } else {
                    // Valid freq turn on
                    if (_isOn != 1) then { // is off
                        [GVAR(currentRadioId), "setOnOffState", 1] call EFUNC(sys_data,dataEvent);
                    };
                };
            };

            // Switch Channel
            ["setCurrentChannel", _newChanNumber] call GUI_DATA_EVENT;
        };
    };

    ["Acre_SEM52Knob", [0,0,0], [0,0,0], 0.3, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call FUNC(render);
};
