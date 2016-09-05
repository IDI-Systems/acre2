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
 *  This function sets the spatialization state of
 *  the radio. The spatialization is set through
 *	a "setState" Event. It is generally recommended
 *	to insert a check if the values are safe for this
 *	kind of parameter. 
 *	Spatial settings are -1/0/1 for left/center/right
 *	if set through the keybindings. Nevertheless
 *	they could represent any other numeric value.
 *	However this is not recommended because of possible
 *	confusion for the player.
 *  
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      setSpatial
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "setSpatial")
 *      2:  Eventdata
 *          2.0:    Spatialization to set
 *      3:  Radiodata 
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      nil
*/

params ["_radioId",  "_event", "_eventData", "_radioData"];

private _spatial = _eventData;

if(_spatial in [-1,0,1]) then {
	[_radioId, "setState", ["ACRE_INTERNAL_RADIOSPATIALIZATION", _spatial]] call EFUNC(sys_data,dataEvent);
};

