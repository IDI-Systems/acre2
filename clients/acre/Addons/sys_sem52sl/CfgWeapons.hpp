/*
	Copyright ? 2010, International Development & Integration Systems, LLC
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
#define WeaponNoSlot		0	// dummy weapon
#define WeaponSlotPrimary	1	// primary weapon
#define WeaponSlotHandGun	2	// handGun/sidearm
#define WeaponSlotSecondary	4	// secondary weapon	// 4 in ArmA, not 16.
#define WeaponSlotHandGunItem	16	// sidearm/GL magazines	// 16 in ArmA, not 32.
#define WeaponSlotItem		256	// main magazines, items, explosives
#define WeaponSlotBinocular	4096	// binocular, NVG, LD, equipment
#define WeaponHardMounted	65536
#define WeaponSlotSmallItems	131072

class CfgWeapons {
	class Default;
	class ACRE_BaseRadio;
	class ItemCore;

	class ACRE_SEM52SL : ACRE_BaseRadio {
		displayName = "SEM 52 SL";
		useActionTitle = "SEM 52 SL";
		picture = QUOTE(PATHTOF(data\ui\sem52sl_icon.paa));
		model = QUOTE(PATHTOF(Data\model\sem52sl.p3d));
		descriptionShort = "Sender/Empfänger, mobil SEM 52 SL";
		
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
			libTextDesc = "SEM 52 SL";
		};
	};

	RADIO_ID_LIST(ACRE_SEM52SL)
};