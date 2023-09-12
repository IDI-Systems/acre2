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
 * [ARGUMENTS] call acre_sys_sem70_fnc_onChannelStepKnobTurn
 *
 * Public: No
 */

 params ["","_key"];

  private _currentDirection = -1;
 if (_key == 0) then {
     // left click
     _currentDirection = 1;
 };

 private _knobPosition = ["getState", "channelSpacingKnobPosition"] call GUI_DATA_EVENT;
 private _newKnobPosition = ((_knobPosition + _currentDirection) max 0) min 3;

 if (_knobPosition != _newKnobPosition) then {
     ["setState", ["channelSpacingKnobPosition",_newKnobPosition]] call GUI_DATA_EVENT;

     switch _newKnobPosition do {
         case 0: {
             // CTCSS on, 25kHz
             ["setState", ["channelSpacing",0]] call GUI_DATA_EVENT;
             ["setState", ["CTCSS",150]] call GUI_DATA_EVENT;
         };

         case 1: {
             // CTCSS off, 25kHz
             ["setState", ["channelSpacing",0]] call GUI_DATA_EVENT;
             ["setState", ["CTCSS",0]] call GUI_DATA_EVENT;
         };

         case 2: {
             // CTCSS off, 50kHz
             ["setState", ["channelSpacing",1]] call GUI_DATA_EVENT;
             ["setState", ["CTCSS",0]] call GUI_DATA_EVENT;
         };

         case 3: {
             // CTCSS on, 50kHz
             ["setState", ["channelSpacing",1]] call GUI_DATA_EVENT;
             ["setState", ["CTCSS",150]] call GUI_DATA_EVENT;
         };
     };

     ["Acre_SEMKnob", [0,0,0], [0,0,0], 0.3, false] call EFUNC(sys_sounds,playSound);
     [MAIN_DISPLAY] call FUNC(render);
 };
