#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * This function returns the direction the local player is facing.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Vector <ARRAY>
 *
 * Example:
 * [] call acre_sys_core_fnc_getHeadVector
 *
 * Public: No
 */

private _position = positionCameraToWorld [0, 0, 0];
private _viewPos = positionCameraToWorld [0, 0, 99999999];
private _vector = _viewPos vectorDiff _position;
//_magnitude = [0, 0, 0] distance _vector;
//_vector = _vector vectorMultiply (1/_magnitude);
_vector = vectorNormalized _vector;
_vector
