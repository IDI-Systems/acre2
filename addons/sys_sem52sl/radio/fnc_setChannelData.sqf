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
 *  Via this function the data of a specific channel
 *  can be changed. It is used mostly for radios which are
 *  capable of ingame-programming. For this example it is not
 *  used at all.
 *  
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      setChannelData
 *  Event raised by:
 *      - No specific function
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "setChannelData")
 *      2:  Eventdata
 *          2.x: Data to be parsed (changed)   
 *      3:  Radiodata 
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      nil
*/

params ["_radioId",  "_event", "_eventData", "_radioData"];

private _channels = HASH_GET(_radioData, "channels");

HASHLIST_SET(_channels, (_eventData select 0), (_eventData select 1));

true


