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

/*
 *  This function returns all specific data of the
 *  channel which number is parsed to the event.
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      getChannelData
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "getChannelData")
 *      2:  Eventdata (-> Channel number)
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      Hash containing all data of parsed channel number
*/

#include "script_component.hpp"

params ["_radioId", "_event", "_eventData", "_radioData"];

/*
 *  First step is to retreive the hash of the desired channel
 *  which is contained in the _radioData -- channels hash.
*/
private _channelNumber = _eventData;
private _channels = HASH_GET(_radioData, "channels");
private _channel = HASHLIST_SELECT(_channels, _channelNumber);

/*
 *  All needed data from the channel hash can be extracted and
 *  consequently written to the _return hash.
 *
 *  Optional:
 *  Here we have the opportunity to add static data to the
 *  channel data hash. This can be useful if the radio has
 *  only one power setting. While this data can be stored in
 *  the _radioData -- channels hash it would only add unneccessary
 *  data as the value can't be changed ingame.
 *  For our example, we also got the "mode" parameter set to
 *  "singleChannel" for all channels.
*/
private _return = HASH_CREATE;
HASH_SET(_return, "mode", GVAR(channelMode));
HASH_SET(_return, "frequencyTX", HASH_GET(_channel, "frequencyTX"));
HASH_SET(_return, "frequencyRX", HASH_GET(_channel, "frequencyRX"));
HASH_SET(_return, "CTCSSTx", GVAR(channelCTCSS));
HASH_SET(_return, "CTCSSRx", GVAR(channelCTCSS));
HASH_SET(_return, "modulation", GVAR(channelModulation));
HASH_SET(_return, "encryption", GVAR(channelEncryption));
HASH_SET(_return, "power", GVAR(channelPower));
HASH_SET(_return, "squelch", GVAR(channelSquelch));
_return
