#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_getCurrentChannelData
 *
 * Public: No
 */

/*
 *  This function returns all specific data of the
 *  current channel.
 *
 *  Type of Event:
 *      Data
 *  Event:
 *      getCurrentChannelData
 *  Event raised by:
 *      - Several functions
 *
 *  Parsed parameters:
 *      0:  Radio ID
 *      1:  Event (-> "getCurrentChannelData")
 *      2:  Eventdata (-> [])
 *      3:  Radiodata
 *      4:  Remote Call (-> false)
 *
 *  Returned parameters:
 *      Hash containing all data of current channel
*/

params ["", "", "", "_radioData"];

/*
 *  First step is to retreive the hash of the desired channel
 *  which is contained in the _radioData -- channels hash.
*/
private _channelNumber = HASH_GET(_radioData,"currentChannel");
ISNILS(_channelNumber,0);
private _channels = HASH_GET(_radioData, "channels");
private _channel = HASHLIST_SELECT(_channels, _channelNumber);

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
