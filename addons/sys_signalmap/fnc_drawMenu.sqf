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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_drawMenu;
 *
 * Public: No
 */

with uiNamespace do {
    GVAR(debugIdc) = 13121;


    GVAR(completedAreas) = [];
    GVAR(currentArgs) = [];
    GVAR(areaProgress) = 0;
    FUNC(formatNumber) = {
        private _ext = abs _this - (floor abs _this);
        private _str = "";
        for "_i" from 1 to 8 do {
            private _d = floor (_ext*10);
            _str = _str + (str _d);
            _ext = (_ext*10)-_d;
        };
        format["%1%2.%3", ["","-"] select (_this < 0), (floor (abs _this)), _str];
    };

    { diag_log text format["clean up: %1", _x]; ctrlDelete _x; } forEach GVAR(signal_debug);


    GVAR(signal_debug) = [];

    GVAR(mapTiles) = [];
    for "_i" from 1 to 50 do {
        private _tile = GVAR(mapDisplay) ctrlCreate ["RscPicture", 120101+_i];
        GVAR(mapTiles) pushBack _tile;
        GVAR(signal_debug) pushBack _tile;
    };

    GVAR(ctrlGroup) = GVAR(mapDisplay) ctrlCreate ["RscControlsGroupNoScrollbars", 13120];
    GVAR(signal_debug) pushBack GVAR(ctrlGroup);

    GVAR(ctrlGroup) ctrlSetBackgroundColor [1,1,0,1];
    GVAR(ctrlGroup) ctrlSetForegroundColor [1,1,0,1];

    GVAR(ctrlGroup) ctrlSetPosition [safezoneX + safezoneW - 0.5, safezoneY + safezoneH - 1, 0.5, 0.75];
    GVAR(ctrlGroup) ctrlCommit 0;

    private ["_background"];
    CTRL(_background,"RscBackground");

    //_background ctrlSetBackgroundColor [0.8,0.75,0.35,0.75];

    _background ctrlSetPosition [0, 0, 0.5, 0.75];
    _background ctrlCommit 0;

    CTRL(GVAR(txAntennaListBox),"RscCombo");

    GVAR(txAntennaListBox) ctrlSetPosition [0.15, 0, 0.35, 0.045];
    private _components = configFile >> "CfgAcreComponents";
    private _c = 0;
    for "_i" from 0 to (count _components) - 1 do {
        private _component = _components select _i;
        private _type = getNumber (_component >> "type");
        if (_type == ACRE_COMPONENT_ANTENNA) then {
            if (getText (_component >> "binaryGainFile") != "") then {
                GVAR(txAntennaListBox) lbAdd (getText(_component >> "name"));
                GVAR(txAntennaListBox) lbSetData [_c, (configName _component)];
                diag_log text format["d: %1", GVAR(txAntennaListBox) lbData _c];
                _c = _c + 1;
            };
        };
    };
    GVAR(txAntennaListBox) lbSetCurSel (uiNamespace getVariable [QGVAR(txAntennaListBoxValue), 0]);
    GVAR(txAntennaListBox) ctrlCommit 0;

    private ["_txAntText"];
    CTRL(_txAntText,"RscText");
    _txAntText ctrlSetPosition [0.0, 0, 0.35, 0.045];
    _txAntText ctrlSetText "Tx Antenna: ";
    _txAntText ctrlCommit 0;

    CTRL(GVAR(txHeight),"RscEdit");
    GVAR(txHeight) ctrlSetPosition [0.15, 0.055, 0.1, 0.045];
    GVAR(txHeight) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(txHeight) ctrlSetText str (uiNamespace getVariable [QGVAR(txHeightValue), 2]);
    GVAR(txHeight) ctrlCommit 0;

    private ["_txHeightTxt"];
    CTRL(_txHeightTxt,"RscText");
    _txHeightTxt ctrlSetPosition [0.0, 0.055, 0.35, 0.045];
    _txHeightTxt ctrlSetText "Tx Height: ";
    _txHeightTxt ctrlCommit 0;

    CTRL(GVAR(txDir),"RscEdit");
    GVAR(txDir) ctrlSetPosition [0.35, 0.055, 0.1, 0.045];
    GVAR(txDir) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(txDir) ctrlSetText str (uiNamespace getVariable [QGVAR(txDirValue), 0]);
    GVAR(txDir) ctrlCommit 0;

    private ["_txDirTxt"];
    CTRL(_txDirTxt,"RscText");
    _txDirTxt ctrlSetPosition [0.26, 0.055, 0.35, 0.045];
    _txDirTxt ctrlSetText "Tx Dir: ";
    _txDirTxt ctrlCommit 0;


    CTRL(GVAR(rxAntennaListBox),"RscCombo");

    GVAR(rxAntennaListBox) ctrlSetPosition [0.15, 0.055*2, 0.35, 0.045];
    _components = configFile >> "CfgAcreComponents";
    _c = 0;
    for "_i" from 0 to (count _components) - 1 do {
        private _component = _components select _i;
        private _type = getNumber(_component >> "type");
        if (_type == ACRE_COMPONENT_ANTENNA) then {
            if (getText(_component >> "binaryGainFile") != "") then {
                GVAR(rxAntennaListBox) lbAdd (getText(_component >> "name"));
                GVAR(rxAntennaListBox) lbSetData [_c, (configName _component)];
                _c = _c + 1;
            };
        };
    };
    GVAR(rxAntennaListBox) lbSetCurSel (uiNamespace getVariable [QGVAR(rxAntennaListBoxValue), 0]);
    GVAR(rxAntennaListBox) ctrlCommit 0;

    private ["_rxAntText"];
    CTRL(_rxAntText,"RscText");
    _rxAntText ctrlSetPosition [0.0, 0.055*2, 0.35, 0.045];
    _rxAntText ctrlSetText "Rx Antenna: ";
    _rxAntText ctrlCommit 0;

    CTRL(GVAR(rxHeight),"RscEdit");
    GVAR(rxHeight) ctrlSetPosition [0.15, 0.055*3, 0.1, 0.045];
    GVAR(rxHeight) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(rxHeight) ctrlSetText str (uiNamespace getVariable [QGVAR(rxHeightValue), 2]);
    GVAR(rxHeight) ctrlCommit 0;

    private ["_rxHeightTxt"];
    CTRL(_rxHeightTxt,"RscText");
    _rxHeightTxt ctrlSetPosition [0.0, 0.055*3, 0.35, 0.045];
    _rxHeightTxt ctrlSetText "Rx Height: ";
    _rxHeightTxt ctrlCommit 0;

    CTRL(GVAR(sampleSize),"RscEdit");
    GVAR(sampleSize) ctrlSetPosition [0.42, 0.055*3, 0.07, 0.045];
    GVAR(sampleSize) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(sampleSize) ctrlSetText str (uiNamespace getVariable [QGVAR(sampleSizeValue), 50]);
    GVAR(sampleSize) ctrlCommit 0;

    private ["_txSampleSizeTxt"];
    CTRL(_txSampleSizeTxt,"RscText");
    _txSampleSizeTxt ctrlSetPosition [0.26, 0.055*3, 0.35, 0.045];
    _txSampleSizeTxt ctrlSetText "Sample Size: ";
    _txSampleSizeTxt ctrlCommit 0;

    CTRL(GVAR(txFreq),"RscEdit");
    GVAR(txFreq) ctrlSetPosition [0.15, 0.055*4, 0.2, 0.045];
    GVAR(txFreq) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(txFreq) ctrlSetText str (uiNamespace getVariable [QGVAR(txFreqValue), 65]);
    GVAR(txFreq) ctrlCommit 0;

    CTRL(_rxHeightTxt,"RscText");
    _rxHeightTxt ctrlSetPosition [0.0, 0.055*4, 0.35, 0.045];
    _rxHeightTxt ctrlSetText "Frequency: ";
    _rxHeightTxt ctrlCommit 0;

    CTRL(_rxHeightTxt,"RscText");
    _rxHeightTxt ctrlSetPosition [0.35, 0.055*4, 0.35, 0.045];
    _rxHeightTxt ctrlSetText "MHz";
    _rxHeightTxt ctrlCommit 0;

    CTRL(GVAR(txPower),"RscEdit");
    GVAR(txPower) ctrlSetPosition [0.15, 0.055*5, 0.2, 0.045];
    GVAR(txPower) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(txPower) ctrlSetText str (uiNamespace getVariable [QGVAR(txPowerValue), 4000]);
    GVAR(txPower) ctrlCommit 0;

    CTRL(_rxHeightTxt,"RscText");
    _rxHeightTxt ctrlSetPosition [0.0, 0.055*5, 0.35, 0.045];
    _rxHeightTxt ctrlSetText "Tx Power: ";
    _rxHeightTxt ctrlCommit 0;

    CTRL(_rxHeightTxt,"RscText");
    _rxHeightTxt ctrlSetPosition [0.35, 0.055*5, 0.35, 0.045];
    _rxHeightTxt ctrlSetText "mW";
    _rxHeightTxt ctrlCommit 0;

    CTRL(GVAR(rxSensitivity),"RscEdit");
    GVAR(rxSensitivity) ctrlSetPosition [0.15, 0.055*6, 0.2, 0.045];
    GVAR(rxSensitivity) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(rxSensitivity) ctrlSetText str (uiNamespace getVariable [QGVAR(rxSensitivityValue), -116]);
    GVAR(rxSensitivity) ctrlCommit 0;

    CTRL(_rxHeightTxt,"RscText");
    _rxHeightTxt ctrlSetPosition [0.0, 0.055*6, 0.35, 0.045];
    _rxHeightTxt ctrlSetText "Sensitivity: ";
    _rxHeightTxt ctrlCommit 0;

    CTRL(_rxHeightTxt,"RscText");
    _rxHeightTxt ctrlSetPosition [0.35, 0.055*6, 0.35, 0.045];
    _rxHeightTxt ctrlSetText "dBm (min)";
    _rxHeightTxt ctrlCommit 0;

    CTRL(GVAR(rxSensitivityUpper),"RscEdit");
    GVAR(rxSensitivityUpper) ctrlSetPosition [0.15, 0.055*7, 0.2, 0.045];
    GVAR(rxSensitivityUpper) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(rxSensitivityUpper) ctrlSetText str (uiNamespace getVariable [QGVAR(rxSensitivityUpperValue), -50]);
    GVAR(rxSensitivityUpper) ctrlCommit 0;

    CTRL(_rxHeightTxt,"RscText");
    _rxHeightTxt ctrlSetPosition [0.0, 0.055*7, 0.35, 0.045];
    _rxHeightTxt ctrlSetText "Sensitivity: ";
    _rxHeightTxt ctrlCommit 0;

    CTRL(_rxHeightTxt,"RscText");
    _rxHeightTxt ctrlSetPosition [0.35, 0.055*7, 0.35, 0.045];
    _rxHeightTxt ctrlSetText "dBm (max)";
    _rxHeightTxt ctrlCommit 0;

    CTRL(GVAR(setTxPosButton),"RscButton");
    GVAR(setTxPosButton) ctrlSetPosition [0.05, 0.055*8, 0.4, 0.045];
    GVAR(setTxPosButton) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(setTxPosButton) ctrlSetText "Set Tx Position";
    GVAR(setTxPosButton) ctrlSetEventHandler ["MouseButtonUp", QUOTE(_this call FUNC(setTxPositionStart))];
    GVAR(setTxPosButton) ctrlCommit 0;

    CTRL(GVAR(txPositionTxt),"RscEdit");
    GVAR(txPositionTxt) ctrlSetPosition [0.15, 0.055*9, 0.35, 0.045];
    GVAR(txPositionTxt) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(txPositionTxt) ctrlSetText "";
    GVAR(txPositionTxt) ctrlCommit 0;

    CTRL(_rxHeightTxt,"RscText");
    _rxHeightTxt ctrlSetPosition [0.0, 0.055*9, 0.35, 0.045];
    _rxHeightTxt ctrlSetText "Tx Position: ";
    _rxHeightTxt ctrlCommit 0;

    CTRL(GVAR(addRxAreaButton),"RscButton");
    GVAR(addRxAreaButton) ctrlSetPosition [0.05, 0.055*10, 0.4, 0.045];
    GVAR(addRxAreaButton) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(addRxAreaButton) ctrlSetText "Add Rx Area";
    GVAR(addRxAreaButton) ctrlSetEventHandler ["MouseButtonUp", QUOTE(_this call FUNC(addRxAreaStart))];
    GVAR(addRxAreaButton) ctrlCommit 0;

    CTRL(GVAR(rxAreaList),"RscCombo");

    GVAR(rxAreaList) ctrlSetPosition [0.05, 0.055*11, 0.3, 0.045];
    _components = configFile >> "CfgAcreComponents";
    private _i = 0;
    {
        GVAR(rxAreaList) lbAdd format["%1: %2", _forEachIndex + 1, (_x select 0)];
        GVAR(rxAreaList) lbSetData [_i, str _forEachIndex];
        _i = _i + 1;
    } forEach GVAR(rxAreas);
    GVAR(rxAreaList) ctrlAddEventHandler ["LBSelChanged", {call FUNC(onAreaLBChange)}];
    GVAR(rxAreaList) lbSetCurSel 0;
    GVAR(rxAreaList) ctrlCommit 0;

    CTRL(GVAR(addRxAreaButton),"RscButton");
    GVAR(addRxAreaButton) ctrlSetPosition [0.355, 0.055*11, 0.095, 0.045];
    GVAR(addRxAreaButton) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(addRxAreaButton) ctrlSetText "Delete";
    GVAR(addRxAreaButton) ctrlSetEventHandler ["MouseButtonUp", QUOTE(_this call FUNC(deleteRxArea))];
    GVAR(addRxAreaButton) ctrlCommit 0;

    CTRL(GVAR(addRxAreaButton),"RscButton");
    GVAR(addRxAreaButton) ctrlSetPosition [0.05, 0.055*12.5, 0.4, 0.045];
    GVAR(addRxAreaButton) ctrlSetBackgroundColor [0,0,0,0.25];
    GVAR(addRxAreaButton) ctrlSetText "Process";
    GVAR(addRxAreaButton) ctrlSetEventHandler ["MouseButtonUp", QUOTE(_this call FUNC(doProcess))];
    GVAR(addRxAreaButton) ctrlCommit 0;

};
