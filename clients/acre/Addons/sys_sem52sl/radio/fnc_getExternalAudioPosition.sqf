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
 *  This function is called when a radio has an internal speaker
 *  and this radio is receiving a transmission or making sounds.
 *  It shall define the ingame position where the speaker is
 *  located for correct 3d Audio playback
 *
 *  Type of Event:
 *      Physical
 *  Event:
 *      getExternalAudioPosition
 *  Event raised by:
 *      - Incoming Transmission and Speaker activated
 *      - Radio is playing a sound and Speaker activated
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "getExternalAudioPosition")
 *      2:  Eventdata (-> [])
 *      3:  Radiodata   
 *      4:  Remote Call (-> false)
 *
 *  Return parameters:
 *      - Position of Radio Speaker
*/

/*
 *  If the radio is equiped with an internal speaker,
 *  a position on the right shoulder is used as 
 *  return value
*/

params ["_radioId", "_event", "_eventData", "_radioData"];

private _obj = RADIO_OBJECT(_radioId);
private _pos = getPosASL _obj;
if(_obj isKindOf "Man") then {
    _pos = ATLtoASL (_obj modelToWorldVisual (_obj selectionPosition "RightShoulder"));
};

_pos;