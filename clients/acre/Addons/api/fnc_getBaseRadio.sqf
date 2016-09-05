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
//#define DEBUG_MODE_FULL
#include "script_component.hpp"
private["_parent", "_hasUnique"];
params["_radioId"];

TRACE_1("", _radioId);
if( ([_radioId] call FUNC(isBaseRadio)) ) exitWith { 
    _radioId
};

_parent = configName (inheritsFrom ( configFile >> "CfgAcreComponents" >> _radioId));
if(_parent == "") then {
    _parent = configName (inheritsFrom ( configFile >> "CfgWeapons" >> _radioId));
};
_hasUnique = 0;
while { _hasUnique != 1 && _parent != ""} do {
    _hasUnique = getNumber(configFile >> "CfgWeapons" >> _parent >> "acre_hasUnique");
    if(_hasUnique != 1) then {
        _parent = configName (inheritsFrom ( configFile >> "CfgWeapons" >> _parent));
    };
};

_parent