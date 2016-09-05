/*
	Copyright © 2016, International Development & Integration Systems, LLC
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

PREP_FOLDER(radio);

PREP(initializeRadio);
PREP(openGui);
PREP(closeGui);
PREP(zoomChannelBlockSelector);
PREP(render);
PREP(preset_information);
// button functions
PREP(onVolumeKnobPress);
PREP(onChannelKnobPress);
PREP(onPTTHandlePress);

[] call FUNC(preset_information);

NO_DEDICATED;

GVAR(currentRadioId) = -1;

DGVAR(backgroundImages) = [ QUOTE(PATHTOF(Data\anim\prc343_anim0000.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0001.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0002.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0003.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0004.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0005.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0006.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0007.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0008.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0009.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0010.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0011.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0012.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0013.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0014.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0015.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0016.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0017.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0018.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0019.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0020.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0021.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0022.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0023.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0024.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0025.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0026.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0027.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0028.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0029.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0030.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0031.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0032.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0033.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0034.paa)),
							QUOTE(PATHTOF(Data\anim\prc343_anim0035.paa))];

ADDON = true;
