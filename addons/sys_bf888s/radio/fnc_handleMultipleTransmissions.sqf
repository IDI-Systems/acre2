#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles multiple transmissions in the "singleChannel" mode. In this mode, the following parameters
 * are used:
 *
 *  - frequencyTX
 *  - frequencyRX
 *  - power
 *  - mode
 *  - CTCSSTx
 *  - CTCSSRx
 *  - modulation
 *  - encryption
 *  - TEK
 *  - trafficRate
 *  - syncLength
 *
 * Depending on this parameters, the function determines if a transmission is usable by the radio or if it
 * is ignored.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "handleMultipleTransmission" <STRING> (Unused)
 * 2: Event data: transmitting radio IDs <ARRAY>
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * List of usable transmissions <ARRAY>
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "handleMultipleTransmissions", ["ACRE_BF888S_ID_2", "ACRE_BF888S_ID_3"], [], false] call acre_sys_bf888s_fnc_handleMultipleTransmissions
 *
 * Public: No
 */

params ["_radioId","","_radios"];

if !([_radioId] call EFUNC(sys_radio,canUnitReceive)) exitWith { [] };

if (SCRATCH_GET_DEF(_radioId, "PTTDown", false) && {!EGVAR(sys_core,fullDuplex)}) exitWith { [] };
private _beeped = SCRATCH_GET(_radioId, "hasBeeped");
private _found = false;
private _transmissionsChanged = false;

private _lastSignalTime = SCRATCH_GET_DEF(_radioId, "lastSignalTime", diag_tickTime-2);


if (diag_tickTime - _lastSignalTime > 1) then {
    SCRATCH_SET(_radioId, "currentTransmissions", []);
};

SCRATCH_SET(_radioId, "lastSignalTime", diag_tickTime);

private _currentTransmissions = SCRATCH_GET(_radioId, "currentTransmissions");
if (isNil "_currentTransmissions") then {
    _currentTransmissions = [];
    SCRATCH_SET(_radioId, "currentTransmissions", _currentTransmissions);
};
private _transmissions = [];
private _sortedRadios = [];
private _okRadios = [];

private _lastSortTime = SCRATCH_GET_DEF(_radioId, "lastSortTime", diag_tickTime-4);
private _radioCache = SCRATCH_GET_DEF(_radioId, "currentTransmissionRadioCache", []);

// Restort every 3 seconds no matter what.
if (diag_tickTime - _lastSortTime > 3) then {
    _transmissionsChanged = true;
} else {
    // Don't resort if we already resorted within the past second
    // If its been a second, lets check to see if the transmitters changed.
    //if (diag_tickTime - _lastSortTime > 1) then {
        if !(_radioCache isEqualTo []) then {
            // Compare BOTH arrays.
            {
                if !(_x in _radioCache) exitWith { _transmissionsChanged = true; };
            } forEach _radios;
            if (!_transmissionsChanged) then {
                {
                    if !(_x in _radios) exitWith { _transmissionsChanged = true; };
                } forEach _radioCache;
            };
        } else {
            // If the cache is empty, resort.
            _transmissionsChanged = true;
        };
    //};
};



if (_transmissionsChanged) then {
    private _areAllRadiosInitialized = true;

    if ((count _radios) > 1) then {
        private _sorted = [];
        {
            _x params ["","_txID","_signalData"];
            _signalData params ["_signalPercent"];
            if (_signalData isEqualTo [0, -992]) then {_areAllRadiosInitialized = false;};

            PUSH(_sorted, [ARR_2(_signalPercent, _forEachIndex)]);
            PUSH(_transmissions, _txId);
        } forEach _radios;
        _sorted sort false; // descending order

        {
            PUSH(_sortedRadios, (_radios select (_x select 1)));
        } forEach _sorted;
    } else {
        PUSH(_transmissions, ((_radios select 0) select 1));
        if (((_radios select 0) select 2) isEqualTo [0, -992]) then {_areAllRadiosInitialized = false;};
        _sortedRadios = _radios;
    };

    private _dif = _transmissions - _currentTransmissions;
    if !(_dif isEqualTo []) then {
        _currentTransmissions = _transmissions;
        SCRATCH_SET(_radioId, "currentTransmissions", _currentTransmissions);
    };


    private _radioRxData = [_radioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
    // diag_log text format["%1 NON-CACHED", diag_tickTime];
    if (HASH_GET(_radioRxData, "mode") == "singleChannel") then {
        private _hearableTransmissions = [];
        private _junkTransmissions = [];
        private _digital = false;
        {
            private _txId = _x select 1;
            private _radioTxData = [_txId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
            if (HASH_GET(_radioRxData, "modulation") == HASH_GET(_radioTxData, "modulation")) then {
                //diag_log text "MOD OK";
                if (HASH_GET(_radioRxData, "encryption") == 1 && {HASH_GET(_radioTxData, "encryption") == 1}) then {
                    //diag_log text "ENCRYPTED";
                    if (HASH_GET(_radioRxData, "TEK") == HASH_GET(_radioTxData, "TEK") &&
                        {HASH_GET(_radioRxData, "trafficRate") == HASH_GET(_radioTxData, "trafficRate")}
                    ) then {
                        //diag_log text "DIGITAL CRYPTO!";
                        PUSH(_hearableTransmissions, _x);
                        _digital = true;
                    } else {
                        PUSH(_junkTransmissions, _x);
                    };
                } else {
                    if (HASH_GET(_radioRxData, "encryption") == 0 && {HASH_GET(_radioTxData, "encryption") == 0}) then {
                        //diag_log text "PT!";
                        if (HASH_GET(_radioRxData, "modulation") == "FM" || {HASH_GET(_radioRxData, "modulation") == "NB"}) then {
                            //diag_log text "ITS FM BABY!";
                            if (HASH_GET(_radioRxData, "CTCSSRx") == HASH_GET(_radioTxData, "CTCSSTx") || {HASH_GET(_radioRxData, "CTCSSRx") == 0}) then {
                                //diag_log text "THE TONES MATCH!";
                                PUSH(_hearableTransmissions, _x);
                            } else {
                                //diag_log text format["NO TONE BONE: %1 == %2", HASH_GET(_radioRxData, "CTCSSRx"), HASH_GET(_radioTxData, "CTCSSTx")];
                                PUSH(_junkTransmissions, _x);
                            };
                        } else {
                            if (HASH_GET(_radioRxData, "modulation") == "AM") then {
                                //diag_log text "AM TALK JUNKIE!";
                                PUSH(_hearableTransmissions, _x);
                            } else {
                                PUSH(_junkTransmissions, _x);
                            };
                        };
                    } else {
                        PUSH(_junkTransmissions, _x);
                    };
                };
            } else {
                PUSH(_junkTransmissions, _x);
            };
        } forEach _sortedRadios;

        //diag_log text format["sorted: %1", _sortedRadios];
        //diag_log text format["junk: %1", _junkTransmissions];
        //diag_log text format["ok: %1", _hearableTransmissions];
        if (EGVAR(sys_core,interference)) then {
            if !(_hearableTransmissions isEqualTo []) then {
                _junkTransmissions = _hearableTransmissions + _junkTransmissions;
                _hearableTransmissions params ["_bestSignal"];
                (_bestSignal select 2) params ["_highestSignal", "_dbm"];
                private _newSignal = _highestSignal;
                //diag_log text format["new sig start: %1", _newSignal];
                for "_i" from 1 to (count _junkTransmissions) - 1 do {
                    private _data = _junkTransmissions select _i;
                    _data params ["", "_txId", "_signalData"];
                    _signalData params ["_signal"];
                    if (_newSignal <= 0) exitWith {
                        _newSignal = 0;
                    };
                    _newSignal = _newSignal * (1 - (_signal / _newSignal));
                    if (_newSignal <= 0) exitWith {
                        _newSignal = 0;
                    };
                };
                //diag_log text format["new sig end: %1", _newSignal];
                if (_newSignal > 0) then {
                    _okRadios = [_bestSignal];
                    _bestSignal set [2, [_newSignal, _dbm + _dbm * (1 - _newSignal/_highestSignal)]];
                } else {
                    _okRadios = [];
                };
            };
        } else {
            _okRadios = _hearableTransmissions;
        };
    };


    if !(_okRadios isEqualTo []) then {
        private _signalData = (_okRadios select 0) select 2;
        _signalData params ["_signalPercent","_signalDbM"];
        private _channelNum = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
        private _channels = [_radioId, "getState", "channels"] call EFUNC(sys_data,dataEvent);
        private _channel = HASHLIST_SELECT(_channels, _channelNum);
        private _squelch = (-116 - 7) + HASH_GET(_channel, "squelch");
        // diag_log text format["squelch: %1 signal: %2", _squelch, _signalDbM];
        if (_signalDbM < _squelch) then {
            _okRadios = [];
            private _pttDown = SCRATCH_GET_DEF(_radioId, "PTTDown", false);
            if (!_pttDown) then {
                if (!isNil "_beeped" && {_beeped}) then {
                    private _volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
                    [_radioId, "Acre_GenericClickOff", [0, 0, 0], [0, 1, 0], _volume] call EFUNC(sys_radio,playRadioSound);
                };
            };
            SCRATCH_SET(_radioId, "hasBeeped", false);
        } else {
            if (isNil "_beeped" || {!_beeped}) then {
                //diag_log "BEEP!";
                SCRATCH_SET(_radioId, "hasBeeped", true);
                private _volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
                [_radioId, "Acre_GenericClickOn", [0, 0, 0], [0, 1, 0], _volume] call EFUNC(sys_radio,playRadioSound);
            };
        };
    } else {
        private _pttDown = SCRATCH_GET_DEF(_radioId, "PTTDown", false);
        if (!_pttDown) then {
            if (!isNil "_beeped" && {_beeped}) then {
                private _volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
                [_radioId, "Acre_GenericClickOff", [0, 0, 0], [0, 1, 0], _volume] call EFUNC(sys_radio,playRadioSound);
            };
        };
        SCRATCH_SET(_radioId, "hasBeeped", false);
    };

    // Cache it
    SCRATCH_SET(_radioId, "currentTransmissionRadioCache", _okRadios);
    //Force a recalculation if data is not ready
    if (_areAllRadiosInitialized) then {
        SCRATCH_SET(_radioId, "lastSortTime", diag_tickTime);
    } else {
        SCRATCH_SET(_radioId, "lastSortTime", -4);
    };
} else {
    _okRadios = _radioCache;
};


// diag_log text format["m: %1", _mend-_mstart];
_okRadios
