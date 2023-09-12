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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_handleSignalData
 *
 * Public: No
 */

private _eventData = _this select 2;
/*
_txId = _eventData select 0;
_rxId = _eventData select 1;

_radioTxData = [_txId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
_radioRxData = [_rxId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);

if (
    HASH_GET(_radioRxData, "modulation") == HASH_GET(_radioTxData, "modulation") &&
    {HASH_GET(_radioRxData, "encryption") == HASH_GET(_radioTxData, "encryption")} &&
    {HASH_GET(_radioRxData, "TEK") == HASH_GET(_radioTxData, "TEK")} &&
    {HASH_GET(_radioRxData, "trafficRate") == HASH_GET(_radioTxData, "trafficRate")} &&
    {(
        HASH_GET(_rxChannel, "CTCSSRx") == HASH_GET(_radioTxData, "CTCSSTx") ||
        {HASH_GET(_rxChannel, "CTCSSRx") == 0}
    )}
) then {
    _hearableTransmission = SCRATCH_GET(_rxId, "hearableTransmission");
    if (isNil "_hearableTransmission") then {
        _hearableTransmission = [];
        SCRATCH_SET(_rxId, "hearableTransmission", _hearableTransmission);
    };
    if (!(_txId in _hearableTransmission)) then {
        PUSH(_hearableTransmission, _txId);
    };
};
*/
_eventData;
