//fnc_sc_speaking.sqf
#include "script_component.hpp"

params["_tx", "_txRadioId", "_rx", "_rxRadioId"];

// acre_player sideChat format["Radio speaking! %1", _this];
private _txData = [_txRadioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
private _txFreq = HASH_GET(_txData, "frequencyTX");
private _txPower = HASH_GET(_txData, "power");

private _maxSignal = [_txFreq, _txPower, _rxRadioId, _txRadioId] call EFUNC(sys_signal,getSignal);

private _return = [_txRadioId, _rxRadioId, _maxSignal select 0, _maxSignal select 1, 0];

_return
