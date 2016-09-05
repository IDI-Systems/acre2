//fnc_delayFrame.sqf
#include "script_component.hpp"

params ["_delayedFrameFunction", "_parameters"];
private _frameNo = diag_frameNo;

ADDPFH(DFUNC(delayFramePFH), 0, ARR_3(_delayedFrameFunction, _parameters, _frameNo));
