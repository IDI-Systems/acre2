/*
    Copyright © 2016,International Development & Integration Systems, LLC
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

/*
 *    This function is called when a radio is initialized.
 *    Initialization happens only once for each Radio ID.
 *    During the initialization the parsed preset is copied
 *    and together with other default values, the radio (id) is
 *    set to its initial state.
 *
 *    Type of Event:
 *        Data
 *    Event:
 *        initializeComponent
 *    Event raised by:
 *        - Uninitialized Radio is in invetory of player
 *
 *     Parsed parameters:
 *        0:    Radio ID
 *        1:    Event (-> "initializeComponent")
 *        2:    Eventdata
 *            2.0:    Baseclass of Radio
 *            2.1:    Preset
 *        3:    Radiodata (-> [])    
 *        4:    Remote Call (-> false)
 *
 *    Returned parameters:
 *        nil
*/

TRACE_1("INITIALIZING ACRE_SEM52SL", _this);

params ["_radioId", "_event", "_eventData", "_radioData"];

_eventData params ["_baseName", "_preset"];

/*
 *    To set the correct data for all available channels,
 *    the data from the preset hash must be transferred to 
 *    the radioData hash.
 *    In addition to that it is ensured that no transmission
 *    is registered to the radio ID.
 *    The last action is to write default values to the radioData
 *    hash, like "is the radio on?" or "default channel" etc.
*/

private _presetData = [_baseName, _preset] call EFUNC(sys_data,getPresetData);
private _channels = HASH_GET(_presetData,"channels");

SCRATCH_SET(_radioId, "currentTransmissions", []);

_currentChannels = HASH_GET(_radioData,"channels");
if(isNil "_currentChannels") then {
    _currentChannels = [];
    HASH_SET(_radioData,"channels",_currentChannels);
};

for "_i" from 0 to (count _channels)-1 do {
    _channelData = HASH_COPY(_channels select _i);
    TRACE_1("Setting " + QUOTE(RADIONAME) + " Init Channel Data", _channelData);
    PUSH(_currentChannels, _channelData);
};

HASH_SET(_radioData,"volume",1);
HASH_SET(_radioData,"radioOn",1);
HASH_SET(_radioData,"currentChannel",0);
HASH_SET(_radioData,"channelKnobPosition", 2); // Channel 1 (after on/off options)
HASH_SET(_radioData,"volumeKnobPosition", 0);// mid-way
HASH_SET(_radioData,"programmingStep", 0);
HASH_SET(_radioData,"lastActiveChannel",0);
HASH_SET(_radioData,"audioPath", "HEADSET");
