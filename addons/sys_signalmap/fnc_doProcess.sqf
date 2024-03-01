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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_doProcess;
 *
 * Public: No
 */

with uiNamespace do {
    private _txAntennaName = GVAR(txAntennaListBox) lbData (lbCurSel GVAR(txAntennaListBox));
    GVAR(txAntennaListBoxValue) = lbCurSel GVAR(txAntennaListBox);

    GVAR(txHeightValue) = parseNumber (ctrlText GVAR(txHeight));

    private _txDir = [1, (parseNumber (ctrlText GVAR(txDir)))*-1, 0] call cba_fnc_polar2vect;
    GVAR(txDirValue) = (parseNumber (ctrlText GVAR(txDir)));

    private _rxAntennaName = GVAR(rxAntennaListBox) lbData (lbCurSel GVAR(rxAntennaListBox));
    GVAR(rxAntennaListBoxValue) = lbCurSel GVAR(rxAntennaListBox);

    GVAR(rxHeightValue) = parseNumber (ctrlText GVAR(rxHeight));

    private _sampleSize = floor (parseNumber (ctrlText GVAR(sampleSize)));
    if (_sampleSize < 1) exitWith {
        hint format["The sample size must be equal to or larger than 1."];
    };
    GVAR(sampleSizeValue) = _sampleSize;

    private _frequency = parseNumber (ctrlText GVAR(txFreq));
    if (_frequency < 30) exitWith {
        hint format["The frequency must be equal to or larger than 30MHz."];
    };
    GVAR(txFreqValue) = _frequency;

    private _power = parseNumber (ctrlText GVAR(txPower));
    if (_power <= 0) exitWith {
        hint format["The Tx power must be larger than 0mW."];
    };
    GVAR(txPowerValue) = _power;

    private _lowerSensitivity = parseNumber (ctrlText GVAR(rxSensitivity));
    private _upperSensitivity = parseNumber (ctrlText GVAR(rxSensitivityUpper));

    if (_lowerSensitivity > _upperSensitivity) exitWith {
        hint format["The upper sensitivity must be larger than the lower sensitivity."];
    };

    GVAR(rxSensitivityValue) = _lowerSensitivity;
    GVAR(rxSensitivityUpperValue) = _upperSensitivity;

    if (isNil QGVAR(txPosition)) exitWith {
        hint format["Please set the Tx position."];
    };

    if (count GVAR(rxAreas) == 0) exitWith {
        hint format["Please set at least one Rx area."];
    };
    GVAR(completedAreas) = [];
    GVAR(areaProgress) = 0;



    GVAR(ctrlGroup) ctrlShow false;
    GVAR(ctrlGroup) ctrlCommit 0;
    GVAR(overlayMessageGrp) = GVAR(mapDisplay) ctrlCreate ["RscControlsGroupNoScrollbars", 13119];
    GVAR(signal_debug) pushBack GVAR(overlayMessageGrp);
    GVAR(overlayMessageGrp) ctrlSetPosition [safezoneX + safezoneW - 0.5, safezoneY + safezoneH - 1, 0.5, 0.75];
    GVAR(overlayMessageGrp) ctrlCommit 0;
    ctrlSetFocus GVAR(overlayMessageGrp);

    private ["_bg"];
    CTRLOVERLAY(_bg,"RscBackground");
    _bg ctrlSetPosition [0, 0, 0.5, 0.75];
    _bg ctrlCommit 0;

    CTRLOVERLAY(GVAR(chunkProgressText),"RscStructuredText");
    GVAR(chunkProgressText) ctrlSetPosition [0.0, 0.25, 0.5, 0.045];
    GVAR(chunkProgressText) ctrlCommit 0;

    CTRLOVERLAY(GVAR(progressBar),"RscProgress");
    GVAR(progressBar) ctrlSetPosition [0.025, 0.3, 0.45, 0.045];
    GVAR(progressBar) ctrlCommit 0;
    GVAR(progressBar) progressSetPosition 0;

    CTRLOVERLAY(GVAR(areaProgressText),"RscStructuredText");
    GVAR(areaProgressText) ctrlSetPosition [0.0, 0.35, 0.5, 0.045];
    GVAR(areaProgressText) ctrlSetStructuredText (parseText format["<t align='center'>Processing Area: %1 of %2</t>", GVAR(areaProgress)+1, (count GVAR(rxAreas))]);
    GVAR(areaProgressText) ctrlCommit 0;

    CTRLOVERLAY(GVAR(progressBarArea),"RscProgress");
    GVAR(progressBarArea) ctrlSetPosition [0.025, 0.4, 0.45, 0.045];
    GVAR(progressBarArea) ctrlCommit 0;
    GVAR(progressBarArea) progressSetPosition 0;
    GVAR(currentId) = format["%1_%2_%3_signalmap", worldName, floor diag_tickTime, _sampleSize];
    GVAR(currentArgs) = [];
    {
        private _args = [
            format["%1_%2", GVAR(currentId), _forEachIndex],
            _sampleSize,
            +((_x select 0) select 0),
            +((_x select 0) select 1),
            +GVAR(txPosition),
            +_txDir,
            GVAR(txHeightValue),
            GVAR(rxHeightValue),
            _txAntennaName,
            _rxAntennaName,
            _frequency,
            _power,
            _lowerSensitivity,
            _upperSensitivity,
            EGVAR(sys_signal,omnidirectionalRadios)
        ];
        GVAR(currentArgs) pushBack +_args;
        with missionNamespace do {
            //IGNORE_PRIVATE_WARNING ["_args"];
            [
                "signal_map",
                _args,
                true,
                {
                    with uiNamespace do {
                        INFO_1("Completed area: %1",GVAR(areaProgress));
                        GVAR(completedAreas) pushBack +(GVAR(currentArgs) select GVAR(areaProgress));
                        private _marker = (GVAR(rxAreas) select GVAR(areaProgress)) select 1;
                        _marker setMarkerBrushLocal "Border";
                        // _marker setMarkerAlphaLocal 0;


                        GVAR(areaProgress) = GVAR(areaProgress) + 1;
                        GVAR(progressBarArea) progressSetPosition (GVAR(areaProgress)/(count GVAR(rxAreas)));
                        if (GVAR(areaProgress)/(count GVAR(rxAreas)) != 1) then {
                            GVAR(areaProgressText) ctrlSetStructuredText (parseText format["<t align='center'>Processing Area: %1 of %2</t>", GVAR(areaProgress)+1, (count GVAR(rxAreas))]);
                        } else {
                            GVAR(areaProgressText) ctrlSetStructuredText (parseText "<t align='center'>Finished</t>");
                        };
                    };
                },
                []
            ] call EFUNC(sys_core,callExt);
        };

    } forEach GVAR(rxAreas);
    with missionNamespace do {
        private _fnc = {
            with uiNamespace do {
                if (GVAR(areaProgress) != (count GVAR(rxAreas))) then {
                    private _res = [1,1];
                    with missionNamespace do {
                        //IGNORE_PRIVATE_WARNING ["_res"];
                        _res = ["signal_map_progress", ""] call EFUNC(sys_core,callExt);
                    };
                    diag_log text format["res: %1", _res];
                    private _p = 0;
                    if (_res select 1 > 0) then {
                        _p = (_res select 0) / (_res select 1);
                    };
                    GVAR(progressBar) progressSetPosition _p;
                    if (_p != 1) then {
                        GVAR(chunkProgressText) ctrlSetStructuredText (parseText format["<t align='center'>%1/%2</t>", _res select 0, _res select 1]);
                    } else {
                        GVAR(chunkProgressText) ctrlSetStructuredText (parseText "<t align='center'>Processing PNG to PAA...</t>");
                    };
                } else {
                    GVAR(chunkProgressText) ctrlSetStructuredText (parseText "<t align='center'>Finished</t>");
                    {
                        (_x select 1) setMarkerAlphaLocal 0;
                    } forEach GVAR(rxAreas);
                    CTRLOVERLAY(GVAR(modifyButton),"RscButton");
                    GVAR(modifyButton) ctrlSetPosition [0.05, 0.055*10, 0.4, 0.045];
                    GVAR(modifyButton) ctrlSetBackgroundColor [0,0,0,0.25];
                    GVAR(modifyButton) ctrlSetText "Modify";
                    GVAR(modifyButton) ctrlSetEventHandler ["MouseButtonUp", QUOTE([] call FUNC(modify))];
                    GVAR(modifyButton) ctrlCommit 0;

                    CTRLOVERLAY(GVAR(clearButton),"RscButton");
                    GVAR(clearButton) ctrlSetPosition [0.05, 0.055*11, 0.4, 0.045];
                    GVAR(clearButton) ctrlSetBackgroundColor [0,0,0,0.25];
                    GVAR(clearButton) ctrlSetText "Clear";
                    GVAR(clearButton) ctrlSetEventHandler ["MouseButtonUp", QUOTE([] call FUNC(clear))];
                    GVAR(clearButton) ctrlCommit 0;

                    with missionNamespace do {
                        [(_this select 1)] call cba_fnc_removePerFrameHandler;
                    };
                };
            };
        };
        [_fnc, 0.1, []] call CBA_fnc_addPerFrameHandler;
    };
};
