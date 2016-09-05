//command_replace.hpp

#define COMPAT_getPosATL			getPosATL 				// needs to be getPos in VBS2
#define COMPAT_getTerrainHeightASL	getTerrainHeightASL 	// needs to be replaced wtih terrainHeight in VBS2
#define COMPAT_say3d				say						// needs to be replaced with say in VBS2
#define COMPAT_diag_tickTime		diag_tickTime			// needs to be replaced with time in VBS2 < 1.30
#define COMPAT_diag_log				diag_log 				// needs to be replaced with debugLog in VBS2 < 1.30
#define COMPAT_hintSilent			hintSilent				// needs to be replaced with hint in VBS2