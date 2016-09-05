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

PREP(debugOverlay);

/* Begin Omnibus Testing Code */

PREP(showOmnibusWizard);

PREP(checkClient);
PREP(checkServer);
PREP(checkSetup);

PREP(checkPipes);
PREP(checkJNET);
PREP(checkJVON);

PREP(launchJVON);

PREP(dumpNamespace);
PREP(dumpArray);
PREP(formatVar);
PREP(openDebugConsole);
PREP(enableOverlay);
PREP(disableOverlay);
// PREP(countLog);

PREP(dumpCounters);
ACRE_DUMPCOUNTERS_FNC = FUNC(dumpCounters);
ACRE_PERFORMANCE_FRAME_TRACKER = [];
ACRE_PFH = [];

/* End Omnibus Testing Code */

DGVAR(countLogs) = HASH_CREATE;

DGVAR(debugUsers) = [
						"76561197961839659", // Nou
						"76561197970889956",  // Jaynus
						"76561197973023455"	// Impulse 9
					];



ACRE_DEBUG_OVERLAYS = [];
// ARMA_MAIN_DISPLAY = (findDisplay 46);
ACRE_OVERLAY_ENABLED = false;

