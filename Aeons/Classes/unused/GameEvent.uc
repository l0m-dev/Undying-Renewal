//=============================================================================
// GameEvent.
//=============================================================================
class GameEvent expands Info;

#exec TEXTURE IMPORT NAME=GameEvent_t FILE=GameEvent.pcx GROUP=System Mips=Off Flags=2

var() name EventName;

var AeonsPlayer AP;

function Trigger(Actor Other, Pawn Instigator)
{
	log("GameEvent triggered ... Game Event = "$EventName, 'GameEvents');
	if (EventName != 'none')
	{
		ForEach AllActors(class 'AeonsPlayer', AP)
		{
			break;
		}
	
		switch ( EventName )
		{

			case 'LizbethDead':
				AP.bLizbethDead = true;
				break;

			case 'AmbroseDead':
				AP.bAmbroseDead = true;
				break;

			case 'JeremiahTalk1':
				AP.bJeremiahTalk1 = true;
				break;

			case 'JeremiahTalk2':
				AP.bJeremiahTalk2 = true;
				break;

			case 'JeremiahDead':
				AP.bJeremiahDead = true;
				break;

			case 'AaronDead':
				AP.bAaronDead = true;
				break;

			case 'BethanyDead':
				AP.bBethanyDead = true;
				break;

			case 'KeisingerDead':
				AP.bKeisingerDead = true;
				break;

			case 'ReturnfromPiratesCove':
				AP.bReturnfromPiratesCove = true;
				break;

			case 'ReturnfromOneiros':
				AP.bReturnfromOneiros = true;
				break;

			case 'Revenant':
				AP.bRevenant = true;
				break;

			case 'Innercourtyard_silverbullets1':
				AP.bInnercourtyard_silverbullets1 = true;
				break;

			case 'Innercourtyard_silverbullets2':
				AP.bInnercourtyard_silverbullets2 = true;
				break;

			case 'Innercourtyard_phosphorus1':
				AP.bInnercourtyard_phosphorus1 = true;
				break;

			case 'Innercourtyard_phosphorus2':
				AP.bInnercourtyard_phosphorus2 = true;
				break;

			case 'Innercourtyard_phosphorus3':
				AP.bInnercourtyard_phosphorus3 = true;
				break;

			case 'Innercourtyard_health1':
				AP.bInnercourtyard_health1 = true;
				break;

			case 'Innercourtyard_health2':
				AP.bInnercourtyard_health2 = true;
				break;

			case 'Innercourtyard_manawell':
				AP.bInnercourtyard_manawell = true;
				break;

			case 'Innercourtyard_arcanewhorl':
				AP.bInnercourtyard_arcanewhorl = true;
				break;

			case 'Northwinglower_kitchen_health':
				AP.bNorthwinglower_kitchen_health = true;
				break;

			case 'Northwinglower_brewery_health':
				AP.bNorthwinglower_brewery_health = true;
				break;

			case 'Northwinglower_diningroom_amplifier':
				AP.bNorthwinglower_diningroom_amplifier = true;
				break;

			case 'Northwinglower_basement_amplifier':
				AP.bNorthwinglower_basement_amplifier = true;
				break;

			case 'Northwinglower_basement_bullets1':
				AP.bNorthwinglower_basement_bullets1 = true;
				break;

			case 'Northwinglower_basement_bullets2':
				AP.bNorthwinglower_basement_bullets2 = true;
				break;

			case 'Northwinglower_basement_phosphorus1':
				AP.bNorthwinglower_basement_phosphorus1 = true;
				break;

			case 'Northwinglower_basement_phosphorus2':
				AP.bNorthwinglower_basement_phosphorus2 = true;
				break;

			case 'Northwinglower_basement_molotov1':
				AP.bNorthwinglower_basement_molotov1 = true;
				break;

			case 'Northwinglower_basement_molotov2':
				AP.bNorthwinglower_basement_molotov2 = true;
				break;

			case 'Northwinglower_basement_molotov3':
				AP.bNorthwinglower_basement_molotov3 = true;
				break;

			case 'Northwinglower_basement_molotov4':
				AP.bNorthwinglower_basement_molotov4 = true;
				break;

			case 'Northwinglower_dayroom_health':
				AP.bNorthwinglower_dayroom_health = true;
				break;

			case 'Northwingupper_servantsq_health':
				AP.bNorthwingupper_servantsq_health = true;
				break;

			case 'Northwingupper_servantsq_bullets':
				AP.bNorthwingupper_servantsq_bullets = true;
				break;

			case 'Northwingupper_servantsq_shotgunammo':
				AP.bNorthwingupper_servantsq_shotgunammo = true;
				break;

			case 'Northwingupper_servantsq_molotov1':
				AP.bNorthwingupper_servantsq_molotov1 = true;
				break;

			case 'Northwingupper_servantsq_molotov2':
				AP.bNorthwingupper_servantsq_molotov2 = true;
				break;

			case 'Northwingupper_aaronsroom_health':
				AP.bNorthwingupper_aaronsroom_health = true;
				break;

			case 'Northwingupper_aaronsroom_molotov1':
				AP.bNorthwingupper_aaronsroom_molotov1 = true;
				break;

			case 'Northwingupper_aaronsroom_molotov2':
				AP.bNorthwingupper_aaronsroom_molotov2 = true;
				break;

			case 'Northwingupper_aaronsroom_molotov3':
				AP.bNorthwingupper_aaronsroom_molotov3 = true;
				break;

			case 'Northwingupper_aaronsroom_molotov4':
				AP.bNorthwingupper_aaronsroom_molotov4 = true;
				break;

			case 'Northwingupper_aaronsroom_molotov5':
				AP.bNorthwingupper_aaronsroom_molotov5 = true;
				break;

			case 'WestWing_Conservatory_Health':
				AP.bWestWing_Conservatory_Health = true;
				break;

			case 'WestWing_Conservatory_ServantKey1':
				AP.bWestWing_Conservatory_ServantKey1 = true;
				break;

			case 'WestWing_Conservatory_Amplifier':
				AP.bWestWing_Conservatory_Amplifier = true;
				break;

			case 'WestWing_SmokingRoom_Health':
				AP.bWestWing_SmokingRoom_Health = true;
				break;

			case 'WestWing_HuntingRoom_Bullets1':
				AP.bWestWing_HuntingRoom_Bullets1 = true;
				break;

			case 'WestWing_HuntingRoom_Bullets2':
				AP.bWestWing_HuntingRoom_Bullets2 = true;
				break;

			case 'WestWing_Jeremiah_Silver1':
				AP.bWestWing_Jeremiah_Silver1 = true;
				break;

			case 'WestWing_Jeremiah_Silver2':
				AP.bWestWing_Jeremiah_Silver2 = true;
				break;

			case 'WestWing_Jeremiah_Silver3':
				AP.bWestWing_Jeremiah_Silver3 = true;
				break;

			case 'WestWing_Jeremiah_Silver4':
				AP.bWestWing_Jeremiah_Silver4 = true;
				break;

			case 'WestWing_Jeremiah_bullets':
				AP.bWestWing_Jeremiah_bullets = true;
				break;

			case 'WestWing_Jeremiah_health':
				AP.bWestWing_Jeremiah_health = true;
				break;

			case 'GreatHall_attic_amplifier':
				AP.bGreatHall_attic_amplifier = true;
				break;

			case 'CentralUpper_Lizbeth_Health':
				AP.bCentralUpper_Lizbeth_Health = true;
				break;

			case 'CentralUpper_Lizbeth_Poetry':
				AP.bCentralUpper_Lizbeth_Poetry = true;
				break;

			case 'CentralUpper_Bethany_Diary':
				AP.bCentralUpper_Bethany_Diary = true;
				break;

			case 'CentralUpper_Study_JoeNotes':
				AP.bCentralUpper_Study_JoeNotes = true;
				break;

			case 'CentralUpper_Study_EtherTrap1':
				AP.bCentralUpper_Study_EtherTrap1 = true;
				break;

			case 'CentralUpper_Study_EtherTrap2':
				AP.bCentralUpper_Study_EtherTrap2 = true;
				break;

			case 'CentralUpper_TowerStairs_Gate':
				AP.bCentralUpper_TowerStairs_Gate = true;
				break;

			case 'CentralLower_SunRoom_BethsLetters':
				AP.bCentralLower_SunRoom_BethsLetters = true;
				break;

			case 'CentralLower_Tower_amplifier':
				AP.bCentralLower_Tower_amplifier = true;
				break;

			case 'CentralLower_TowerAccess':
				AP.bCentralLower_TowerAccess = true;
				break;

			case 'EastWingLower_Nursery_Health':
				AP.bEastWingLower_Nursery_Health = true;
				break;

			case 'EastWingLower_Nursery_ServantDiary':
				AP.bEastWingLower_Nursery_ServantDiary = true;
				break;

			case 'EastWingLower_BackStairs_Amplifier':
				AP.bEastWingLower_BackStairs_Amplifier = true;
				break;

			case 'EastWingUpper_UpperBackAccess':
				AP.bEastWingUpper_UpperBackAccess = true;
				break;

			case 'WidowsWatch_SmallGardenAccess':
				AP.bWidowsWatch_SmallGardenAccess = true;
				break;

			case 'Gardens_ToolShop_Health1':
				AP.bGardens_ToolShop_Health1 = true;
				break;

			case 'Gardens_ToolShop_Health2':
				AP.bGardens_ToolShop_Health2 = true;
				break;

			case 'Gardens_ToolShop_Dynamite1':
				AP.bGardens_ToolShop_Dynamite1 = true;
				break;

			case 'Gardens_ToolShop_Dynamite2':
				AP.bGardens_ToolShop_Dynamite2 = true;
				break;

			case 'Gardens_ToolShop_Dynamite3':
				AP.bGardens_ToolShop_Dynamite3 = true;
				break;

			case 'Gardens_ToolShop_Dynamite4':
				AP.bGardens_ToolShop_Dynamite4 = true;
				break;

			case 'Gardens_ToolShop_Dynamite5':
				AP.bGardens_ToolShop_Dynamite5 = true;
				break;

			case 'Gardens_ToolShop_Dynamite6':
				AP.bGardens_ToolShop_Dynamite6 = true;
				break;

			case 'Gardens_Greenhouse_phosphorus1':
				AP.bGardens_Greenhouse_phosphorus1 = true;
				break;

			case 'Gardens_Greenhouse_phosphorus2':
				AP.bGardens_Greenhouse_phosphorus2 = true;
				break;

			case 'Gardens_Greenhouse_phosphorus3':
				AP.bGardens_Greenhouse_phosphorus3 = true;
				break;

			case 'Gardens_Greenhouse_phosphorus4':
				AP.bGardens_Greenhouse_phosphorus4 = true;
				break;

			case 'Gardens_Greenhouse_phosphorus5':
				AP.bGardens_Greenhouse_phosphorus5 = true;
				break;

			case 'Gardens_Greenhouse_phosphorus6':
				AP.bGardens_Greenhouse_phosphorus6 = true;
				break;

			case 'Gardens_Greenhouse_phosphorus7':
				AP.bGardens_Greenhouse_phosphorus7 = true;
				break;

			case 'Gardens_Greenhouse_Health':
				AP.bGardens_Greenhouse_Health = true;
				break;

			case 'Gardens_Greenhouse_BethanyKey':
				AP.bGardens_Greenhouse_BethanyKey = true;
				break;

			case 'Gardens_Well_Amplifier':
				AP.bGardens_Well_Amplifier = true;
				break;

			case 'Innercourtyard_BalconyDoorAccess':
				AP.bInnercourtyard_BalconyDoorAccess = true;
				break;

			case 'GreatHall_attic_bullets1':
				AP.bGreatHall_attic_bullets1 = true;
				break;

			case 'GreatHall_attic_bullets2':
				AP.bGreatHall_attic_bullets2 = true;
				break;

			case 'GreatHall_Shotgunshells1':
				AP.bGreatHall_Shotgunshells1 = true;
				break;

			case 'GreatHall_Shotgunshells2':
				AP.bGreatHall_Shotgunshells2 = true;
				break;

			case 'GreatHall_Health1':
				AP.bGreatHall_Health1 = true;
				break;

			case 'GreatHall_Health2':
				AP.bGreatHall_Health2 = true;
				break;

			case 'GreatHall_Molotov1':
				AP.bGreatHall_Molotov1 = true;
				break;

			case 'GreatHall_Molotov2':
				AP.bGreatHall_Molotov2 = true;
				break;

			case 'GreatHall_Molotov3':
				AP.bGreatHall_Molotov3 = true;
				break;

			case 'GreatHall_Molotov4':
				AP.bGreatHall_Molotov4 = true;
				break;

			case 'GreatHall_AtticAccess':
				AP.bGreatHall_AtticAccess = true;
				break;

			case 'Innercourtyard_amplifier':
				AP.bInnercourtyard_amplifier = true;
				break;

			case 'Innercourtyard_AaronsRoomKey':
				AP.bInnercourtyard_AaronsRoomKey = true;
				break;

			case 'Innercourtyard_molotov1':
				AP.bInnercourtyard_molotov1 = true;
				break;

			case 'Innercourtyard_molotov2':
				AP.bInnercourtyard_molotov2 = true;
				break;

			case 'Innercourtyard_molotov3':
				AP.bInnercourtyard_molotov3 = true;
				break;

			case 'TowerRun_Inhabitants_amplifier':
				AP.bTowerRun_Inhabitants_amplifier = true;
				break;

			case 'TowerRun_dynamite1':
				AP.bTowerRun_dynamite1 = true;
				break;

			case 'TowerRun_dynamite2':
				AP.bTowerRun_dynamite2 = true;
				break;

			case 'TowerRun_dynamite3':
				AP.bTowerRun_dynamite3 = true;
				break;

			case 'TowerRun_dynamite4':
				AP.bTowerRun_dynamite4 = true;
				break;

			case 'TowerRun_Health':
				AP.bTowerRun_Health = true;
				break;

			case 'TowerRun_Amplifier':
				AP.bTowerRun_Amplifier = true;
				break;

			case 'TowerRun_TowerAccess':
				AP.bTowerRun_TowerAccess = true;
				break;

			case 'Chapel_etherTrap1':
				AP.bChapel_etherTrap1 = true;
				break;

			case 'Chapel_etherTrap2':
				AP.bChapel_etherTrap2 = true;
				break;

			case 'Chapel_Health1':
				AP.bChapel_Health1 = true;
				break;

			case 'Chapel_Health2':
				AP.bChapel_Health2 = true;
				break;

			case 'Chapel_Paper':
				AP.bChapel_Paper = true;
				break;

			case 'Chapel_Tome':
				AP.bChapel_Tome = true;
				break;

			case 'Chapel_amplifier':
				AP.bChapel_amplifier = true;
				break;

			case 'Chapel_PriestKey':
				AP.bChapel_PriestKey = true;
				break;

			case 'SedgewickConversation':
				AP.bSedgewickConversation = true;
				break;

			case 'KiesingerConversation':
				AP.bKiesingerConversation = true;
				break;
				
			case 'EastWingUpper_Guest_Health1':
				AP.bEastWingUpper_Guest_Health1 = true;
				break;

			case 'EastWingUpper_Guest_Health2':
				AP.bEastWingUpper_Guest_Health2 = true;
				break;

			case 'EastWingUpper_Ambrose_Health':
				AP.bEastWingUpper_Ambrose_Health = true;
				break;

			case 'EastWingUpper_Ambrose_Journal':
				AP.bEastWingUpper_Ambrose_Journal = true;
				break;

			case 'EastWingUpper_Ambrose_Pirate':
				AP.bEastWingUpper_Ambrose_Pirate = true;
				break;

			case 'EastWingUpper_Ambrose_Phosphorus1':
				AP.bEastWingUpper_Ambrose_Phosphorus1 = true;
				break;

			case 'EastWingUpper_Ambrose_Phosphorus2':
				AP.bEastWingUpper_Ambrose_Phosphorus2 = true;
				break;

			case 'EastWingUpper_Ambrose_Phosphorus3':
				AP.bEastWingUpper_Ambrose_Phosphorus3 = true;
				break;

			case 'EastWingUpper_Keisinger_Journal':
				AP.bEastWingUpper_Keisinger_Journal = true;
				break;

			case 'EastWingUpper_Office_Evaline':
				AP.bEastWingUpper_Office_Evaline = true;
				break;

			case 'EastWingUpper_ReadingRoom_Health1':
				AP.bEastWingUpper_ReadingRoom_Health1 = true;
				break;

			case 'EastWingUpper_ReadingRoom_Health2':
				AP.bEastWingUpper_ReadingRoom_Health2 = true;
				break;

			case 'EastWingUpper_Bar_molotov1':
				AP.bEastWingUpper_Bar_molotov1 = true;
				break;

			case 'EastWingUpper_Bar_molotov2':
				AP.bEastWingUpper_Bar_molotov2 = true;
				break;

			case 'EastWingUpper_Bar_molotov3':
				AP.bEastWingUpper_Bar_molotov3 = true;
				break;

			case 'EastWingUpper_Lounge_ShotgunShells':
				AP.bEastWingUpper_Lounge_ShotgunShells = true;
				break;

			case 'EastWingUpper_Hallway_Amplifier':
				AP.bEastWingUpper_Hallway_Amplifier = true;
				break;

			case 'VisitAaronsStudio':
				AP.bVisitAaronsStudio = true;
				break;

			case 'CentralUpper_WidowsWatchKey':
				AP.bCentralUpper_WidowsWatchKey = true;
				break;

			case 'CentralUpper_Josephsconcern':
				AP.bCentralUpper_Josephsconcern = true;
				break;

			case 'EntranceHall_JoesRoom_Joenotes':
				AP.bEntranceHall_JoesRoom_Joenotes = true;
				break;

			case 'EntranceHall_EvasRoom_EvalinesDiary':
				AP.bEntranceHall_EvasRoom_EvalinesDiary = true;
				break;

			case 'NorthWIngUpper_Aaron_amplifier':
				AP.bNorthWIngUpper_Aaron_amplifier = true;
				break;

			case 'LearnofPiratesCove':
				AP.bLearnofPiratesCove = true;
				break;

			case 'WestWing_Jeremiah_StudyKey':
				AP.bWestWing_Jeremiah_StudyKey = true;
				break;

			case 'NorthWIngUpper_Aaron_BethanyGate':
				AP.bNorthWIngUpper_Aaron_BethanyGate = true;
				break;

			case 'CentralUpper_Study_Health':
				AP.bCentralUpper_Study_Health = true;
				break;

			case 'MonasteryPastFinished':
				AP.bMonasteryPastFinished = true;
				break;

			case 'AmbrosesRoom':
				AP.bAmbrosesRoom = true;
				break;

			case 'VisitStandingStones':
				AP.bVisitStandingStones = true;
				log("Setting VisitStandingStones game event to be "$AP.bVisitStandingStones, 'GameEvents');
				break;

			case 'FlightEnabled':
				AP.bFlightEnabled = true;
				break;

			case 'AfterChapel':
				AP.bAfterChapel = true;
				break;

			case 'KiesingerDead':
				AP.bKiesingerDead = true;
				break;

			case 'ChandelierFell':
				AP.bChandelierFell = true;
				break;

			case 'BethanyTransformed':
				AP.bBethanyTransformed = true;
				break;

			case 'AmplifierFound':
				AP.bAmplifierFound = true;
				break;

			case 'OracleReturn':
				AP.bOracleReturn = true;
				break;

			case 'WhorlFound':
				AP.bWhorlFound = true;
				break;

			case 'EtherFound':
				AP.bEtherFound = true;
				break;

			case 'PostShrine':
				AP.bPostShrine = true;
				break;

			case 'ManaWellFound':
				AP.bManaWellFound = true;
				break;

			case 'Chapel_EtherTrap3':
				AP.bChapel_EtherTrap3 = true;
				break;

			case 'Chapel_EtherTrap4':
				AP.bChapel_EtherTrap4 = true;
				break;

			case 'Chapel_Bullets':
				AP.bChapel_Bullets = true;
				break;

			case 'EnteredJeremiahsRoom':
				AP.bEnteredJeremiahsRoom = true;
				break;

			default:
				log("GameEvent: Can't match GameEvent name "$EventName);
				break;
		}
	}
}

defaultproperties
{
     Texture=Texture'Aeons.System.GameEvent_t'
}
