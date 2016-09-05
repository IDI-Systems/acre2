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

#define __br (parseText "<br />")
#define __det (parseText (format ["Version mismatch detected."]))
#define __server (parseText (format ["Server Version: %1", _serverVersion]))
#define __client (parseText (format ["Client Version:  <t color ='#FF0F00'>%1</t>", _localVersion]))
#define __update (parseText (format ["Go update sucker!"]))


private["_serverVersion", "_localVersion", "_i"];
_serverVersion = _this select 0;
_localVersion = _this select 1;
_player = _this select 2;

while { true } do {
    waitUntil { !dialog }; // OK
    if (_i > 5) exitWith { endMission "END6" };
    ADD(_i,1);
    
    createDialog "ACRE_VERSION_MISMATCH";
    ((findDisplay 666123666) displayCtrl 114113) ctrlSetStructuredText (composeText [__det, __br, __br, __server, __br, __client, __br, __br, __br, __update]);
    ((findDisplay 666123666) displayCtrl 4112) ctrlSetText "ACRE VERSION MISMATCH";

    sleep 10; // OK - TEMP
};