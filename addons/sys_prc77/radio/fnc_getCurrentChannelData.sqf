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
private ["_return"];
params ["_radioId", "_event", "_eventData", "_radioData"];

/*//copy all necessary information from _radioData
_currentTuneKnob = HASH_GET(_radioData,"currentChannel");
_currentBand = HASH_GET(_radioData,"band");

//Finding the MHz
//interpreting the band selector
_baseMhzFrequency = 30;
if (_currentBand == 1) then {
    _baseMhzFrequency = 53;
};
//adding the value of the KnobPosition
_MHz = _baseMhzFrequency + (_currentTuneKnob select 0);
//Finding the kHz
_kHz = (_currentTuneKnob select 1)*0.05;
//Making it Arma-Float-Stable
_kHz = [_kHz, 1, 2] call CBA_fnc_formatNumber;

//Combining both
_frequency = _MHz + _kHz;*/

_return = HASH_CREATE;

HASH_SET(_return, "mode", HASH_GET(_radioData, "mode"));
HASH_SET(_return, "frequencyTX", HASH_GET(_radioData, "frequencyTX"));
HASH_SET(_return, "frequencyRX", HASH_GET(_radioData, "frequencyRX"));
HASH_SET(_return, "power", HASH_GET(_radioData, "power"));
HASH_SET(_return, "CTCSSTx", HASH_GET(_radioData, "CTCSSTx"));
HASH_SET(_return, "CTCSSRx", HASH_GET(_radioData, "CTCSSRx"));
HASH_SET(_return, "modulation", HASH_GET(_radioData, "modulation"));
HASH_SET(_return, "encryption", HASH_GET(_radioData, "encryption"));
HASH_SET(_return, "TEK", HASH_GET(_radioData, "TEK"));
HASH_SET(_return, "trafficRate", HASH_GET(_radioData, "trafficRate"));
HASH_SET(_return, "syncLength", HASH_GET(_radioData, "syncLength"));

_return