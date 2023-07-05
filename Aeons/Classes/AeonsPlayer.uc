//=============================================================================
// AeonsPlayer.
//=============================================================================
class AeonsPlayer expands PlayerPawn
    config(user)
	abstract;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Impacts.uax PACKAGE=Impacts
//#exec OBJ LOAD FILE=\Aeons\Sounds\Voiceover.uax PACKAGE=Voiceover

// Deaths
//#exec AUDIO IMPORT FILE="Sounds/Deaths/P_Death01.wav" NAME="P_Death01" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/Deaths/P_Death02.wav" NAME="P_Death02" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/Deaths/P_Death03.wav" NAME="P_Death03" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/Deaths/P_Death04.wav" NAME="P_Death04" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/Deaths/P_Death_Watr01.wav" NAME="P_Death_Watr01" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/Deaths/P_Drown01.wav" NAME="P_Drown01" GROUP="Player"

// Footsteps
//#exec AUDIO IMPORT FILE="Sounds/FootSteps/P_Foot_Stn01.wav" NAME="P_Foot_Stn01" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/FootSteps/P_Foot_Stn02.wav" NAME="P_Foot_Stn02" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/FootSteps/P_Foot_Stn03.wav" NAME="P_Foot_Stn03" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/FootSteps/P_Foot_Watr01.wav" NAME="P_Foot_Watr01" GROUP="Player"

// Swimming Noises
//#exec AUDIO IMPORT FILE="Sounds/Swimming/P_Swim01.wav" NAME="P_Swim01" GROUP="SharedHuman"
//#exec AUDIO IMPORT FILE="Sounds/Swimming/P_Swim02.wav" NAME="P_Swim02" GROUP="SharedHuman"
//#exec AUDIO IMPORT FILE="Sounds/Swimming/P_Swim03.wav" NAME="P_Swim03" GROUP="SharedHuman"

// Misc
//#exec AUDIO IMPORT FILE="Sounds/Miscellaneous/P_Gasp_Air01.wav" NAME="P_Gasp_Air01" GROUP="Player"

// Take Hits
//#exec AUDIO IMPORT FILE="Sounds/TakeHits/P_Hit_Hurt01.wav" NAME="P_Hit_Hurt01" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/TakeHits/P_Hit_Hurt02.wav" NAME="P_Hit_Hurt02" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/TakeHits/P_Hit_Hurt03.wav" NAME="P_Hit_Hurt03" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/TakeHits/P_Hit_Hurt04.wav" NAME="P_Hit_Hurt04" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/TakeHits/P_Hit_Watr01.wav" NAME="P_Hit_Watr01" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/TakeHits/P_Hit_Watr02.wav" NAME="P_Hit_Watr02" GROUP="Player"

// Jumps and Landings
//#exec AUDIO IMPORT FILE="Sounds/Jumps-Landings/P_Jump01.wav" NAME="P_Jump01" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/Jumps-Landings/P_Land01.wav" NAME="P_Land01" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/Jumps-Landings/P_Land_Grunt01.wav" NAME="P_Land_Grunt01" GROUP="Player"
//#exec AUDIO IMPORT FILE="Sounds/Jumps-Landings/P_Land_Splash01.wav" NAME="P_Land_Splash01" GROUP="Player"

//#exec OBJ LOAD FILE=\Aeons\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) sound   Drown;
var(Sounds) sound	BreathAgain;
var(Sounds) sound	Footstep1;
var(Sounds) sound	Footstep2;
var(Sounds) sound	Footstep3;
var(Sounds) sound	Swim1;
var(Sounds) sound	Swim2;
var(Sounds) sound	Swim3;
var(Sounds) sound	HitSound3;
var(Sounds) sound	HitSound4;
var(Sounds) sound	Die2;
var(Sounds) sound	Die3;
var(Sounds) sound	Die4;
var(Sounds) sound	GaspSound;
var(Sounds) sound	UWHit1;
var(Sounds) sound	UWHit2;
var(Sounds) sound	LandGrunt;
var(Sounds) sound	UnderWater;
// normally I would just AmbientSound, but of course other effects will probably need it.
// So I'll just play the sound, save the ID and stopsound when the player leaves the water
var int				UnderWaterSoundID;
var float			SoundDuration;


var Actor OverlayActor;					// for rendering overlays outside the player class.

var() travel bool	bDoubleShotgun;
// var bool	bAmplifySpell;				// should the next spell to be fired amplify one level?
var bool bLanternOn;
// Spell effects on the player
var travel bool 	bWeaponSound;				// players conventional weapon makes a sound? Incantation of Silence Spell affects this
var travel bool 	bMagicSound;				// players cast spells make sounds? Incantation of Silence Spell affects this
var travel float	refireMultiplier;			// multiplier for the refire rate of weapons and spells - the Haste modifier affects this
var travel float	speedMultiplier;
var bool bRenderWeapon;

// WizardEye Support
var WizardEye_proj wizEye;				// Wizard eye projectile - to look through.
var bool bWizardEye;					// looking through wizard eye right now
var bool bPhoenix;

// Player Modifiers ---------------------------------------------------------------------------
var PlayerModifier	WardMod;			// Ward Modifier
var travel PlayerModifier	HasteMod;			// Haste Modifier
var PlayerModifier	SphereOfColdMod;	// Sphere of Cold Modifier
var PlayerModifier	MindshatterMod;		// Mindshatter Modifier
var travel PlayerModifier	PhaseMod;			// Phase Modifier
var travel PlayerModifier	SilenceMod;			// Incantation of Silence Modifier
var travel PlayerModifier	DispelMod;			// Dispel Magic Modifier
var travel PlayerModifier	ShieldMod;			// Shield Modifier
var travel ShalasModifier	ShalasMod;			// Shalas Vortex Modifier
var travel PlayerModifier	FireFlyMod;			// Firefly Modifier
var travel PlayerModifier	ManaMod;			// Mana Modifier
var travel PlayerModifier  ScryeMod;			// Scrye Modifier
var travel PlayerModifier  HealthMod;			// Health Modifier
var travel PlayerModifier  SoundMod;			// Sound Modifier
var	travel PlayerModifier	StealthMod;			// Stealth Modifier
var travel PlayerModifier	PlayerDamageMod;	// Player Damage Physics Modifier
var travel PlayerModifier	GameStateMod;		// Game State tracking modifier
var travel PlayerModifier	InvokeMod;			// Invoke modifier
var PlayerModifier	RainMod;			// Rain & Snow modifier
var PlayerModifier	FrictionMod;		// Friction modifier
var PlayerModifier	SlothMod;			// Slowing modifier
var PlayerModifier	SlimeMod;			// Slime modifier
var OnScreenMessageModifier OSMMod;		// OnScreen Message Modifier

// Game Events	-------------------------------------------------------------------------------

var travel bool bLizbethDead;
var travel bool bAmbroseDead;
var travel bool bJeremiahTalk1;
var travel bool bJeremiahTalk2;
var travel bool bJeremiahDead;
var travel bool bAaronDead;
var travel bool bBethanyDead;
var travel bool bKeisingerDead;
var travel bool bReturnfromPiratesCove;
var travel bool bReturnfromOneiros;
var travel bool bRevenant;
var travel bool bInnercourtyard_silverbullets1;
var travel bool bInnercourtyard_silverbullets2;
var travel bool bInnercourtyard_phosphorus1;
var travel bool bInnercourtyard_phosphorus2;
var travel bool bInnercourtyard_phosphorus3;
var travel bool bInnercourtyard_health1;
var travel bool bInnercourtyard_health2;
var travel bool bInnercourtyard_manawell;
var travel bool bInnercourtyard_arcanewhorl;
var travel bool bNorthwinglower_kitchen_health;
var travel bool bNorthwinglower_brewery_health;
var travel bool bNorthwinglower_diningroom_amplifier;
var travel bool bNorthwinglower_basement_amplifier;
var travel bool bNorthwinglower_basement_bullets1;
var travel bool bNorthwinglower_basement_bullets2;
var travel bool bNorthwinglower_basement_phosphorus1;
var travel bool bNorthwinglower_basement_phosphorus2;
var travel bool bNorthwinglower_basement_molotov1;
var travel bool bNorthwinglower_basement_molotov2;
var travel bool bNorthwinglower_basement_molotov3;
var travel bool bNorthwinglower_basement_molotov4;
var travel bool bNorthwinglower_dayroom_health;
var travel bool bNorthwingupper_servantsq_health;
var travel bool bNorthwingupper_servantsq_bullets;
var travel bool bNorthwingupper_servantsq_shotgunammo;
var travel bool bNorthwingupper_servantsq_molotov1;
var travel bool bNorthwingupper_servantsq_molotov2;
var travel bool bNorthwingupper_aaronsroom_health;
var travel bool bNorthwingupper_aaronsroom_molotov1;
var travel bool bNorthwingupper_aaronsroom_molotov2;
var travel bool bNorthwingupper_aaronsroom_molotov3;
var travel bool bNorthwingupper_aaronsroom_molotov4;
var travel bool bNorthwingupper_aaronsroom_molotov5;
var travel bool bWestWing_Conservatory_Health;
var travel bool bWestWing_Conservatory_ServantKey1;
var travel bool bWestWing_Conservatory_Amplifier;
var travel bool bWestWing_SmokingRoom_Health;
var travel bool bWestWing_HuntingRoom_Bullets1;
var travel bool bWestWing_HuntingRoom_Bullets2;
var travel bool bWestWing_Jeremiah_Silver1;
var travel bool bWestWing_Jeremiah_Silver2;
var travel bool bWestWing_Jeremiah_Silver3;
var travel bool bWestWing_Jeremiah_Silver4;
var travel bool bWestWing_Jeremiah_bullets;
var travel bool bWestWing_Jeremiah_health;
var travel bool bGreatHall_attic_amplifier;
var travel bool bCentralUpper_Lizbeth_Health;
var travel bool bCentralUpper_Lizbeth_Poetry;
var travel bool bCentralUpper_Bethany_Diary;
var travel bool bCentralUpper_Study_JoeNotes;
var travel bool bCentralUpper_Study_EtherTrap1;
var travel bool bCentralUpper_Study_EtherTrap2;
var travel bool bCentralUpper_TowerStairs_Gate;
var travel bool bCentralLower_SunRoom_BethsLetters;
var travel bool bCentralLower_Tower_amplifier;
var travel bool bZagnutz;
var travel bool bCentralLower_TowerAccess;
var travel bool bEastWingLower_Nursery_Health;
var travel bool bEastWingLower_Nursery_ServantDiary;
var travel bool bEastWingLower_BackStairs_Amplifier;
var travel bool bEastWingUpper_UpperBackAccess;
var travel bool bWidowsWatch_SmallGardenAccess;
var travel bool bGardens_ToolShop_Health1;
var travel bool bGardens_ToolShop_Health2;
var travel bool bGardens_ToolShop_Dynamite1;
var travel bool bGardens_ToolShop_Dynamite2;
var travel bool bGardens_ToolShop_Dynamite3;
var travel bool bGardens_ToolShop_Dynamite4;
var travel bool bGardens_ToolShop_Dynamite5;
var travel bool bGardens_ToolShop_Dynamite6;
var travel bool bGardens_Greenhouse_phosphorus1;
var travel bool bGardens_Greenhouse_phosphorus2;
var travel bool bGardens_Greenhouse_phosphorus3;
var travel bool bGardens_Greenhouse_phosphorus4;
var travel bool bGardens_Greenhouse_phosphorus5;
var travel bool bGardens_Greenhouse_phosphorus6;
var travel bool bGardens_Greenhouse_phosphorus7;
var travel bool bGardens_Greenhouse_Health;
var travel bool bGardens_Greenhouse_BethanyKey;
var travel bool bGardens_Well_Amplifier;
var travel bool bInnercourtyard_BalconyDoorAccess;
var travel bool bGreatHall_attic_bullets1;
var travel bool bGreatHall_attic_bullets2;
var travel bool bGreatHall_Shotgunshells1;
var travel bool bGreatHall_Shotgunshells2;
var travel bool bGreatHall_Health1;
var travel bool bGreatHall_Health2;
var travel bool bGreatHall_Molotov1;
var travel bool bGreatHall_Molotov2;
var travel bool bGreatHall_Molotov3;
var travel bool bGreatHall_Molotov4;
var travel bool bGreatHall_AtticAccess;
var travel bool bInnercourtyard_amplifier;
var travel bool bInnercourtyard_AaronsRoomKey;
var travel bool bInnercourtyard_molotov1;
var travel bool bInnercourtyard_molotov2;
var travel bool bInnercourtyard_molotov3;
var travel bool bTowerRun_Inhabitants_amplifier;
var travel bool bTowerRun_dynamite1;
var travel bool bTowerRun_dynamite2;
var travel bool bTowerRun_dynamite3;
var travel bool bTowerRun_dynamite4;
var travel bool bTowerRun_Health;
var travel bool bTowerRun_Amplifier;
var travel bool bTowerRun_TowerAccess;
var travel bool bChapel_etherTrap1;
var travel bool bChapel_etherTrap2;
var travel bool bChapel_Health1;
var travel bool bChapel_Health2;
var travel bool bChapel_Paper;
var travel bool bChapel_Tome;
var travel bool bChapel_amplifier;
var travel bool bChapel_PriestKey;
var travel bool bSedgewickConversation;
var travel bool bKiesingerConversation;
var travel bool bEastWingUpper_Guest_Health1;
var travel bool bEastWingUpper_Guest_Health2;
var travel bool bEastWingUpper_Ambrose_Health;
var travel bool bEastWingUpper_Ambrose_Journal;
var travel bool bEastWingUpper_Ambrose_Pirate;
var travel bool bEastWingUpper_Ambrose_Phosphorus1;
var travel bool bEastWingUpper_Ambrose_Phosphorus2;
var travel bool bEastWingUpper_Ambrose_Phosphorus3;
var travel bool bEastWingUpper_Keisinger_Journal;
var travel bool bEastWingUpper_Office_Evaline;
var travel bool bEastWingUpper_ReadingRoom_Health1;
var travel bool bEastWingUpper_ReadingRoom_Health2;
var travel bool bEastWingUpper_Bar_molotov1;
var travel bool bEastWingUpper_Bar_molotov2;
var travel bool bEastWingUpper_Bar_molotov3;
var travel bool bEastWingUpper_Lounge_ShotgunShells;
var travel bool bEastWingUpper_Hallway_Amplifier;
var travel bool bVisitAaronsStudio;
var travel bool bCentralUpper_WidowsWatchKey;
var travel bool bCentralUpper_Josephsconcern;
var travel bool bEntranceHall_JoesRoom_Joenotes;
var travel bool bEntranceHall_EvasRoom_EvalinesDiary;
var travel bool bNorthWIngUpper_Aaron_amplifier;
var travel bool bLearnofPiratesCove;
var travel bool bWestWing_Jeremiah_StudyKey;
var travel bool bNorthWIngUpper_Aaron_BethanyGate;
var travel bool bCentralUpper_Study_Health;
var travel bool bMonasteryPastFinished;
var travel bool bAmbrosesRoom;
var travel bool bVisitStandingStones;
var travel bool bFlightEnabled;
var travel bool bAfterChapel;
var travel bool bKiesingerDead;
var travel bool bChandelierFell;
var travel bool bBethanyTransformed;
var travel bool bAmplifierFound;
var travel bool bOracleReturn;
var travel bool bWhorlFound;
var travel bool bEtherFound;
var travel bool bPostShrine;
var travel bool bManaWellFound;
var travel bool bChapel_EtherTrap3;
var travel bool bChapel_EtherTrap4;
var travel bool bChapel_Bullets;
var travel bool bEnteredJeremiahsRoom;

// --------------------------------------------------------------------------------------------

var globalConfig bool bLogGameState;

var MasterCameraPoint MasterCamPoint;

// Modifier states
var travel bool bWardActive;
var travel bool bHasteActive;
var travel bool bColdActive;
var travel bool bMindActive;
var travel bool bSilenceActive;
var travel bool bDispelActive;
var travel bool bShieldActive;
var travel bool bShalasActive;
var travel bool bFireFlyActive;
var travel bool bScryeActive;
var travel bool bPhaseActive;
var travel bool bSlothActive;
var travel bool bSlimeActive;

var Rotator CamDebugRotDiff;
var vector CamDebugPosDiff;
var vector LookAt1;
var vector LookAt2;
var vector LookDir;
var float pDist;

var InvDisplayManager InvDisplayMan;	// Inventory Display

var() config class<VoicePack> VoiceType;

var float CrossHairOffsetX, CrossHairOffsetY, crossHairScale;	// offsets for the crosshair
var bool bDrawCrosshair;

// book item
var travel BookJournalBase Book;

// debug HUD flags
var bool bDrawPawnName;		// draw the name of the Pawn the cross hair is over
var bool bDrawActorName;	// draw the name of the Actor the cross hair is over
var bool bDrawStealth;		// draw stealth info to the hud.

var bool bDrawInvList;		// Draw the Inventory List?
var() bool bDrawDebugHUD;		// Draw debug items in the hud

var float NoManaFlashTime;

var globalconfig bool bAllowSelectionHUD;
var bool bAllowSpellSelectionHUD;
var enum ESelectMode
{
    SM_None,
    SM_Weapon,
    SM_AttSpell,
    SM_DefSpell,
	SM_Item
} SelectMode;

var	travel	  float SelectTimer; // max double click interval for select object
var(Movement) globalconfig float	SelectTime;
var(Movement) globalconfig float	SelectTimePSX2;
var bool      bTryingSelect;
var bool      bSelectObject; //set when in selection is active

var float     FireDefSpellHeldTime; //tracks length of bFireAttSpell being held down
var float     FireAttSpellHeldTime; //tracks length of bFireAttSpell being held down
var float     FireHeldTime; //tracks length of bFire being held down
var float     JumpHeldTime; //tracks length of Jump being held down
var FlightModifier	Flight;

var Weapon ClientPending;
var Weapon OldClientWeapon;
var bool bNeedActivate;
var int WeaponUpdate;

// main mana vars moved to pawn
var	bool	bUseMana;	// for debugging - set to false to not decrement mana
var   travel int ManaWellsFound;    //For selecting anim for spell hand
var   travel int ManaWhorlsFound;   //For selecting anim for spell hand

/////////////////////////////////////////////////////////////
var travel int    FavWeapon1;    //favorite weapon #1
var travel int    FavWeapon2;
var travel bool   FavWeaponToggle;   //decides next favorite to be overwritten
var travel int    FavAttSpell1;  //favorite attack spell #1
var travel int    FavAttSpell2;
var travel bool   FavAttSpellToggle; //decides next favorite to be overwritten
var travel int    FavDefSpell1;  //favorite defense spell #1
var travel int    FavDefSpell2;
var travel bool   FavDefSpellToggle; //decides next favorite to be overwritten

/////////////////////////////////////////////////////////////
var bool	bTryingScroll;	// like bTryingSelect, except for the PS2 scrolling
var bool	bScrollObject;	// have we actually entered the PS2 scrolling phase
var Inventory SelectedInvPSX2;

var struct	DefUserSettingsPSX2// saves settings from the options screen
{
	var() byte SoundVolumePSX2;
	var() byte MusicVolumePSX2;
	var() byte ControllerConfigPSX2;
	var() bool EasyAimPSX2;
	var() bool InvertLookPSX2;
	var() bool VibrationPSX2;
} UserSettingsPSX2;

var float ScrollTimerPSX2;	// times scrolling for repetition
var float ScrollDelayPSX2;	// time between scrolling repeats

/////////////////////////////////////////////////////////////

var bool bRequestedShot;
var string SavePath;

var float fDecision;
var vector LastStepLocation;
var vector StepDisplacement;

var EnvironmentModifier EMod;

var wind wind;

var travel byte			Objectives[100];
var localized string	ObjectivesText[100];

var travel bool bShowScryeHint;
var travel bool bDrawRico;

var input byte bSelectItem;
var travel int    FavItem1;  //favorite item #1
var travel int    FavItem2;
var travel bool   FavItemToggle; //decides next favorite to be overwritten

replication
{
	// Variables the server should send to the client.
	reliable if( Role==ROLE_Authority && bNetOwner)
		ManaWellsFound, ManaWhorlsFound, crossHairScale,
        FavAttSpell1, FavAttSpell2, FavAttSpellToggle,
        FavDefSpell1, FavDefSpell2, FavDefSpellToggle, ScryeMod, 
		FavItem1, FavItem2, FavItemToggle,
		bWardActive, bHasteActive, bColdActive, bMindActive, bSilenceActive, bDispelActive,
		bShieldActive, bShalasActive, bFireFlyActive, bScryeActive, bPhaseActive, refireMultiplier, ShieldMod, wizEye, bWizardEye,
		speedMultiplier, bWeaponSound, bMagicSound, OSMMod,
		bDoubleShotgun, bDrawInvList, bShowScryeHint;

	reliable if ( Role==ROLE_Authority )
		SendClientFire, RealWeapon;

	// Functions server can call.
	unreliable if( Role==ROLE_Authority )
		ClientPlayTakeHit, bRenderWeapon, GiveBook, GiveJournal;

	// Functions client can call.
	reliable if( Role<ROLE_Authority )
        Scrye, JumpHeldTime, FireHeldTime, useWizardEye, AddAll;
}

event PreBeginPlay()
{
	bIsLit = false;
	bIsPlayer = true;
	Super.PreBeginPlay();
	//rb move to mana modifier ?
	// SetTimer(1,True);
	bWeaponSound = true;
	bMagicSound = true;
	refireMultiplier = 1.0;			// changes nothing by default
	volumeMultiplier = 1.0;
	crossHairScale = 1.0;
	bDrawCrosshair = true;
	speedMultiplier = 1.0;
	
	bUseMana = true;
	// bDrawInvList = true;		// Draw the inventory list
	
	bRenderWeapon = true;
	
	wind = spawn(class 'PlayerWind',self,,Location);
	wind.setBase(self);

	//gun = spawn(class'SPRevolver', self,,Location);
	//gun.setBase(self, 'L_Palm', 'root');

	//EMod = spawn(class 'EnvironmentModifier',self,,Location);
	//EMod.setBase(self);
	bAllowSpellSelectionHUD = true;
}

event PreClientTravel()
{
	// fix ambient sound playing when coming back to a level
	// maybe even destroy the modifiers since they are recreated
	if (ScryeMod != None)
		ScryeMod.AmbientSound = None;
	if (Flight != None)
		Flight.AmbientSound = None;
}

event HeadZoneChange(ZoneInfo newHeadZone)
{
	Super.HeadZoneChange(newHeadZone);

//if ((Level.NetMode != NM_Standalone) || (Level.NetMode != NM_Client))
	if ( Level.NetMode == NM_DedicatedServer )
		return;

	if (!HeadRegion.Zone.bWaterZone)
	{
		if ( newHeadZone.bWaterZone )
		{
			SoundDuration = GetSoundDuration (Swim3);
			PlaySound(Swim3, SLOT_MISC, 1.0);
 			UnderWaterSoundID = PlaySound( UnderWater, SLOT_None, 1.5, false,, 1.5 );
			//UnderWaterSoundID = LastSoundId;
		}
	}
	else
	{
		if (!newHeadZone.bWaterZone)
		{
			StopSound(UnderWaterSoundID);
			SoundDuration = GetSoundDuration (Swim1);
			PlaySound(Swim1, SLOT_None, 1.0);
			UnderWaterSoundID = 0;
		}
	}
}

// Calculate for this pawn the total effect of all PhysicalEffectors.
final function vector GetTotalPhysicalEffect( float DeltaTime )
{
	local PhysicsEffector	PEffect;
	local vector			PVect;

	PVect = vect(0,0,0);
	foreach AllActors( class'PhysicsEffector', PEffect )
		if ( bAllowMove || PEffect.bAffectLockedPlayer )
			PVect += PEffect.EffectOn( Location );
	return PVect;
}

function PlayerTick( float DeltaTime )
{
	local float DeltaOpacity;
	
	DoEyeTrace();
	if (PhaseMod == none)
	{
		//Super.PlayerTick(DeltaTime);
	} 
	else if (!PhaseMod.bActive) 
	{
		// player cutscene fade in/out
		DeltaOpacity = deltaTime * 2.0;
		if ( bRenderSelf )
			Opacity = FClamp(Opacity + DeltaOpacity, 0, 1);
		else
			Opacity = FClamp(Opacity - DeltaOpacity, 0, 1);
	}
}

function ScreenMessage(string Message, float HoldTime, optional bool bFromServer)
{
	if (OSMMod != none)
		OSMMod.NewMessage(Message, HoldTime, bFromServer);
}

simulated event RenderOverlays( canvas Canvas )
{
	if ( Weapon != None )
		Weapon.RenderOverlays(Canvas);

	if ( myHUD != None )
		myHUD.RenderOverlays(Canvas);

    if ( AttSpell != None )
        AttSpell.RenderOverlays(Canvas);

    if ( OSMMod != none )
		OSMMod.RenderOverlays(Canvas);
	
	// if ( DefSpell != None )
     //   DefSpell.RenderOverlays(Canvas);	

	if (OverlayActor != none)
	{
		// Set the velocity of the overlay the same as the player so it will travel along with it.
		OverlayActor.Velocity = Velocity + (Acceleration * 0.025);
		OverlayActor.RenderOverlays(Canvas);
	}
}

// takes the castingLevel of the DispelMagic Spell, and the casting level
// of the magical effect it is trying to dispel and calculates how much
// mana is required to dispel the effect.
function int DispelManaCost(int DispelLevel, int effectLevel)
{
	local int finalManaCost, baseManaCost, levelOffset, manaInc;
	
	baseManaCost = 45;
	manaInc = 10;
	
	levelOffset = effectLevel - dispelLevel;
	finalManaCost = baseManaCost + (levelOffset * manaInc);
	
	return finalManaCost;
}

// This function is called from the Dispel Magic Trigger
// it takes an int that is how much mana it can use to step through the modifiers and dispel them
// if any mana is left over, it returns that amount, otherwise, it returns 0.
function int DisableSpellModifiers(int manaBag, int DispelCastingLevel, bool bSelf)
{
	local int DispelCost;
	
	// All of these need to be in the proper oder
	
	if ( bSelf )
	{
		// Mindshatter
		if ( MindshatterMod.bActive )
		{
			DispelCost = DispelManaCost(DispelCastingLevel, MindshatterMod.castingLevel);
			log("Dispelling Mindshatter ... ", 'Misc');
			log("Incoming Level = "$MindshatterMod.castingLevel, 'Misc');
			log("My Dispel Casting Level = "$DispelCastingLevel, 'Misc');
			log("DispelCost = "$DispelCost, 'Misc');
			if ( manaBag > DispelCost )
			{
				MindshatterMod.Dispel();
				manaBag -= DispelCost;
			} else {
				AeonsSpell(AttSpell).FailedSpellCast();
			}
		}

		// Slime
		if ( SlimeMod.bActive )
		{
			DispelCost = DispelManaCost(DispelCastingLevel, AeonsPlayer(Owner).SlimeMod.castingLevel);
			if ( manaBag > DispelCost )
			{
				SlimeMod.Dispel();
				manaBag -= DispelCost;
			} else {
				AeonsSpell(AttSpell).FailedSpellCast();
			}
		}

		// Sloth
		if ( SlothMod.bActive )
		{
			DispelCost = DispelManaCost(DispelCastingLevel, AeonsPlayer(Owner).SlothMod.castingLevel);
			if ( manaBag > DispelCost )
			{
				SlothMod.Dispel();
				manaBag -= DispelCost;
			} else {
				AeonsSpell(AttSpell).FailedSpellCast();
			}
		}

		// Firefly
		if ( FireflyMod.bActive )
		{
			DispelCost = DispelManaCost(DispelCastingLevel, AeonsPlayer(Owner).FireflyMod.castingLevel);
			if ( manaBag > DispelCost )
			{
				FireflyMod.Dispel();
				manaBag -= DispelCost;
			} else {
				AeonsSpell(AttSpell).FailedSpellCast();
			}
		}

		// Sphere of Cold
		if ( SphereOfColdMod.bActive )
		{
			DispelCost = DispelManaCost(DispelCastingLevel, AeonsPlayer(Owner).SphereOfColdMod.CastingLevel);
			if ( manaBag > DispelCost )
			{
				SphereOfColdMod.Dispel();
				manaBag -= DispelCost;
			} else {
				AeonsSpell(AttSpell).FailedSpellCast();
			}
		}
	} else {

		// Haste
		if ( HasteMod.bActive )
		{
			DispelCost = DispelManaCost(DispelCastingLevel, AeonsPlayer(Owner).HasteMod.castingLevel);
			if ( manaBag > DispelCost )
			{
				HasteMod.Dispel();
				manaBag -= DispelCost;
			}
		}

		// Phase
		DispelCost = DispelManaCost(DispelCastingLevel, AeonsPlayer(Owner).PhaseMod.CastingLevel);
		if ( manaBag > DispelCost )
		{
			PhaseMod.Dispel();
			manaBag -= DispelCost;
		}

		// Shala's Vortex
		DispelCost = DispelManaCost(DispelCastingLevel, AeonsPlayer(Owner).ShalasMod.CastingLevel);
		if ( manaBag > DispelCost )
		{
			ShalasMod.Dispel();
			manaBag -= DispelCost;
		}

		// Shield
		DispelCost = DispelManaCost(DispelCastingLevel, AeonsPlayer(Owner).ShieldMod.CastingLevel);
		if ( manaBag > DispelCost )
		{
			ShieldMod.Dispel();
			manaBag -= DispelCost;
		}

		// Silence
		DispelCost = DispelManaCost(DispelCastingLevel, AeonsPlayer(Owner).SilenceMod.CastingLevel);
		if ( manaBag > DispelCost )
		{
			SilenceMod.Dispel();
			manaBag -= DispelCost;
		}
	}


	return manaBag;
}

function DisableSaveGame()
{
	WindowConsole(Player.Console).bShellPauses = true;
	Level.bDontAllowSavegame = true;
}
function EnableSaveGame()
{
	WindowConsole(Player.Console).bShellPauses = false;
	Level.bDontAllowSavegame = false;
}

function PlayDamageEffect(vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	if (PlayerDamageMod != none)
	{
		PlayerDamageModifier(PlayerDamageMod).TakeHit(DInfo.EffectStrength);
	}
}

function ProjectileHit(Pawn Instigator, vector HitLocation, vector Momentum, projectile proj, DamageInfo DInfo)
{
	local bool bReflectProj;
	local vector playerCoord1, playerCoord2, vd, nvd;
	local vector HitNormal, PlayerLocation, DamageLocation, NewHitLocation;

	DamageLocation = HitLocation;
	DamageLocation.z = 0;
	PlayerLocation = Location;
	PlayerLocation.z = 0;

	if ( Instigator != none )
		Instigator.ProjectileStrikeNotify(self);

	if ( self.ShieldMod.isInState('Activated') )
	{
		if (ShieldMod.castingLevel >= 3)
		{
			vd = vector(ViewRotation);
			playerCoord1 = ( Normal(DamageLocation - PlayerLocation) ) - vd;
			playerCoord2 = ( Normal(DamageLocation - PlayerLocation) ) - (-vd);
			if ( VSize(PlayerCoord2) > VSize(PlayerCoord1) )
				bReflectProj = true;
		}
	}

	// not hitting myself again?
	if ( !(proj.Instigator == self) || !proj.bHasBeenReflected )
		if ( AcceptDamage (DInfo) )
		{
			NewHitLocation = Location - (Normal(proj.velocity) * CollisionRadius);
			TakeDamage(Instigator, NewHitLocation, Momentum, DInfo);
		}

	if (bReflectProj)
	{
		// ClientMessage("Reflected Projectile"$Rand(100));
		proj.Instigator = self;
		proj.bHasBeenReflected = true;
		proj.Velocity = Vector(ViewRotation) * VSize(Proj.Velocity);
	} else {
		if ( !DInfo.bBounceProjectile )
			proj.Explode(HitLocation, HitNormal);
	}
}

function TakeDamage( Pawn instigatedBy, Vector hitlocation, Vector momentum, DamageInfo DInfo)
{
	local vector playerCoord1, playerCoord2, vd, nvd, PlayerLocation, DamageLocation;
	local float dp;

	PlayerLocation = Location;
	PlayerLocation.z = 0;
	DamageLocation = HitLocation;
	DamageLocation.z = 0;

	ClientInstantFlash( -0.4, vect(500, 0, 0));
	
	if ( ShalasMod != none )
		if ( ShalasMod.bActive && DInfo.bMagical )
			AddMana(DInfo.ManaCost * ShalasMod.AbsorbManaPct, true);

	//log("Incoming DamageType = "$DInfo.DamageType, 'Misc');
	
	if ( !((DInfo.DamageType == 'Fell') || (DInfo.DamageType == 'FellHard') || (DInfo.DamageType == 'Drown') || (DInfo.DamageType == 'Fire')) )
	{
		if ( self.ShieldMod.isInState('Activated') )
		{
			if ( DInfo.DamageType == 'LightningBoltOfGods' )
			{
				if ( ShieldModifier(ShieldMod).shieldHealth > 0 )
					ShieldMod.TakeDamage(instigatedBy, hitlocation, momentum, DInfo);
				super.TakeDamage(instigatedBy, hitlocation, momentum, DInfo);
			} else {
			
				vd = vector(ViewRotation);
				vd.z = 0;
				playerCoord1 = ( Normal(DamageLocation - PlayerLocation) ) - vd;
				playerCoord2 = ( Normal(DamageLocation - PlayerLocation) ) + vd;

				dp = Normal(DamageLocation - PlayerLocation) dot vd;
				
				/*
				log("", 'Misc');
				log("DamageLocation = "$DamageLocation, 'Misc');
				log("PlayerLocation = "$PlayerLocation, 'Misc');
				log("Distance = "$( VSize(PlayerLocation - DamageLocation) ),'Misc');
				log("dot product = "$dp, 'Misc');
				log("", 'Misc');
				*/
				// if ( VSize(PlayerCoord2) < VSize(PlayerCoord1) )
				if ( dp < 0 )
				{
					// Player takes damage
					//ClientMessage("Shield does not protect the player"$Rand(100));
					super.TakeDamage(instigatedBy, hitlocation, momentum, DInfo);
				} else {
					// Shield Absorbs damage
					// ClientMessage("Shield protects the player"$Rand(100));
					if ( ShieldModifier(ShieldMod).shieldHealth > 0 )
						ShieldMod.TakeDamage(instigatedBy, hitlocation, momentum, DInfo);
					else
						super.TakeDamage(instigatedBy, hitlocation, momentum, DInfo);
				}
			}
		} else {
			// ClientMessage("TakeDamage: "$Dinfo.Damage);
			super.TakeDamage( instigatedBy, hitlocation, momentum, DInfo );
		}
	} else {
		super.TakeDamage( instigatedBy, hitlocation, momentum, DInfo );
	}
}
//----------------------------------------------------------------------------

exec function StartLog( name N )
{
	EnableLog(N);		
}

exec function EndLog( name N ) 
{
	DisableLog(N);
}

//----------------------------------------------------------------------------

exec function TestJournal( string JournalEntryName )
{
	local class<JournalEntry> JournalEntryClass;

	JournalEntryClass = Class<JournalEntry>(DynamicLoadObject(JournalEntryName, class'Class'));
	
	// if it class didn't load, try forcing the aeons. prefix
	if ( (JournalEntryClass == None) && (InStr(JournalEntryName, "Aeons.") < 0) )
	{
		JournalEntryName = "Aeons." $ JournalEntryName;
		
		JournalEntryClass = Class<JournalEntry>(DynamicLoadObject(JournalEntryName, class'Class'));
	}
		
	if ( JournalEntryClass != None )
	{	
		GiveJournal( JournalEntryClass, false );
	}

}

//----------------------------------------------------------------------------
simulated function bool GiveJournal(class<JournalEntry> JournalClass, optional bool bShowImmediate )
{
	local JournalEntry TempEntry;
	
	if ( JournalClass != None )
	{	
		TempEntry = Spawn(JournalClass);
			
		if (TempEntry!=None)
		{
			if (!Book.AddEntry( TempEntry, true ))
			{
				TempEntry.Destroy();
				return false;
			}
		}
	}

	if ( bShowImmediate )
		ShowBook();
	
	return true;
}

/*exec brady doesn't want this to be bindable*/ 
exec function ShowBook()
{
	local windowconsole wconsole;
	
//	if ( Book.NumJournals == 0 ) 
//		return;

	wconsole = WindowConsole(Player.Console);
	if ( wconsole != None )
	{
		AeonsConsole(wconsole).bRequestedBook = true;
		wconsole.LaunchUWindow();
	}
}

// change 
/*
exec function Fire( optional float F )
{
	// log("AeonsPlayer Fire() called");
	bJustFired = true;
	if( bShowMenu || (Level.Pauser!="") )
		return;

	if( Weapon!=None )
	{
		Weapon.bPointing = true;
		PlayFiring();	// does nothing - idiot function.
		// log("weapon = "$Weapon);
		Weapon.Fire(F);
	}
}
// change 
*/




//change
//============================================================================
// The player wants to fire.an attack spell
exec function FireAttSpell( optional float F )
{
/*
	Log("");
	Log("");
	Log("");
	Log("AeonsPlayer: FireAttSpell");
*/
	if ( bShowMenu || (Level.Pauser!="") || (AttSpell == None) || Region.Zone.bNeutralZone )
		return;
	
	//Log("AeonsPlayer: FireAttSpell: AttSpell is valid");

	//bJustFiredAttSpell = true;

	if( Role < ROLE_Authority )
	{
		//Log("AeonsPlayer: FireAttSpell: Client calling AttSpell.ClientFire()");
		bJustFiredAttSpell = AttSpell.ClientFire(F);
		//bJustFiredAttSpell = false;
		return;
	}
	else
	{
		if ( DefSpell!=None && DefSpell.bInControl )
		{
			//rb will we need to do this yet ?  AttSpell is going to go away
			//	 so DefSpell can come up, right ?
			//PlaySpellFiring();
			//Log("AeonsPlayer: FireAttSpell: DefSpell is in control, calling DefSpell.FireAttSpell()");
			DefSpell.FireAttSpell(F);
			return;
		}
		else
		{
			//Log("AeonsPlayer: FireAttSpell: calling AttSpell.FireAttSpell()");
			PlaySpellFiring();
			bJustFiredAttSpell = true;
			AttSpell.FireAttSpell(F);
		}
	}
}

//============================================================================


// The player wants to fire a defense spell
exec function FireDefSpell( optional float F ) 
{
	if ( bShowMenu || (Level.Pauser!="") || (DefSpell == None) || Region.Zone.bNeutralZone )
		return;

	//bJustFiredDefSpell = true;

	if( Role < ROLE_Authority )
	{
		Log("AeonsPlayer: FireDefSpell: Client calling DefSpell.ClientFire()");
		bJustFiredDefSpell = DefSpell.ClientFire(F);



		return;
	}
	else
	{
		if ( AttSpell!=None && AttSpell.bInControl )
		{
			//rb will we need to do this yet ?  AttSpell is going to go away
			//	 so DefSpell can come up, right ?
			//PlaySpellFiring();
			Log("AeonsPlayer: FireDefSpell: AttSpell is in control, calling AttSpell.FireDefpPell()");
			AttSpell.FireDefSpell(F);
			return;
		}
		else
		{
			Log("AeonsPlayer: FireDefSpell: calling DefSpell.FireDefSpell()");
			PlaySpellFiring();
			bJustFiredDefSpell = true;
			DefSpell.FireDefSpell(F);
		}

	}

//    //tell the currently firing attack spell we want to switch
//    if ( AttSpell != None && AttSpell.bInControl )
//    {
//        AttSpell.FireDefSpell(F);
//        return;
//    }
//    else
//	if ( DefSpell != None )
//	{
//		PlaySpellFiring();
//		DefSpell.FireDefSpell(F);
//	}

}


/*
// The player wants to fire.an attack spell
exec function FireAttSpell( optional float F )
{
	bJustFiredAttSpell = true;

	if ( bShowMenu || (Level.Pauser!="") || (Role < ROLE_Authority) )
		return;

    //tell the currently firing defense spell we want to switch
    if ( DefSpell != None && DefSpell.bInControl )
    {
        DefSpell.FireAttSpell(F);
        return;
    }
    else
	if ( AttSpell != None )
	{
		PlaySpellFiring();
		AttSpell.FireAttSpell(F);
	}
}

// The player wants to fire.a defense spell



exec function FireDefSpell( optional float F ) 
{

	bJustFiredDefSpell = true;
	if ( bShowMenu || (Level.Pauser!="")  )

		return;

    //tell the currently firing attacl spell we want to switch
	if ( AttSpell != None && AttSpell.bInControl )
    {
        AttSpell.FireDefSpell(F);
        return;
    }
    else
	if ( DefSpell != None )
	{
		PlaySpellFiring();
		DefSpell.FireDefSpell(F);
	}

}

*/



//============================================================================

exec function SelectWeapon( optional float F )
{
	/*
	log ("bAllowSelectionHUD = "$bAllowSelectionHUD, 'Misc');
	log ("bTryingSelect = "$bTryingSelect, 'Misc');
	log ("bSelectObject = "$bSelectObject, 'Misc');
	log ("bShowMenu = "$bShowMenu, 'Misc');
	log ("Level.Pauser = "$Level.Pauser, 'Misc');
	*/
	
	if ( !bAllowSelectionHUD || bTryingSelect || bSelectObject ||
         bShowMenu  || (Level.Pauser!="") )
		return;
		
//	Log("Select Weapon called");
 	bTryingSelect = true;
    SelectMode = SM_Weapon;

	if ( GetPlatform() == PLATFORM_PSX2 )
		SelectTimer = SelectTimePSX2;
	else
		SelectTimer = SelectTime;
}

exec function SelectAttSpell( optional float F )
{
	if( !bAllowSelectionHUD || bTryingSelect || bSelectObject || !bAllowSpellSelectionHUD || bShowMenu  || (Level.Pauser!="") )
		return;

//	Log("Select AttSpell called");
   	bTryingSelect = true;
    SelectMode = SM_AttSpell;

	if ( GetPlatform() == PLATFORM_PSX2 )
		SelectTimer = SelectTimePSX2;
	else
		SelectTimer = SelectTime;
}

exec function SelectDefSpell( optional float F )
{
	
	if( !bAllowSelectionHUD || bTryingSelect || bSelectObject ||
         bShowMenu  || (Level.Pauser!="") )
		return;
		
//	Log("Select DefSpell called");
   	bTryingSelect = true;
    SelectMode = SM_DefSpell;

	if ( GetPlatform() == PLATFORM_PSX2 )
		SelectTimer = SelectTimePSX2;
	else
		SelectTimer = SelectTime;
}

exec function SelectItem( optional float F )
{
	if( !bAllowSelectionHUD || bTryingSelect || bSelectObject || !bAllowSpellSelectionHUD || bShowMenu  || (Level.Pauser!="") )
		return;

   	bTryingSelect = true;
    SelectMode = SM_Item;

	if ( GetPlatform() == PLATFORM_PSX2 )
		SelectTimer = SelectTimePSX2;
	else
		SelectTimer = SelectTime;
}

exec function ScrollWeapon( optional float F )
{
	if ( bTryingScroll || bScrollObject || bShowMenu || (Level.Pauser!="") )
		return;
	
//	Log("Scroll Weapon called");
   	bTryingScroll = true;
    SelectMode = SM_Weapon;
    SelectTimer = SelectTimePSX2;
}

exec function ScrollAttSpell( optional float F )
{
	if ( bTryingScroll || bScrollObject || bShowMenu || (Level.Pauser!="") )
		return;
		
// 	Log("Scroll AttSpell called");
 	bTryingScroll = true;
    SelectMode = SM_AttSpell;
    SelectTimer = SelectTimePSX2;
}

exec function ScrollDefSpell( optional float F )
{
	if ( bTryingScroll || bScrollObject || bShowMenu || (Level.Pauser!="") )
		return;
		
// 	Log("Scroll DefSpell called");
	bTryingScroll = true;
    SelectMode = SM_DefSpell;
    SelectTimer = SelectTimePSX2;
}

// These next four don't do anything here, but are overloaded in state ScrollObject
exec function AxisLeft( optional float F )
{
//	Log("AxisLeft called!");
}

exec function AxisRight( optional float F )
{
//	Log("AxisRight called!");
}

exec function AxisUp( optional float F )
{
//	Log("AxisUp called!");
}

exec function AxisDown( optional float F )
{
//	Log("AxisDown called!");
}

// The player wants to switch to weapon group number I.
exec function SwitchWeapon( byte F )
{
	local weapon newWeapon;
	
	if ( bShowMenu || Level.Pauser!="" )
	{
		if ( myHud != None )
			myHud.InputNumber(F);
		return;
	}
	if ( Inventory == None )
		return;

    if ( (bSelectAttSpell == 1 || (F > 10 && F < 21)) )
    {
		SwitchAttSpell(F);
        return;
    }
    else
    if ( (bSelectDefSpell == 1 || (F > 20 && F < 31)) )
    {
	    SwitchDefSpell(F);
        return;
    }
	else
	if ( (bSelectItem == 1 || (F >= 100)) )
	{
		SelectedItem = Inventory.FindItemInGroup(F);
		return;
	}
    else
    {
		// conventional weapon
    }
	
	if ( (Weapon != None) && (Weapon.Inventory != None) )
		newWeapon = Weapon(Weapon.Inventory.FindItemInGroup(F));
	else
		newWeapon = None;	
	if ( newWeapon == None )
		newWeapon = Weapon(Inventory.FindItemInGroup(F));
	// Molotov and Phoenix are only selectable if you have some in stock.
	if ( (newWeapon == None) || ((newWeapon.AmmoType != None) && (newWeapon.AmmoType.AmmoAmount <= 0) &&
		 ((newWeapon.IsA('Molotov')) || (newWeapon.IsA('Phoenix')))) )
		return;

	if ( Weapon == None )
	{
		PendingWeapon = newWeapon;
		ChangedWeapon();
	}
	else if ( (Weapon != newWeapon) && Weapon.PutDown() )
		PendingWeapon = newWeapon;
}

exec function SwitchAttSpell( byte F )
{
    local Spell newSpell;

	//attack spells are inventory groups 11 to 20
    if ( F < 11 )
        F += 10;

	if ( (AttSpell != None) && (AttSpell.Inventory != None) )
		newSpell = Spell(AttSpell.Inventory.FindItemInGroup(F));
	else
		newSpell = None;
	if ( newSpell == None )
		newSpell = Spell(Inventory.FindItemInGroup(F));

	if ( newSpell == None )
		return;
	
    if ( AttSpell == newSpell )
	    return;	

	if ( AttSpell.bInControl )
	{
        AttSpell.PutDown();
		PendingAttSpell = newSpell;
	}
	else
    {
		PendingAttSpell = newSpell;
		ChangedAttSpell();
    }
}

exec function SwitchDefSpell( byte F )
{
    local Spell newSpell;

    //defense spells are inventory groups 21 to 30
    if ( F < 11 )
        F += 20;
		
	if ( F == 21 || F == 24 || F == 25)
	{
	if ( (AttSpell != None) && (AttSpell.Inventory != None) )
		newSpell = Spell(AttSpell.Inventory.FindItemInGroup(F));
	else
		newSpell = None;
	if ( newSpell == None )
		newSpell = Spell(Inventory.FindItemInGroup(F));

	if ( newSpell == None )
		return;
	
    if ( AttSpell == newSpell )
	    return;	

	if ( AttSpell.bInControl )
	{
        AttSpell.PutDown();
		PendingAttSpell = newSpell;
	}
	else
    {
		PendingAttSpell = newSpell;
		ChangedAttSpell();
    }
	}
	else
	{
	if ( (DefSpell != None) && (DefSpell.Inventory != None) )
		newSpell = Spell(DefSpell.Inventory.FindItemInGroup(F));
	else
		newSpell = None;	
	if ( newSpell == None )
		newSpell = Spell(Inventory.FindItemInGroup(F));

	if ( newSpell == None )
		return;

    if ( DefSpell == newSpell )
        return;

    if ( DefSpell.bInControl )
	{
        DefSpell.PutDown();
		PendingDefSpell = newSpell;
	}
	else
    {
		PendingDefSpell = newSpell;
		ChangedDefSpell();
    }
	}
}

exec function Scrye()
{

	if ( ScryeMod != None )
	{
		//ScryeMod.Activate();		// has to be activatable
		ScryeMod.GotoState('Activated');		

	}

}


/*
function Timer()
{

	ClientMessage("Player Velocity is: "$(VSize(Velocity)));
}
*/

//cheat
exec function Pie()
{
	// aka "AllMana".
    Mana = ManaCapacity;
	//ClientMessage("Mana:"$Mana);
}

event Possess()
{
	Super.Possess();
}

exec function PlayerMesh(string MeshName)
{
	local mesh NewMesh;
	NewMesh = mesh( DynamicLoadObject( "Aeons."$MeshName, class'SkelMesh' ) );
	if (NewMesh != none)
	{
		Mesh = NewMesh;
		bBehindView = true;
		bHidden = false;
	}
}

exec event ShowUpgradeMenu()
{
    /* NEEDAEONS -code needs uncommenting once we have an upgrade menu
	bSpecialMenu = true;
	SpecialMenu = class'Aeons.UpgradeMenu';
	ShowMenu();
    ============= NEEDAEONS */
}

exec function ShowLoadMenu()
{
    /* NEEDAEONS -code needs uncommenting once we have a load menu
   	bSpecialMenu = true;
	SpecialMenu = class'Aeons.UnrealLoadMenu';
	ShowMenu();
    ============= NEEDAEONS */
}


/*
exec function Bring( string ClassName )
{
	local class<actor> NewClass;
	if( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
	if( instr(ClassName,".")==-1 )
		ClassName = "Aeons." $ ClassName;
	Super.Bring( ClassName );
}
*/


//-----------------------------------------------------------------------------
// Sound functions
simulated function PlayFootStep()
{
	local sound step;
	local float decision;
	local int id;
	local texture HitTexture;
	local int flags;
	
	if ( Role < ROLE_Authority )
		return;

//	if ( !bIsWalking && (Level.Game.Difficulty > 1) && ((Weapon == None) || !Weapon.bPointing) )
	//	MakePlayerNoise(0.05 * Level.Game.Difficulty * VolumeMultiplier);

	if ( FootRegion.Zone.bWaterZone )
	{
		PlaySound(WaterStep, SLOT_Interact, VolumeMultiplier, false, 1000.0, 1.0);
		MakePlayerNoise(1.0 * VolumeMultiplier, 1280 * VolumeMultiplier);
		return;
	}

	if ( FootSoundClass != None )
	{
		HitTexture = TraceTexture( location + vect(0,0,-1)*CollisionHeight*2, location, flags );
	
		if ( HitTexture != None )
		{
			if ( bIsWalking)							// half volume, half radius for walking ?
			{
				PlayFootSound( 1, HitTexture, 0, Location, (0.5f * VolumeMultiplier), 400.0f, 1.0f );
				MakePlayerNoise(0.5 * VolumeMultiplier, (0.5 * 1280) * VolumeMultiplier);
			} else {
				PlayFootSound( 1, HitTexture, 0, Location, (1.0f * VolumeMultiplier), 800.0f, 1.0f );
				MakePlayerNoise(1.0 * VolumeMultiplier, 1280 * VolumeMultiplier);
			}
		}
	}
	
}

function PlayDyingSound()
{
	local float rnd;

	if ( HeadRegion.Zone.bWaterZone )
	{
		MakePlayerNoise(1.0 * VolumeMultiplier, 1280 * VolumeMultiplier);
		if ( FRand() < 0.5 )
			PlaySound(UWHit1, SLOT_Pain,VolumeMultiplier,,,Frand()*0.2+0.9);
		else
			PlaySound(UWHit2, SLOT_Pain,VolumeMultiplier,,,Frand()*0.2+0.9);
		return;
	}

	rnd = FRand();
	if (rnd < 0.25)
		PlaySound(Die, SLOT_Talk,volumeMultiplier);
	else if (rnd < 0.5)
		PlaySound(Die2, SLOT_Talk,volumeMultiplier);
	else if (rnd < 0.75)
		PlaySound(Die3, SLOT_Talk,volumeMultiplier);
	else 
		PlaySound(Die4, SLOT_Talk,volumeMultiplier);
	MakePlayerNoise(1.0 * VolumeMultiplier, 1280 * VolumeMultiplier);
}

function PlayTakeHitSound(int damage, name damageType, int Mult)
{
	if ( Level.TimeSeconds - LastPainSound < 0.3 )
		return;
	LastPainSound = Level.TimeSeconds;

	if ( HeadRegion.Zone.bWaterZone )
	{
		MakePlayerNoise(1.0 * VolumeMultiplier, 1280 * VolumeMultiplier);
		if ( damageType == 'Drowned' )
			PlaySound(drown, SLOT_Pain, 1.5 * VolumeMultiplier);
		else if ( FRand() < 0.5 )
			PlaySound(UWHit1, SLOT_Pain,2.0 * VolumeMultiplier,,,Frand()*0.15+0.9);
		else
			PlaySound(UWHit2, SLOT_Pain,2.0 * VolumeMultiplier,,,Frand()*0.15+0.9);
		return;
	}
	damage *= FRand();

	MakePlayerNoise(2.0 * VolumeMultiplier, 2560 * VolumeMultiplier);
	if (damage < 8)
		PlaySound(HitSound1, SLOT_Pain,2.0 * VolumeMultiplier,,,Frand()*0.15+0.9);
	else if (damage < 25)
	{
		if (FRand() < 0.5)
			PlaySound(HitSound2, SLOT_Pain,2.0 * VolumeMultiplier,,,Frand()*0.15+0.9);			
		else
			PlaySound(HitSound3, SLOT_Pain,2.0 * VolumeMultiplier,,,Frand()*0.15+0.9);
	}
	else
		PlaySound(HitSound4, SLOT_Pain,2.0 * VolumeMultiplier,,,Frand()*0.15+0.9);

	MakePlayerNoise(2.0 * VolumeMultiplier, 2560 * VolumeMultiplier);
}

function Gasp()
{
	if ( Role != ROLE_Authority )
		return;
	if ( PainTime < 2 )
	{
		PlaySound(GaspSound, SLOT_Talk, 2.0 * VolumeMultiplier);
		MakePlayerNoise(2.0 * VolumeMultiplier, 2560 * VolumeMultiplier);
	} else {
		PlaySound(BreathAgain, SLOT_Talk, 2.0 * VolumeMultiplier);
		MakePlayerNoise(2.0 * VolumeMultiplier, 2560 * VolumeMultiplier);
	}
}

// send crouching notifications to ScriptedPawns
function SendCrouchNotifications()
{
	local ScriptedPawn	sPawn;

	foreach AllActors( class 'ScriptedPawn', sPawn )
	{
		sPawn.WarnPlayerCrouching( self );
	}
}

// adjust CollisionHeight and BaseEyeHeight for crouching mode
function AdjustCrouch( float delta )
{
	local float		cHeight;
	local float		dHeight;
	local float		cTime;
	local vector	cLoc;

	if (SpeedMod != none)
	{
		if (!SpeedMod.bActive)
		{
			if ( bIsCrouching )
			{
				GroundSpeed = default.GroundSpeed * CrouchSpeedScale;
		//		log( Role $ " IS crouching, Physics is " $ Physics $ ", CollisionHeight is " $ CollisionHeight $ ", EyeHeight is " $ BaseEyeHeight $ ", aUp is " $ aUp );
				if ( CrouchTime < 1.0 )
				{
					CrouchTime += ( delta / CrouchRate );
					if ( CrouchTime > 1.0 )
					{
						CrouchTime = 1.0;
						SendCrouchNotifications();
					}
					cHeight = DefaultCollisionHeight() - ( DefaultCollisionHeight() - CrouchCollisionHeight ) * CrouchTime;
					dHeight = CollisionHeight - cHeight;
					SetCollisionSize( DefaultCollisionRadius(), cHeight );
					if ( dHeight > 0.0 )
						SetLocation( Location - ( vect(0,0,1) * dHeight ) );
					BaseEyeHeight = default.BaseEyeHeight - ( default.BaseEyeHeight - CrouchEyeHeight ) * CrouchTime;
				}
			}
			else
			{
		//		log( Role $ " NOT crouching, Physics is " $ Physics $ ", CollisionHeight is " $ CollisionHeight $ ", EyeHeight is " $ BaseEyeHeight $ ", aUp is " $ aUp );
				GroundSpeed = default.GroundSpeed * CrouchSpeedScale;
				if ( ( CollisionHeight != DefaultCollisionHeight() ) || ( BaseEyeHeight != default.BaseEyeHeight * DrawScale ) )
				{
					cTime = CrouchTime - ( delta / CrouchRate ) * 1.0;
					if ( cTime < 0.0 )
						cTime = 0.0;
					cHeight = DefaultCollisionHeight() - ( DefaultCollisionHeight() - CrouchCollisionHeight ) * cTime;
					dHeight = cHeight - CollisionHeight;
					cLoc = Location;

					// move to potential new location first...
					if ( dHeight > 0.0 )
						SetLocation( Location + ( vect(0,0,1) * dHeight ) );

					// then see if collision size can be expanded
					if ( SetCollisionSize( DefaultCollisionRadius(), cHeight ) )
					{
						BaseEyeHeight = default.BaseEyeHeight - ( default.BaseEyeHeight - CrouchEyeHeight ) * cTime;
						CrouchTime = cTime;
						if ( ( CrouchTime == 0.0 ) &&  ( ( Velocity.X * Velocity.X + Velocity.Y * Velocity.Y ) < 1000 ) )
							PlayLocomotion( vect(0,0,0) );
					}
					else
					{
						// couldn't expand collision size, so restore location
						SetLocation( cLoc );
					}
				}
				else
				{
					GroundSpeed = default.GroundSpeed;
					if ( bIsWalking )
						GroundSpeed = default.GroundSpeed * WalkingSpeedScale;
				}
			}
			// GroundSpeed needs to query the speed modifiers for their effect on the player's speed.
			if (HasteMod != none)
			{
				GroundSpeed = GroundSpeed * HasteModifier(HasteMod).speedMultiplier;
				AccelRate = default.AccelRate * HasteModifier(HasteMod).speedMultiplier;
			}
			
			if (SlothMod != none)
				GroundSpeed = GroundSpeed * SlothModifier(SlothMod).speedMultiplier;
		}
	}
}

//-----------------------------------------------------------------------------
// Animation functions

// check if "really" crouched (because AeonsPlayer can be crouching [e.g. stuck in a tunnel] when bIsCrouched is false)
function bool InCrouch()
{
	return bIsCrouching || ( CrouchTime > 0.0 );
}

function PlaySpellFiring();

function ClientPlayTakeHit(float tweentime, vector HitLoc, int Damage, bool bServerGuessWeapon)
{															//dodge  ??
	if ( bServerGuessWeapon && ((GetAnimGroup(AnimSequence) == 'Dodge') || ((Weapon != None) && Weapon.bPointing)) )
		return;
	Enable('AnimEnd');
//	BaseEyeHeight = Default.BaseEyeHeight;
	PlayTakeHit(tweentime, HitLoc, Damage);
}	

function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	local float rnd;
	//local Bubble1 bub;
	local bool bServerGuessWeapon;
	local vector BloodOffset;

	if ( (Damage <= 0) && (ReducedDamageType != 'All') )
		return;

	if ( ReducedDamageType != 'All' ) //spawn some blood
	{
        /* NEEDMOH -need class Bubble1 for drowning or BloodBurst and BloodSpray
		if (damageType == 'Drowned')
		{
			bub = spawn(class 'Bubble1',,, Location 
				+ 0.7 * CollisionRadius * vector(ViewRotation) + 0.3 * EyeHeight * vect(0,0,1));
			if (bub != None)
				bub.DrawScale = FRand()*0.06+0.04;
		}
		else if ( (damageType != 'Burned') && (damageType != 'Corroded') 
					&& (damageType != 'Fell') )
		{
			BloodOffset = 0.2 * CollisionRadius * Normal(HitLocation - Location);
			BloodOffset.Z = BloodOffset.Z * 0.5;
			if ( (Level.Game != None) && Level.Game.bVeryLowGore )
				spawn(class 'BloodBurst',,,hitLocation + BloodOffset, rotator(BloodOffset));
			else
				spawn(class 'BloodSpray',,,hitLocation + BloodOffset, rotator(BloodOffset));
		}
        ============== NEEDMOH */
	}	

	rnd = FClamp(Damage, 15, 60);
    if ( damageType == 'Burned' )
		ClientFlash( -0.009375 * rnd, rnd * vect(16.41, 11.719, 4.6875));
	else if ( damageType == 'corroded' )
		ClientFlash( -0.01171875 * rnd, rnd * vect(9.375, 14.0625, 4.6875));
	else if ( damageType == 'Drowned' )
		ClientFlash(-0.390, vect(312.5,468.75,468.75));
	else 
		ClientFlash( -0.017 * rnd, rnd * vect(24, 4, 4));

	ShakeView(0.15 + 0.005 * Damage, Damage * 30, 0.3 * Damage); 
	PlayTakeHitSound(Damage, damageType, 1);
																									//dodge ?
	bServerGuessWeapon = ( ((Weapon != None) && Weapon.bPointing) || (GetAnimGroup(AnimSequence) == 'Dodge') );
	ClientPlayTakeHit(0.1, hitLocation, Damage, bServerGuessWeapon ); 
	if ( !bServerGuessWeapon 
		&& ((Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer)) )
	{
		Enable('AnimEnd');
//		BaseEyeHeight = Default.BaseEyeHeight;
		PlayTakeHit(0.1, hitLocation, Damage);
	}
}

function PlayDeathHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	if ( Region.Zone.bDestructive && (Region.Zone.ExitActor != None) )
		Spawn(Region.Zone.ExitActor);

    /* NEEDMOH -need classes Bubble1, BloodSpray
	local Bubble1 bub;

	if (HeadRegion.Zone.bWaterZone)
	{
		bub = spawn(class 'Bubble1',,, Location 
			+ 0.3 * CollisionRadius * vector(Rotation) + 0.8 * EyeHeight * vect(0,0,1));
		if (bub != None)
			bub.DrawScale = FRand()*0.08+0.03; 
		bub = spawn(class 'Bubble1',,, Location 
			+ 0.2 * CollisionRadius * VRand() + 0.7 * EyeHeight * vect(0,0,1));
		if (bub != None)
			bub.DrawScale = FRand()*0.08+0.03; 
		bub = spawn(class 'Bubble1',,, Location 
			+ 0.3 * CollisionRadius * VRand() + 0.6 * EyeHeight * vect(0,0,1));
		if (bub != None)
			bub.DrawScale = FRand()*0.08+0.03; 
	}

	if ( (damageType != 'Drowned') && (damageType != 'Corroded') )
		spawn(class 'BloodSpray',self,'', hitLocation);
    ============ NEEDMOH */
}


function PlayTurning()
{
//	BaseEyeHeight = Default.BaseEyeHeight;
	if ( (Weapon == None) || (Weapon.Mass < 20) )
		PlayAnim('TurnSM', 0.3);
	else
		PlayAnim('TurnLG', 0.3);
}

function TweenToWalking(float tweentime)
{
	PlayLocomotion( vect(0.5,0,0) );
}

function TweenToRunning(float tweentime)
{
	if (bIsWalking)
	{
		TweenToWalking(0.1);
		return;
	}
	PlayLocomotion( vect(1,0,0) );
}

function PlayRising()
{
//	BaseEyeHeight = 0.4 * Default.BaseEyeHeight;
//	TweenAnim('DuckWlkS', 0.7);
	PlayAnim( 'get_up' );
}

function PlayFeignDeath()
{
	PlayAnim( 'death_gun_back' );
}

function PlayDying(name DamageType, vector HitLoc, DamageInfo DInfo)
{
	local vector X,Y,Z, HitVec, HitVec2D;
	local vector HitLocation, HitNormal, End;
	local float DistToSurface, dotp;
	local int HitJoint;
	local bool bSpearDeath;

	switch (DamageType)
	{
		case 'spear':
			log("Dying by Spear ....", 'Misc');
			End = Location + Normal(DInfo.ImpactForce) * 256;
			Trace(HitLocation, HitNormal, HitJoint, End, Location, false);
			bSpearDeath = true;
			SetPhysics(PHYS_Falling);
			Velocity = (Normal(DInfo.ImpactForce) + vect(0,0,0.35)) * 512;
			break;

		default:
			break;
	}

	if ( !bSpearDeath || bSpearDeath )
	{
		log( "AeonsPlayer.PlayDying(), damage is " $ DamageType );
	
		PlayDyingSound();
				
		if ( FRand() < 0.15 )
		{
			PlayAnim('Dead3',0.7);
			return;
		}
	
		// check for big hit
		if ( (Velocity.Z > 250) && (FRand() < 0.7) )
		{
			PlayAnim('Dead2', 0.7);
			return;
		}
	
		// check for head hit
		if ( ((DamageType == 'Decapitated') || (HitLoc.Z - Location.Z > 0.6 * CollisionHeight)) && ((Level.Game == None) || !Level.Game.bVeryLowGore) )
		{
			DamageType = 'Decapitated';
			if ( Level.NetMode != NM_Client )
			{
	            /* NEEDMOH -need class 'FemaleHead'
				carc = Spawn(class 'FemaleHead',,, Location + CollisionHeight * vect(0,0,0.8), Rotation + rot(3000,0,16384) );
				if (carc != None)
				{
					carc.Initfor(self);
					carc.Velocity = Velocity + VSize(Velocity) * VRand();
					carc.Velocity.Z = FMax(carc.Velocity.Z, Velocity.Z);
				}
	            ================= NEEDMOH */
			}
			PlayAnim('Dead6', 0.7);
			return;
		}

		if ( FRand() < 0.15)
		{
			PlayAnim('Dead1', 0.7);
			return;
		}
	
		GetAxes(Rotation,X,Y,Z);
		X.Z = 0;
		HitVec = Normal(HitLoc - Location);
		HitVec2D= HitVec;
		HitVec2D.Z = 0;
		dotp = HitVec2D dot X;
		
		if (Abs(dotp) > 0.71) //then hit in front or back
		{
			 PlayAnim('Dead4', 0.7);
		} else {
			dotp = HitVec dot Y;
			if ( (dotp > 0.0) && ((Level.Game == None) || !Level.Game.bVeryLowGore) )
			{
				// PlayAnim('Dead7', 0.7);
	            /* NEEDMOH -need class 'Arm1'
				carc = Spawn(class 'Arm1');
				if (carc != None)
				{
					carc.Initfor(self);
					carc.Velocity = Velocity + VSize(Velocity) * VRand();
					carc.Velocity.Z = FMax(carc.Velocity.Z, Velocity.Z);
				}
	            =============== NEEDMOH */
			}	else {
				PlayAnim('Dead5', 0.7);
			}
		}
	}
}

function PlayGutHit(float tweentime)
{
	if ( (AnimSequence == 'GutHit') || (AnimSequence == 'Dead2') )
	{
		if (FRand() < 0.5)
			TweenAnim('LeftHit', tweentime);
		else
			TweenAnim('RightHit', tweentime);
	}
	else if ( FRand() < 0.6 )
		TweenAnim('GutHit', tweentime);
	else
		TweenAnim('Dead2', tweentime);
}

function PlayHeadHit(float tweentime)
{
	if ( (AnimSequence == 'HeadHit') || (AnimSequence == 'Dead4') )
		TweenAnim('GutHit', tweentime);
	else if ( FRand() < 0.6 )
		TweenAnim('HeadHit', tweentime);
	else
		TweenAnim('Dead4', tweentime);
}

function PlayLeftHit(float tweentime)
{
	if ( (AnimSequence == 'LeftHit') || (AnimSequence == 'Dead3') )
		TweenAnim('GutHit', tweentime);
	else if ( FRand() < 0.6 )
		TweenAnim('LeftHit', tweentime);
	else 
		TweenAnim('Dead3', tweentime);
}

function PlayRightHit(float tweentime)
{
	if ( (AnimSequence == 'RightHit') || (AnimSequence == 'Dead5') )
		TweenAnim('GutHit', tweentime);
	else if ( FRand() < 0.6 )
		TweenAnim('RightHit', tweentime);
	else
		TweenAnim('Dead5', tweentime);
}
	
function PlayLanded(float impactVel)
{
	local Texture HitTexture;
	local int id;
	local int flags;

	impactVel = impactVel/JumpZ;
	impactVel = 0.1 * impactVel * impactVel;

	if ( Role == ROLE_Authority )
	{
		// don't bother tracing unless we have a FootSoundClass
		if ( FootSoundClass != None ) 
		{
			HitTexture = TraceTexture(location + vect(0,0,-1)*CollisionHeight*2, location, flags );
		
			if ( HitTexture != None )
				//fix maybe check for velocity ?			
				PlayFootSound( 3, HitTexture, 1, Location, (0.8f * VolumeMultiplier), 800.0f, 1.0f );
		}
		/*  these extra sounds can be put back later
		if ( impactVel > 0.17 )
			PlaySound(LandGrunt, SLOT_Talk, FMin(5, 5 * impactVel) * VolumeMultiplier,false,1200,FRand()*0.4+0.8);
		if ( !FootRegion.Zone.bWaterZone && (impactVel > 0.01) )
			PlaySound(Land, SLOT_Interact, FClamp(4 * impactVel,0.5,5) * VolumeMultiplier, false,1000, 1.0);
		*/

	}
	if ( (impactVel > 0.06) || (GetAnimGroup(AnimSequence) == 'Jumping') )
	{
		if ( (Weapon == None) || (Weapon.Mass < 20) )
			TweenAnim('LandSMFR', 0.12);
		else
			TweenAnim('LandLGFR', 0.12);
	}
	else if ( !IsAnimating() )
	{
		if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
		{
			SetPhysics(PHYS_Walking);
			AnimEnd();
		}
		else 
		{
			if ( (Weapon == None) || (Weapon.Mass < 20) )
				TweenAnim('LandSMFR', 0.12);
			else
				TweenAnim('LandLGFR', 0.12);
		}
	}
}
	
function PlayInAir()
{
	LoopAnim( 'jump_cycle', speedMultiplier, MOVE_None );
}

function PlayJump()
{
	PlayInAir();
}

function PlayFlight()
{
	PlayAnim( 'flight_start', speedMultiplier, MOVE_None );
}

function PlayDuck()
{
//	BaseEyeHeight = 0;
	if ( (Weapon == None) || (Weapon.Mass < 20) )
		TweenAnim('DuckWlkS', 0.25);
	else
		TweenAnim('DuckWlkL', 0.25);
}

function PlayCrawling()
{
	//log("Play duck");
//	BaseEyeHeight = 0;
	if ( (Weapon == None) || (Weapon.Mass < 20) )
		LoopAnim('DuckWlkS', -1.0);
	else
		LoopAnim('DuckWlkL', -1.0);
}

function TweenToWaiting(float tweentime)
{
	if ( (IsInState('PlayerSwimming')) || (Physics == PHYS_Swimming) )
	{
//		BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
		if ( (Weapon == None) || (Weapon.Mass < 20) )
			TweenAnim('TreadSM', tweentime);
		else
			TweenAnim('TreadLG', tweentime);
	}
	else
	{
//		BaseEyeHeight = Default.BaseEyeHeight;
		if ( (Weapon == None) || (Weapon.Mass < 20) )
			TweenAnim('StillSMFR', tweentime);
		else
			TweenAnim('StillFRRP', tweentime);
	}
}

simulated function PlayFiring()
{
	// switch animation sequence mid-stream if needed
	if (AnimSequence == 'RunLG')
		AnimSequence = 'RunLGFR';
	else if (AnimSequence == 'RunSM')
		AnimSequence = 'RunSMFR';
	else if (AnimSequence == 'WalkLG')
		AnimSequence = 'WalkLGFR';
	else if (AnimSequence == 'WalkSM')
		AnimSequence = 'WalkSMFR';
	else if ( AnimSequence == 'JumpSMFR' )
		TweenAnim('JumpSMFR', 0.03);
	else if ( AnimSequence == 'JumpLGFR' )
		TweenAnim('JumpLGFR', 0.03);
	else if ( (GetAnimGroup(AnimSequence) == 'Waiting') || (GetAnimGroup(AnimSequence) == 'Gesture')
		&& (AnimSequence != 'TreadLG') && (AnimSequence != 'TreadSM') )
	{
		if ( Weapon.Mass < 20 )
			TweenAnim('StillSMFR', 0.02);
		else
			TweenAnim('StillFRRP', 0.02);
	}

	PlayAnim('attack_revolver_fire');
}

function PlayWeaponSwitch(Weapon NewWeapon)
{
	if ( (Weapon == None) || (Weapon.Mass < 20) )
	{
		if ( (NewWeapon != None) && (NewWeapon.Mass > 20) )
		{
			if ( (AnimSequence == 'RunSM') || (AnimSequence == 'RunSMFR') )
				AnimSequence = 'RunLG';
			else if ( (AnimSequence == 'WalkSM') || (AnimSequence == 'WalkSMFR') )
				AnimSequence = 'WalkLG';	
		 	else if ( AnimSequence == 'JumpSMFR' )
		 		AnimSequence = 'JumpLGFR';
			else if ( AnimSequence == 'DuckWlkL' )
				AnimSequence = 'DuckWlkS';
		 	else if ( AnimSequence == 'StillSMFR' )
		 		AnimSequence = 'StillFRRP';
			else if ( AnimSequence == 'AimDnSm' )
				AnimSequence = 'AimDnLg';
			else if ( AnimSequence == 'AimUpSm' )
				AnimSequence = 'AimUpLg';
		 }	
	}
	else if ( (NewWeapon == None) || (NewWeapon.Mass < 20) )
	{		
		if ( (AnimSequence == 'RunLG') || (AnimSequence == 'RunLGFR') )
			AnimSequence = 'RunSM';
		else if ( (AnimSequence == 'WalkLG') || (AnimSequence == 'WalkLGFR') )
			AnimSequence = 'WalkSM';
	 	else if ( AnimSequence == 'JumpLGFR' )
	 		AnimSequence = 'JumpSMFR';
		else if ( AnimSequence == 'DuckWlkS' )
			AnimSequence = 'DuckWlkL';
	 	else if (AnimSequence == 'StillFRRP')
	 		AnimSequence = 'StillSMFR';
		else if ( AnimSequence == 'AimDnLg' )
			AnimSequence = 'AimDnSm';
		else if ( AnimSequence == 'AimUpLg' )
			AnimSequence = 'AimUpSm';
	}
}

function PlaySwimming()
{
//	BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
	if ((Weapon == None) || (Weapon.Mass < 20) )
		LoopAnim('SwimSM', -1.0);
	else
		LoopAnim('SwimLG', -1.0);
}

function TweenToSwimming(float tweentime)
{
	PlaySwimming();
}


exec function PlayerStateTrigger(optional float rSpeed, optional float aRate)
{
	GroundSpeed = rSpeed;
	AccelRate = aRate;
}

/////////////////////////////////////////////////
// Functions for changing player movement params
/////////////////////////////////////////////////
exec function Run()
{
	GroundSpeed = default.GroundSpeed;
	AccelRate = default.AccelRate;
}

exec function Haste(float mult)
{
	// ClientMessage("Haste Called");
	// AirSpeed = default.AirSpeed * mult;
	GroundSpeed = default.GroundSpeed * mult;
	AccelRate = default.AccelRate * mult;
	speedMultiplier = mult;
}

function bool CheckSelect( float DeltaTime )
{
	SelectTimer -= DeltaTime;
//	Log("CheckSelect called!");

	if (GetPlatform() == PLATFORM_PSX2)
	{
		if ( SelectTimer > 0.0 )
		{
//			Log("SelectTimer = "$SelectTimer);
			// if key is back up, all we do is go to next selection in the list
			if ( SelectMode == SM_Weapon && bSelectWeapon == 0 )
			{
				bTryingSelect = false;
				NextWeapon();
//				Log("CheckSelect: NextWeapon(), Timer had "$SelectTimer$" left");
				return false; //don't force calling fn to return
			}
			else if ( SelectMode == SM_AttSpell && bSelectAttSpell == 0 )
			{
				bTryingSelect = false;
				NextAttSpell();
//				Log("CheckSelect: NextAttSpell(), Timer had "$SelectTimer$" left");
				return false; //don't force calling fn to return
			}
			else if ( SelectMode == SM_DefSpell && bSelectDefSpell == 0 )
			{
				bTryingSelect = false;
				NextDefSpell();
//				Log("CheckSelect: NextDefSpell(), Timer had "$SelectTimer$" left");
				return false; //don't force calling fn to return
			}
			else if ( SelectMode == SM_Item && bSelectItem == 0 )
			{
				bTryingSelect = false;
				NextItem();
//				Log("CheckSelect: NextItem(), Timer had "$SelectTimer$" left");
				return false; //don't force calling fn to return
			}
		}
		else
		{
//			Log("SelectTimer = "$SelectTimer$" < 0, so bring up wheel!");
			//lets bring up selection menu
			bTryingSelect = false;
			bSelectObject = true;
			GotoState('SelectObject');
			return true; //use this to force calling fn to immed. return.
		}
	}
	else
	{
		if ( SelectTimer > 0.0 )
		{
    
    		//if key state is back up then switch to next favorite if we can
			if ( SelectMode == SM_Weapon && bSelectWeapon == 0 )
			{
				bTryingSelect = false;
				if ( Weapon == None || 
					(Weapon.InventoryGroup != FavWeapon1 &&
					 Weapon.InventoryGroup != FavWeapon2) )
				{
					if ( FavWeapon1 != 0 )
					{
						SwitchWeapon(FavWeapon1);
					}
					else
					if ( FavWeapon2 != 0 )
					{
						SwitchWeapon(FavWeapon2);
					}
					return false; //don't force calling fn to return also
				}
                
				if ( Weapon.InventoryGroup == FavWeapon1 && FavWeapon2 != 0 )
				{
					SwitchWeapon(FavWeapon2);
				}
				else
				if ( Weapon.InventoryGroup == FavWeapon2 && FavWeapon1 != 0 )
				{
					SwitchWeapon(FavWeapon1);
				}
			}
			else
			if ( SelectMode == SM_AttSpell && bSelectAttSpell == 0 )
			{
				bTryingSelect = false;
				if ( AttSpell == None ||
					(AttSpell.InventoryGroup != FavAttSpell1 &&
					 AttSpell.InventoryGroup != FavAttSpell2) )
				{
					if ( FavAttSpell1 != 0 )
					{
						SwitchWeapon(FavAttSpell1);
					}
					else
					if ( FavAttSpell2 != 0 )
					{
						SwitchWeapon(FavAttSpell2);
					}
					return false; //don't force calling fn to return
				}
                
				if ( AttSpell.InventoryGroup == FavAttSpell1 && FavAttSpell2 != 0 )
				{
					SwitchWeapon(FavAttSpell2);
				}
				else
				if ( AttSpell.InventoryGroup == FavAttSpell2 && FavAttSpell1 != 0 )
				{
					SwitchWeapon(FavAttSpell1);
				}
			}
			else
			if ( SelectMode == SM_DefSpell && bSelectDefSpell == 0 )
			{
				bTryingSelect = false;
				if ( DefSpell == None ||
					(DefSpell.InventoryGroup != FavDefSpell1 &&
					 DefSpell.InventoryGroup != FavDefSpell2) )
				{
					if ( FavDefSpell1 != 0 )
					{
						SwitchWeapon(FavDefSpell1);
					}
					else
					if ( FavDefSpell2 != 0 )
					{
						SwitchWeapon(FavDefSpell2);
					}
					return false; //don't force calling fn to return
				}
                
				if ( DefSpell.InventoryGroup == FavDefSpell1 && FavDefSpell2 != 0 )
				{
					SwitchWeapon(FavDefSpell2);
				}
				else
				if ( DefSpell.InventoryGroup == FavDefSpell2 && FavDefSpell1 != 0 )
				{
					SwitchWeapon(FavDefSpell1);
				}
			}
			else
			if ( SelectMode == SM_Item && bSelectItem == 0 )
			{
				bTryingSelect = false;
				if ( SelectedItem == None ||
					(SelectedItem.InventoryGroup != FavItem1 &&
					SelectedItem.InventoryGroup != FavItem2) )
				{
					if ( FavItem1 != 0 )
					{
						SelectedItem = Inventory.FindItemInGroup(FavItem1);
					}
					else
					if ( FavItem2 != 0 )
					{
						SelectedItem = Inventory.FindItemInGroup(FavItem2);
					}
					return false; //don't force calling fn to return
				}
                
				if ( SelectedItem.InventoryGroup == FavItem1 && FavItem2 != 0 )
				{
					SelectedItem = Inventory.FindItemInGroup(FavItem2);
				}
				else
				if ( SelectedItem.InventoryGroup == FavItem2 && FavItem1 != 0 )
				{
					SelectedItem = Inventory.FindItemInGroup(FavItem1);
				}
			}
		}
		else
		{
			//lets bring up selection menu
			bTryingSelect = false;
			bSelectObject = true;
			GotoState('SelectObject');
			return true; //use this to force calling fn to immed. return.
		}
	}
    return false;
}

// like the wheel, except this checks to see if we should enter 'scrolling' on PS2
function bool CheckScroll( float DeltaTime )
{
//	Log("CheckScroll called!");
	SelectTimer -= DeltaTime;

	if ( SelectTimer > 0.0 )
	{
		// if key is back up, all we do is go to next selection in the list
		if ( SelectMode == SM_Weapon && bScrollWeapon == 0 )
		{
			bTryingScroll = false;
			NextWeapon();
//			Log("CheckScroll: NextWeapon(), Timer had "$SelectTimer$" left");
			return false; //don't force calling fn to return
		}
		else if ( SelectMode == SM_AttSpell && bScrollAttSpell == 0 )
		{
			bTryingScroll = false;
			NextAttSpell();
//			Log("CheckScroll: NextAttSpell(), Timer had "$SelectTimer$" left");
			return false; //don't force calling fn to return
		}
		else if ( SelectMode == SM_DefSpell && bScrollDefSpell == 0 )
		{
			bTryingScroll = false;
			NextDefSpell();
//			Log("CheckScroll: NextDefSpell(), Timer had "$SelectTimer$" left");
			return false; //don't force calling fn to return
		}
	}
	else
	{
		// player has held button down long enough--we enter 'scrolling' mode
		bTryingScroll = false;
		bScrollObject = true;
//		Log("Held button long enough, entering state ScrollObject");
		GotoState('ScrollObject');
		return true; //use this to force calling fn to immed. return.
	}
}

event PlayerInput( float DeltaTime )
{
	if ( !bShowMenu && bTryingSelect && (myHud != None) )
    {
        CheckSelect( DeltaTime );
    }
	
	if ( !bShowMenu && bTryingScroll && (myHud != None) )
    {
		// this is ps2 specific, will never get called on PC
		// this checks to see if we should enter 'scrolling' state
        CheckScroll( DeltaTime );
    }

	Super.PlayerInput( DeltaTime );

	if ( bJump > 0 ) 
		JumpHeldTime += DeltaTime;
	else
		JumpHeldTime = 0;
		
	if ( bFire > 0 ) 
		FireHeldTime += DeltaTime;
	else
		FireHeldTime = 0;

	if ( bFireAttSpell > 0 ) 
		FireAttSpellHeldTime += DeltaTime;
	else
		FireAttSpellHeldTime = 0;

	if ( bFireDefSpell > 0 ) 
		FireDefSpellHeldTime += DeltaTime;
	else
		FireDefSpellHeldTime = 0;
		
}

//----------------------------------------------------------------------------

// return raw (unclipped, unlimited) rotation delta
function rotator RawDeltaRotation( float deltaTime )
{
	local rotator	dRot;

	dRot.Pitch = 32.0 * deltaTime * aLookUp;
	dRot.Yaw = 32.0 * deltaTime * aTurn;
	dRot.Roll = 0.0;
	return dRot;
}

//----------------------------------------------------------------------------

//change

function NeedActivate()
{
	bNeedActivate = true;
}


// Player movement.
// Player Swimming
state PlayerSwimming
{
ignores SeePlayer, HearNoise, Bump;

	event UpdateEyeHeight(float DeltaTime)
	{
		local float smooth, bound;
		
		// smooth up/down stairs
		if( !bJustLanded )
		{
			smooth = FMin(1.0, 10.0 * DeltaTime/Level.TimeDilation);
			EyeHeight = (EyeHeight - Location.Z + OldLocation.Z) * (1 - smooth) + ( ShakeVert + BaseEyeHeight) * smooth;
			bound = -0.5 * CollisionHeight;
			if (EyeHeight < bound)
				EyeHeight = bound;
			else
			{
				bound = CollisionHeight + FClamp((OldLocation.Z - Location.Z), 0.0, MaxStepHeight); 
				 if ( EyeHeight > bound )
					EyeHeight = bound;
			}
		}
		else
		{
			smooth = FClamp(10.0 * DeltaTime/Level.TimeDilation, 0.35, 1.0);
			bJustLanded = false;
			EyeHeight = EyeHeight * ( 1 - smooth) + (BaseEyeHeight + ShakeVert) * smooth;
		}

		// teleporters affect your FOV, so adjust it back down
		if ( FOVAngle != DesiredFOV )
		{
			if ( FOVAngle > DesiredFOV )
				FOVAngle = FOVAngle - FMax(7, 0.9 * DeltaTime * (FOVAngle - DesiredFOV)); 
			else 
				FOVAngle = FOVAngle - FMin(-7, 0.9 * DeltaTime * (FOVAngle - DesiredFOV)); 
			if ( Abs(FOVAngle - DesiredFOV) <= 10 )
				FOVAngle = DesiredFOV;
		}

		// adjust FOV for weapon zooming
		if ( bZooming )
		{	
			ZoomLevel += DeltaTime * 1.0;
			if (ZoomLevel > 0.9)
				ZoomLevel = 0.9;
			DesiredFOV = FClamp(90.0 - (ZoomLevel * 88.0), 1, 170);
		} 
	}

	function Landed(vector HitNormal)
	{
		CheckLanded( HitNormal );

		if ( !bUpdating )
		{
			//log(class$" Landed while swimming");
			PlayLanded(Velocity.Z);
			TakeFallingDamage();
			bJustLanded = true;
		}
		if ( Region.Zone.bWaterZone )
			SetPhysics(PHYS_Swimming);
		else
		{
			GotoState('PlayerWalking');
			AnimEnd();
		}
	}

	function AnimEnd()
	{
		local vector X,Y,Z;
		GetAxes(Rotation, X,Y,Z);
		if ( (Acceleration Dot X) <= 0 )
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
			{
				bAnimTransition = true;
				TweenToWaiting(0.2);
			} 
			else
				PlayWaiting();
		}	
		else
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
			{
				bAnimTransition = true;
				TweenToSwimming(0.2);
			} 
			else
				PlaySwimming();
		}
	}
	
	function ZoneChange( ZoneInfo NewZone )
	{
		local actor HitActor;
		local vector HitLocation, HitNormal, checkpoint;
		local int HitJoint;

		if (!NewZone.bWaterZone)
		{
			SetPhysics(PHYS_Falling);
			if (bUpAndOut && CheckWaterJump(HitNormal)) //check for waterjump
			{
				velocity.Z = 330 + 2 * CollisionRadius; //set here so physics uses this for remainder of tick
				PlayDuck();
				GotoState('PlayerWalking');
			}				
			else if (!FootRegion.Zone.bWaterZone || (Velocity.Z > 160) )
			{
				GotoState('PlayerWalking');
				AnimEnd();
			}
			else //check if in deep water
			{
				checkpoint = Location;
				checkpoint.Z -= (CollisionHeight + 6.0);
				HitActor = Trace(HitLocation, HitNormal, HitJoint, checkpoint, Location, false);
				if (HitActor != None)
				{
					GotoState('PlayerWalking');
					AnimEnd();
				}
				else
				{
					Enable('Timer');
					SetTimer(0.7,false);
				}
			}
			//log("Out of water");
		}
		else
		{
			Disable('Timer');
			SetPhysics(PHYS_Swimming);
		}
	}

	function ProcessMove(float DeltaTime, vector NewAccel, rotator DeltaRot)	
	{
		local vector X,Y,Z, Temp;
	
		GetAxes(ViewRotation,X,Y,Z);
		Acceleration = NewAccel;

		SwimAnimUpdate( (X Dot Acceleration) <= 0 );

		bUpAndOut = ((X Dot Acceleration) > 0) && ((Acceleration.Z > 0) || (ViewRotation.Pitch > 2048));
		if ( bUpAndOut && !Region.Zone.bWaterZone && CheckWaterJump(Temp) ) //check for waterjump
		{
			velocity.Z = 330 + 2 * CollisionRadius; //set here so physics uses this for remainder of tick
			PlayDuck();
			GotoState('PlayerWalking');
		}				
		if ( Physics == PHYS_Swimming )
		{
			// check crouch
			if ( bDuck == 0 )
			{
				// change from crouching to standing
				bIsCrouching = false;
			}
		}
		AdjustCrouch( DeltaTime );
	}

	event PlayerTick( float DeltaTime )
	{
		DoEyeTrace();
		if ( bUpdatePosition )
			ClientUpdatePosition();

		SoundDuration -= DeltaTime;
		
		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local rotator oldRotation;
		local vector X,Y,Z, NewAccel;
		local float Speed2D, random;
	
		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.2;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;
		
		NewAccel = aForward*X + aStrafe*Y + aUp*vect(0,0,1);

		// Add swimming noises if the player is swimming.
		if (((NewAccel.X * NewAccel.X + NewAccel.Y * NewAccel.Y + NewAccel.Z * NewAccel.Z) > 0) && (SoundDuration < 0))
		{
			random = FRand ();
			if (random < 0.3333)
			{
				SoundDuration = GetSoundDuration (Swim1) + 0.2;
				PlaySound(Swim1, SLOT_None, 1.0);
			}
			else if (random < 0.6666)
			{
				SoundDuration = GetSoundDuration (Swim2) + 0.2;
				PlaySound(Swim2, SLOT_None, 1.0);
			}
			else
			{
				SoundDuration = GetSoundDuration (Swim3) + 0.2;
				PlaySound(Swim3, SLOT_None, 1.0);
			}

		}
	
		//add bobbing when swimming
		if ( !bShowMenu )
		{
			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			WalkBob = Y * Bob *  0.5 * Speed2D * sin(4.0 * Level.TimeSeconds);
			WalkBob.Z = Bob * 1.5 * Speed2D * sin(8.0 * Level.TimeSeconds);
		}

		// Update rotation.
		oldRotation = Rotation;
		UpdateRotation(DeltaTime);

		if (bAllowMove)
		{
			if ( Role < ROLE_Authority ) // then save this move and replicate it
				ReplicateMove(DeltaTime, NewAccel, OldRotation - Rotation);
			else
				ProcessMove(DeltaTime, NewAccel, OldRotation - Rotation);
		}
		bPressedJump = false;
	}

	function Timer()
	{
		if ( !Region.Zone.bWaterZone && (Role == ROLE_Authority) )
		{
			//log("timer out of water");
			GotoState('PlayerWalking');
			AnimEnd();
		}
	
		Disable('Timer');
	}
	
	function BeginState()
	{
		bRenderWeapon = true;
		bSelectObject = false;
		Disable('Timer');
		if ( !IsAnimating() )
			TweenToWaiting(0.3);
		SoundDuration = 0.0;
		//log("player swimming");
	}
}


//================================================================================
// Player movement.
// Player Standing, walking, running, falling.
state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;

	exec function FeignDeath()
	{
		if ( Physics == PHYS_Walking )
		{			ServerFeignDeath();
			Acceleration = vect(0,0,0);
			GotoState('FeigningDeath');
		}
	}

	function ZoneChange( ZoneInfo NewZone )
	{
		if (NewZone.bWaterZone)
		{
			SelectMode = SM_None;
			setPhysics(PHYS_Swimming);
			GotoState('PlayerSwimming');
		}
	}

/*	TODO: can this event help transitions?
	function AnimEnd()
	{
		local name MyAnimGroup;

		if (Physics == PHYS_Walking)
		{
			if (bIsCrouching)
			{
				if ( !bIsTurning && ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) < 1000) )
					PlayDuck();	
				else
					PlayCrawling();
			}
			else
			{
				MyAnimGroup = GetAnimGroup(AnimSequence);
				if ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) == 1000)
					PlayLocomotion( vect(0,0,0) );
				else if (bIsWalking)
					PlayLocomotion( vect(0.5,0,0) );
				else
					PlayLocomotion( vect(1,0,0) );
			}
		}
	}
*/

	function Landed(vector HitNormal)
	{
//		log( "event Landed()" );
//		ClientMessage( "event Landed()" );
		Global.Landed(HitNormal);
		if ( VSize(Acceleration) < 100 )
			PlayWaiting();
	}

	function ProcessMove(float DeltaTime, vector NewAccel, rotator DeltaRot)
	{
		local vector	OldAccel;
		local float		OldVSize;
		local float		NewVSize;
		local rotator	lRot;

		OldAccel = Acceleration;
		OldVSize = VSize(OldAccel);
		NewVSize = VSize(NewAccel);

//		log( "in ProcessMove, OldAccel is <" $ OldAccel $ "> (" $ OldVSize $ "), NewAccel is <" $ NewAccel $ "> (" $ NewVSize $ ")" );

		Acceleration = NewAccel;
		bIsTurning = ( Abs(DeltaRot.Yaw/DeltaTime) > 5000 );

		if ( bPressedJump )
			DoJump();

		if ( Physics == PHYS_Walking )
		{
			// check crouch
			if ( !bIsCrouching )
			{
				if ( bDuck != 0 )
				{
					// change from standing to crouching
					bIsCrouching = true;
					if ( NewVSize < 0.05 )
						PlayLocomotion( vect(0,0,0) );
				}
			}
			else if ( bDuck == 0 )
			{
				// change from crouching to standing
				bIsCrouching = false;
			}

			if ( ( NewVSize > 0.05 ) )	//&& ( OldVSize < 0.05 ) )
			{
				// movement just started
				lRot = Rotation;
				lRot.Pitch = 0;
				lRot.Roll = 0;

				lRot = rotator(Acceleration) - lRot;
				PlayLocomotion( vector(lRot) );
			}
			else if ( ( NewVSize < 0.05 ) && ( OldVSize > 0.05 ) )
			{
				// movement just stopped
				PlayLocomotion( vect(0,0,0) );
			}
/*
			if ( !bIsCrouching )
			{
				if ( Acceleration != vect(0,0,0) )
				{
					if ( (GetAnimGroup(AnimSequence) == 'Waiting') || (GetAnimGroup(AnimSequence) == 'Gesture') || (GetAnimGroup(AnimSequence) == 'TakeHit') )
						PlayLocomotion( vect(1,0,0) );
				}
				else if ( (Velocity.X * Velocity.X + Velocity.Y * Velocity.Y < 1000) 
					&& (GetAnimGroup(AnimSequence) != 'Gesture') ) 
				{
					if ( GetAnimGroup(AnimSequence) == 'Waiting' )
					{
						if ( bIsTurning && (AnimFrame >= 0) ) 
							PlayTurning();
					}
					else if ( !bIsTurning ) 
						PlayLocomotion( vect(0,0,0) );
				}
			}
			else if ( bIsCrouching )
			{
				if ( (OldAccel == vect(0,0,0)) && (Acceleration != vect(0,0,0)) )
					PlayCrawling();
			 	else if ( !bIsTurning && (Acceleration == vect(0,0,0)) && (AnimFrame > 0.1) )
					PlayDuck();
			}
*/
		}
		AdjustCrouch( DeltaTime );
	}
			
	event PlayerTick( float DeltaTime )
	{
		local float DeltaOpacity;

		if ( Health <= 0 )
		{
			GotoState('Dying');
			return;
		}

		DoEyeTrace();
		if (PhaseMod == none)
		{
			//Super.PlayerTick(DeltaTime);
		} 
		else if (!PhaseMod.bActive) 
		{
			// player cutscene fade in/out
			DeltaOpacity = deltaTime * 2.0;
			if ( bRenderSelf )
				Opacity = FClamp(Opacity + DeltaOpacity, 0, 1);
			else
				Opacity = FClamp(Opacity - DeltaOpacity, 0, 1);
		}

		if ( bUpdatePosition )
			ClientUpdatePosition();

		PlayerMove(DeltaTime);
	}

	function PlayerMove( float DeltaTime )
	{
		local vector X,Y,Z, NewAccel;
		local rotator OldRotation;
		local float Speed2D;
		local bool	bSaveJump;
		local rotator MoveRot;

		VelocityBias = GetTotalPhysicalEffect( DeltaTime );

		MoveRot.Yaw = ViewRotation.Yaw;
		GetAxes(MoveRot,X,Y,Z);

		aForward *= 0.4;
		aStrafe  *= 0.4;
		aLookup  *= 0.24;
		aTurn    *= 0.24;

		// Update acceleration.
		NewAccel = aForward*X + aStrafe*Y; 
		NewAccel.Z = 0;
																		//dodge  ?
		if ( (Physics == PHYS_Walking) && (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			//if walking, look up/down stairs - unless player is rotating view
			if ( !bKeyboardLook && (bLook == 0) )
			{
				if ( bLookUpStairs )
					ViewRotation.Pitch = FindStairRotation(deltaTime);
				else if ( bCenterView )
				{
					ViewRotation.Pitch = ViewRotation.Pitch & 65535;
					if (ViewRotation.Pitch > 32768)
						ViewRotation.Pitch -= 65536;
					ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
					if ( Abs(ViewRotation.Pitch) < 1000 )
						ViewRotation.Pitch = 0;	
				}
			}

			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			//add bobbing when walking
			if ( !bShowMenu )
			{
				if ( Speed2D < 10 )
					BobTime += 0.2 * DeltaTime;
				else
					BobTime += DeltaTime * (0.3 + 0.7 * Speed2D/GroundSpeed);
				WalkBob = Y * 0.65 * Bob * Speed2D * sin(6.0 * BobTime);
				if ( Speed2D < 10 )
					WalkBob.Z = Bob * 30 * sin(12 * BobTime);
				else
					WalkBob.Z = Bob * Speed2D * sin(12 * BobTime);
			}
		}	
		else if ( !bShowMenu )
		{ 
			BobTime = 0;
			WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
		}

		OldRotation = Rotation;
		if ( bBehindView && ( bExtra2 > 0 ) )
		{
			// apply rotation delta to behindview offset
			BehindViewOffset = BehindViewOffset + RawDeltaRotation( DeltaTime );
		}
		else
		{
			// Update rotation.
			UpdateRotation(DeltaTime);
		}
														//dodge ?
		if ( bPressedJump && ((GetAnimGroup(AnimSequence) == 'Dodge') || (GetAnimGroup(AnimSequence) == 'Landing')) )
		{
			bSaveJump = true;
			bPressedJump = false;
		}
		else
			bSaveJump = false;

		if (!bAllowMove)
		{
			aForward *= 0;
			aStrafe  *= 0;
			aLookup  *= 0;
			aTurn    *= 0;
	
			// Update acceleration.
			NewAccel = vect(0,0,0); 
			Velocity = vect(0,0,0);
		}

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, OldRotation - Rotation);
		bPressedJump = bSaveJump;
	}

	function BeginState()
	{
		bRenderWeapon = true;
//		WindowConsole(Player.Console).bShellPauses = false;
//		Level.bDontAllowSavegame = false;
		// LetterBox(false);
		UnFreeze(); // just make sure we're unfrozen (in case we're coming from a Dialog Scene)
		WalkBob = vect(0,0,0);
		bIsTurning = false;
		bPressedJump = false;
		if (Physics != PHYS_Falling) SetPhysics(PHYS_Walking);
		if ( !IsAnimating() )
			PlayLocomotion( vect(0,0,0) );

		bSelectObject = false;
		SelectMode = SM_None;
	}
	
	function EndState()
	{
		WalkBob = vect(0,0,0);
	}
}

//================================================================================
// Player is being shown a cutscene.
simulated state PlayerCutScene
{
	ignores WeaponAction, ActivateItem, DoJump, SeePlayer, HearNoise, Bump, FeignDeath, ProcessMove, FireAttSpell, FireDefSpell, SelectWeapon, SelectAttSpell, SelectDefSpell, SelectItem, SwitchWeapon, SwitchAttSpell, SwitchDefSpell, Scrye, NextItem, PrevItem, PrevWeapon, NextWeapon, QuickSave, ShowBook; // SaveGameToMemoryCard, SaveGame, ;
	
	function UnLock()
	{
		bAcceptDamage = true;
		bAcceptMagicDamage = true;
		UnFreeze();
		ReleasePos();
		ViewSelf();
		Letterbox(false);
		bRenderSelf = true;
		DesiredFOV = DefaultFOV;
	}
	
	function BeginState()
	{
		log("PlayerCutscene BeginState() ... "$Level.TimeSeconds, 'Misc');
		if ( (HasteMod != none) && HasteMod.bActive )
			HasteMod.GotoState('Deactivated');
		bFire = 0;
		bFireAttSpell = 0;
		bFireDefSpell = 0;

		bSelectWeapon = 0;
		bSelectAttSpell = 0;
		bSelectDefSpell = 0;
		bSelectItem = 0;
	
		if ( Player != None && Player.Console != None )
			WindowConsole(Player.Console).bShellPauses = true;
		Level.bDontAllowSavegame = true;
		NoDetect(true);
	}
	
	function EndState()
	{
		log("PlayerCutscene BeginState() ... "$Level.TimeSeconds, 'Misc');
		NoDetect(false);
		UnLock();
		if ( Player != None && Player.Console != None )
			WindowConsole(Player.Console).bShellPauses = false;
		Level.bDontAllowSavegame = false;
		bFire = 0;
		bFireAttSpell = 0;
		bFireDefSpell = 0;
		if ( Weapon != None )
			Weapon.GotoState('Idle');
		if ( AttSpell != None )
			AttSpell.GotoState('Idle');
	}

	exec simulated function StopCutScene()
	{
		UnLock();
		Walk();
		if (Region.Zone.bWaterZone)
			GotoState('PlayerSwimming');
		else
			GotoState('PlayerWalking');
	}

	simulated event PlayerTick( float DeltaTime ) 
	{
		if (Health <= 0)
		{
			GotoState('Dying');
			return;
		}
		if ( MasterCamPoint == none )
		{
			GotoState('PlayerWalking');
			return;
		} else {
			DoEyeTrace();
			if (Health <= 0)
			{
				UnLock();
				GotoState('Dying');
			}
		}
		//ViewFade(DeltaTime, 4);
		ViewFlash(DeltaTime);
	}

	exec function Fire( optional float F )
	{
		local CameraProjectile Cam;
		local ScriptedPawn SP;

		if ( MasterCamPoint != none && (MasterCamPoint.bEscapable || MasterCamPoint.URL != "") )
		{
			log("Player in PlayerCutscene State -- forcing Completed Cutscene", 'Misc');
			MasterCamPoint.CompleteCutscene(self);
			MasterCamPoint.Teleport(self);
		}
		else if (GetRenewalConfig().bMoreSkippableCutscenes)
		{
			ForEach AllActors(class 'CameraProjectile', Cam)
			{
				Cam.SkipIt();
			}

			foreach AllActors( class'ScriptedPawn', SP )
			{
				SP.Script.bClickThrough = true;
				SP.FastScript( true );
			}
			
			AeonsHud(myHud).RemoveSubtitle();
		}
	}

	Begin:
		bAcceptDamage = false;
		bAcceptMagicDamage = false;
		LetterboxRate(0);
		LetterBox(true);
		//ClientMessage("Begin Cutscene State");
		PlayAnim('Idle');
	End:
		//ClientMessage("End Cutscene State");
}

state SpecialKill
{
	ignores SelectItem;
}

//================================================================================
// Player is flying... up, up, in the air...like a beautiful baloooooon.....

state PlayerFlying
{
ignores SeePlayer, HearNoise, Bump;
		
	function AnimEnd()
	{
		PlaySwimming();
	}

	function ProcessMove(float DeltaTime, vector NewAccel, rotator DeltaRot)	
	{
//		log( Role $ " in ProcessMove(), aUp is " $ aUp );

		Acceleration = Normal(NewAccel) * AirSpeed;
		MoveSmooth(Acceleration * DeltaTime);
	}
	
	event PlayerTick( float DeltaTime ) 
	{
		local float DeltaOpacity;
		
		DoEyeTrace();
		if (PhaseMod == none)
		{
			//Super.PlayerTick(DeltaTime);
		} 
		else if (!PhaseMod.bActive) 
		{
			// player cutscene fade in/out
			DeltaOpacity = deltaTime * 2.0;
		
			if ( bRenderSelf )
				Opacity = FClamp(Opacity + DeltaOpacity, 0, 1);
			else
				Opacity = FClamp(Opacity - DeltaOpacity, 0, 1);
		}

		if ( bUpdatePosition )
			ClientUpdatePosition();
	
		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local rotator newRotation;
		local vector X,Y,Z;

		VelocityBias = GetTotalPhysicalEffect( DeltaTime );

		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.1;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;
 
		//Acceleration = aForward*X + aStrafe*Y + aUp*vect(0,0,1);  
		Acceleration = aForward*X + aStrafe*Y ;//+ aForward*Z;  
		
		UpdateRotation(DeltaTime);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, Acceleration, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Acceleration, rot(0,0,0));
/*		
		//fix		
		if ( aUp > 0 )
		{
			SetTimer(0.2, false); 
		}
*/
			
	}
/*	
	function Timer()
	{
		SetPhysics(PHYS_Falling);
		if (Region.Zone.bWaterZone)
			GotoState('PlayerSwimming');
		else
			GotoState('PlayerWalking');
	}
*/	
	function BeginState()
	{
		bRenderWeapon = true;
		EyeHeight = BaseEyeHeight;
		SetPhysics(PHYS_Flying);
		bCanFly = true;
		PlayFlight();
		SelectMode = SM_None;
//		if  ( !IsAnimating() ) 
//			PlaySwimming();
	}
	
	function EndState()
	{
		bCanFly = false;
	}
}

//================================================================================
//This state is for routing player input to the HUD for selecting weapons and spells
//only expands on PlayerWalking state so all movement functions are the same
//we only overload PlayerInput to redirect just player's mouse movements.
state SelectObject expands PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;

	function Taunt( name Sequence )
	{
	}

    //ignore Pause and ShowMenu when in this state
    function Pause()
    {
    }

    function ShowMenu()
    {
    }

	/*
	exec function Jump( optional float F )
	{
		//Log("JUmp while in wheel");
	}
	*/

	exec function Fire(optional float F)
	{
		bFire = 0;
		SetObject(true);
	}

    exec function FireAttSpell( optional float F )
    {
		bFireAttSpell = 0;
    }

	exec function FireDefSpell( optional float F )
    {
		bFireDefSpell = 0;
	}

    //could have these functions advance or decrement current HUD selection
    function PrevWeapon()
    {
    }

    function NextWeapon()
    {
    }

    //player wishes to select by hitting a number key
    function SelectInputNumber( byte F )
    {
        //if spell then search inventory for an item ManaWhorl that is bActive
        //if found then increment castingLevel of selected spell and destroy ManaWhorl
		//Log("Switching to " $ F );
        //SwitchWeapon now handles spells as well and is already multiplayer compliant
        SwitchWeapon(F);
    }

    function SetObject(optional bool bClicked)
    {
        local byte  slot;
		local Inventory Inv;

		//Log("SetObject - AeonsHud(myHud) = " $ AeonsHud(myHud) );
        //read mouse coords and determine slot
        //determine if slot has valid selection object -else return
        if ( AeonsHUD(myHud) != None ) 
        {
			if ( AeonsHUD(myHud).SelectedSector >= 0 )
				slot = AeonsHUD(myHud).SelectedSector;
			else 
				return;

            //conventional weapons are inventory groups 1 to 10
	        //Attack spells are inventory groups 11 to 20
	        //Defense spells are inventory groups 21 to 30
	        //Items are inventory groups >= 100
	        if ( SelectMode == SM_AttSpell )
	            //slot += 10;
				slot = AeonsHud(MyHud).Off_InvGroup[slot];
	        else if ( SelectMode == SM_DefSpell )
	            //slot += 20;
				slot = AeonsHud(MyHud).Def_InvGroup[slot];
			else if ( SelectMode == SM_Weapon )
				slot = AeonsHud(MyHud).Con_InvGroup[slot];
			else if ( SelectMode == SM_Item )
				slot = AeonsHud(MyHud).Item_InvGroup[slot];

			if ( slot >= 100 && bClicked )
			{
				// use item directly instead of switching to it
				Inv = Inventory.FindItemInGroup(slot);
				if ( Inv != none )
					Inv.Activate();
			}
	        else
			{
				SelectInputNumber(slot);

				PlaySound(sound'Aeons.HUD_Select01',SLOT_Misc,0.5);
			}
        
        }
    }

    exec function SetFavorite()
    {
        local int Favorite;
		local int InvGroup;
	
        //read mouse coords and determine valid selection object else return
        // Favorite = ???
        if ( AeonsHUD(myHud) != None )
        {
    		Favorite = AeonsHUD(myHud).SelectedSector;
	
			if ( SelectMode == SM_Weapon )
	        {
				if (Favorite != -1)
				{
					InvGroup = AeonsHUD(myHud).Con_InvGroup[Favorite];
					if ( InvGroup <= 0 )
					{
						PlaySound( sound'Aeons.HUD_Favorite01',SLOT_Misc,0.1);
						return;
					}
				}
				
	            if ( FavWeaponToggle )
	                FavWeapon2 = InvGroup;
	            else
	                FavWeapon1 = InvGroup;
	            FavWeaponToggle = !FavWeaponToggle;
	        }
	        else
	        if ( SelectMode == SM_AttSpell )
	        {
	        	if (Favorite != -1)
				{
					InvGroup = AeonsHUD(myHud).Off_InvGroup[Favorite];
					if ( InvGroup <= 0 )
					{
						PlaySound( sound'Aeons.HUD_Favorite01',SLOT_Misc,0.1);
						return;
					}
				}

	            if ( FavAttSpellToggle )
	                FavAttSpell2 = InvGroup;
	            else
	                FavAttSpell1 = InvGroup;
	            FavAttSpellToggle = !FavAttSpellToggle;
	        }
	        else
	        if ( SelectMode == SM_DefSpell )
	        {
				if (Favorite != -1)
				{
					InvGroup = AeonsHUD(myHud).Def_InvGroup[Favorite];
					if ( InvGroup <= 0 )
					{
						PlaySound( sound'Aeons.HUD_Favorite01',SLOT_Misc,0.1);
						return;
					}
				}

	            if ( FavDefSpellToggle )
	                FavDefSpell2 = InvGroup;
	            else
	                FavDefSpell1 = InvGroup;
	            FavDefSpellToggle = !FavDefSpellToggle;
	        }
			else
	        if ( SelectMode == SM_Item )
	        {
				if (Favorite != -1)
				{
					InvGroup = AeonsHUD(myHud).Item_InvGroup[Favorite];
					if ( InvGroup <= 0 )
					{
						PlaySound( sound'Aeons.HUD_Favorite01',SLOT_Misc,0.1);
						return;
					}
				}

	            if ( FavItemToggle )
	                FavItem2 = InvGroup;
	            else
					FavItem1 = InvGroup;
	            FavItemToggle = !FavItemToggle;
	        }

			PlaySound( sound'Aeons.HUD_Favorite01',SLOT_Misc,0.25);
        }
    }

    // Overloads the version in PlayerPawn so we can use input for object selection
    event PlayerInput( float DeltaTime )
    {
	    local float SmoothTime, FOVScale, MouseScale, KbdScale, AbsInput, AbsSmoothX, AbsSmoothY;

		if ( SelectMode == SM_Weapon && bSelectWeapon != 1 ||
			 SelectMode == SM_AttSpell && bSelectAttSpell != 1 ||
			 SelectMode == SM_DefSpell && bSelectDefSpell != 1 ||
			 SelectMode == SM_Item && bSelectItem != 1 || 
			 SelectMode == SM_None )
		{
			//player has finished with selection screen
			bSelectObject = false;
			bAllowSelectionHUD = true;
			Global.PlayerInput( DeltaTime);
			if (Region.Zone.bWaterZone)
				GotoState('PlayerSwimming');
			else
				GotoState('PlayerWalking');

			return;
		}

		Super.PlayerInput(DeltaTime);
		
		if ( GetPlatform() == PLATFORM_PSX2 )
		{
//			Log("aStrafe = "$aStrafe);
//			Log("aForward = "$aForward);

			AeonsHUD(myHUD).aX = aStrafe;
			AeonsHUD(myHUD).aY = aForward;

			aStrafe = 0;
			//aBaseY = 0;
			aForward = 0;
		}
		else
		{
			//mouse input goes to HUD
			if ( AeonsHUD(myHUD) != None )
			{
				if ( bMouseSmoothing ) 
				{
					AeonsHUD(myHUD).aX = SmoothMouseX * MouseSensitivity;
					AeonsHUD(myHUD).aY = SmoothMouseY * MouseSensitivity;
				}
				else
				{
					AeonsHUD(myHUD).aX = aMouseX * MouseSensitivity;
					AeonsHUD(myHUD).aY = aMouseY * MouseSensitivity;
				}
				AeonsHUD(myHUD).WheelMouseInput(DeltaTime);
			}

			aLookUp = 0;
			aTurn = 0;
			
			HandleWalking();
		}
	}

	function Killed(pawn Killer, pawn Other, name damageType)
	{
	//	bSelectObject = false;
		super.Killed(Killer, Other, DamageType);
	}

    function BeginState()
    {
		if ( AeonsHUD(myHUD) != None )
            AeonsHUD(myHUD).InitSelectMode();
    }

    function EndState()
    {
        if ( AeonsHUD(myHUD) != None )
            AeonsHUD(myHUD).FinishSelectMode();

		bFire = 0;
		bFireAttSpell = 0;
		bFireDefSpell = 0;
		SetObject();
		//bSelectObject = False;
   }
}

//================================================================================
//This state is exclusively for PS2, for a new feature called Weapon/Spell scrolling
//it allows you to use left analog stick to scroll thru weapons/spells while next
//weapon/spell button is held down (a quick tap of this button just gets next weapon/spell)
//it routes player input to the HUD for scrolling weapons and spells
//only expands on PlayerWalking state so all movement functions are the same
//we only overload PlayerInput to overload axis functions for scrolling.
state ScrollObject expands PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;

	function Taunt( name Sequence )
	{
	}

    //ignore Pause and ShowMenu when in this state
    function Pause()
    {
    }

    function ShowMenu()
    {
    }

	/* exec brady doesn't want this bindable */
	function ShowBook()
	{
		Log("I'm sorry Dave, can't show the book right now, Dave, try releasing that button, Dave...");
	}

	exec function Jump( optional float F )
	{
	}
	
	exec function Fire(optional float F)
	{
	}

    exec function FireAttSpell( optional float F )
    {
    }

	exec function FireDefSpell( optional float F )
    {
	}

    function PrevWeapon()
    {
    }

    function NextWeapon()
    {
    }

    function SelectInputNumber( byte F )
    {
    }

    function SetObject()
    {
	    if ( SelectedInvPSX2 != None )
		{
//			Log("Switching to " $ SelectedInvPSX2.InventoryGroup );
			SwitchWeapon(SelectedInvPSX2.InventoryGroup);

			PlaySound(sound'Aeons.HUD_Select01',SLOT_Misc,0.5);
		}
		else
			PlaySound(sound'Aeons.HUD_Select01',SLOT_Misc,0.1);
    }

    exec function SetFavorite()
    {
    }

    // Overloads the version in PlayerPawn so we can use input for object selection
    event PlayerInput( float DeltaTime )
    {
	    local float SmoothTime, FOVScale, MouseScale, KbdScale, AbsInput, AbsSmoothX, AbsSmoothY;

		if ( SelectMode == SM_Weapon && bScrollWeapon != 1 ||
			 SelectMode == SM_AttSpell && bScrollAttSpell != 1 ||
			 SelectMode == SM_DefSpell && bScrollDefSpell != 1 || 
			 SelectMode == SM_None )
		{
			//player has finished with scrolling
//			Log("Scroll button released, taking action");
			bScrollObject = false;
			bAllowSelectionHUD = true;
			Global.PlayerInput( DeltaTime);
			if (Region.Zone.bWaterZone)
				GotoState('PlayerSwimming');
			else
				GotoState('PlayerWalking');

			return;
		}

		if ( bAxisLeft == 1 || bAxisRight == 1 )
		{
			ScrollTimerPSX2 += DeltaTime;
			if ( ScrollTimerPSX2 > ScrollDelayPSX2 )
			{
				// we repeat in the direction stick is pressed
				if ( bAxisLeft == 1 )
					AxisLeft();
				else
					AxisRight();

				ScrollTimerPSX2 = 0;
			}
		}
		else
			ScrollTimerPSX2 = 0;

		Super.PlayerInput(DeltaTime);

	}

    exec function AxisRight( optional float F )
	{
//		Log("AxisRight called!");
		switch( SelectMode )
		{
			case SM_Weapon:
//				Log("GetNextWeapon() called!");
				GetNextWeapon();
				break;

			case SM_AttSpell:
//				Log("GetNextAttSpell() called!");
				GetNextAttSpell();
				break;

			case SM_DefSpell:
//				Log("GetNextDefSpell() called!");
				GetNextDefSpell();
				break;
		}

		ScrollTimerPSX2 = 0;
	}

    exec function AxisLeft( optional float F )
	{
//		Log("AxisLeft called!");
		switch( SelectMode )
		{
			case SM_Weapon:
//				Log("GetPrevWeapon() called!");
				GetPrevWeapon();
				break;

			case SM_AttSpell:
//				Log("GetPrevAttSpell() called!");
				GetPrevAttSpell();
				break;

			case SM_DefSpell:
//				Log("GetPrevDefSpell() called!");
				GetPrevDefSpell();
				break;
		}

		ScrollTimerPSX2 = 0;
	}

	function GetNextWeapon()
	{
		// Increment displayed weapon/spell
		local int nextGroup;
		local Inventory inv;
		local Weapon nextWeapon, realWeapon, w, Prev;
		local bool bFoundWeapon;

		nextGroup = 100;
		nextWeapon = None;

		if ( Weapon == None	)
			return;

		realWeapon = Weapon;
		Weapon = Weapon(SelectedInvPSX2);

		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			w = Weapon(inv);
			if ( w != None )
			{
				if ( w.InventoryGroup == Weapon.InventoryGroup )
				{
					if ( w == Weapon )
						bFoundWeapon = true;
					else if ( bFoundWeapon && ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
					{
						nextWeapon = W;
						break;
					}
				}
				else if ( (w.InventoryGroup > Weapon.InventoryGroup) 
						&& ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) 
						&& (w.InventoryGroup < nextGroup) )
				{
					nextGroup = w.InventoryGroup;
					nextWeapon = w;
				}
			}
		}

		bFoundWeapon = false;
		nextGroup = Weapon.InventoryGroup;
		if ( nextWeapon == None )
			for (inv=Inventory; inv!=None; inv=inv.Inventory)
			{
				w = Weapon(Inv);
				if ( w != None )
				{
					if ( w.InventoryGroup == Weapon.InventoryGroup )
					{
						if ( w == Weapon )
						{
							bFoundWeapon = true;
							if ( Prev != None )
								nextWeapon = Prev;
						}
						else if ( !bFoundWeapon && (nextWeapon == None) && ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
							Prev = W;
					}
					else if ( (w.InventoryGroup < nextGroup) 
						&& ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) ) 
					{
						nextGroup = w.InventoryGroup;
						nextWeapon = w;
					}
				}
			}

		Weapon = realWeapon;
		if ( nextWeapon == None )
			return;

		SelectedInvPSX2 = nextWeapon;
//		Log("Now showing "$SelectedInvPSX2.ItemName);
	}

	function GetNextAttSpell()
	{
		local int nextGroup;
		local Inventory inv;
		local Spell nextAttSpell, realAttSpell, s, Prev;
		local bool bFoundAttSpell;

		if ( AttSpell == None )
			return;

		nextGroup = 100;
		nextAttSpell = None;

		realAttSpell = AttSpell;
		AttSpell = Spell(SelectedInvPSX2);

		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			s = AttSpell(inv);
			if ( s != None )
			{
				if ( s.InventoryGroup == AttSpell.InventoryGroup )
				{
					if ( s == AttSpell )
						bFoundAttSpell = true;
					else if ( bFoundAttSpell )
					{
						nextAttSpell = s;
						break;
					}
				}
				else if ( (s.InventoryGroup > AttSpell.InventoryGroup) && (s.InventoryGroup < nextGroup) )
				{
					nextGroup = s.InventoryGroup;
					nextAttSpell = s;
				}
			}
		}

		bFoundAttSpell = false;
		nextGroup = AttSpell.InventoryGroup;
		if ( nextAttSpell == None )
			for (inv=Inventory; inv!=None; inv=inv.Inventory)
			{
				s = AttSpell(Inv);
				if ( s != None )
				{
					if ( s.InventoryGroup == AttSpell.InventoryGroup )
					{
						if ( s == AttSpell )
						{
							bFoundAttSpell = true;
							if ( Prev != None )
								nextAttSpell = Prev;
						}
						else if ( !bFoundAttSpell && (nextAttSpell == None) )
							Prev = s;
					}
					else if ( s.InventoryGroup < nextGroup ) 
					{
						nextGroup = s.InventoryGroup;
						nextAttSpell = s;
					}
				}
			}

		AttSpell = realAttSpell;
		if ( nextAttSpell == None )
			return;

		SelectedInvPSX2 = nextAttSpell;
//		Log("Now showing "$SelectedInvPSX2.ItemName);
	}

	function GetNextDefSpell()
	{
		local int nextGroup;
		local Inventory inv;
		local Spell nextDefSpell, realDefSpell, s, Prev;
		local bool bFoundDefSpell;

		if ( DefSpell == None )
			return;

		nextGroup = 100;
		nextDefSpell = None;

		realDefSpell = DefSpell;
		DefSpell = Spell(SelectedInvPSX2);

		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			s = DefSpell(inv);
			if ( s != None )
			{
				if ( s.InventoryGroup == DefSpell.InventoryGroup )
				{
					if ( s == DefSpell )
						bFoundDefSpell = true;
					else if ( bFoundDefSpell )
					{
						nextDefSpell = s;
						break;
					}
				}
				else if ( (s.InventoryGroup > DefSpell.InventoryGroup) && (s.InventoryGroup < nextGroup) )
				{
					nextGroup = s.InventoryGroup;
					nextDefSpell = s;
				}
			}
		}

		bFoundDefSpell = false;
		nextGroup = DefSpell.InventoryGroup;
		if ( nextDefSpell == None )
			for (inv=Inventory; inv!=None; inv=inv.Inventory)
			{
				s = DefSpell(Inv);
				if ( s != None )
				{
					if ( s.InventoryGroup == DefSpell.InventoryGroup )
					{
						if ( s == DefSpell )
						{
							bFoundDefSpell = true;
							if ( Prev != None )
								nextDefSpell = Prev;
						}
						else if ( !bFoundDefSpell && (nextDefSpell == None) )
							Prev = s;
					}
					else if ( s.InventoryGroup < nextGroup ) 
					{
						nextGroup = s.InventoryGroup;
						nextDefSpell = s;
					}
				}
			}

		DefSpell = realDefSpell;
		if ( nextDefSpell == None )
			return;

		SelectedInvPSX2 = nextDefSpell;
//		Log("Now showing "$SelectedInvPSX2.ItemName);
	}

	function GetPrevWeapon()
	{
		local int prevGroup;
		local Inventory inv;
		local Weapon prevWeapon, realWeapon, w, Prev;
		local bool bFoundWeapon;

		prevGroup = 0;
		prevWeapon = None;

		if ( Weapon == None	)
			return;

		realWeapon = Weapon;
		Weapon = Weapon(SelectedInvPSX2);
		
		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			w = Weapon(inv);
			if ( w != None )
			{
				if ( w.InventoryGroup == Weapon.InventoryGroup )
				{
					if ( w == Weapon )
					{
						bFoundWeapon = true;
						if ( Prev != None )
						{
							prevWeapon = Prev;
							break;
						}
					}
					else if ( !bFoundWeapon && ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
						Prev = W;
				}
				else if ( (w.InventoryGroup < Weapon.InventoryGroup) 
						&& ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) 
						&& (w.InventoryGroup >= prevGroup) )
				{
					prevGroup = w.InventoryGroup;
					prevWeapon = w;
				}
			}
		}
		bFoundWeapon = false;
		prevGroup = Weapon.InventoryGroup;
		if ( prevWeapon == None )
			for (inv=Inventory; inv!=None; inv=inv.Inventory)
			{
				w = Weapon(inv);
				if ( w != None )
				{
					if ( w.InventoryGroup == Weapon.InventoryGroup )
					{
						if ( w == Weapon )
							bFoundWeapon = true;
						else if ( bFoundWeapon && (prevWeapon == None) && ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
							prevWeapon = W;
					}
					else if ( (w.InventoryGroup > PrevGroup) 
							&& ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) ) 
					{
						prevGroup = w.InventoryGroup;
						prevWeapon = w;
					}
				}
			}

		Weapon = realWeapon;
		if ( prevWeapon == None )
			return;

		SelectedInvPSX2 = prevWeapon;
//		Log("Now showing "$SelectedInvPSX2.ItemName);
	}

	function GetPrevAttSpell()
	{
		local int prevGroup;
		local Inventory inv;
		local Spell prevAttSpell, realAttSpell, s, Prev;
		local bool bFoundAttSpell;

		if ( AttSpell == None )
			return;

		prevGroup = 0;
		prevAttSpell = None;

		realAttSpell = AttSpell;
		AttSpell = Spell(SelectedInvPSX2);
		
		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			s = AttSpell(inv);
			if ( s != None )
			{
				if ( s.InventoryGroup == AttSpell.InventoryGroup )
				{
					if ( s == AttSpell )
					{
						bFoundAttSpell = true;
						if ( Prev != None )
						{
							prevAttSpell = Prev;
							break;
						}
					}
					else if (!bFoundAttSpell )
						Prev = s;
				}
				else if ( (s.InventoryGroup < AttSpell.InventoryGroup) 
						&& (s.InventoryGroup >= prevGroup) )
				{
					prevGroup = s.InventoryGroup;
					prevAttSpell = s;
				}
			}
		}
		bFoundAttSpell = false;
		prevGroup = AttSpell.InventoryGroup;
		if ( prevAttSpell == None )
			for (inv=Inventory; inv!=None; inv=inv.Inventory)
			{
				s = AttSpell(inv);
				if ( s != None )
				{
					if ( s.InventoryGroup == AttSpell.InventoryGroup )
					{
						if ( s == AttSpell )
							bFoundAttSpell = true;
						else if ( bFoundAttSpell && (prevAttSpell == None) )
							prevAttSpell = s;
					}
					else if ( s.InventoryGroup > PrevGroup ) 
					{
						prevGroup = s.InventoryGroup;
						prevAttSpell = s;
					}
				}
			}

		AttSpell = realAttSpell;
		if ( prevAttSpell == None )
			return;

		SelectedInvPSX2 = prevAttSpell;
//		Log("Now showing "$SelectedInvPSX2.ItemName);
	}

	function GetPrevDefSpell()
	{
		local int prevGroup;
		local Inventory inv;
		local Spell prevDefSpell, realDefSpell, s, Prev;
		local bool bFoundDefSpell;

		if ( DefSpell == None )
			return;

		prevGroup = 0;
		prevDefSpell = None;
		
		realDefSpell = DefSpell;
		DefSpell = Spell(SelectedInvPSX2);

		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			s = DefSpell(inv);
			if ( s != None )
			{
				if ( s.InventoryGroup == DefSpell.InventoryGroup )
				{
					if ( s == DefSpell )
					{
						bFoundDefSpell = true;
						if ( Prev != None )
						{
							prevDefSpell = Prev;
							break;
						}
					}
					else if (!bFoundDefSpell )
						Prev = s;
				}
				else if ( (s.InventoryGroup < DefSpell.InventoryGroup) 
						&& (s.InventoryGroup >= prevGroup) )
				{
					prevGroup = s.InventoryGroup;
					prevDefSpell = s;
				}
			}
		}
		bFoundDefSpell = false;
		prevGroup = DefSpell.InventoryGroup;
		if ( prevDefSpell == None )
			for (inv=Inventory; inv!=None; inv=inv.Inventory)
			{
				s = DefSpell(inv);
				if ( s != None )
				{
					if ( s.InventoryGroup == DefSpell.InventoryGroup )
					{
						if ( s == DefSpell )
							bFoundDefSpell = true;
						else if ( bFoundDefSpell && (prevDefSpell == None) )
							prevDefSpell = s;
					}
					else if ( s.InventoryGroup > PrevGroup ) 
					{
						prevGroup = s.InventoryGroup;
						prevDefSpell = s;
					}
				}
			}

		DefSpell = realDefSpell;
		if ( prevDefSpell == None )
			return;

		SelectedInvPSX2 = prevDefSpell;
//		Log("Now showing "$SelectedInvPSX2.ItemName);
	}

	function Killed(pawn Killer, pawn Other, name damageType)
	{
//		bScrollObject = false;
		super.Killed(Killer, Other, DamageType);
	}

    function BeginState()
	{
		if ( SelectMode == SM_Weapon )
			SelectedInvPSX2 = Weapon;
		else if ( SelectMode == SM_AttSpell )
			SelectedInvPSX2 = AttSpell;
		else if ( SelectMode == SM_DefSpell )
			SelectedInvPSX2 = DefSpell;
		else if ( SelectMode == SM_Item )
			SelectedInvPSX2 = SelectedItem;
		else
			SelectedInvPSX2 = None;

		ScrollTimerPSX2 = 0.0;

		// Very Important--switch to digital axis input
		bDigitalStickPSX2 = True;
	}

    function EndState()
    {
		SetObject();
 
 		// Very Important--switch back to analog stick input
		bDigitalStickPSX2 = False;
   }
}

exec function mShat(int i)
{
	if (i == 0 )
		self.MindShatterMod.gotoState('Deactivated');
	else
	{
		self.MindShatterMod.gotoState('Deactivated');
		self.MindShatterMod.castingLevel = clamp((i-1),0, 4);
		self.MindShatterMod.gotoState('Activated');
	}
}

exec function becomeLight(int i)
{
	if ( i == 0 )
	{
		self.LightType = LT_none;
		self.LightSaturation = 0;
		self.LightRadius = 0;
		self.LightBrightness = 0;
	} 
	
	if ( i == 1 )
	{
		self.LightType = LT_Steady;
		self.LightSaturation = 255;
		self.LightRadius = 30;
		self.LightBrightness = 200;
	} 

}
exec function AssAll()
{
	bring('donkey');
}

exec function AddAll()
{
	local Weapon newWeapon;
	local Spell newSpell;
	local Items newItem;
		
	AttSpell.LocalCastingLevel = 4;
	AttSpell.CastingLevel = 4;

	// Conventional Weapons


	if ( (Inventory == None) || (Inventory.FindItemInGroup(class'Aeons.GhelziabahrStone'.default.InventoryGroup) == none)) //2
	{
		newWeapon = Spawn(class'Aeons.GhelziabahrStone');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}

	if (Inventory.FindItemInGroup(class'Aeons.Scythe'.default.InventoryGroup) == none)
	{
		newWeapon = Spawn(class'Aeons.Scythe');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}

	if (Inventory.FindItemInGroup(class'Aeons.Revolver'.default.InventoryGroup) == none)
	{
		newWeapon = Spawn(class'Aeons.Revolver');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}

	/*
	if (Inventory.FindItemInGroup(class'Aeons.Molotov'.default.InventoryGroup) == none)
	{
		newWeapon = Spawn(class'Aeons.Molotov');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}*/

	if (Inventory.FindItemInGroup(class'Aeons.Speargun'.default.InventoryGroup) == none)
	{
		newWeapon = Spawn(class'Aeons.Speargun');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}

	if (Inventory.FindItemInGroup(class'Aeons.TibetianWarCannon'.default.InventoryGroup) == none)
	{
		newWeapon = Spawn(class'Aeons.TibetianWarCannon');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}

	if (Inventory.FindItemInGroup(class'Aeons.Shotgun'.default.InventoryGroup) == none)
	{
		newWeapon = Spawn(class'Aeons.Shotgun');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}

	/*
	if (Inventory.FindItemInGroup(class'Aeons.Dynamite'.default.InventoryGroup) == none)
	{
		newWeapon = Spawn(class'Aeons.Dynamite');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}
	*/


	// Offensive spells
	if (Inventory.FindItemInGroup(class'Aeons.Ectoplasm'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Ectoplasm');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
			AttSpell = newSpell;
		}
	}

	if (Inventory.FindItemInGroup(class'Aeons.SkullStorm'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.SkullStorm');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}


	if (Inventory.FindItemInGroup(class'Aeons.Lightning'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Lightning');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}

	/*
	if (Inventory.FindItemInGroup(class'Aeons.Mindshatter'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Mindshatter');
		if( newSpell != None )
			newSpell.GiveTo(self);
	}


	if (Inventory.FindItemInGroup(class'Aeons.PowerWord'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.PowerWord');
		if( newSpell != None )
			newSpell.GiveTo(self);
	}
	*/
	if (Inventory.FindItemInGroup(class'Aeons.Phoenix'.default.InventoryGroup) == none)
	{
		newWeapon = Spawn(class'Aeons.Phoenix');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}

	if (Inventory.FindItemInGroup(class'Aeons.Invoke'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Invoke');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}

	/*
	if (Inventory.FindItemInGroup(class'Aeons.Ward'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Ward');
		if( newSpell != None )
			newSpell.GiveTo(self);
	}
	*/
	// Defensive Spells
	if (Inventory.FindItemInGroup(class'Aeons.DispelMagic'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.DispelMagic');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}

	/*
	if (Inventory.FindItemInGroup(class'Aeons.Firefly'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Firefly');
		if( newSpell != None )
			newSpell.GiveTo(self);
	}
	*/

	if (Inventory.FindItemInGroup(class'Aeons.Haste'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Haste');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}
	/*
	if (Inventory.FindItemInGroup(class'Aeons.IncantationOfSilence'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.IncantationOfSilence');
		if( newSpell != None )
			newSpell.GiveTo(self);
	}

	if (Inventory.FindItemInGroup(class'Aeons.Phase'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Phase');
		if( newSpell != None )
			newSpell.GiveTo(self);
	}
	*/
	if (Inventory.FindItemInGroup(class'Aeons.Scrye'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Scrye');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
			AttSpell = newSpell;
		}
	}
	/*
	if (Inventory.FindItemInGroup(class'Aeons.ShalasVortex'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.ShalasVortex');
		if( newSpell != None )
			newSpell.GiveTo(self);
	}
	*/
	if (Inventory.FindItemInGroup(class'Aeons.Shield'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Shield');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}
	/*
	if (Inventory.FindItemInGroup(class'Aeons.Pyro'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Pyro');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}
	*/
	/* Lantern is cut
	// give the player the Lantern
	if (Inventory.FindItemInGroup(class'Aeons.Lantern'.default.InventoryGroup) == none)
	{
		newItem = Spawn(class'Aeons.Lantern',,,Location);
		if( newItem != None )
		{
			newItem.GiveTo(self);
			newItem.setBase(self);
		}
	}*/

	AttSpell.LocalCastingLevel = 4;
	AttSpell.CastingLevel = 4;

	// all ammo
	Woo();
}

exec function DefAll()
{
	local Weapon newWeapon;
	local Spell newSpell;
	local Items newItem;
	
	if (Inventory.FindItemInGroup(class'Aeons.Mindshatter'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Mindshatter');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}


	if (Inventory.FindItemInGroup(class'Aeons.PowerWord'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.PowerWord');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}

	if (Inventory.FindItemInGroup(class'Aeons.Ward'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Ward');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}

	if (Inventory.FindItemInGroup(class'Aeons.Firefly'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Firefly');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}

	if (Inventory.FindItemInGroup(class'Aeons.IncantationOfSilence'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.IncantationOfSilence');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}

	if (Inventory.FindItemInGroup(class'Aeons.Phase'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Phase');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}

	if (Inventory.FindItemInGroup(class'Aeons.ShalasVortex'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.ShalasVortex');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}
	/*
	if (Inventory.FindItemInGroup(class'Aeons.Pyro'.default.InventoryGroup) == none)
	{
		newSpell = Spawn(class'Aeons.Pyro');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			newSpell.LocalCastingLevel = 4;
			newSpell.CastingLevel = 4;
		}
	}
	*/
}

exec function GiveMe(name this, optional int Amplitude)
{
	local Weapon newWeapon;
	local Spell newSpell;
	local Items newItem;
	
	// Conventional Weapons


	switch( this )
	{
		case 'GhelziabahrStone':
		case 'Stone':
		case 'Ghelz':
			if ( (Inventory == None) || (Inventory.FindItemInGroup(class'Aeons.GhelziabahrStone'.default.InventoryGroup) == none)) //2
			{
				newWeapon = Spawn(class'Aeons.GhelziabahrStone');
				if( newWeapon != None )
				{
					newWeapon.Instigator = self;
					newWeapon.BecomeItem();
					AddInventory(newWeapon);
					newWeapon.BringUp();
					newWeapon.GiveAmmo(self);
					newWeapon.SetSwitchPriority(self);
					newWeapon.WeaponSet(self);
				}
			}
			break;

		case 'Scythe':
			if (Inventory.FindItemInGroup(class'Aeons.Scythe'.default.InventoryGroup) == none)
			{
				newWeapon = Spawn(class'Aeons.Scythe');
				if( newWeapon != None )
				{
					newWeapon.Instigator = self;
					newWeapon.BecomeItem();
					AddInventory(newWeapon);
					newWeapon.BringUp();
					newWeapon.GiveAmmo(self);
					newWeapon.SetSwitchPriority(self);
					newWeapon.WeaponSet(self);
				}
			}
			break;

		case 'Revolver':
		case 'Pistol':
			if (Inventory.FindItemInGroup(class'Aeons.Revolver'.default.InventoryGroup) == none)
			{
				newWeapon = Spawn(class'Aeons.Revolver');
				if( newWeapon != None )
				{
					newWeapon.Instigator = self;
					newWeapon.BecomeItem();
					AddInventory(newWeapon);
					newWeapon.BringUp();
					newWeapon.GiveAmmo(self);
					newWeapon.SetSwitchPriority(self);
					newWeapon.WeaponSet(self);
				}
			}
			break;

		case 'Molotov':
			if (Inventory.FindItemInGroup(class'Aeons.Molotov'.default.InventoryGroup) == none)
			{
				newWeapon = Spawn(class'Aeons.Molotov');
				if( newWeapon != None )
				{
					newWeapon.Instigator = self;
					newWeapon.BecomeItem();
					AddInventory(newWeapon);
					newWeapon.BringUp();
					newWeapon.GiveAmmo(self);
					newWeapon.SetSwitchPriority(self);
					newWeapon.WeaponSet(self);
				}
			}
			break;


		case 'Speargun':
			if (Inventory.FindItemInGroup(class'Aeons.Speargun'.default.InventoryGroup) == none)
			{
				newWeapon = Spawn(class'Aeons.Speargun');
				if( newWeapon != None )
				{
					newWeapon.Instigator = self;
					newWeapon.BecomeItem();
					AddInventory(newWeapon);
					newWeapon.BringUp();
					newWeapon.GiveAmmo(self);
					newWeapon.SetSwitchPriority(self);
					newWeapon.WeaponSet(self);
				}
			}
			break;

		case 'Cannon':
		case 'TibetianWarCannon':
			if (Inventory.FindItemInGroup(class'Aeons.TibetianWarCannon'.default.InventoryGroup) == none)
			{
				newWeapon = Spawn(class'Aeons.TibetianWarCannon');
				if( newWeapon != None )
				{
					newWeapon.Instigator = self;
					newWeapon.BecomeItem();
					AddInventory(newWeapon);
					newWeapon.BringUp();
					newWeapon.GiveAmmo(self);
					newWeapon.SetSwitchPriority(self);
					newWeapon.WeaponSet(self);
				}
			}
			break;


		case 'BoomStick':
		case 'Shotgun':
			if (Inventory.FindItemInGroup(class'Aeons.Shotgun'.default.InventoryGroup) == none)
			{
				newWeapon = Spawn(class'Aeons.Shotgun');
				if( newWeapon != None )
				{
					newWeapon.Instigator = self;
					newWeapon.BecomeItem();
					AddInventory(newWeapon);
					newWeapon.BringUp();
					newWeapon.GiveAmmo(self);
					newWeapon.SetSwitchPriority(self);
					newWeapon.WeaponSet(self);
				}
			}
			break;

		/*
		case 'Dynamite':
			if (Inventory.FindItemInGroup(class'Aeons.Dynamite'.default.InventoryGroup) == none)
			{
				newWeapon = Spawn(class'Aeons.Dynamite');
				if( newWeapon != None )
				{
					newWeapon.Instigator = self;
					newWeapon.BecomeItem();
					AddInventory(newWeapon);
					newWeapon.BringUp();
					newWeapon.GiveAmmo(self);
					newWeapon.SetSwitchPriority(self);
					newWeapon.WeaponSet(self);
				}
			}
			break;*/


		// Offensive spells
		case 'Ecto':
		case 'Ectoplasm':
			if (Inventory.FindItemInGroup(class'Aeons.Ectoplasm'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.Ectoplasm');
				if( newSpell != None )
				{
					newSpell.GiveTo(self);
					NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
					AttSpell = newSpell;
				}
			}
			break;

		case 'SkullStorm':
		case 'Skull':
			if (Inventory.FindItemInGroup(class'Aeons.SkullStorm'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.SkullStorm');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;

		case 'Lightning':
			if (Inventory.FindItemInGroup(class'Aeons.Lightning'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.Lightning');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;

		case 'mshat':
		case 'mindshatter':
			if (Inventory.FindItemInGroup(class'Aeons.Mindshatter'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.Mindshatter');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;


		case 'pw':
		case 'word':
		case 'powerword'	:
			if (Inventory.FindItemInGroup(class'Aeons.PowerWord'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.PowerWord');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;
		case 'phoenix':
		case 'bird':
			if (Inventory.FindItemInGroup(class'Aeons.Phoenix'.default.InventoryGroup) == none)
			{
				newWeapon = Spawn(class'Aeons.Phoenix');
				if( newWeapon != None )
				{
					newWeapon.Instigator = self;
					newWeapon.BecomeItem();
					AddInventory(newWeapon);
					newWeapon.BringUp();
					newWeapon.GiveAmmo(self);
					newWeapon.SetSwitchPriority(self);
					newWeapon.WeaponSet(self);
				}
			}
			break;

		case 'invoke':
			if (Inventory.FindItemInGroup(class'Aeons.Invoke'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.Invoke');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;

		case 'ward':
			if (Inventory.FindItemInGroup(class'Aeons.Ward'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.Ward');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;
		// Defensive Spells
		case 'dispel':
		case 'dispelmagic':
			if (Inventory.FindItemInGroup(class'Aeons.DispelMagic'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.DispelMagic');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;


		case 'firefly':
			if (Inventory.FindItemInGroup(class'Aeons.Firefly'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.Firefly');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;
		case 'Haste':
			if (Inventory.FindItemInGroup(class'Aeons.Haste'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.Haste');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;

		case 'silence':

			if (Inventory.FindItemInGroup(class'Aeons.IncantationOfSilence'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.IncantationOfSilence');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;

		case 'invis':
		case 'invisibility':
		case 'phase':

			if (Inventory.FindItemInGroup(class'Aeons.Phase'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.Phase');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;
		case 'scrye':

			if (Inventory.FindItemInGroup(class'Aeons.Scrye'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.Scrye');
				if( newSpell != None )
				{
					newSpell.GiveTo(self);
					NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
					AttSpell = newSpell;
				}
			}
			break;

		case 'vortex':
		case 'shala':
		case 'shalas':
		case 'shalasvortex':

			if (Inventory.FindItemInGroup(class'Aeons.ShalasVortex'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.ShalasVortex');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;
		case 'shield':
			if (Inventory.FindItemInGroup(class'Aeons.Shield'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.Shield');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;
		case 'pyro':
			if (Inventory.FindItemInGroup(class'Aeons.Pyro'.default.InventoryGroup) == none)
			{
				newSpell = Spawn(class'Aeons.Pyro');
				NewSpell.CastingLevel = Clamp(Amplitude, 0, 4);
				if( newSpell != None )
					newSpell.GiveTo(self);
			}
			break;
		default:
			if (FRand() > 0.5)
				bring('donkey');
			else
				bring('sheep');
			break;
	}
}

function bool HasItem( name InvClass )
{
	local Inventory Inv;

	Inv = Inventory;
	while( Inv != none )
	{
		if( Inv.IsA( InvClass ) )
			return true;
		Inv = Inv.Inventory;
	}
	return false;
}

function GiveStartupWeapons()
{
	local Weapon newWeapon;
	local Spell newSpell;
	local Items newItem;
	
	// Conventional Weapons

	if ( (Inventory == None) || !HasItem('GhelziabahrStone')) //2
	{
		newWeapon = Spawn(class'Aeons.GhelziabahrStone');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}

	/*
	if (!HasItem('Dynamite'))
	{
		newWeapon = Spawn(class'Aeons.Dynamite');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}
	*/

	if (!HasItem('Molotov'))
	{
		newWeapon = Spawn(class'Aeons.Molotov');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}

	if (!HasItem('Revolver'))
	{
		newWeapon = Spawn(class'Aeons.Revolver');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}

	if (!HasItem('Scrye'))
	{
		newSpell = Spawn(class'Aeons.Scrye');
		if( newSpell != None )
		{
			newSpell.GiveTo(self);
			AttSpell = newSpell;
		}
	}
	
	//ConsoleCommand("SetupInv");
}

simulated function GiveBook()
{
	local BookJournalBase TempBook;
	local class<BookJournalBase> BookJournalClass;
	local JournalEntry TempEntry;
	
	if ( Book == None )
	{
		if (GetPlatform() == PLATFORM_PSX2)
		{
			TempBook = Spawn(class'Aeons.BookJournalPSX2', Self);
		}
		else
		{
			//Log("We're on the PC, so give em a PC book.");
			BookJournalClass = class<BookJournalBase>(DynamicLoadObject("Aeons.BookJournal", class'Class'));
			if ( BookJournalClass != None )
			{
				//Log("BookJournalClass != None, it = "$BookJournalClass);
				TempBook = Spawn(BookJournalClass, Self);

// The book spawns it's ObjectivesJournal in it's PostBeginPlay
//				if ( TempBook != None )
//				{
//					GiveJournal(class'ObjectivesJournal');
//				}
			}
		}

		TempBook.GiveTo(Self);
		Book = TempBook;
		
		log("Got book", 'Misc');
	}
}

exec function movViewOffsetX (float value)
{
	Weapon.PlayerViewOffset.x += value;
	ClientMessage("View Offet: "$Weapon.PlayerViewOffset);
}

exec function movViewOffsetY (float value)
{
	Weapon.PlayerViewOffset.y += value;
	ClientMessage("View Offet: "$Weapon.PlayerViewOffset);
}

exec function movViewOffsetZ (float value)
{
	Weapon.PlayerViewOffset.z += value;
	ClientMessage("View Offet: "$Weapon.PlayerViewOffset);
}

exec function changeViewScale (float value)
{
	Weapon.DrawScale += value;
	ClientMessage("Blow Scale: "$Weapon.DrawScale);
}

exec function DispelMe( int i)
{
	if (i == 0)
		DispelMod.gotoState('Idle');

	if (i == 1)
		DispelMod.gotoState('Dispel');
}


function bool AddInventory(Inventory NewItem)
{
	//log("Add Inventory()");
	return super.addInventory(NewItem);
}

// fov zoom
function eagleEyes()
{
	if ( desiredFOV != defaultFOV )
	{
		desiredFOV = defaultFOV;
		if ( Weapon.IsA('Speargun') )
			Speargun(Weapon).bZoomedIn = false;
	} else if ( Weapon.IsA('Speargun') && (PendingWeapon == none) ) {
		Speargun(Weapon).bZoomedIn = true;
		desiredFOV = ZoomFOV;
	}
}

exec function modFOV(int amt)
{
	desiredFOV = clamp((desiredFOV + amt),10, defaultFOV);
}

exec function resetFOV()
{
	desiredFOV = defaultFOV;
}

// Sneaking behavior
exec function Sneak()
{
	// muffle sound here as well?
	bRunMode = !bRunMode;
	/*
	if ( groundSpeed < default.groundSpeed )
		groundSpeed = default.groundSpeed;
	else
		groundSpeed = default.groundSpeed * 0.5;
	*/
}

// Reload Weapon
function Reload()
{
	if ( AeonsWeapon(Weapon).ClipCount < weapon.ReloadCount )
		AeonsWeapon(Weapon).gotoState('NewClip');
}

function vwe()
{
	if ((wizEye != none) && (!bWizardEye))
	{
		bWizardEye = true;
		//wizEye.GotoState('ViewedThrough');
		viewTarget = wizEye;
		desiredFOV = 140;
	} 
	else if ((wizEye == none) || (bWizardEye) ) 
	{
		bWizardEye = false;
		//wizEye.GotoState('Idle');
		self.desiredFOV = default.desiredFOV;
		self.viewTarget = none;
	}
}

//----------------------------------------------------------------------------

simulated function SplatterHUD(int ActualDamage, Vector HitLocation)
{
	if ( (MyHUD != None) && (AeonsHUD(myHUD) != None) )
	{
		AeonsHud(MyHUD).AddSplat(ActualDamage/4+1, HitLocation);		
	}
}

//----------------------------------------------------------------------------

exec function TestBlood( int HitPoints ) 
{
	SplatterHUD( HitPoints, Location );
}

//----------------------------------------------------------------------------

exec function DumpInv( optional int Start, optional int End )
{
	local inventory Inv;
	local int temp;

	if ( Start > End ) 
	{
		Temp = Start;
		Start = End;
		End = Temp;
	}

	for ( Inv=Inventory; Inv!=None; Inv = Inv.Inventory )
	{
		if ( (Inv.InventoryGroup >= Start) && ((End == 0)||(Inv.InventoryGroup <= End)) )
		{
			Log( " " $ Inv.Class.Name $ " (" $ Inv.InventoryGroup $ ")"); 
		}
	}
}

//----------------------------------------------------------------------------

exec function DumpActors()
{
	local actor A;

	Log("==============================");
	Log("==        Actor Dump        ==");
	Log("==============================");

	foreach AllActors( class 'Actor', A )
	{
		Log("   " $ A);		
	}

	Log(" ");
	Log("==============================");
	Log(" ");
	
}

exec function DumpActorStats()
{
	local actor A;
	local int StaticCount, MovableCount, BothCount;

	Log("===============================");
	Log("==  Actor Stat Dump  ==");
	Log("===============================");

	foreach AllActors( class 'Actor', A )
	{
		if ( A.bSavable )
		{
			if (A.bStatic)
				StaticCount ++;
	
			if (!A.bMovable)
				MovableCount ++;
	
			if (!A.bMovable && A.bStatic)
				BothCount ++;
		}
	}

	Log("bStatic Count = "$StaticCount);
	Log("!bMovable Count = "$MovableCount);
	Log("bStatic and !bMovable Count = "$BothCount);

	Log(" ");
	Log("==============================");
	Log(" ");
	
}

// Toggles the display of the name of the pawn actor the crosshair is trained on
exec function showPawnNames()
{
	if (bDrawPawnName) {
		bDrawPawnName = false;
		ClientMessage("Draw Pawn Names is OFF");
	} else {
		bDrawPawnName = true;
		ClientMessage("Draw Pawn Names is ON");
	}
}

// Toggles the display of the name of the pawn actor the crosshair is trained on
exec function showActorNames()
{
	if (bDrawActorName) {
		bDrawActorName = false;
		ClientMessage("Draw Actor Names is OFF");
	} else {
		bDrawActorName = true;
		ClientMessage("Draw Actor Names is ON");
	}
}

exec function debugAnim(name pawnName, name AnimName, optional bool bLoop, optional float rate)
{
	local Actor A;

	if ( rate == 0 )
		rate = 1.0;

	forEach AllActors(class 'Actor', A)
	{
		if ( A.name == pawnName )
			if (bLoop)
				A.loopAnim(AnimName, rate);
			else
				A.playAnim(AnimName, rate);
	}
}


function ClientPutDown(Weapon Current, Weapon Next)
{	
	if ( Role == ROLE_Authority )
		return;
	bNeedActivate = false;
	if ( (Current != None) && (Current != Next) )
		Current.ClientPutDown(Next);
	else if ( Weapon != None )
	{
		if ( Weapon != Next )
			Weapon.ClientPutDown(Next);
		else
		{
			bNeedActivate = false;
			ClientPending = None;
			if ( Weapon.IsInState('ClientDown') || !Weapon.IsAnimating() )
			{
				Weapon.GotoState('');
				Weapon.TweenToStill();
			}
		}
	}
}

function AttachWeapon()
{
	local AeonsWeapon AWep;
	AWep = AeonsWeapon(Weapon);
	
	log("Attached", 'Misc');
	
	AWep.TempMesh = AWep.Mesh;
	AWep.Mesh = AWep.ThirdPersonMesh;
	if ( AWep.ThirdPersonJointName != 'none' )
		AWep.SetBase( Self, 'Revolver_Attach_Hand', AWep.ThirdPersonJointName );
	else
		AWep.SetBase( Self, 'Revolver_Attach_Hand', 'root' );
	AWep.Mesh = AWep.TempMesh;
}

function SendClientFire(weapon W, int N)
{
	RealWeapon(W,N);
	if ( Weapon.IsA('AeonsWeapon') )
	{
 //change 
		Log("AeonsPlayer: SendClientFire");
		AeonsWeapon(Weapon).bCanClientFire = true;
		AeonsWeapon(Weapon).ForceClientFire();

	}

}

function SendFire(Weapon W)
{
	Log("AeonsPlayer: SendFire");
	WeaponUpdate++;
	SendClientFire(W,WeaponUpdate);
}

function UpdateRealWeapon(Weapon W)
{
	Log("AeonsPlayer: UpdateRealWeapon");
	WeaponUpdate++;
	RealWeapon(W,WeaponUpdate);
	AttachWeapon();
}
	
function RealWeapon(weapon Real, int N)
{
	if ( N <= WeaponUpdate )
		return;
	WeaponUpdate = N;
	Weapon = Real;

	Log("AeonsPlayer: RealWeapon");

	if ( (Weapon != None) && !Weapon.IsAnimating() )
	{
		if ( bNeedActivate || (Weapon == ClientPending) )
			Weapon.GotoState('ClientActive');
		else
			Weapon.TweenToStill();
		
		//AttachWeapon();
	}
	bNeedActivate = false;
	ClientPending = None;	// make sure no client side weapon changes pending
}

function ReplicateMove
(
	float DeltaTime, 
	vector NewAccel, 
	rotator DeltaRot
)
{
	Super.ReplicateMove(DeltaTime,NewAccel, DeltaRot);
	if ( (Weapon != None) && !Weapon.IsAnimating() )
	{
		if ( (Weapon == ClientPending) || (Weapon != OldClientWeapon) )
		{
			if ( Weapon.IsInState('ClientActive') )
				AnimEnd();
			else
				Weapon.GotoState('ClientActive');
//			if ( (Weapon != ClientPending) && (myHUD != None) && myHUD.IsA('ChallengeHUD') )
//				ChallengeHUD(myHUD).WeaponNameFade = 1.3;
			if ( (Weapon != OldClientWeapon) && (OldClientWeapon != None) )
				OldClientWeapon.GotoState('');

			ClientPending = None;
			bNeedActivate = false;
		}
		else
		{
			Weapon.GotoState('');
			Weapon.TweenToStill();
		}
	}
	OldClientWeapon = Weapon;
}

function Killed(pawn Killer, pawn Other, name damageType)
{
	if ( FireFlyMod != none )
		FireFlyMod.gotoState('Deactivated');
	if ( Other == self )
	{
		log( "player was killed" );
		// LetterBox( true );
	}

	super.Killed(Killer, Other, DamageType);
}

// Spawn a gibbed version of this actor.
function SpawnGibbedCarcass( vector Dir )
{
	local int i;
	local Actor Gib;
	//local place P;
	local vector Vel;
	
	for (i=0; i<NumJoints(); i++)
	{
		if (FRand() > 0.25)
			continue;
		//P = JointPlace( JointName(i) );
		//Gib = Spawn(class 'MandorlaParticleFX', self,, P.pos);
		//Vel = vect(FRand(), FRand(), 0.25) * 256;
		Vel = VRand() * 512;
		//Vel = Vector(RotRand()) * 256;
		Vel.Z = 64;
		
		Gib = DetachLimb(JointName(i), Class 'BodyPart');
		Gib.Velocity = Vel;
		Gib.DesiredRotation = RotRand();
		Gib.bBounce = true;
		Gib.SetCollisionSize((Gib.CollisionRadius * 0.65), (Gib.CollisionHeight * 0.15));
		//SetBase(self, JointName(i));
	}
	
	// km - this is a bit temp :)
	//Spawn( class'Gibs',,, Location, Rotator(Dir) );

	//PlaySound( GibbedSound );
	//if ( CarcassClass != none )
	//	Spawn( CarcassClass,,, Location );
}

// ===============================================================================
// Direct Access Inventory activation - the following functions
// can be called from the game console or bound to a keystroke
// to activate a specific inventory item
// ===============================================================================

// a direct function to use the Health
exec function useHealth()
{
	local Inventory Inv;
	
	Inv = Inventory.FindItemInGroup(101);
	if ( Inv != none )
		Inv.Activate();
}

// a direct function to use the WizardEye
exec function useWizardEye()
{
	local Inventory Inv;
	
	Inv = Inventory.FindItemInGroup(102);
	if ( Inv != none )
		Inv.Activate();
}

// a direct function to use the amplifier
exec function useAmplifier()
{
	local Inventory Inv;
	
	Inv = Inventory.FindItemInGroup(103);
	if ( Inv != none )
		Inv.Activate();
}

// a direct function to turn on/off the lantern
exec function useLantern()
{
	local Inventory Inv;
	
	Inv = Inventory.FindItemInGroup(105);
	if ( Inv != none && viewTarget == none)
		Inv.Activate();
}

// a direct function to use the Powder of the Siren
exec function usePowderOfSiren()
{
	local Inventory Inv;
	
	Inv = Inventory.FindItemInGroup(107);
	if ( Inv != none )
		Inv.Activate();
}

// a direct function to use the Translocation Scroll
exec function useTranslocationScroll()
{
	local Inventory Inv;
	
	Inv = Inventory.FindItemInGroup(108);
	if ( Inv != none )
		Inv.Activate();
}


exec function cold()
{
	if ( sphereOfColdMod.bActive )
		sphereOfColdMod.gotoState('Deactivated');
	else
		sphereOfColdMod.gotoState('Activated');
}

exec function getGroundSpeed()
{
	ClientMessage("Ground Speed = "$groundSpeed);

}

exec function setGroundSpeed(int gs)
{
	default.groundSpeed = gs;
	groundSpeed = gs;
	ClientMessage("Ground Speed = "$groundSpeed);

}


simulated function SetFlight(bool bFlight)
{
	if ( bFlight )
	{
		if ( Flight == None )
			AeonsPlayer(Owner).Flight = Spawn(class'Aeons.FlightModifier', Owner);
		
	}
	else
	{
		if (Flight != None)
			AeonsPlayer(Owner).Flight.Destroy();
	}
}

/*
     Footstep1=Sound'Aeons.Player.P_Foot_Stn01'
     Footstep2=Sound'Aeons.Player.P_Foot_Stn02'
     Footstep3=Sound'Aeons.Player.P_Foot_Stn03'
     WaterStep=Sound'Aeons.Player.P_Foot_Watr01'
*/

exec function ShowStealth()
{
	if (bDrawStealth)
		bDrawStealth = false;
	else
		bDrawStealth = true;

}

// toggles playing sounds for magical effects
exec function MagicSounds()
{
	local string str;
	
	bMagicSound = !bMagicSound;
	if (bMagicSound)
		str = "ON";
	else
		str = "OFF";
	ClientMessage("Magic sounds are "$str);
}

// toggles playing sounds for weapon effects
exec function WeaponSounds()
{
	local string str;

	bWeaponSound = !bWeaponSound;

	if (bWeaponSound)
		str = "ON";
	else
		str = "OFF";
	ClientMessage("Weapon sounds are "$str);
}

exec function NextItem()
{
	InvDisplayMan.Ping();
	super.NextItem();
}

exec function PrevItem()
{
	InvDisplayMan.Ping();
	super.PrevItem();
}

exec function ChooseItem(name ClassName)
{
	local Inventory Inv;

	bUpdateInventorySelect = False;
	if (SelectedItem == None)
		super.NextItem();

	if (SelectedItem == None)
		return;

	Inv = SelectedItem;

	do
	{
		super.NextItem();
	} until ((SelectedItem.IsA(ClassName)) || (Inv == SelectedItem));
	bUpdateInventorySelect = True;
	// Pawn(Owner).ClientMessage(ClassName$" is selected");
}

exec function DebugHUD()
{
	bDrawDebugHUD = !bDrawDebugHUD;
}

exec function UnHide(name ClassName)
{
	local Actor A;
	

	ForEach AllActors(Class 'Actor', A)
	{
		if (A.IsA(ClassName))
			A.bHidden = false;
	}
}

exec function Hide(name ClassName)
{
	local Actor A;

	ForEach AllActors(Class 'Actor', A)
	{
		if (A.IsA(ClassName))
			if (A.default.bHidden)
				A.bHidden = true;
	}
}

exec function ForceHide(name ClassName)
{
	local Actor A;

	ForEach AllActors(Class 'Actor', A)
	{
		if (A.IsA(ClassName))
			A.bHidden = true;
	}
}

exec function ToggleHide(name ClassName)
{
	local Actor A;

	ForEach AllActors(Class 'Actor', A)
	{
		if (A.IsA(ClassName))
			A.bHidden = !A.bHidden;
	}
}

function DoubleShotgun()
{
	bDoubleShotgun = !bDoubleShotgun;
	// ClientMessage("Double Shotgun: "$bDoubleShotgun);
}

exec function RenderWeapon()
{
	bRenderWeapon = !bRenderWeapon;
}

function Died(pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo)
{
	spawn(class 'CarnageDecal',,,Location, rotator(vect(0,0,1)));
	Super.Died(Killer, damageType, HitLocation, DInfo);	
}

// PrevDefSpell()
// Switch to previous inventory group DefSpell
exec function PrevDefSpell()
{
	local int prevGroup;
	local Inventory inv;
	local Spell realDefSpell, s, Prev;
	local bool bFoundDefSpell;

	if( bShowMenu || Level.Pauser!="" )
		return;

	if ( DefSpell == None )
	{
		// SwitchToBestSpell();
		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			s = DefSpell(inv);
			if ( s != None )
			{
				DefSpell = s;
				break;
			}
		}
		return;
	}

	prevGroup = 0;
	realDefSpell = DefSpell;
	if ( PendingDefSpell != None )
		DefSpell = PendingDefSpell;
	PendingDefSpell = None;
	
	for (inv=Inventory; inv!=None; inv=inv.Inventory)
	{
		s = DefSpell(inv);
		if ( s != None )
		{
			if ( s.InventoryGroup == DefSpell.InventoryGroup )
			{
				if ( s == DefSpell )
				{
					bFoundDefSpell = true;
					if ( Prev != None )
					{
						PendingDefSpell = Prev;
						break;
					}
				}
				else if (!bFoundDefSpell )
					Prev = s;
			}
			else if ( (s.InventoryGroup < DefSpell.InventoryGroup) 
					&& (s.InventoryGroup >= prevGroup) )
			{
				prevGroup = s.InventoryGroup;
				PendingDefSpell = s;
			}
		}
	}
	bFoundDefSpell = false;
	prevGroup = DefSpell.InventoryGroup;
	if ( PendingDefSpell == None )
		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			s = DefSpell(inv);
			if ( s != None )
			{
				if ( s.InventoryGroup == DefSpell.InventoryGroup )
				{
					if ( s == DefSpell )
						bFoundDefSpell = true;
					else if ( bFoundDefSpell && (PendingDefSpell == None) )
						PendingDefSpell = s;
				}
				else if ( s.InventoryGroup > PrevGroup ) 
				{
					prevGroup = s.InventoryGroup;
					PendingDefSpell = s;
				}
			}
		}

	if (PendingDefSpell != None)
		DefSpell = PendingDefSpell;
}

// PrevAttSpell()
// Switch to previous inventory group AttSpell

exec function PrevAttSpell()
{
	local int prevGroup;
	local Inventory inv;
	local Spell realAttSpell, s, Prev;
	local bool bFoundAttSpell;

	if( bShowMenu || Level.Pauser!="" )
		return;

	if ( AttSpell == None )
	{
		// SwitchToBestSpell();
		return;
	}

	prevGroup = 0;
	realAttSpell = AttSpell;
	if ( PendingAttSpell != None )
		AttSpell = PendingAttSpell;
	PendingAttSpell = None;
	
	for (inv=Inventory; inv!=None; inv=inv.Inventory)
	{
		s = AttSpell(inv);
		if ( s != None )
		{
			if ( s.InventoryGroup == AttSpell.InventoryGroup )
			{
				if ( s == AttSpell )
				{
					bFoundAttSpell = true;
					if ( Prev != None )
					{
						PendingAttSpell = Prev;
						break;
					}
				}
				else if (!bFoundAttSpell )
					Prev = s;
			}
			else if ( (s.InventoryGroup < AttSpell.InventoryGroup) 
					&& (s.InventoryGroup >= prevGroup) )
			{
				prevGroup = s.InventoryGroup;
				PendingAttSpell = s;
			}
		}
	}
	bFoundAttSpell = false;
	prevGroup = AttSpell.InventoryGroup;
	if ( PendingAttSpell == None )
		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			s = AttSpell(inv);
			if ( s != None )
			{
				if ( s.InventoryGroup == AttSpell.InventoryGroup )
				{
					if ( s == AttSpell )
						bFoundAttSpell = true;
					else if ( bFoundAttSpell && (PendingAttSpell == None) )
						PendingAttSpell = s;
				}
				else if ( s.InventoryGroup > PrevGroup ) 
				{
					prevGroup = s.InventoryGroup;
					PendingAttSpell = s;
				}
			}
		}

	if ( PendingAttSpell != None )
		AttSpell = PendingAttSpell;
}


// NextAttSpell()
// Switch to next inventory group weapon
exec function NextAttSpell()
{
	local int nextGroup;
	local Inventory inv;
	local Spell realAttSpell, s, Prev;
	local bool bFoundAttSpell;

	if( bShowMenu || Level.Pauser!="" )
		return;
	if ( AttSpell == None )
	{
		// SwitchToBestWeapon();
		return;
	}

	nextGroup = 100;
	realAttSpell = AttSpell;
	if ( PendingAttSpell != None )
		AttSpell = PendingAttSpell;
	PendingAttSpell = None;

	for (inv=Inventory; inv!=None; inv=inv.Inventory)
	{
		s = AttSpell(inv);
		if ( s != None )
		{
			if ( s.InventoryGroup == AttSpell.InventoryGroup )
			{
				if ( s == AttSpell )
					bFoundAttSpell = true;
				else if ( bFoundAttSpell )
				{
					PendingAttSpell = s;
					break;
				}
			}
			else if ( (s.InventoryGroup > AttSpell.InventoryGroup) && (s.InventoryGroup < nextGroup) )
			{
				nextGroup = s.InventoryGroup;
				PendingAttSpell = s;
			}
		}
	}

	bFoundAttSpell = false;
	nextGroup = AttSpell.InventoryGroup;
	if ( PendingAttSpell == None )
		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			s = AttSpell(Inv);
			if ( s != None )
			{
				if ( s.InventoryGroup == AttSpell.InventoryGroup )
				{
					if ( s == AttSpell )
					{
						bFoundAttSpell = true;
						if ( Prev != None )
							PendingAttSpell = Prev;
					}
					else if ( !bFoundAttSpell && (PendingAttSpell == None) )
						Prev = s;
				}
				else if ( s.InventoryGroup < nextGroup ) 
				{
					nextGroup = s.InventoryGroup;
					PendingAttSpell = s;
				}
			}
		}

	if ( PendingAttSpell != None ) 
		AttSpell = PendingAttSpell;
}


// NextDefSpell()
// Switch to next inventory group weapon
exec function NextDefSpell()
{
	local int nextGroup;
	local Inventory inv;
	local Spell realDefSpell, s, Prev;
	local bool bFoundDefSpell;

	if( bShowMenu || Level.Pauser!="" )
		return;
	if ( DefSpell == None )
	{
		// SwitchToBestWeapon();
		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			s = DefSpell(inv);
			if ( s != None )
			{
				DefSpell = s;
				break;
			}
		}
		return;
	}

	nextGroup = 100;
	realDefSpell = DefSpell;
	if ( PendingDefSpell != None )
		DefSpell = PendingDefSpell;
	PendingDefSpell = None;

	for (inv=Inventory; inv!=None; inv=inv.Inventory)
	{
		s = DefSpell(inv);
		if ( s != None )
		{
			if ( s.InventoryGroup == DefSpell.InventoryGroup )
			{
				if ( s == DefSpell )
					bFoundDefSpell = true;
				else if ( bFoundDefSpell )
				{
					PendingDefSpell = s;
					break;
				}
			}
			else if ( (s.InventoryGroup > DefSpell.InventoryGroup) && (s.InventoryGroup < nextGroup) )
			{
				nextGroup = s.InventoryGroup;
				PendingDefSpell = s;
			}
		}
	}

	bFoundDefSpell = false;
	nextGroup = DefSpell.InventoryGroup;
	if ( PendingDefSpell == None )
		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			s = DefSpell(Inv);
			if ( s != None )
			{
				if ( s.InventoryGroup == DefSpell.InventoryGroup )
				{
					if ( s == DefSpell )
					{
						bFoundDefSpell = true;
						if ( Prev != None )
							PendingDefSpell = Prev;
					}
					else if ( !bFoundDefSpell && (PendingDefSpell == None) )
						Prev = s;
				}
				else if ( s.InventoryGroup < nextGroup ) 
				{
					nextGroup = s.InventoryGroup;
					PendingDefSpell = s;
				}
			}
		}

	DefSpell = PendingDefSpell;
}

exec function PDP()
{
	if (PlayerDamageMod != none)
	{
		PlayerDamageModifier(PlayerDamageMod).TakeHit(FRand());
	}
}

exec function bool UseMana(int i)
{
	// log("AeonsPlayer:UseMana()....using "$i,'Misc');
	if ( bUseMana )
		return super.UseMana(i);
	else
		return true;
}

exec function InfiniteMana()
{
	bUseMana = !bUseMana;
	ClientMessage("Infinite Mana use is "$!bUseMana);
}

exec function AmpAttSpell()
{
	if (AttSpell != none)
	{
		if (AttSpell.CastingLevel < 4)
		{
			AttSpell(AttSpell).LocalCastingLevel +=1;
			AttSpell.CastingLevel +=1;
		}
	}
}

exec function AmpDefSpell()
{
	if (DefSpell != none)
	{
		if (DefSpell.CastingLevel < 4)
		{
			DefSpell(DefSpell).LocalCastingLevel +=1;
			DefSpell.CastingLevel +=1;
		}
	}
}

exec function DeAmpAttSpell()
{
	if (AttSpell != none)
	{
		if (AttSpell.CastingLevel > 0)
		{
			AttSpell(AttSpell).LocalCastingLevel -=1;
			AttSpell.CastingLevel -=1;
		}
	}
}

exec function DeAmpDefSpell()
{
	if (DefSpell != none)
	{
		if (DefSpell.CastingLevel > 0)
		{
			DefSpell(DefSpell).LocalCastingLevel -= 1;
			DefSpell.CastingLevel -= 1;
		}
	}
}

function bool Decapitate(optional vector Dir)
{
	local PersistentWound Wound;

	Wound = spawn(Class 'DecapitateWound',self,,JointPlace('Head').pos, Rotator(vect(0,0,1)));
	Wound.AttachJoint = 'Head';
	Wound.setup();

	DestroyLimb('Head');

	return true;
}

function OnFire(bool bOnFire);

exec function LogGameState()
{
	if ( GameStateMod != none )
	{
		if (GameStateMod.bActive)
		{
			ClientMessage("Game State Logging is OFF");
			GameStateModifier(GameStateMod).Deactivate();
		} else {
			ClientMessage("Game State Logging is ON");
			GameStateModifier(GameStateMod).Activate();
		}
	}
}

exec function bool SpawnHound()
{
	/*
	local vector X, Y, Z, HitLocation, HitNormal, EyeLoc, TempVec;
	local int HitJoint, i;
	local vector Eh; // eye height
	local vector TestLoc;
	local Hound H;

	GetAxes(ViewRotation, X, Y, Z);

	Eh.z = EyeHeight;

	EyeLoc = Location + Eh;

	//TempVec = VRand();
	//TempVec.z = 0;
	TempVec = Normal(X + (VRand() * 0.25));
	TestLoc = EyeLoc + (TempVec * RandRange(768, 2048));

 	Trace(HitLocation, HitNormal, HitJoint, TestLoc + vect(0,0,-512), TestLoc);

	if ( FastTrace(EyeLoc, TestLoc) )
	{
		H = Spawn(class 'Hound',,,TestLoc, Rotator(Location - TestLoc));
		H.InitState(self);
		return true;
	}
	return false;
	*/
	
	
	local SpawnPoint	SP;
	local SpawnPoint	Chosen;
	local float			PCount;
	local float			R;
	local vector		HitLocation, HitNormal;
	local int			HitJoint;
	local vector		DVect;
	local class<pawn>	HClass;
	local Hound			H;
	
	bring('Hound');

	return true;

	// Don't bring a Hound until Ambrose is dead.
	//if( !CheckGameEvent( 'AmbroseDead' ) )
	//	return false;

	Chosen = none;
	R = FRand();
	PCount = 0.0;

	foreach AllActors( class'SpawnPoint', SP )
	{
		PCount += 1.0;
		if ( PCount == 1.0 )
			Chosen = SP;
		else
		{
			if ( R < ( 1 / PCount ) )
				Chosen = SP;
		}
	}

	if ( Chosen != none )
	{
		HClass = class'Hound';
		DVect = Chosen.Location;

		Trace( HitLocation, HitNormal, HitJoint, DVect + vect(0,0,-512), DVect );
		DVect = HitLocation + vect(0,0,1) * HClass.default.CollisionHeight;
		H = Spawn( class'Hound',,, DVect, Chosen.Rotation );
		if ( H != none )
		{
			H.InitState( self );
			return true;
		}
	}
	return false;
}

function bool CheckGameEvent(name EventName, optional bool bSet)
{
	if ( bSet )
		log("Game Event "$EventName$" being set to TRUE", 'GameEvents');
	else
		log("Checking Game Event "$EventName, 'GameEvents');

	switch ( EventName )
	{
		case 'LizbethDead':
			if ( bSet )
				bLizbethDead = true;
			else
				return bLizbethDead;
			break;

		case 'AmbroseDead':
			if ( bSet )
				bAmbroseDead = true;
			else
				return bAmbroseDead;
			break;

		case 'JeremiahTalk1':
			if ( bSet )
				bJeremiahTalk1 = true;
			else
				return bJeremiahTalk1;
			break;

		case 'JeremiahTalk2':
			if ( bSet )
				bJeremiahTalk2 = true;
			else
				return bJeremiahTalk2;
			break;

		case 'JeremiahDead':
			if ( bSet )
				bJeremiahDead = true;
			else
				return bJeremiahDead;
			break;

		case 'AaronDead':
			if ( bSet )
				bAaronDead = true;
			else
				return bAaronDead;
			break;

		case 'BethanyDead':
			if ( bSet )
				bBethanyDead = true;
			else
				return bBethanyDead;
			break;

		case 'KeisingerDead':
			if ( bSet )
				bKeisingerDead = true;
			else
				return bKeisingerDead;
			break;

		case 'ReturnfromPiratesCove':
			if ( bSet )
				bReturnfromPiratesCove = true;
			else
				return bReturnfromPiratesCove;
			break;

		case 'ReturnfromOneiros':
			if ( bSet )
				bReturnfromOneiros = true;
			else
				return bReturnfromOneiros;
			break;

		case 'Revenant':
			if ( bSet )
				bRevenant = true;
			else
				return bRevenant;
			break;

		case 'Innercourtyard_silverbullets1':
			if ( bSet )
				bInnercourtyard_silverbullets1 = true;
			else
				return bInnercourtyard_silverbullets1;
			break;

		case 'Innercourtyard_silverbullets2':
			if ( bSet )
				bInnercourtyard_silverbullets2 = true;
			else
				return bInnercourtyard_silverbullets2;
			break;

		case 'Innercourtyard_phosphorus1':
			if ( bSet )
				bInnercourtyard_phosphorus1 = true;
			else
				return bInnercourtyard_phosphorus1;
			break;

		case 'Innercourtyard_phosphorus2':
			if ( bSet )
				bInnercourtyard_phosphorus2 = true;
			else
				return bInnercourtyard_phosphorus2;
			break;

		case 'Innercourtyard_phosphorus3':
			if ( bSet )
				bInnercourtyard_phosphorus3 = true;
			else
				return bInnercourtyard_phosphorus3;
			break;

		case 'Innercourtyard_health1':
			if ( bSet )
				bInnercourtyard_health1 = true;
			else
				return bInnercourtyard_health1;
			break;

		case 'Innercourtyard_health2':
			if ( bSet )
				bInnercourtyard_health2 = true;
			else
				return bInnercourtyard_health2;
			break;

		case 'Innercourtyard_manawell':
			if ( bSet )
				bInnercourtyard_manawell = true;
			else
				return bInnercourtyard_manawell;
			break;

		case 'Innercourtyard_arcanewhorl':
			if ( bSet )
				bInnercourtyard_arcanewhorl = true;
			else
				return bInnercourtyard_arcanewhorl;
			break;

		case 'Northwinglower_kitchen_health':
			if ( bSet )
				bNorthwinglower_kitchen_health = true;
			else
				return bNorthwinglower_kitchen_health;
			break;

		case 'Northwinglower_brewery_health':
			if ( bSet )
				bNorthwinglower_brewery_health = true;
			else
				return bNorthwinglower_brewery_health;
			break;

		case 'Northwinglower_diningroom_amplifier':
			if ( bSet )
				bNorthwinglower_diningroom_amplifier = true;
			else
				return bNorthwinglower_diningroom_amplifier;
			break;

		case 'Northwinglower_basement_amplifier':
			if ( bSet )
				bNorthwinglower_basement_amplifier = true;
			else
				return bNorthwinglower_basement_amplifier;
			break;

		case 'Northwinglower_basement_bullets1':
			if ( bSet )
				bNorthwinglower_basement_bullets1 = true;
			else
				return bNorthwinglower_basement_bullets1;
			break;

		case 'Northwinglower_basement_bullets2':
			if ( bSet )
				bNorthwinglower_basement_bullets2 = true;
			else
				return bNorthwinglower_basement_bullets2;
			break;

		case 'Northwinglower_basement_phosphorus1':
			if ( bSet )
				bNorthwinglower_basement_phosphorus1 = true;
			else
				return bNorthwinglower_basement_phosphorus1;
			break;

		case 'Northwinglower_basement_phosphorus2':
			if ( bSet )
				bNorthwinglower_basement_phosphorus2 = true;
			else
				return bNorthwinglower_basement_phosphorus2;
			break;

		case 'Northwinglower_basement_molotov1':
			if ( bSet )
				bNorthwinglower_basement_molotov1 = true;
			else
				return bNorthwinglower_basement_molotov1;
			break;

		case 'Northwinglower_basement_molotov2':
			if ( bSet )
				bNorthwinglower_basement_molotov2 = true;
			else
				return bNorthwinglower_basement_molotov2;
			break;

		case 'Northwinglower_basement_molotov3':
			if ( bSet )
				bNorthwinglower_basement_molotov3 = true;
			else
				return bNorthwinglower_basement_molotov3;
			break;

		case 'Northwinglower_basement_molotov4':
			if ( bSet )
				bNorthwinglower_basement_molotov4 = true;
			else
				return bNorthwinglower_basement_molotov4;
			break;

		case 'Northwinglower_dayroom_health':
			if ( bSet )
				bNorthwinglower_dayroom_health = true;
			else
				return bNorthwinglower_dayroom_health;
			break;

		case 'Northwingupper_servantsq_health':
			if ( bSet )
				bNorthwingupper_servantsq_health = true;
			else
				return bNorthwingupper_servantsq_health;
			break;

		case 'Northwingupper_servantsq_bullets':
			if ( bSet )
				bNorthwingupper_servantsq_bullets = true;
			else
				return bNorthwingupper_servantsq_bullets;
			break;

		case 'Northwingupper_servantsq_shotgunammo':
			if ( bSet )
				bNorthwingupper_servantsq_shotgunammo = true;
			else
				return bNorthwingupper_servantsq_shotgunammo;
			break;

		case 'Northwingupper_servantsq_molotov1':
			if ( bSet )
				bNorthwingupper_servantsq_molotov1 = true;
			else
				return bNorthwingupper_servantsq_molotov1;
			break;

		case 'Northwingupper_servantsq_molotov2':
			if ( bSet )
				bNorthwingupper_servantsq_molotov2 = true;
			else
				return bNorthwingupper_servantsq_molotov2;
			break;

		case 'Northwingupper_aaronsroom_health':
			if ( bSet )
				bNorthwingupper_aaronsroom_health = true;
			else
				return bNorthwingupper_aaronsroom_health;
			break;

		case 'Northwingupper_aaronsroom_molotov1':
			if ( bSet )
				bNorthwingupper_aaronsroom_molotov1 = true;
			else
				return bNorthwingupper_aaronsroom_molotov1;
			break;

		case 'Northwingupper_aaronsroom_molotov2':
			if ( bSet )
				bNorthwingupper_aaronsroom_molotov2 = true;
			else
				return bNorthwingupper_aaronsroom_molotov2;
			break;

		case 'Northwingupper_aaronsroom_molotov3':
			if ( bSet )
				bNorthwingupper_aaronsroom_molotov3 = true;
			else
				return bNorthwingupper_aaronsroom_molotov3;
			break;

		case 'Northwingupper_aaronsroom_molotov4':
			if ( bSet )
				bNorthwingupper_aaronsroom_molotov4 = true;
			else
				return bNorthwingupper_aaronsroom_molotov4;
			break;

		case 'Northwingupper_aaronsroom_molotov5':
			if ( bSet )
				bNorthwingupper_aaronsroom_molotov5 = true;
			else
				return bNorthwingupper_aaronsroom_molotov5;
			break;

		case 'WestWing_Conservatory_Health':
			if ( bSet )
				bWestWing_Conservatory_Health = true;
			else
				return bWestWing_Conservatory_Health;
			break;

		case 'WestWing_Conservatory_ServantKey1':
			if ( bSet )
				bWestWing_Conservatory_ServantKey1 = true;
			else
				return bWestWing_Conservatory_ServantKey1;
			break;

		case 'WestWing_Conservatory_Amplifier':
			if ( bSet )
				bWestWing_Conservatory_Amplifier = true;
			else
				return bWestWing_Conservatory_Amplifier;
			break;

		case 'WestWing_SmokingRoom_Health':
			if ( bSet )
				bWestWing_SmokingRoom_Health = true;
			else
				return bWestWing_SmokingRoom_Health;
			break;

		case 'WestWing_HuntingRoom_Bullets1':
			if ( bSet )
				bWestWing_HuntingRoom_Bullets1 = true;
			else
				return bWestWing_HuntingRoom_Bullets1;
			break;

		case 'WestWing_HuntingRoom_Bullets2':
			if ( bSet )
				bWestWing_HuntingRoom_Bullets2 = true;
			else
				return bWestWing_HuntingRoom_Bullets2;
			break;

		case 'WestWing_Jeremiah_Silver1':
			if ( bSet )
				bWestWing_Jeremiah_Silver1 = true;
			else
				return bWestWing_Jeremiah_Silver1;
			break;

		case 'WestWing_Jeremiah_Silver2':
			if ( bSet )
				bWestWing_Jeremiah_Silver2 = true;
			else
				return bWestWing_Jeremiah_Silver2;
			break;

		case 'WestWing_Jeremiah_Silver3':
			if ( bSet )
				bWestWing_Jeremiah_Silver3 = true;
			else
				return bWestWing_Jeremiah_Silver3;
			break;

		case 'WestWing_Jeremiah_Silver4':
			if ( bSet )
				bWestWing_Jeremiah_Silver4 = true;
			else
				return bWestWing_Jeremiah_Silver4;
			break;

		case 'WestWing_Jeremiah_bullets':
			if ( bSet )
				bWestWing_Jeremiah_bullets = true;
			else
				return bWestWing_Jeremiah_bullets;
			break;

		case 'WestWing_Jeremiah_health':
			if ( bSet )
				bWestWing_Jeremiah_health = true;
			else
				return bWestWing_Jeremiah_health;
			break;

		case 'GreatHall_attic_amplifier':
			if ( bSet )
				bGreatHall_attic_amplifier = true;
			else
				return bGreatHall_attic_amplifier;
			break;

		case 'CentralUpper_Lizbeth_Health':
			if ( bSet )
				bCentralUpper_Lizbeth_Health = true;
			else
				return bCentralUpper_Lizbeth_Health;
			break;

		case 'CentralUpper_Lizbeth_Poetry':
			if ( bSet )
				bCentralUpper_Lizbeth_Poetry = true;
			else
				return bCentralUpper_Lizbeth_Poetry;
			break;

		case 'CentralUpper_Bethany_Diary':
			if ( bSet )
				bCentralUpper_Bethany_Diary = true;
			else
				return bCentralUpper_Bethany_Diary;
			break;

		case 'CentralUpper_Study_JoeNotes':
			if ( bSet )
				bCentralUpper_Study_JoeNotes = true;
			else
				return bCentralUpper_Study_JoeNotes;
			break;

		case 'CentralUpper_Study_EtherTrap1':
			if ( bSet )
				bCentralUpper_Study_EtherTrap1 = true;
			else
				return bCentralUpper_Study_EtherTrap1;
			break;

		case 'CentralUpper_Study_EtherTrap2':
			if ( bSet )
				bCentralUpper_Study_EtherTrap2 = true;
			else
				return bCentralUpper_Study_EtherTrap2;
			break;

		case 'CentralUpper_TowerStairs_Gate':
			if ( bSet )
				bCentralUpper_TowerStairs_Gate = true;
			else
				return bCentralUpper_TowerStairs_Gate;
			break;

		case 'CentralLower_SunRoom_BethsLetters':
			if ( bSet )
				bCentralLower_SunRoom_BethsLetters = true;
			else
				return bCentralLower_SunRoom_BethsLetters;
			break;

		case 'CentralLower_Tower_amplifier':
			if ( bSet )
				bCentralLower_Tower_amplifier = true;
			else
				return bCentralLower_Tower_amplifier;
			break;

		case 'CentralLower_TowerAccess':
			if ( bSet )
				bCentralLower_TowerAccess = true;
			else
				return bCentralLower_TowerAccess;
			break;

		case 'EastWingLower_Nursery_Health':
			if ( bSet )
				bEastWingLower_Nursery_Health = true;
			else
				return bEastWingLower_Nursery_Health;
			break;

		case 'EastWingLower_Nursery_ServantDiary':
			if ( bSet )
				bEastWingLower_Nursery_ServantDiary = true;
			else
				return bEastWingLower_Nursery_ServantDiary;
			break;

		case 'EastWingLower_BackStairs_Amplifier':
			if ( bSet )
				bEastWingLower_BackStairs_Amplifier = true;
			else
				return bEastWingLower_BackStairs_Amplifier;
			break;

		case 'EastWingUpper_UpperBackAccess':
			if ( bSet )
				bEastWingUpper_UpperBackAccess = true;
			else
				return bEastWingUpper_UpperBackAccess;
			break;

		case 'WidowsWatch_SmallGardenAccess':
			if ( bSet )
				bWidowsWatch_SmallGardenAccess = true;
			else
				return bWidowsWatch_SmallGardenAccess;
			break;

		case 'Gardens_ToolShop_Health1':
			if ( bSet )
				bGardens_ToolShop_Health1 = true;
			else
				return bGardens_ToolShop_Health1;
			break;

		case 'Gardens_ToolShop_Health2':
			if ( bSet )
				bGardens_ToolShop_Health2 = true;
			else
				return bGardens_ToolShop_Health2;
			break;

		case 'Gardens_ToolShop_Dynamite1':
			if ( bSet )
				bGardens_ToolShop_Dynamite1 = true;
			else
				return bGardens_ToolShop_Dynamite1;
			break;

		case 'Gardens_ToolShop_Dynamite2':
			if ( bSet )
				bGardens_ToolShop_Dynamite2 = true;
			else
				return bGardens_ToolShop_Dynamite2;
			break;

		case 'Gardens_ToolShop_Dynamite3':
			if ( bSet )
				bGardens_ToolShop_Dynamite3 = true;
			else
				return bGardens_ToolShop_Dynamite3;
			break;

		case 'Gardens_ToolShop_Dynamite4':
			if ( bSet )
				bGardens_ToolShop_Dynamite4 = true;
			else
				return bGardens_ToolShop_Dynamite4;
			break;

		case 'Gardens_ToolShop_Dynamite5':
			if ( bSet )
				bGardens_ToolShop_Dynamite5 = true;
			else
				return bGardens_ToolShop_Dynamite5;
			break;

		case 'Gardens_ToolShop_Dynamite6':
			if ( bSet )
				bGardens_ToolShop_Dynamite6 = true;
			else
				return bGardens_ToolShop_Dynamite6;
			break;

		case 'Gardens_Greenhouse_phosphorus1':
			if ( bSet )
				bGardens_Greenhouse_phosphorus1 = true;
			else
				return bGardens_Greenhouse_phosphorus1;
			break;

		case 'Gardens_Greenhouse_phosphorus2':
			if ( bSet )
				bGardens_Greenhouse_phosphorus2 = true;
			else
				return bGardens_Greenhouse_phosphorus2;
			break;

		case 'Gardens_Greenhouse_phosphorus3':
			if ( bSet )
				bGardens_Greenhouse_phosphorus3 = true;
			else
				return bGardens_Greenhouse_phosphorus3;
			break;

		case 'Gardens_Greenhouse_phosphorus4':
			if ( bSet )
				bGardens_Greenhouse_phosphorus4 = true;
			else
				return bGardens_Greenhouse_phosphorus4;
			break;

		case 'Gardens_Greenhouse_phosphorus5':
			if ( bSet )
				bGardens_Greenhouse_phosphorus5 = true;
			else
				return bGardens_Greenhouse_phosphorus5;
			break;

		case 'Gardens_Greenhouse_phosphorus6':
			if ( bSet )
				bGardens_Greenhouse_phosphorus6 = true;
			else
				return bGardens_Greenhouse_phosphorus6;
			break;

		case 'Gardens_Greenhouse_phosphorus7':
			if ( bSet )
				bGardens_Greenhouse_phosphorus7 = true;
			else
				return bGardens_Greenhouse_phosphorus7;
			break;

		case 'Gardens_Greenhouse_Health':
			if ( bSet )
				bGardens_Greenhouse_Health = true;
			else
				return bGardens_Greenhouse_Health;
			break;

		case 'Gardens_Greenhouse_BethanyKey':
			if ( bSet )
				bGardens_Greenhouse_BethanyKey = true;
			else
				return bGardens_Greenhouse_BethanyKey;
			break;

		case 'Gardens_Well_Amplifier':
			if ( bSet )
				bGardens_Well_Amplifier = true;
			else
				return bGardens_Well_Amplifier;
			break;

		case 'Innercourtyard_BalconyDoorAccess':
			if ( bSet )
				bInnercourtyard_BalconyDoorAccess = true;
			else
				return bInnercourtyard_BalconyDoorAccess;
			break;

		case 'GreatHall_attic_bullets1':
			if ( bSet )
				bGreatHall_attic_bullets1 = true;
			else
				return bGreatHall_attic_bullets1;
			break;

		case 'GreatHall_attic_bullets2':
			if ( bSet )
				bGreatHall_attic_bullets2 = true;
			else
				return bGreatHall_attic_bullets2;
			break;

		case 'GreatHall_Shotgunshells1':
			if ( bSet )
				bGreatHall_Shotgunshells1 = true;
			else
				return bGreatHall_Shotgunshells1;
			break;

		case 'GreatHall_Shotgunshells2':
			if ( bSet )
				bGreatHall_Shotgunshells2 = true;
			else
				return bGreatHall_Shotgunshells2;
			break;

		case 'GreatHall_Health1':
			if ( bSet )
				bGreatHall_Health1 = true;
			else
				return bGreatHall_Health1;
			break;

		case 'GreatHall_Health2':
			if ( bSet )
				bGreatHall_Health2 = true;
			else
				return bGreatHall_Health2;
			break;

		case 'GreatHall_Molotov1':
			if ( bSet )
				bGreatHall_Molotov1 = true;
			else
				return bGreatHall_Molotov1;
			break;

		case 'GreatHall_Molotov2':
			if ( bSet )
				bGreatHall_Molotov2 = true;
			else
				return bGreatHall_Molotov2;
			break;

		case 'GreatHall_Molotov3':
			if ( bSet )
				bGreatHall_Molotov3 = true;
			else
				return bGreatHall_Molotov3;
			break;

		case 'GreatHall_Molotov4':
			if ( bSet )
				bGreatHall_Molotov4 = true;
			else
				return bGreatHall_Molotov4;
			break;

		case 'GreatHall_AtticAccess':
			if ( bSet )
				bGreatHall_AtticAccess = true;
			else
				return bGreatHall_AtticAccess;
			break;

		case 'Innercourtyard_amplifier':
			if ( bSet )
				bInnercourtyard_amplifier = true;
			else
				return bInnercourtyard_amplifier;
			break;

		case 'Innercourtyard_AaronsRoomKey':
			if ( bSet )
				bInnercourtyard_AaronsRoomKey = true;
			else
				return bInnercourtyard_AaronsRoomKey;
			break;

		case 'Innercourtyard_molotov1':
			if ( bSet )
				bInnercourtyard_molotov1 = true;
			else
				return bInnercourtyard_molotov1;
			break;

		case 'Innercourtyard_molotov2':
			if ( bSet )
				bInnercourtyard_molotov2 = true;
			else
				return bInnercourtyard_molotov2;
			break;

		case 'Innercourtyard_molotov3':
			if ( bSet )
				bInnercourtyard_molotov3 = true;
			else
				return bInnercourtyard_molotov3;
			break;

		case 'TowerRun_Inhabitants_amplifier':
			if ( bSet )
				bTowerRun_Inhabitants_amplifier = true;
			else
				return bTowerRun_Inhabitants_amplifier;
			break;

		case 'TowerRun_dynamite1':
			if ( bSet )
				bTowerRun_dynamite1 = true;
			else
				return bTowerRun_dynamite1;
			break;

		case 'TowerRun_dynamite2':
			if ( bSet )
				bTowerRun_dynamite2 = true;
			else
				return bTowerRun_dynamite2;
			break;

		case 'TowerRun_dynamite3':
			if ( bSet )
				bTowerRun_dynamite3 = true;
			else
				return bTowerRun_dynamite3;
			break;

		case 'TowerRun_dynamite4':
			if ( bSet )
				bTowerRun_dynamite4 = true;
			else
				return bTowerRun_dynamite4;
			break;

		case 'TowerRun_Health':
			if ( bSet )
				bTowerRun_Health = true;
			else
				return bTowerRun_Health;
			break;

		case 'TowerRun_Amplifier':
			if ( bSet )
				bTowerRun_Amplifier = true;
			else
				return bTowerRun_Amplifier;
			break;

		case 'TowerRun_TowerAccess':
			if ( bSet )
				bTowerRun_TowerAccess = true;
			else
				return bTowerRun_TowerAccess;
			break;

		case 'Chapel_etherTrap1':
			if ( bSet )
				bChapel_etherTrap1 = true;
			else
				return bChapel_etherTrap1;
			break;

		case 'Chapel_etherTrap2':
			if ( bSet )
				bChapel_etherTrap2 = true;
			else
				return bChapel_etherTrap2;
			break;

		case 'Chapel_Health1':
			if ( bSet )
				bChapel_Health1 = true;
			else
				return bChapel_Health1;
			break;

		case 'Chapel_Health2':
			if ( bSet )
				bChapel_Health2 = true;
			else
				return bChapel_Health2;
			break;

		case 'Chapel_Paper':
			if ( bSet )
				bChapel_Paper = true;
			else
				return bChapel_Paper;
			break;

		case 'Chapel_Tome':
			if ( bSet )
				bChapel_Tome = true;
			else
				return bChapel_Tome;
			break;

		case 'Chapel_amplifier':
			if ( bSet )
				bChapel_amplifier = true;
			else
				return bChapel_amplifier;
			break;

		case 'Chapel_PriestKey':
			if ( bSet )
				bChapel_PriestKey = true;
			else
				return bChapel_PriestKey;
			break;

		case 'SedgewickConversation':
			if ( bSet )
				bSedgewickConversation = true;
			else
				return bSedgewickConversation;
			break;

		case 'KiesingerConversation':
			if ( bSet )
				bKiesingerConversation = true;
			else
				return bKiesingerConversation;
			break;

		case 'EastWingUpper_Guest_Health1':
			if ( bSet )
				bEastWingUpper_Guest_Health1 = true;
			else
				return bEastWingUpper_Guest_Health1;
			break;

		case 'EastWingUpper_Guest_Health2':
			if ( bSet )
				bEastWingUpper_Guest_Health2 = true;
			else
				return bEastWingUpper_Guest_Health2;
			break;

		case 'EastWingUpper_Ambrose_Health':
			if ( bSet )
				bEastWingUpper_Ambrose_Health = true;
			else
				return bEastWingUpper_Ambrose_Health;
			break;

		case 'EastWingUpper_Ambrose_Journal':
			if ( bSet )
				bEastWingUpper_Ambrose_Journal = true;
			else
				return bEastWingUpper_Ambrose_Journal;
			break;

		case 'EastWingUpper_Ambrose_Pirate':
			if ( bSet )
				bEastWingUpper_Ambrose_Pirate = true;
			else
				return bEastWingUpper_Ambrose_Pirate;
			break;

		case 'EastWingUpper_Ambrose_Phosphorus1':
			if ( bSet )
				bEastWingUpper_Ambrose_Phosphorus1 = true;
			else
				return bEastWingUpper_Ambrose_Phosphorus1;
			break;

		case 'EastWingUpper_Ambrose_Phosphorus2':
			if ( bSet )
				bEastWingUpper_Ambrose_Phosphorus2 = true;
			else
				return bEastWingUpper_Ambrose_Phosphorus2;
			break;

		case 'EastWingUpper_Ambrose_Phosphorus3':
			if ( bSet )
				bEastWingUpper_Ambrose_Phosphorus3 = true;
			else
				return bEastWingUpper_Ambrose_Phosphorus3;
			break;

		case 'EastWingUpper_Keisinger_Journal':
			if ( bSet )
				bEastWingUpper_Keisinger_Journal = true;
			else
				return bEastWingUpper_Keisinger_Journal;
			break;

		case 'EastWingUpper_Office_Evaline':
			if ( bSet )
				bEastWingUpper_Office_Evaline = true;
			else
				return bEastWingUpper_Office_Evaline;
			break;

		case 'EastWingUpper_ReadingRoom_Health1':
			if ( bSet )
				bEastWingUpper_ReadingRoom_Health1 = true;
			else
				return bEastWingUpper_ReadingRoom_Health1;
			break;

		case 'EastWingUpper_ReadingRoom_Health2':
			if ( bSet )
				bEastWingUpper_ReadingRoom_Health2 = true;
			else
				return bEastWingUpper_ReadingRoom_Health2;
			break;

		case 'EastWingUpper_Bar_molotov1':
			if ( bSet )
				bEastWingUpper_Bar_molotov1 = true;
			else
				return bEastWingUpper_Bar_molotov1;
			break;

		case 'EastWingUpper_Bar_molotov2':
			if ( bSet )
				bEastWingUpper_Bar_molotov2 = true;
			else
				return bEastWingUpper_Bar_molotov2;
			break;

		case 'EastWingUpper_Bar_molotov3':
			if ( bSet )
				bEastWingUpper_Bar_molotov3 = true;
			else
				return bEastWingUpper_Bar_molotov3;
			break;

		case 'EastWingUpper_Lounge_ShotgunShells':
			if ( bSet )
				bEastWingUpper_Lounge_ShotgunShells = true;
			else
				return bEastWingUpper_Lounge_ShotgunShells;
			break;

		case 'EastWingUpper_Hallway_Amplifier':
			if ( bSet )
				bEastWingUpper_Hallway_Amplifier = true;
			else
				return bEastWingUpper_Hallway_Amplifier;
			break;

		case 'VisitAaronsStudio':
			if ( bSet )
				bVisitAaronsStudio = true;
			else
				return bVisitAaronsStudio;
			break;

		case 'CentralUpper_WidowsWatchKey':
			if ( bSet )
				bCentralUpper_WidowsWatchKey = true;
			else
				return bCentralUpper_WidowsWatchKey;
			break;

		case 'CentralUpper_Josephsconcern':
			if ( bSet )
				bCentralUpper_Josephsconcern = true;
			else
				return bCentralUpper_Josephsconcern;
			break;

		case 'EntranceHall_JoesRoom_Joenotes':
			if ( bSet )
				bEntranceHall_JoesRoom_Joenotes = true;
			else
				return bEntranceHall_JoesRoom_Joenotes;
			break;

		case 'EntranceHall_EvasRoom_EvalinesDiary':
			if ( bSet )
				bEntranceHall_EvasRoom_EvalinesDiary = true;
			else
				return bEntranceHall_EvasRoom_EvalinesDiary;
			break;

		case 'NorthWIngUpper_Aaron_amplifier':
			if ( bSet )
				bNorthWIngUpper_Aaron_amplifier = true;
			else
				return bNorthWIngUpper_Aaron_amplifier;
			break;

		case 'LearnofPiratesCove':
			if ( bSet )
				bLearnofPiratesCove = true;
			else
				return bLearnofPiratesCove;
			break;

		case 'WestWing_Jeremiah_StudyKey':
			if ( bSet )
				bWestWing_Jeremiah_StudyKey = true;
			else
				return bWestWing_Jeremiah_StudyKey;
			break;

		case 'NorthWIngUpper_Aaron_BethanyGate':
			if ( bSet )
				bNorthWIngUpper_Aaron_BethanyGate = true;
			else
				return bNorthWIngUpper_Aaron_BethanyGate;
			break;

		case 'CentralUpper_Study_Health':
			if ( bSet )
				bCentralUpper_Study_Health = true;
			else
				return bCentralUpper_Study_Health;
			break;

		case 'MonasteryPastFinished':
			if ( bSet )
				bMonasteryPastFinished = true;
			else
				return bMonasteryPastFinished;
			break;

		case 'AmbrosesRoom':
			if ( bSet )
				bAmbrosesRoom = true;
			else
				return bAmbrosesRoom;
			break;

		case 'VisitStandingStones':
			if ( bSet )
			{
				bVisitStandingStones = true;
				log("AeonsPlayer Setting VisitStandingStones Event "$bVisitStandingStones, 'GameEvents');
			} else {
				log("AeonsPlayer Checking VisitStandingStones Event "$bVisitStandingStones, 'GameEvents');
				return bVisitStandingStones;
			}
			break;

		case 'FlightEnabled':
			if ( bSet )
				bFlightEnabled = true;
			else
				return bFlightEnabled;
			break;

		case 'AfterChapel':
			if ( bSet )
				bAfterChapel = true;
			else
				return bAfterChapel;
			break;

		case 'KiesingerDead':
			if ( bSet )
				bKiesingerDead = true;
			else
				return bKiesingerDead;
			break;

		case 'ChandelierFell':
			if ( bSet )
				bChandelierFell = true;
			else
				return bChandelierFell;
			break;

		case 'BethanyTransformed':
			if ( bSet )
				bBethanyTransformed = true;
			else
				return bBethanyTransformed;
			break;

		case 'AmplifierFound':
			if ( bSet )
				bAmplifierFound = true;
			else
				return bAmplifierFound;
			break;

		case 'OracleReturn':
			if ( bSet )
				bOracleReturn = true;
			else
				return bOracleReturn;
			break;

		case 'WhorlFound':
			if ( bSet )
				bWhorlFound = true;
			else
				return bWhorlFound;
			break;

		case 'EtherFound':
			if ( bSet )
				bEtherFound = true;
			else
				return bEtherFound;
			break;

		case 'PostShrine':
			if ( bSet )
				bPostShrine = true;
			else
				return bPostShrine;
			break;

		case 'ManaWellFound':
			if ( bSet )
				bManaWellFound = true;
			else
				return bManaWellFound;
			break;

		case 'Chapel_EtherTrap3':
			if ( bSet )
				bChapel_EtherTrap3 = true;
			else
				return bChapel_EtherTrap3;
			break;

		case 'Chapel_EtherTrap4':
			if ( bSet )
				bChapel_EtherTrap4 = true;
			else
				return bChapel_EtherTrap4;
			break;

		case 'Chapel_Bullets':
			if ( bSet )
				bChapel_Bullets = true;
			else
				return bChapel_Bullets;
			break;

		case 'EnteredJeremiahsRoom':
			if ( bSet )
				bEnteredJeremiahsRoom = true;
			else
				return bEnteredJeremiahsRoom;
			break;

		default:
			return false;
			break;
	}
}

// sets the camera fov immediately.
exec function SetFOV(float newFOV)
{
	DesiredFov = newFov;
	FOVAngle = newFOV;
}

exec function WeaponAction()
{
	if (Weapon != none)
	switch(Weapon.class.name)
	{
		case 'GhelziabahrStone':
			break;

		case 'Revolver':
			Revolver(Weapon).Reload();
			break;
	
		case 'Shotgun':
			if (Shotgun(Weapon).ClipCount == 1)
				Shotgun(Weapon).Reload();
			else
			{
				Shotgun(Weapon).DoubleBarrelToggle();
				DoubleShotgun();
			}
			break;

		case 'Molotov':
			break;

		//case 'Dynamite':
		//	Dynamite(Weapon).DropStick();
		//	break;

		case 'Scythe':
			Scythe(Weapon).Berserk();
			break;
	
		case 'TibetianWarCannon':
			break;

		case 'Speargun':
			EagleEyes();
			break;
	}
}

exec function SetTake(int i)
{
	local CameraProjectile Cam;

	ForEach AllActors(class 'CameraProjectile', Cam)
	{
		Cam.SetTake(i);
	}
}

exec function NextTake()
{
	local CameraProjectile Cam;

	ForEach AllActors(class 'CameraProjectile', Cam)
	{
		Cam.NextTake();
	}
}

exec function PrevTake()
{
	local CameraProjectile Cam;

	ForEach AllActors(class 'CameraProjectile', Cam)
	{
		Cam.PrevTake();
	}
}

//----------------------------------------------------------------------------

function ProcessObjectives( string ObjectivesText )
{
	local string Remainder;
	local string Op, NextOp;
	local string NumberString;
	local string CurrentChar;
	local bool Process;
	local bool EatChar;
	
	log("ProcessObjectives: " $ ObjectivesText);

	Remainder = ObjectivesText;

	NumberString = "";
	Op = "";
	Process = false;
	EatChar = false;

	while ( Remainder != "" )
	{
		CurrentChar = Left(Remainder,1);

		switch ( CurrentChar ) 
		{
			// if we find a space, just call Process, it won't hurt to process nothing
			case " ": 
				Process = true;
				break;

			case "-": 
			case "+":
				// if we found an op and we don't have a number built, we need to record this
				if (NumberString == "") 
				{
					Op = CurrentChar;
				}
				// otherwise, this is the start of the next objective.  leave the char for next iteration and process
				else
				{
					EatChar = false;
					Process = true;
				}
				break;

			case "0":
			case "1":
			case "2":
			case "3":
			case "4":
			case "5":
			case "6":
			case "7":
			case "8":
			case "9":
				// if we get a number, just concatenate to current numberstring
				NumberString = NumberString $ CurrentChar;
				break;		
		}


		// if we need to eat the current char, grab everything but the currentchar ( from the right )
		if ( EatChar ) 
		{
			Remainder = Right( Remainder, Len(Remainder)-1 );

			if ( Remainder == "" ) 
				Process = true;
		}

		// true is the default behavior
		EatChar = true;

		// if we were told to process our current data
		if ( Process ) 
		{
			// if we have a vaild number string
			if ( Len(NumberString) > 0 )
			{
				// if we have an explicit '-' char then remove the objective
				if ( Op == "-" )
				{
					RemoveObjective(int(NumberString));
				}
				// Op is either '+' or nothing ( so this will work -10 25 -35
				else
				{
					AddObjective(int(NumberString));
				}

			}

			// we processed so clear accumulating data
			Op = ""; 
			NumberString = "";
			Process = false;
		
		}
		
	}

}

//----------------------------------------------------------------------------

function AddObjective( int ObjectiveNumber )
{
	local int i, j;
	local int FreeSlot;
	local int GreatestTag;
	local int CurrentTag, NewTag, TempObjective;
	local string TagString;
	local int Token;

	if ( ObjectiveNumber <= 0 ) 
	{
		log("AddObjective: Negative Objective(" $ ObjectiveNumber $ ")");
		return;
	}

	if ( ObjectiveNumber > 99 ) 
	{
		ClientMessage( "AddObjective: Objective out of range (" $ ObjectiveNumber $ ")  See Keebler!"	);
		return;
	}

	if ( ObjectivesText[ObjectiveNumber] == "" ) 
	{
		Log("Objective " $ ObjectiveNumber $ " has no text !");
		return;
	}

	log("AddObjective: " $ ObjectiveNumber);

	for ( i=0; i<ArrayCount(Objectives); i++ )
	{
		// if already in objective list, return
		if ( (Objectives[i] == ObjectiveNumber) || (Objectives[i]-100 == ObjectiveNumber) )
		{
			return;
		}
	}

	FreeSlot = -1;
	GreatestTag=0;

	NewTag = GetObjectiveTag(ObjectiveNumber);
	
	for ( i=0; i<ArrayCount(Objectives); i++ )
	{
		// 0 means objective is empty
		if ( Objectives[i] == 0 ) 
		{
			FreeSlot = i;
			break;
		}
		// else insert sorted by tag Descending order ( greater value = higher priority )
		else
		{
			CurrentTag = GetObjectiveTag( Objectives[i] );
			
			if ( CurrentTag < NewTag ) 
			{
				for ( j=ArrayCount(Objectives)-2; j>=i; j-- )
				{
					Objectives[j+1] = Objectives[j];					
				}

				FreeSlot = i;
				break;
			}
		}
	}

	if ( FreeSlot >= 0 ) 
	{
		Objectives[FreeSlot] = ObjectiveNumber;
		if ( AeonsHUD(myHud) != None && GetRenewalConfig().bAutoShowObjectives ) 
		{
			AeonsHUD(myHud).DisplayObjectives();
		}
	}
}

//----------------------------------------------------------------------------

function int GetObjectiveTag( int ObjectiveNumber )
{
	local string TagString;
	local int TokenPos;
	local int Tag;

	TagString = ObjectivesText[ ObjectiveNumber ];

	TokenPos = InStr( TagString, "," );

	if (TokenPos >= 0)
	{
		TagString = Left(TagString, TokenPos);			
		
		Tag = int(TagString);

		//log("GetObjectiveTag returning " $ Tag);
		return Tag;
	}
	else
		return -1;

}

//----------------------------------------------------------------------------
// if it exists and it's positive, it's enabled
// if it exists and it's negative, it's disabled
// if it doesn't exist, it's off

function RemoveObjective( int ObjectiveNumber )
{
	local int i, j, FoundSlot;

	log("RemoveObjective: " $ ObjectiveNumber);

	for ( i=0; i<ArrayCount(Objectives); i++ )
	{
		if ( Objectives[i] == ObjectiveNUmber )
		{
			// slide the rest of the objectives up 
			for ( j=i; j<ArrayCount(Objectives)-1; j++ )
			{
				Objectives[j] = Objectives[j+1];				
			}

			// place newly disabled objective on the end of the list
			Objectives[ ArrayCount(Objectives)-1 ] = ObjectiveNumber+100;

			return;
		}
		else if ( Objectives[i]-100 == ObjectiveNumber )
		{
			return;
		}
	}

	// didn't find it, but we still need to disable it 
	for ( i=ArrayCount(Objectives)-1; i>=0; i-- )
	{

		log("Removeobjective: doesn't exist, still removing " $ ObjectiveNumber );
		if ( Objectives[i] == 0 )
		{
			Objectives[i] = ObjectiveNumber+100;
			return;
		}
	}
}

function WalkTexture( texture Texture, vector StepLocation, vector StepNormal )
{
/*
	if ((Texture.Climb > 0) && (StepNormal.z > 0.7))
		bIsClimbing = true;
*/
}

function GiveMolotov()
{
	local Weapon newWeapon;
	
	if (Inventory.FindItemInGroup(class'Aeons.Molotov'.default.InventoryGroup) == none)
	{
		newWeapon = Spawn(class'Aeons.Molotov');
		if( newWeapon != None )
		{
			newWeapon.Instigator = self;
			newWeapon.BecomeItem();
			AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(self);
			newWeapon.SetSwitchPriority(self);
			newWeapon.WeaponSet(self);
		}
	}

}



exec function QuickSave()
{
	if ( (Health > 0) 
		&& (Level.NetMode == NM_Standalone)
		&& !Level.Game.bDeathMatch )
	{
		//dynamic ConsoleCommand("SaveShot ..\\save\\0\\save.bmp");

		ClientMessage(QuickSaveString);
		ConsoleCommand("SaveGame 0");
	}
}

state CheatFlying
{
	function ProcessMove(float DeltaTime, vector NewAccel, rotator DeltaRot)	
	{
		local float OldAirSpeed;

		Acceleration = Normal(NewAccel);
		Velocity = Normal(NewAccel) * GroundSpeed * HasteModifier(HasteMod).speedMultiplier;
		
		OldAirSpeed = AirSpeed;
		
		AutonomousPhysics(DeltaTime);
		AirSpeed = OldAirSpeed;
		//MoveSmooth(Acceleration * DeltaTime);
	}
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     BreathAgain=Sound'Voiceover.Patrick.Pa_140'
     Swim1=Sound'CreatureSFX.SharedHuman.P_Swim01'
     Swim2=Sound'CreatureSFX.SharedHuman.P_Swim02'
     Swim3=Sound'CreatureSFX.SharedHuman.P_Swim03'
     HitSound3=Sound'Voiceover.Patrick.Pa_126'
     HitSound4=Sound'Voiceover.Patrick.Pa_127'
     Die2=Sound'Voiceover.Patrick.Pa_131'
     Die3=Sound'Voiceover.Patrick.Pa_132'
     Die4=Sound'Voiceover.Patrick.Pa_132'
     GaspSound=Sound'Aeons.Player.P_Gasp_Air01'
     LandGrunt=Sound'Voiceover.Patrick.Pa_138'
     UnderWater=Sound'CreatureSFX.SharedHuman.P_Underwater01'
     VoiceType=Class'Engine.VoicePack'
     bAllowSelectionHUD=True
     SelectTime=0.15
     SelectTimePSX2=0.2
     UserSettingsPSX2=(SoundVolumePSX2=7,MusicVolumePSX2=5,EasyAimPSX2=True,VibrationPSX2=True)
     ScrollDelayPSX2=0.3
     JumpSound(0)=Sound'Voiceover.Patrick.Pa_135'
     JumpSound(1)=Sound'Voiceover.Patrick.Pa_136'
     bSinglePlayer=True
     bCanStrafe=True
     bIsHuman=True
     MeleeRange=50
     GroundSpeed=400
     AirSpeed=256
     AccelRate=2048
     JumpZ=350
     ManaRefreshAmt=2
     ManaRefreshTime=2
     BaseEyeHeight=48
     OnFireParticles=Class'Aeons.OnFireParticleFX'
     UnderWaterTime=20
     Intelligence=BRAINS_Human
     PI_StabSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_BiteSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_BluntSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_BulletSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_RipSliceSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_GenLargeSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_GenMediumSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_GenSmallSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     HitSound1=Sound'Voiceover.Patrick.Pa_124'
     HitSound2=Sound'Voiceover.Patrick.Pa_125'
     Land=Sound'Voiceover.Patrick.Pa_137'
     Die=Sound'Voiceover.Patrick.Pa_130'
     Buoyancy=99
     AnimSequence=None
     RotationRate=(Pitch=3072,Yaw=65000,Roll=2048)
     Style=STY_Masked
     Sprite=Texture'Engine.S_Pawn'
     CollisionRadius=32
     CollisionHeight=64
	 bShowScryeHint=True
}
