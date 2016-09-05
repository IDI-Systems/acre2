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
 *  This function sets the current volume state of
 *  the radio.
 *  Depending on the possible steps of the volume 
 *  for the radio, it is recommended to recheck if
 *  the actual value of the volume is in line with
 *  these steps. 
 *  The range must be between 0 and 1 as well.
 *
 *  Any kind of UI changes can be inserted here
 *  as well.
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      setVolume
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "setVolume")
 *      2:  Eventdata
 *          2.0:    Volume to set
 *      3:  Radiodata 
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      nil
*/

private ["_vol", "_currentMenu"];
params ["_radioId", "_event", "_eventData", "_radioData"];

private _vol = _eventData;

if(_vol%0.20 != 0) then {
    _vol = _vol-(_vol%0.20);
};

HASH_SET(_radioData, "volume", _eventData);
TRACE_3("VOLUME SET",_radioId, _vol, _radioData);