/*
	Author: IDI-Systems, LLC

	Description:
	Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum 

	Parameter(s):
		0 (Optional): Lorem ipsum 
			STRING - end name (default: "end1")
			ARRAY in format [endName,ID], will be composed to "endName_ID" string
		1 (Optional): BOOL - true to end mission, false to fail mission (default: true)
		2 (Optional):
			BOOL - true for signature closing shot (default: true)
			NUMBER - duration of a simple fade out to black

	Returns:
	BOOL
*/

/*
	Copyright © 2016,International Development & Integration Systems, LLC
	All rights reserved.
	http://www.idi-systems.com/

	For personal use only. Military or commercial use is STRICTLY
	prohibited. Redistribution or modification of source code is 
	STRICTLY prohibited.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
	COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES INCLUDING,
	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
	ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
	POSSIBILITY OF SUCH DAMAGE.
*/
#include "script_component.hpp"

if (!hasInterface) exitWith {false}; //Exit on server.

params[["_unit",acre_player]];

private _returnValue = !([_unit] call FUNC(hasBaseRadio)); // Is initialized if the unit has no base radio. HasBaseRadio also can not return nil.

if(_returnValue) then { // Just check that we don't return true if the unit has an itemRadio as itemRadio is also a base radio.
    if( ("ItemRadio" in ([_unit] call EFUNC(lib,getGear))) ) then {
        _returnValue = false;
    };
};

_returnValue