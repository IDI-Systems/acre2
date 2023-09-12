#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_getChannelData
 *
 * Public: No
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

params ["", "", "_eventData", "_radioData"];

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
