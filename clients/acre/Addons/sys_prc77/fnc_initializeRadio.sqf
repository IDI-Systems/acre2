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
params ["_radioId", "_event", "_eventData", "_radioData"];
TRACE_1("INITIALIZING RADIO 77", _this);

SCRATCH_SET(_radioId, "currentTransmissions", []);


//Radio Settings
HASH_SET(_radioData,"volume",1);								//0-1
HASH_SET(_radioData,"function",2);  							//0 - OFF, 1 - ON, 2 - SQUELCH, 3 - RETRANS, 4 - LITE (Temp)
HASH_SET(_radioData,"radioOn",1);								//0 - OFF, 1 - ON
HASH_SET(_radioData,"band",0);									//{0,1}
HASH_SET(_radioData,"currentPreset",ARR_2(ARR_2(0,0),ARR_2(0,0))); //Array of Presetarrays (KnobPositions)
HASH_SET(_radioData,"currentChannel",ARR_2(0,0));


//Common Channel Settings
HASH_SET(_radioData,"frequencyTX",30);
HASH_SET(_radioData,"frequencyRX",30);
HASH_SET(_radioData,"power",3500);
HASH_SET(_radioData,"mode","singleChannel");
HASH_SET(_radioData,"CTCSSTx", 150);
HASH_SET(_radioData,"CTCSSRx", 150);
HASH_SET(_radioData,"modulation","FM");
HASH_SET(_radioData,"encryption",0);
HASH_SET(_radioData,"TEK","");
HASH_SET(_radioData,"trafficRate",0);
HASH_SET(_radioData,"syncLength",0);
HASH_SET(_radioData,"squelch",3);