//Loadouts called with: [this,"side_class","unit_class"] call tb3_fLoadout;
//Use those bellow as an example as to creating a side and unit class.
class TB3_Gear {//Gear definitions stay within this.

	class survivors {
		class baseUnit {
			weapons[] = {"rhs_weap_m4"}; 
			priKit[] = {"rhsusf_acc_compm4"};
			secKit[] = {};
			
			assignedItems[] = {"ItemCompass","ItemWatch"};
			
			headgear[] = {};
			goggles[] = {};
			
			uniform[] = {"U_B_CombatUniform_mcam_tshirt"};
			uniformContents[] = { {"rhs_mag_30Rnd_556x45_M855A1_Stanag", 2} };
				
			vest[] = {"V_TacVest_blk"};
				vestContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",4},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2}									
				};
				
			backpack[] = {"B_OutdoorPack_blu"};
				backpackContents[] = {
					{"rhsusf_100Rnd_762x51", 1 }, 
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",5},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",3}
				};
				
			magazines[] = {}; items[] = {};
		};
		class civilian_one : baseUnit {
			weapons[] = {"rhs_weap_m4"}; 
			priKit[] = {"rhsusf_acc_ACOG2"};
			secKit[] = {};
			
			assignedItems[] = {"ItemCompass","ItemWatch"};
			
			headgear[] = {};
			goggles[] = {};
			
			uniform[] = {"U_B_CombatUniform_mcam_tshirt"};
			uniformContents[] = { {"ACRE_PRC343", 1},{"rhs_mag_30Rnd_556x45_M855A1_Stanag", 2} };
				
			magazines[] = {}; items[] = {};
		};
		class civilian_two : baseUnit {
			weapons[] = {"rhs_weap_m4"}; 
			priKit[] = {"rhsusf_acc_compm4"};
			secKit[] = {};
			
			assignedItems[] = {"ItemCompass","ItemWatch"};
			
			headgear[] = {};
			goggles[] = {};
			
			uniform[] = {"U_B_CombatUniform_mcam_tshirt"};
			uniformContents[] = { {"rhs_mag_30Rnd_556x45_M855A1_Stanag", 2} };
				
			magazines[] = {}; items[] = {};
		};
		class civilian_three : baseUnit {
			weapons[] = {"rhs_weap_m240B"}; 
			priKit[] = {"rhsusf_acc_compm4"};
			secKit[] = {};

			assignedItems[] = {"ItemCompass","ItemWatch"};
			backpackContents[] = { {"rhsusf_100Rnd_762x51", 3 }  };
			vestContents[] = { {"rhsusf_100Rnd_762x51", 2 }  };
			headgear[] = {};
			goggles[] = {};
			
			uniform[] = {"U_B_CombatUniform_mcam_tshirt"};
			uniformContents[] = { };
				
			magazines[] = {}; items[] = {};
		};
		
		class civilian_four : baseUnit {
			weapons[] = {"rhs_weap_m4"}; 
			priKit[] = {"rhsusf_acc_compm4"};
			secKit[] = {};
			
			assignedItems[] = {"ItemCompass","ItemWatch"};
			
			headgear[] = {};
			goggles[] = {};
			
			uniform[] = {"U_B_CombatUniform_mcam_tshirt"};
			uniformContents[] = { {"rhs_mag_30Rnd_556x45_M855A1_Stanag", 2} };

			magazines[] = {}; items[] = {};
		};
		class civilian_five : baseUnit {
			weapons[] = {"rhs_weap_m240B"}; 
			priKit[] = {"rhsusf_acc_compm4"};
			secKit[] = {};

			assignedItems[] = {"ItemCompass","ItemWatch"};
			backpackContents[] = { {"rhsusf_100Rnd_762x51", 3 }  };
			vestContents[] = { {"rhsusf_100Rnd_762x51", 2 }  };
			headgear[] = {};
			goggles[] = {};
			
			uniform[] = {"U_B_CombatUniform_mcam_tshirt"};
			uniformContents[] = { };
				
			magazines[] = {}; items[] = {};
		};
	};

	class USArmyMotInf {
		//rhsusf_assault_eagleaiii_ucp
		//rhs_weap_m240B rhsusf_100Rnd_762x51
		//rhs_weap_m249_pip rhsusf_100Rnd_556x45_soft_pouch
		//rhs_m4_m320 
			//rhs_mag_M433_HEDP
			//rhs_mag_M714_white
			//1Rnd_HE_Grenade_shell
			//rhs_mag_m67
		//rhs_weap_m4
		//rhs_weap_m4_grip
			//rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red 
			//rhs_mag_30Rnd_556x45_M855A1_Stanag
			//rhsusf_acc_anpeq15
			//rhsusf_acc_compm4
			//rhsusf_acc_ACOG2
		class baseUnit {
			weapons[] = {"rhs_weap_m4"}; 
			priKit[] = {"rhsusf_acc_compm4","rhs_mag_30Rnd_556x45_M855A1_Stanag"};
			secKit[] = {};
			
			assignedItems[] = {"ItemMap","ItemCompass","ItemWatch","ItemGPS"};
			
			headgear[] = {"rhsusf_ach_helmet_ucp"};
			goggles[] = {"G_Shades_Black"};
			
			uniform[] = {"rhs_uniform_cu_ucp"};
			uniformContents[] = { 
				    {"cse_earplugs_electronic",1},
                    {"cse_tourniquet",1},
                    {"cse_quikclot",2},
                    {"cse_chestseal",1},
                    {"cse_bandage_basic",2},
                    {"cse_bandageElastic",2},
                    {"cse_personal_aid_kit",1},
                    {"cse_packing_bandage",2}
			};
				
			vest[] = {"rhsusf_iotv_ucp"};
				vestContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2},
					{"rhs_mag_m67",1}										
				};
				
			backpack[] = {"rhsusf_assault_eagleaiii_ucp"};
				backpackContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",1},
					{"rhs_mag_m67",1}
				};
				
			magazines[] = {}; items[] = {};
		};
		class platoonleader : baseUnit {
			weapons[] = {"rhs_weap_m4_grip","Binocular"}; 
			vest[] = {"rhsusf_iotv_ucp_squadleader"};
				vestContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2},
					{"rhs_mag_m67",1},
					{"SmokeShell",1},
					{"ACRE_PRC343",1},
					{"ACRE_PRC152",1}					
				};
				backpackContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",1},
					{"rhs_mag_m67",1},
					{"SmokeShell",1},
					{"rhsusf_ANPVS_14",1}
				};	
		};	
		class platoonsergeant : baseUnit {
			weapons[] = {"rhs_weap_m4_grip","Binocular"}; 
			vest[] = {"rhsusf_iotv_ucp_teamleader"};
				vestContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2},
					{"rhs_mag_m67",1},
					{"SmokeShell",1},
					{"ACRE_PRC343",1},
					{"ACRE_PRC152",1}					
				};	
				backpackContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",1},
					{"rhs_mag_m67",1},
					{"SmokeShell",1},
					{"rhsusf_ANPVS_14",1}
				};					
		};		
		class platoonrto : baseUnit {
			vest[] = {"rhsusf_iotv_ucp_rifleman"};
			backpack[] = {"rhsusf_assault_eagleaiii_ucp"};
				uniformContents[] = {
					{"ACRE_PRC343",1},
					{"ACRE_PRC152",1},
					{"cse_earplugs_electronic",1},
                    {"cse_tourniquet",1},
                    {"cse_quikclot",2},
                    {"cse_chestseal",1},
                    {"cse_bandage_basic",2},
                    {"cse_bandageElastic",2},
                    {"cse_personal_aid_kit",1},
                    {"cse_packing_bandage",2}
				};
				vestContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2},
					{"rhs_mag_m67",1},
					{"SmokeShellRed",1}					
				};			
				backpackContents[] = {
					{"rhsusf_ANPVS_14",1},
					{"ACRE_PRC117F",1}
				};
		};
		class platoonmedic : baseUnit {
			vest[] = {"rhsusf_iotv_ucp_rifleman"};
			backpack[] = {"rhsusf_assault_eagleaiii_ucp"};
				
				vestContents[] = {
					{"ACRE_PRC343",1},
					{"ACRE_PRC152",1},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2},
					{"rhs_mag_m67",1}	
				};
				
				backpackContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",1},
					{"rhs_mag_m67",1},
					{"rhs_mag_m67",1},
					{"rhsusf_ANPVS_14",1},
					{"cse_tourniquet",5},
                    {"cse_quikclot",6},
                    {"cse_chestseal",3},
                    {"cse_bandage_basic",10},
                    {"cse_bandageElastic",10},
                    {"cse_personal_aid_kit",2},
                    {"cse_packing_bandage",10}
				};
		};		
		class vehcrew : baseUnit {
			vest[] = {"rhsusf_iotv_ucp_rifleman"};	
				vestContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2},
					{"rhs_mag_m67",1},
					{"ACRE_PRC343",1},
					{"rhsusf_ANPVS_14",1}
				};			
			backpack[] = {};
			backpackContents[] = {};		
		};
		class squadleader : baseUnit {
			weapons[] = {"rhs_weap_m4_grip","Binocular"}; 
			vest[] = {"rhsusf_iotv_ucp_squadleader"};
				vestContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2},
					{"rhs_mag_m67",1},
					{"SmokeShell",1},
					{"ACRE_PRC343",1},
					{"ACRE_PRC152",1}					
				};
				backpackContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",1},
					{"rhs_mag_m67",1},
					{"SmokeShell",1},
					{"rhsusf_ANPVS_14",1}
				};	
		};	
		class teamleader : baseUnit {
			weapons[] = {"rhs_weap_m4_grip","Binocular"}; 
			vest[] = {"rhsusf_iotv_ucp_teamleader"};
				vestContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2},
					{"rhs_mag_m67",1},
					{"SmokeShell",1},
					{"ACRE_PRC343",1}					
				};	
				backpackContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",1},
					{"rhs_mag_m67",1},
					{"SmokeShell",1}
				};					
		};		
		class rifleman : baseUnit {
			vest[] = {"rhsusf_iotv_ucp_rifleman"};			
			weapons[] = {"rhs_weap_m4_grip","rhs_weap_M136"}; 
				backpackContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",3},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",1},
					{"rhs_mag_m67",1},
					{"rhsusf_100Rnd_556x45_soft_pouch",2},
					{"rhs_m136_mag",1},
					{"rhsusf_ANPVS_14",1}
				};
		};
		class grenadier : baseUnit {
			vest[] = {"rhsusf_iotv_ucp_grenadier"};	
			
				vestContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",2},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",1},
					{"rhs_mag_m67",1},
					{"rhs_mag_M433_HEDP",6}
				};			
			weapons[] = {"rhs_m4_m320"}; 
				backpackContents[] = {
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag",4},
					{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2},
					{"rhs_mag_m67",1},
					{"rhs_mag_M433_HEDP",10},
					{"rhs_mag_M714_white",4},
					{"rhsusf_ANPVS_14",1}
				};
		};
		class automaticRifleman : baseUnit {
			weapons[] = {"rhs_weap_m249_pip"}; 
			priKit[] = {"rhsusf_acc_ACOG2","rhsusf_100Rnd_556x45_soft_pouch"};		
			vest[] = {"rhsusf_iotv_ucp_SAW"};	
				uniformContents[] = { 
					{"cse_earplugs_electronic",1},
                    {"cse_tourniquet",1},
                    {"cse_quikclot",2},
                    {"cse_chestseal",1},
                    {"cse_bandage_basic",2},
                    {"cse_bandageElastic",2},
                    {"cse_personal_aid_kit",1},
                    {"cse_packing_bandage",2}
				};
				vestContents[] = {
					{"rhs_mag_m67",1},
					{"rhsusf_100Rnd_556x45_soft_pouch",2}
				};			
				backpackContents[] = {
					{"rhsusf_100Rnd_556x45_soft_pouch",2},
					{"rhsusf_ANPVS_14",1}
				};
		};

		class pltVeh {
			vehCargoWeapons[] = {{"rhs_weap_M136",2}};
			vehCargoMagazines[] = {	
				{"rhs_mag_30Rnd_556x45_M855A1_Stanag",30},
				{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",10},
				{"rhs_mag_m67",6},
				{"SmokeShell",6},
				{"rhsusf_100Rnd_556x45_soft_pouch",6},
				{"rhs_m136_mag",2}
			};
			vehCargoItems[] = {	/*maybe add some extra medical kit?	*/	};
			vehCargoRucks[] = {			};
		};
		class pltHQVeh {
			vehCargoWeapons[] = {{"rhs_weap_M136",2}};
			vehCargoMagazines[] = {	
				{"rhs_mag_30Rnd_556x45_M855A1_Stanag",30},
				{"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",10},
				{"rhs_mag_m67",6},
				{"SmokeShell",6},
				{"SmokeShellRed",2},
				{"SmokeShellGreen",2},
				{"SmokeShellPurple",2},				
				{"rhsusf_100Rnd_556x45_soft_pouch",6},
				{"rhs_m136_mag",2}
			};
			vehCargoItems[] = {	/*maybe add some extra medical kit?	*/	};
			vehCargoRucks[] = {	{"rhsusf_assault_eagleaiii_ucp",2}	};
		};		

	};

	class RussianLaxDefender {
		class baseUnit {
			weapons[] = {"rhs_weap_ak74m"}; 
			priKit[] = {"rhs_30Rnd_545x39_AK"};
			secKit[] = {};
			
			assignedItems[] = {"ItemMap","ItemCompass","ItemWatch"};
			
			headgear[] = {"rhs_6b27m_green"};
			goggles[] = {};
			
			uniform[] = {"rhs_uniform_vdv_emr"};
			
			uniformContents[] =  {
				{"cse_earplugs_electronic",1},
				{"cse_tourniquet",1},
				{"cse_quikclot",2},
				{"cse_chestseal",1},
				{"cse_bandage_basic",2},
				{"cse_bandageElastic",2},
				{"cse_personal_aid_kit",1},
				{"cse_packing_bandage",2}
			};
			
			vest[] = {"rhs_6b23_digi_rifleman"};
				vestContents[] = {
					{"rhs_30Rnd_545x39_AK",3},
					{"rhs_30Rnd_545x39_AK_green",2},
					{"rhs_mag_rgd5",1}				
				};

			backpack[] = {"rhs_sidor"};
				backpackContents[] = {
					{"rhs_30Rnd_545x39_AK",3},
					{"rhs_30Rnd_545x39_AK_green",1},
					{"rhs_mag_rgd5",1}
				};
				
			magazines[] = {}; items[] = {};
		};
		class platoonleader : baseUnit {
			weapons[] = {"rhs_weap_ak74m","Binocular"}; 
			vest[] = {"rhs_vest_commander"};
				
				vestContents[] = {
					{"rhs_30Rnd_545x39_AK",2},
					{"rhs_30Rnd_545x39_AK_green",1},
					{"rhs_mag_rgd5",1},
					{"SmokeShell",1}					
				};
				backpackContents[] = {
					{"rhs_mag_rgd5",1},
					{"SmokeShell",1},
					{"rhsusf_ANPVS_14",1},
					{"ACRE_PRC77",1}
				};	
		};	
		class teamleader : baseUnit {
			weapons[] = {"rhs_weap_ak74m","Binocular"}; 
			vest[] = {"rhs_6b23_6sh92_radio"};
							
				vestContents[] = {
					{"rhs_30Rnd_545x39_AK",4},
					{"rhs_30Rnd_545x39_AK_green",2},
					{"rhs_mag_rgd5",2},
					{"SmokeShell",1}			
				};
				backpackContents[] = {
					{"SmokeShell",1},
					{"rhsusf_ANPVS_14",1},
					{"ACRE_PRC77",1}
				};	
		};	
		class rifleman : baseUnit {
			weapons[] = {"rhs_weap_ak74m"}; 
			vest[] = {"rhs_6b23_digi_rifleman"};

				vestContents[] = {
					{"rhs_30Rnd_545x39_AK",3},
					{"rhs_30Rnd_545x39_AK_green",2},
					{"rhs_mag_rgd5",3},
					{"SmokeShell",1}				
				};
				backpackContents[] = {
					{"rhs_30Rnd_545x39_AK",4},
					{"rhs_30Rnd_545x39_AK_green",1},
					{"rhs_mag_rgd5",1},
					{"SmokeShell",1},
					{"rhsusf_ANPVS_14",1}
				};	
		};	
		class rpk_gunner : baseUnit {
			weapons[] = {"rhs_weap_pkp"}; 
			vest[] = {"rhs_6b23_digi_rifleman"};
			priKit[] = {"rhs_100Rnd_762x54mmR"};
				vestContents[] = { {"rhs_100Rnd_762x54mmR_green", 1} };
				backpackContents[] = {
					{"rhs_100Rnd_762x54mmR",1},
					{"rhs_100Rnd_762x54mmR_green", 1},
					{"rhsusf_ANPVS_14",1}
				};	
		};	
		class rifleman_rpg : baseUnit {
			weapons[] = {"rhs_weap_ak74m","rhs_weap_rpg7_1pn93"}; 
			vest[] = {"rhs_6b23_digi_rifleman"};
						
				vestContents[] = {
					{"rhs_30Rnd_545x39_AK",3},
					{"rhs_30Rnd_545x39_AK_green",2}	
				};
				backpackContents[] = {
					{"rhs_rpg7_OG7V_mag", 2},
					{"rhsusf_ANPVS_14",1}
				};	
			backpack[] = {"rhs_rpg"};
		};
		class grenadier : baseUnit {
			weapons[] = {"rhs_weap_ak74m_gp25"}; 
			vest[] = {"rhs_6b23_digi_6sh92_vog"};
				uniformContents[] = {
					{"cse_earplugs_electronic",1},
					{"cse_tourniquet",1},
					{"cse_quikclot",2},
					{"cse_chestseal",1},
					{"cse_bandage_basic",2},
					{"cse_bandageElastic",2},
					{"cse_personal_aid_kit",1},
					{"cse_packing_bandage",2},								
					{"rhs_30Rnd_545x39_AK",2},
					{"rhs_30Rnd_545x39_AK_green",1}
				};
				vestContents[] = {
					{"rhs_VOG25", 5 },
					{"rhs_30Rnd_545x39_AK",2},
					{"rhs_30Rnd_545x39_AK_green",2},
					{"rhs_mag_rgd5",1},
					{"SmokeShell",1}					
				};
				backpackContents[] = {
					{"rhs_VOG25", 7 },
					{"rhs_GRD40_White",2},
					{"rhs_GRD40_Green",2},
					{"rhs_VG40OP_white",2},
					{"rhs_VG40OP_green",1},
					{"rhs_VG40OP_red",1},
					{"rhs_30Rnd_545x39_AK",2},
					{"rhs_30Rnd_545x39_AK_green",1},
					{"rhsusf_ANPVS_14",1}
				};	
		};	
		class vehicle {
			vehCargoWeapons[] = {	
			};
			vehCargoMagazines[] = {		
				{"rhs_VOG25", 20 },
				{"rhs_GRD40_White",10},
				{"rhs_GRD40_Green",10},
				{"rhs_VG40OP_white",10},
				{"rhs_VG40OP_green",10},
				{"rhs_VG40OP_red",10},
				{"rhs_30Rnd_545x39_AK",50},
				{"rhs_30Rnd_545x39_AK_green",50},
				{"rhs_100Rnd_762x54mmR",10},
				{"rhs_100Rnd_762x54mmR_green", 10}			
			};
			vehCargoItems[] = {	
				{"rhsusf_ANPVS_14",5}
			};
			vehCargoRucks[] = {			
			};
		};				
	};
	
	
	
///////////////////////////////////////////////////////////	
	
	
		class ExampleSide { //Side_class, 1st string in _this
		class ExampleUnit {
			weapons[] = {"arifle_Mk20_GL_F","Rangefinder"}; 
			priKit[] = {"optic_Arco","acc_pointer_IR"};
			secKit[] = {};
			
			assignedItems[] = {"ItemRadio","ItemMap","ItemCompass","ItemWatch","ItemGPS"};
			
			headgear[] = {"H_HelmetB_plain_mcamo"};
			goggles[] = {"G_Shades_Black"};
			
			uniform[] = {"U_B_CTRG_1"};
				uniformContents[] = {
					{"30Rnd_556x45_Stanag",3},// {classname,number}
					{"SmokeShell",2},
					{"Chemlight_green",2},
					{"FirstAidKit",1},
					{"ACRE_PRC148",1}
				};
				
			vest[] = {"V_PlateCarrierL_CTRG"};
				vestContents[] = {
					{"30Rnd_556x45_Stanag",5},
					{"30Rnd_556x45_Stanag_Tracer_Red",1},
					{"1Rnd_HE_Grenade_shell",7},
					{"1Rnd_SmokeRed_Grenade_shell",2},
					{"1Rnd_SmokeGreen_Grenade_shell",2},
					{"HandGrenade",2},
					{"Chemlight_green",4},
					{"I_IR_Grenade",1},
					{"FirstAidKit",1}
				};
				
			backpack[] = {"B_TacticalPack_oli"};
				backpackContents[] = {
					{"30Rnd_556x45_Stanag",6},
					{"30Rnd_556x45_Stanag_Tracer_Red",2},
					{"HandGrenade",2},
					{"SmokeShell",2},
					{"SmokeShellRed",2},
					{"SmokeShellGreen",2},
					{"I_IR_Grenade",1},
					{"1Rnd_SmokeRed_Grenade_shell",2},
					{"1Rnd_HE_Grenade_shell",6},
					{"Chemlight_green",6},
					{"FirstAidKit",2}
				};
				
			magazines[] = {}; items[] = {}; // only use these if you do not want to assign gear to specific locations in containers, if you do use these ensure the magazine/item container arrays are empty.
		};//end ExampleUnit
		class ExampleVehicle {
			vehCargoWeapons[] = {			};
			vehCargoMagazines[] = {			};
			vehCargoItems[] = {			};
			vehCargoRucks[] = {			};
		};		
	};
};