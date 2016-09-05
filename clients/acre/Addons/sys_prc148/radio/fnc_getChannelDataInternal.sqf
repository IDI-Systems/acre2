//fnc_getChannelDataInternal.sqf
#include "script_component.hpp"

private ["_channels", "_channel", "_channelType", "_return"];
params["_channelNumber", "_radioData"];

_channels = HASH_GET(_radioData, "channels");
_channel = HASHLIST_SELECT(_channels, _channelNumber);

_channelType = HASH_GET(_channel, "channelMode");
_return = HASH_CREATE;
switch _channelType do {
	case "BASIC": {
		HASH_SET(_return, "mode", "singleChannel");
		HASH_SET(_return, "frequencyTX", HASH_GET(_channel, "frequencyTX"));
		HASH_SET(_return, "frequencyRX", HASH_GET(_channel, "frequencyRX"));
		HASH_SET(_return, "power", HASH_GET(_channel, "power"));
		HASH_SET(_return, "CTCSSTx", HASH_GET(_channel, "CTCSSTx"));
		HASH_SET(_return, "CTCSSRx", HASH_GET(_channel, "CTCSSRx"));
		HASH_SET(_return, "modulation", HASH_GET(_channel, "modulation"));
		HASH_SET(_return, "encryption", HASH_GET(_channel, "encryption"));
		HASH_SET(_return, "TEK", HASH_GET(_channel, "tek"));
		HASH_SET(_return, "trafficRate", HASH_GET(_channel, "trafficRate"));
		HASH_SET(_return, "syncLength", HASH_GET(_channel, "phase"));
	};
};
_return
