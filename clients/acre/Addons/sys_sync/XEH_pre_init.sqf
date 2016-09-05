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

ADDON = false;

// Interlocks
PREP(interlockedDecrement);
PREP(interlockedIncrement);
PREP(interlockedExchange);

// Mutex
PREP(mutexCreate);
PREP(mutexDestroy);
PREP(mutexLock);
PREP(mutexUnlock);
PREP(mutexPeek);
// Object-based locking
PREP(objectMutexCreate);
PREP(objectMutexDestroy);
PREP(objectMutexLock);
PREP(objectMutexUnlock);
PREP(objectMutexPeek);

// Helpers
PREP(runScript);

// Circular FIFO handling functions for ourselves
PREP(circularFifoCreate);			// create a new circular fifo
PREP(circularFifoPush);				// pushes a new item to the fifo queue, to end
PREP(circularFifoPop);				// pops the next item in the fifo queue, moving it back to the end
PREP(circularFifoGet);				// gets the full array of items in the circular fifo queu
PREP(circularFifoDestroy);			// destroy a current circular fifo

// perFrame/persistant engine handlers
PREP(perFrame_add);
PREP(perFrame_remove);

PREP(perFrame_onFrame);
PREP(perFrame_onTriggerFrame);
PREP(perFrame_monitorFrameRender);

DGVAR(checkLogic) = "logic" createVehicleLocal [-1000,-1000,0];

PREP(perFrameEngine);

// perFrame/persistant variables
DGVAR(lastFrameRender) = 0;
DGVAR(perFrameHandlerArray) = [];

DGVAR(nextPFHid) = -1;
DGVAR(moanCount) = 0;

#ifdef ACRE_PERFORMANCE_COUNTERS
	DVAR(ACRE_PERFORMANCE_COUNTERS_MAXFRAMETIME) = 0.016;
	DVAR(ACRE_PERFORMANCE_COUNTERS_MAXHANDLETIME) = 0.016;

	ACRE_PERFORMANCE_EXCESSIVE_STEP_TRACKER = [];
	ACRE_PERFORMANCE_EXCESSIVE_STEP_TRACKER = [];
	
	ACRE_PERFORMANCE_EXCESSIVE_FRAME_TRACKER = [];
	ACRE_PERFORMANCE_FRAME_TRACKER = [];
#endif


DFUNC(bitchAndMoanBadMissionMaker) = {
	private ["_message"];
	GVAR(moanCount) = GVAR(moanCount) + 1;
	_message = "!!!! WARNING ONEACHFRAME POSSIBLY REASSIGNED !!!! IT APPEARS THAT A ADDON OR MISSION HAS POSSIBLY FAILED TO CORRECTLY USE THE BIS STACKED EVENT HANDLER FUNCTIONS FOR ONEACHFRAME!";
	diag_log text _message;
	if(GVAR(moanCount) > 10) then {
		acre_player sideChat _message;
		hint _message;
	};
	true
};

ADDON = true;