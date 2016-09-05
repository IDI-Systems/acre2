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
NO_DEDICATED;

_components = configFile >> "CfgAcreComponents";

for "_i" from 0 to (count _components)-1 do {
    _component = _components select _i;
    if(isClass _component) then {
        _type = getNumber(_component >> "type");
        if(_type == ACRE_COMPONENT_ANTENNA) then {
            _binaryGainFile = getText(_component >> "binaryGainFile");
            if(_binaryGainFile != "") then {
                _res = ["load_antenna", [(configName _component), _binaryGainFile]] call EFUNC(sys_core,callExt);
                diag_log text format["ACRE: Loaded Binary Antenna Data for %1 [%2]: %3", (configName _component), _binaryGainFile, _res];
            };
        };
    };
};

// this function does setVariables on units to assign their current attenuation volumes