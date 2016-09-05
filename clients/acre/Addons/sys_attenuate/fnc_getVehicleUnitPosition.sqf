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

private["_vehicle", "_ret"];
params["_unit"];

_ret = "other";

if( (vehicle _unit) == _unit) exitWith {
	nil
};
_vehicle = vehicle _unit;


if(((commander _vehicle) == _unit) && (((assignedVehicleRole _unit) select 0) == "Turret")) exitWith {
	_ret = "commander";
	_ret
};

if((driver _vehicle) == _unit) exitWith {
	_ret = "driver";
	_ret
};

if((gunner _vehicle) == _unit) exitWith {
	_ret = "gunner";
	_ret
};

if((Count (assignedVehicleRole _unit)>1)) exitWith {
	_ret = "gunner";
	_ret
};

if(((assignedVehicleRole _unit) select 0) == "Cargo") exitWith {
	_ret = "cargo";
	_ret 
};

_ret