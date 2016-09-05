class VEHICLE_CLASS_NAME {
	//This is a list of the actual "to use" classes for attenuation.
	// You can delete any of the classes that dont apply, and just 
	// delete them from this list as well. This is to help clean up configs.
	// Ex: If you delete the whole class below of "commander", then remove it from this list
	// THat helps keep the configs concise and clean.
	positions[] = { gunner, commander, driver, cargo, other };
	
	// This is for any crew member flagged as "gunner". This includes real gunner, or turret gunners
	// on Aircraft, this is the crew chief.
	class gunner {
		hasCrewIntercom = 0;	// This value makes it so each slot that has this value set to 1, 
								// does not get any 3d-positional sound or volume changes. THey are 
								// "in eachothers heads", like an intercom. This *ALSO* cuts down
								// *ANYONE* not a crew member talking by 20%, to simulate the headset
		
		class inside {
			// This is for when this crew member is INSIDE the vehicle, e.g. not turned out
			// Each attenuation value is 0 for full volume, or 1.0 for completely silent
			// Each class below here is what *THIS* person hears of THAT POSITION.
			// so if "commander" is set to 1.0, that means, in this example, the gunner wont 
			// hear the commander. Etc.
			class other 	{ attenuationValue = 0; };
			class gunner 	{ attenuationValue = 0; };
			class driver 	{ attenuationValue = 0; };
			class commander { attenuationValue = 0; };
			class cargo 	{ attenuationValue = 0; };
			attenuateOutside	= 0;		// This is the value for the volume of people OUTSIDE the vehicle
											// FROM this position while TURNED IN. Example, tanks have
											// all turned in values to attenuateOutside = 1.0, cause they
											// cannot hear people on direct outside the tank.
		};
		
		// THis class does the exact same thing as above, except for when a crew member is turned out.
		// A good example is that a bradley commander could hear the people inside the tank while turned in,
		// but not while turned out. Alternatively, a tank crewman can only hear people outside the tank
		// while turned out. That would mean attenuateOutside = 0.0 instead of 1.0
		class turnedout {
			class other 	{ attenuationValue = 0; };
			class gunner 	{ attenuationValue = 0; };
			class driver 	{ attenuationValue = 0; };
			class commander { attenuationValue = 0; };
			class cargo 	{ attenuationValue = 0; };
			attenuateOutside	= 0;
		};
	};
	
	// This is for the commander slot of vehicles which have it.
	class commander {
		hasCrewIntercom = 0;
		
		class inside {
			class other 	{ attenuationValue = 0; };
			class gunner 	{ attenuationValue = 0; };
			class driver 	{ attenuationValue = 0; };
			class commander { attenuationValue = 0; };
			class cargo 	{ attenuationValue = 0; };
			attenuateOutside	= 0;
		};
		class turnedout {
			class other 	{ attenuationValue = 0; };
			class gunner 	{ attenuationValue = 0; };
			class driver 	{ attenuationValue = 0; };
			class commander { attenuationValue = 0; };
			class cargo 	{ attenuationValue = 0; };
			attenuateOutside	= 0;
		};
	};
	
	// This applies to the driver of a vehicle. For aircraft, its the pilot.
	class driver {
		hasCrewIntercom = 0;
		
		class inside {
			class other 	{ attenuationValue = 0; };
			class gunner 	{ attenuationValue = 0; };
			class driver 	{ attenuationValue = 0; };
			class commander { attenuationValue = 0; };
			class cargo 	{ attenuationValue = 0; };
			attenuateOutside	= 0;
		};
		class turnedout {
			class other 	{ attenuationValue = 0; };
			class gunner 	{ attenuationValue = 0; };
			class driver 	{ attenuationValue = 0; };
			class commander { attenuationValue = 0; };
			class cargo 	{ attenuationValue = 0; };
			attenuateOutside	= 0;
		};
	};
	
	// This applies to the CARGO positions on a vehicle.
	// BE CAREFUL! This applies to the co-pilot as well.
	class cargo {
		hasCrewIntercom = 0;
		
		class inside {
			class other 	{ attenuationValue = 0; };
			class gunner 	{ attenuationValue = 0; };
			class driver 	{ attenuationValue = 0; };
			class commander { attenuationValue = 0; };
			class cargo 	{ attenuationValue = 0; };
			attenuateOutside	= 0;
		};
		class turnedout {
			class other 	{ attenuationValue = 0; };
			class gunner 	{ attenuationValue = 0; };
			class driver 	{ attenuationValue = 0; };
			class commander { attenuationValue = 0; };
			class cargo 	{ attenuationValue = 0; };
			attenuateOutside	= 0;
		};
	};
	
	// This is our backup attenuation. It rarely gets used, but it is "just in case", this will be used for 
	// any "position" inside a vehicle we did not detect.
	class other {
		hasCrewIntercom = 0;
		
		class inside {
			class other 	{ attenuationValue = 0; };
			class gunner 	{ attenuationValue = 0; };
			class driver 	{ attenuationValue = 0; };
			class commander { attenuationValue = 0; };
			class cargo 	{ attenuationValue = 0; };
			attenuateOutside	= 0;
		};
		class turnedout {
			class other 	{ attenuationValue = 0; };
			class gunner 	{ attenuationValue = 0; };
			class driver 	{ attenuationValue = 0; };
			class commander { attenuationValue = 0; };
			class cargo 	{ attenuationValue = 0; };
			attenuateOutside	= 0;
		};
	};
};

//
//
// !!!!! EXAMPLE BELOW!!!!!
//
//
class Tank : DefaultAttenuation {
		positions[] = {gunner,driver,commander,cargo,other };
		
		class gunner {
			hasCrewIntercom = 1;
			
			class inside {
				class other 	{ attenuationValue = 0.7; };
				class gunner 	{ attenuationValue = 0; };
				class driver 	{ attenuationValue = 0; };
				class commander { attenuationValue = 0; };
				class cargo 	{ attenuationValue = 0.7; };
				attenuateOutside	= 1;
			};
			class turnedout {
				class other 	{ attenuationValue = 1; };
				class gunner 	{ attenuationValue = 0; };
				class driver 	{ attenuationValue = 0; };
				class commander { attenuationValue = 0; };
				class cargo 	{ attenuationValue = 1; };
				attenuateOutside	= 0.7;
			};
		};
		
		class commander {
			hasCrewIntercom = 1;
			
			class inside {
				class other 	{ attenuationValue = 0.7; };
				class gunner 	{ attenuationValue = 0; };
				class driver 	{ attenuationValue = 0; };
				class commander { attenuationValue = 0; };
				class cargo 	{ attenuationValue = 0.7; };
				attenuateOutside	= 1;
			};
			class turnedout {
				class other 	{ attenuationValue = 1; };
				class gunner 	{ attenuationValue = 0; };
				class driver 	{ attenuationValue = 0; };
				class commander { attenuationValue = 0; };
				class cargo 	{ attenuationValue = 1; };
				attenuateOutside	= 0.7;
			};
		};
		
		class driver {
			hasCrewIntercom = 1;
			
			class inside {
				class other 	{ attenuationValue = 0.7; };
				class gunner 	{ attenuationValue = 0; };
				class driver 	{ attenuationValue = 0; };
				class commander { attenuationValue = 0; };
				class cargo 	{ attenuationValue = 0.7; };
				attenuateOutside	= 1;
			};
			class turnedout {
				class other 	{ attenuationValue = 1; };
				class gunner 	{ attenuationValue = 0; };
				class driver 	{ attenuationValue = 0; };
				class commander { attenuationValue = 0; };
				class cargo 	{ attenuationValue = 1; };
				attenuateOutside	= 0.7;
			};
		};
		
		class cargo {
			hasCrewIntercom = 0;
			
			class inside {
				class other 	{ attenuationValue = 0; };
				class gunner 	{ attenuationValue = 0.3; };
				class driver 	{ attenuationValue = 0.3; };
				class commander { attenuationValue = 0.3; };
				class cargo 	{ attenuationValue = 0; };
				attenuateOutside	= 1;
			};
			class turnedout {
				class other 	{ attenuationValue = 1; };
				class gunner 	{ attenuationValue = 1; };
				class driver 	{ attenuationValue = 1; };
				class commander { attenuationValue = 1; };
				class cargo 	{ attenuationValue = 1; };
				attenuateOutside	= 0;
			};
		};
		
		class other {
			hasCrewIntercom = 0;
			
			class inside {
				class other 	{ attenuationValue = 0; };
				class gunner 	{ attenuationValue = 0.3; };
				class driver 	{ attenuationValue = 0.3; };
				class commander { attenuationValue = 0.3; };
				class cargo 	{ attenuationValue = 0; };
				attenuateOutside	= 1;
			};
			class turnedout {
				class other 	{ attenuationValue = 1; };
				class gunner 	{ attenuationValue = 1; };
				class driver 	{ attenuationValue = 1; };
				class commander { attenuationValue = 1; };
				class cargo 	{ attenuationValue = 1; };
				attenuateOutside	= 0;
			};
		};
	};
