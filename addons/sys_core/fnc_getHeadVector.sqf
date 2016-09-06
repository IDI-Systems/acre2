/*
 * Author: AUTHOR
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

private _position = positionCameraToWorld [0, 0, 0];
private _viewPos = positionCameraToWorld [0, 0, 99999999];
private _vector = _viewPos vectorDiff _position;
//_magnitude = [0, 0, 0] distance _vector;
//_vector = _vector vectorMultiply (1/_magnitude);
_vector = vectorNormalized _vector;
_vector
