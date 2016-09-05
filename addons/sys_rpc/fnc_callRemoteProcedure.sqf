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
//fnc_callRemoteProcedure.sqf
#define FORMAT_NUMBER(num) (num call FUNC(formatNumber))
 
#include "script_component.hpp"

params["_name","_params"];

if(IS_ARRAY(_params)) then {
    private _arrayParams = _params;
    _params = "";
    {
        _element = _x;
        if(IS_ARRAY(_element)) then {
            {
                if(!IS_STRING(_x)) then {
                    if(IS_BOOL(_x)) then {
                        if(_x) then {
                            _x = 1;
                        } else {
                            _x = 0;
                        };
                    };
                    // if(IS_NUMBER(_x)) then {
                        // _x = FORMAT_NUMBER(_x);
                        // _params = _params + _x + ",";
                    // } else {
                        _params = _params + (str _x) + ",";
                    // };
                } else {
                    _params = _params + _x + ",";
                };
            } forEach _element;
        } else {
            if(!IS_STRING(_element)) then {
                if(IS_BOOL(_element)) then {
                    if(_element) then {
                        _element = 1;
                    } else {
                        _element = 0;
                    };
                };
                // if(IS_NUMBER(_element)) then {
                    // _element = FORMAT_NUMBER(_element);
                    // _params = _params + _element + ",";
                // } else {
                    _params = _params + (str _element) + ",";
                // };
            } else {
                _params = _params + _element + ",";
            };
        };
    
    } forEach _arrayParams;
};
private _data = _name + ":" + _params;
TRACE_1("sendMessage ", _data);
_data call EFUNC(sys_io,sendMessage);
