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
if((getPlayerUID player) in GVAR(debugUsers) || {(getPlayerUID player) == "76561197961839659"} || {(getPlayerUID player) == "76561197970889956"}) then {
    ["ACRE2_Debug", "DebugConsole", "Open Debug Console", { [] call FUNC(openDebugConsole) }, "", [0x29, [true, false, false]]] call cba_fnc_addKeybind;
    ["ACRE2_Debug", "Overlay", "Toggle Overlay", { if(!ACRE_OVERLAY_ENABLED) then { [] call FUNC(enableOverlay) } else { [] call FUNC(disableOverlay) };  }, "", [0x29, [false, true, false]]] call cba_fnc_addKeybind;
};