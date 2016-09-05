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

private["_type", "_ret", "_i", "_scope", "_id", "_flag"];
params["_weapon"];

// check that it at least inherits from ACRE_BaseRadio *AND* has a unique ID
// If its scoped 1, that means its either a base or not a radio.
_flag = getNumber(configFile >> "CfgWeapons" >> _weapon >> "acre_isRadio");
_id = getNumber(configFile >> "CfgWeapons" >> _weapon >> "acre_uniqueId");
_scope = getNumber(configFile >> "CfgWeapons" >> _weapon >> "scope");
if(isNil "_flag" || isNil "_scope" || isNil "_id") exitWith { false };
if(_flag == 1 && _scope == 1) exitWith { true };

false