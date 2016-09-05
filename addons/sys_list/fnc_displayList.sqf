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
// fnc_displayList.sqf
#include "script_component.hpp"

//COMPAT_diag_log format["%1", acre_sys_radio_currentRadioDialog];
if(isNil "acre_sys_radio_currentRadioDialog") then {
    _ok = createDialog QUOTE(GVAR(radioListDisplay));
    acre_sys_radio_currentRadioDialog = QUOTE(GVAR(radioList));
    [([] call EFUNC(sys_data,getPlayerRadioList))] call FUNC(populateList);
};
false