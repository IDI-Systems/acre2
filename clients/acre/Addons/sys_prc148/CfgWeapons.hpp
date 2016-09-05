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
class CfgWeapons {
	class Default;
	class ACRE_BaseRadio;

	class ACRE_PRC148 : ACRE_BaseRadio {
		displayName = "AN/PRC-148";
		useActionTitle = "AN/PRC-148";
		model = QUOTE(PATHTOF(Data\models\prc148.p3d));
		picture = QUOTE(PATHTOF(Data\static\prc148_icon.paa));
		descriptionShort = "AN/PRC-148 Radio";
        scopeCurator = 2;
        scope = 2;
		
		type = 4096;
		simulation = "ItemMineDetector";
		class ItemInfo
		{
			mass = 8;
			type = 0;
			scope = 0;
		};
		
		class Library 
		{
			libTextDesc = "AN/PRC-148";
		};
	};
	/*
	class ACRE_PRC148_UHF : ACRE_BaseRadio {
		displayName = "AN/PRC-148 UHF";
		useActionTitle = "AN/PRC-148 UHF";
		model = QUOTE(PATHTOF(Data\Models\prc148.p3d));
		picture = QUOTE(PATHTOF(Data\148_icon.paa));

		descriptionShort = "AN/PRC-148 UHF Radio";
		class Library
		{
			libTextDesc = "ACRE AN/PRC-148 UHF";
		};
	};
	*/
	RADIO_ID_LIST(ACRE_PRC148)
	// RADIO_ID_LIST(ACRE_PRC148_UHF)

};
