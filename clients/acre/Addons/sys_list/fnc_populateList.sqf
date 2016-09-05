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
//fnc_populateList.sqf
#include "script_component.hpp"
private["_radioList", "_listId", "_curIndex", "_radioClass", "_activeRadio", "_oblix", "_freq", "_baseConfig", "_realRadio", "_typeName"];
_radioList = _this select 0;

_listId = 20100;
lbClear _listId;
_curIndex = 0;

// Populate local radio list
{
	_radioClass = _x;
	_freq = [_radioClass, "getListInfo"] call EFUNC(sys_data,dataEvent);
	_baseConfig = inheritsFrom (configFile >> "CfgWeapons" >> _radioClass);
	_realRadio = configName ( _baseConfig );
	_typeName = getText (configFile >> "CfgAcreComponents" >> _realRadio >> "name");
	
	lbAdd [_listId, format["%1   Freq: %2Mhz",_typeName,_freq]];
	lbSetData [_listId, _curIndex, _radioClass];
	if(_radioClass == ACRE_ACTIVE_RADIO) then {
		lbSetColor [_listId, _curIndex, [1,0,0,1]];
		lbSetCurSel [_listId, _curIndex];
	};
	_curIndex = _curIndex + 1;
} foreach _radioList;
