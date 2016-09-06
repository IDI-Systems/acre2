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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"
private["_packet", "_data", "_header", "_id", "_received", "_type"];
_packet = copyFromClipboard;
_data = toArray _packet;
_id = "";
_received = "";
_header = "";
_type = -1;
if((count _data) >= 11) then {
    _header = toString[_data select 0, _data select 1, _data select 2];
    if(_header == PACKET_PREFIX || _header == REMOTE_PACKET_PREFIX) then {
        _type = parseNumber (toString [_data select 3]);
        for "_i" from 4 to 11 do {
            _id = _id + (toString [_data select _i]);
        };
        for "_i" from 12 to (count _data) - 1 do {
            _received = _received + (toString [_data select _i]);
        };
    };
};
[_header, _type, _id, _received]
