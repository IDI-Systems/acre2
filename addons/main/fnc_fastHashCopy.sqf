#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Copies one hash to another or creates an ACRE2 hash with the object variables if the input is an object.
 *
 * Arguments:
 * 0: ACRE 2 Hash <HASH>/<OBJECT>
 *
 * Return Value:
 * ACRE 2 Hash <HASH>
 *
 * Example:
 * new_acreHash = [acreHash] call acre_main_fnc_fastHashCopy
 * new_acreHash = [player] call acre_main_fnc_fastHashCopy
 *
 * Public: No
 */

private _return = [];

if (IS_ARRAY(_this)) then {
    _return = _this call FUNC(fastHashCopyArray);
} else {
    _return = call FUNC(fastHashCreate);
    {
        private _el = _this getVariable _x;
        private _eln = _x;
        if (IS_ARRAY(_el)) then {
            _return setVariable [_eln, _el call FUNC(fastHashCopyArray)];
        } else {
            if (IS_HASH(_el)) then {
                _return setVariable [_eln, _el call FUNC(fastHashCopy)];
            } else {
                _return setVariable [_eln, _el];
            };
        };
    } forEach (allVariables _this);
};
_return;
