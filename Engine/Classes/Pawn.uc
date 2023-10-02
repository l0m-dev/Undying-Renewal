//=============================================================================
// Pawn, the base class of all actors that can be controlled by players or AI.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Pawn extends Visible 
	abstract
	native
	nativereplication;

//#exec Texture Import File=Textures\Pawn.pcx Name=S_Pawn Mips=On Flags=2

//-----------------------------------------------------------------------------
// Pawn variables.

struct ImpactSoundParams
{
	var() float MaxVolume;
	var() float MinVolume;
	var() float Radius;
	var() float MaxPitch;
	var() float MinPitch;
	var() sound Sound_1;
	var() sound Sound_2;
	var() sound Sound_3;
};

// General flags.
var travel bool bBehindView;    // Outside-the-player view.
var bool        bIsPlayer;      // Pawn is a player or a player-bot.
var bool		bJustLanded;	// used by eyeheight adjustment
var bool		bUpAndOut;		// used by swimming 
var bool		bIsWalking;
var bool		bIsCreeping;
var const bool	bHitSlopedWall;	// used by Physics
var globalconfig bool	bNeverSwitchOnPickup;	// if true, don't automatically switch to picked up weapon
var bool		bWarping;		// Set when travelling through warpzone (so shouldn't telefrag)
var bool		bUpdatingDisplay; // to avoid infinite recursion through inventory setdisplay
var bool		bNoDetect;		// Set if pawn can not be detected by other's senses.
var bool		bBloodyFootprints;	// drop Bloody footprints?

var bool bForceClimb;
var bool bIsClimbing;

// Bloody Footprint decals
var(BloodFootprints) class<Decal> BackRightDecalClass;
var(BloodFootprints) class<Decal> BackLeftDecalClass;
var(BloodFootprints) class<Decal> FrontRightDecalClass;
var(BloodFootprints) class<Decal> FrontLeftDecalClass;

var(SnowFootprints) class<Decal> BackRightSnowDecalClass;
var(SnowFootprints) class<Decal> BackLeftSnowDecalClass;
var(SnowFootprints) class<Decal> FrontRightSnowDecalClass;
var(SnowFootprints) class<Decal> FrontLeftSnowDecalClass;


//AI flags
var(AICombat) bool	bCanStrafe;
var(AIOrders) bool	bFixedStart;
var const bool		bReducedSpeed;		//used by movement natives
var		bool		bCanJump;
var		bool 		bCanWalk;
var		bool		bCanSwim;
var		bool		bCanFly;
var		bool		bCanOpenDoors;
var		bool		bCanDoSpecial;
var		bool		bDrowning;
var const bool		bLOSflag;			// used for alternating LineOfSight traces
var 	bool 		bFromWall;
var		bool		bHunting;			// tells navigation code that pawn is hunting another pawn,
										//	so fall back to finding a path to a visible pathnode if none
										//	are reachable
var(Movement) bool	bAvoidLedges;		// don't get too close to ledges
var(Movement) bool	bStopAtLedges;		// if bAvoidLedges and bStopAtLedges, Pawn doesn't try to walk along the edge at all
var		bool		bJumpOffPawn;		
var		bool		bShootSpecial;
var		bool		bAutoActivate;
var		bool		bIsHuman;			// for games which care about whether a pawn is a human
var		bool		bIsFemale;
var		bool		bIsMultiSkinned;
var		bool		bCountJumps;
var		bool		bAdvancedTactics;	// used during movement between pathnodes
var		bool		bViewTarget;

var		bool		bIsLit;				// if the pawn is Lit by the FireFly spell
var		int			LitAmplitude;		// casting level of the firefly spell - so projectiles will know how eagerly to persue the lit Pawn

var travel float	VolumeMultiplier;	// multiplier for the volume of player sounds 

// Ticked pawn timers
var		float		SightCounter;	//Used to keep track of when to check player visibility
var		float       PainTime;		//used for getting PainTimer() messages (for Lava, no air, etc.)
var		float		SpeechTime;	

// Physics updating time monitoring (for AI monitoring reaching destinations)
var const	float		AvgPhysicsTime;

// Additional pawn region information.
var PointRegion FootRegion;
var PointRegion HeadRegion;

// Attached Modifiers
var FireModifier 	FireMod;			// Fire Modifier - for being lit on fire
var WetModifier 	WetMod;				// Wet Modifier - for being wet after exiting a waterzone
var GlowModifier 	GlowMod;			// Glow Modifier - for showing a glow about the pawn
var BloodFootprintModifier BloodMod;	// modifier for managing bloody footprints

// Navigation AI
var 	float		MoveTimer;
var 	Actor		MoveTarget;		// set by movement natives
var		Actor		FaceTarget;		// set by strafefacing native
var		vector	 	Destination;	// set by Movement natives
var	 	vector		Focus;			// set by Movement natives
var		float		DesiredSpeed;
var		float		MaxDesiredSpeed;
var		bool		bReverseMove;	// moving in reverse
var(AIDistance) float	MeleeRange; // Max range for melee attack (not including collision radii)

// Player and enemy movement.
var(Movement) int		 YawThreshold;	 // How far Facing can be from Rotation before affecting Rotation (yaw only).
var(Movement) float      GroundSpeed;     // The maximum ground speed.
var float						GroundFriction;		// friction right here, right now.
var(Movement) float      WaterSpeed;      // The maximum swimming speed.
var(Movement) float      AirSpeed;        // The maximum flying speed.
var(Movement) float		 AccelRate;		  // max acceleration rate
var(Movement) float		 JumpZ;      		// vertical acceleration w/ jump
var(Movement) float      MaxStepHeight;   // Maximum size of upward/downward step.
var(Movement) float      AirControl;		// amount of AirControl available to the pawn
var(Movement) name       LookJoint;			// Joint used for looking.

// AI basics.
var	 	float		MinHitWall;		// Minimum HitNormal dot Velocity.Normal to get a HitWall from the
									// physics
var() 	byte       	Visibility;      //How visible is the pawn? 0 = invisible. 
									// 128 = normal.  255 = highly visible.
var(AI)	float		Alertness; // -1 to 1 ->Used within specific states for varying reaction to stimuli 
var		float 		Stimulus; // Strength of stimulus - Set when stimulus happens, used in Acquisition state 
var(AI) float		SightRadius;     //Maximum seeing distance.
var(AI) float		PeripheralVision;//Cosine of limits of peripheral vision.
var(AI) float		HearingThreshold;  //Minimum noise loudness for hearing
var		vector		LastSeenPos; 		// enemy position when I last saw enemy (auto updated if EnemyNotVisible() enabled)
var		vector		LastSeeingPos;		// position where I last saw enemy (auto updated if EnemyNotVisible enabled)
var		float		LastSeenTime;
var	 	Pawn    	Enemy;
var(AI) class<pawn>	HatedClass;			// class of creature hated by this class
var(AI) name		HatedTag;			// tag of creature(s) hated by this class
var(AI) name		HatedID;			// this creature's tag, others will search for it
var(AI) bool		bIsHated;			// flags if this class can be hated by another

// Player info.
var travel Weapon       Weapon;        // The pawn's current weapon.
var Weapon				PendingWeapon;	// Will become weapon once current weapon is put down
var travel Inventory	SelectedItem;	// currently selected inventory item

var travel bool bAcceptDamage;		// accept conventional attack damage
var travel bool bAcceptMagicDamage; // accept magical attack damage
var bool				bWetFeet;			// My feet are wet

var travel Spell AttSpell; //currently selected attack spell
var travel Spell DefSpell; //currently selected defense spell
var Spell PendingAttSpell;
var Spell PendingDefSpell;

var(Mana) travel int Mana;              //Current Mana amount
var(Mana) travel int ManaCapacity;      //Total Mana Capacity
var(Mana) travel int ManaRefreshAmt;    //Mana refreshed per ManaRefreshTime
var(Mana) travel float ManaRefreshTime;

var travel bool	bRunMode;

// Movement.
var rotator     	ViewRotation;  	// View rotation.
var vector			WalkBob;
var() float      	BaseEyeHeight; 	// Base eye height above collision center.
var float        	EyeHeight;     	// Current eye height, adjusted for bobbing and stairs.
var	const	vector	Floor;			// Normal of floor pawn is standing on (only used
									//	by PHYS_Spider)
var float			SplashTime;		// time of last splash
var float           Climb;			// Rate of climb.
var(Movement) float ClimbRate;		// Ability of pawn to climb. //fix remove these if using Legend climbing
var float           ClimbDirection;	// Direction along the rotation of the climb.
var vector			VelocityBias;	// Direction to bias velocity.

// View
var float        OrthoZoom;     // Orthogonal/map view zoom factor.
var() float      FovAngle;      // X field of view angle in degrees, usually 90.
var rotator		 BehindViewOffset;	// offset for behind view

// Player game statistics.
var int			DieCount, ItemCount, KillCount, SecretCount, Spree;

//Health
var() travel float      Health;          // Health: 100 = normal maximum

// Joint effects
var() class<ParticleFX> OnFireParticles;	// Particle system I use when I'm on fire.
var() class<ParticleFX> OnFireSmokeParticles;	// Particle system I use when I'm on fire.
var() class<Actor> 		GlowFX;				// Effect actor I use when I am glowing
var() class<ParticleFX> WaterParticles;		// Particle system I use when I'm drippng water.

// Selection Mesh
var() string			SelectionMesh;
var() string			SpecialMesh;

// Inherent Armor (for creatures).
var() name	ReducedDamageType; //Either a damagetype name or 'All', 'AllEnvironment' (Burned, Corroded, Frozen)
var() float ReducedDamagePct;

// Inventory to drop when killed (for creatures)
var() class<inventory> DropWhenKilled;

// Zone pain
var(Movement) float		UnderWaterTime;  	//how much time pawn can go without air (in seconds)

var(AI) enum EAttitude  //important - order in decreasing importance
{
	ATTITUDE_Fear,		//will try to run away
	ATTITUDE_Hate,		// will attack enemy
	ATTITUDE_Frenzy,	//will attack anything, indiscriminately
	ATTITUDE_Threaten,	// animations, but no attack
	ATTITUDE_Ignore,
	ATTITUDE_Friendly,
	ATTITUDE_Follow 	//accepts player as leader
} AttitudeToPlayer;	//determines how creature will react on seeing player (if in human form)

var(AI) enum EIntelligence //important - order in increasing intelligence
{
	BRAINS_None,		//only reacts to immediate stimulus
	BRAINS_Reptile,		//follows to last seen position
	BRAINS_Mammal,		//simple navigation (limited path length)
	BRAINS_Human		//complex navigation, team coordination, use environment stuff (triggers, etc.)
}	Intelligence;

var(AI) float		Skill;			// skill, scaled by game difficulty (add difficulty to this value)	
var		actor		SpecialGoal;	// used by navigation AI
var		float		SpecialPause;

// Sound and noise management
var const 	vector 		noise1spot;
var const 	float 		noise1time;
var const	pawn		noise1other;
var const	float		noise1loudness;
var const 	vector 		noise2spot;
var const 	float 		noise2time;
var const	pawn		noise2other;
var const	float		noise2loudness;
var			float		LastPainSound;

var class<SoundContainer>	SoundSet;		// Pawn's sound set.

// Projectile Sound Impacts
var(Projectile_Impact) ImpactSoundParams	PI_StabSound;
var(Projectile_Impact) ImpactSoundParams	PI_BiteSound;
var(Projectile_Impact) ImpactSoundParams	PI_BluntSound;
var(Projectile_Impact) ImpactSoundParams	PI_BulletSound;
var(Projectile_Impact) ImpactSoundParams	PI_RipSliceSound;
var(Projectile_Impact) ImpactSoundParams	PI_GenLargeSound;
var(Projectile_Impact) ImpactSoundParams	PI_GenMediumSound;
var(Projectile_Impact) ImpactSoundParams	PI_GenSmallSound;

var(Projectile_Effect) class<Actor>	PE_StabEffect;
var(Projectile_Effect) class<Actor>	PE_StabKilledEffect;
var(Projectile_Effect) class<Actor>	PE_BiteEffect;
var(Projectile_Effect) class<Actor>	PE_BiteKilledEffect;
var(Projectile_Effect) class<Actor>	PE_BluntEffect;
var(Projectile_Effect) class<Actor>	PE_BluntKilledEffect;
var(Projectile_Effect) class<Actor>	PE_BulletEffect;
var(Projectile_Effect) class<Actor>	PE_BulletKilledEffect;
var(Projectile_Effect) class<Actor>	PE_RipSliceEffect;
var(Projectile_Effect) class<Actor>	PE_RipSliceKilledEffect;
var(Projectile_Effect) class<Actor> PE_GenLargeEffect;
var(Projectile_Effect) class<Actor> PE_GenLargeKilledEffect;
var(Projectile_Effect) class<Actor> PE_GenMediumEffect;
var(Projectile_Effect) class<Actor> PE_GenMediumKilledEffect;
var(Projectile_Effect) class<Actor> PE_GenSmallEffect;
var(Projectile_Effect) class<Actor> PE_GenSmallKilledEffect;

var(Projectile_Decal) class<Decal> PD_StabDecal;
var(Projectile_Decal) class<Decal> PD_BiteDecal;
var(Projectile_Decal) class<Decal> PD_BluntDecal;
var(Projectile_Decal) class<Decal> PD_BulletDecal;
var(Projectile_Decal) class<Decal> PD_RipSliceDecal;
var(Projectile_Decal) class<Decal> PD_GenLargeDecal;
var(Projectile_Decal) class<Decal> PD_GenMediumDecal;
var(Projectile_Decal) class<Decal> PD_GenSmallDecal;

var(Wounds) class<Actor> StabWound;
var(Wounds) class<Actor> BiteWound;
var(Wounds) class<Actor> BluntWound;
var(Wounds) class<Actor> BulletWound;
var(Wounds) class<Actor> RipSliceWound;
var(Wounds) class<Actor> GenLargeWound;
var(Wounds) class<Actor> GenMediumWound;
var(Wounds) class<Actor> GenSmallWound;

// chained pawn list
var const	pawn		nextPawn;


// Common sounds
var byte	LastFootStep;  // which footstep sound did we play last
//var(Sounds) byte	FootStepID;
var(Sounds)	sound	HitSound1;
var(Sounds)	sound	HitSound2;
var(Sounds)	sound	Land;
var(Sounds)	sound	Die;
var(Sounds) sound	WaterStep;

var(Sounds) class<FootSoundSet> FootSoundClass;
var(Sounds) float	FootSoundRadius;

// Input buttons.
var input byte
	bZoom, bRun, bLook, bDuck, bSnapLevel,
	bStrafe, bFire, bFreeLook, 
    bFireAttSpell, bFireDefSpell,
	bExtra0, bJump, bExtra2, bExtra3;

var NavigationPoint home; //set when begin play, used for retreating and attitude checks

// Route Cache for Navigation
var NavigationPoint RouteCache[16];
 
var name NextState; //for queueing states
var name NextLabel; //for queueing states

// Damage Stuff
var float DamageScaling;
var() float GibDamageThresh;	// The amount of damage this pawn must take (all at once) to gib (only if dying or dead).
var() class<ParticleFX> PersistentBlood;
var ParticleFX PBlood;

var() int HeartRate;			// heartRate of our guy - used for wounds
var() int BloodPressure;		// Blood Pressure of out guy - used for Wounds

var	Decoration	carriedDecoration;

var Name PlayerReStartState;

var() localized  string MenuName; //Name used for this pawn type in menus (e.g. player selection) 
var() localized  string NameArticle; //article used in conjunction with this class (e.g. "a", "an")

var() byte VoicePitch; //for speech
var() string VoiceType; //for speech
var float OldMessageTime; //to limit frequency of voice messages

// Replication Info
var() class<PlayerReplicationInfo> PlayerReplicationInfoClass;
var PlayerReplicationInfo PlayerReplicationInfo;

// shadow decal
var Decal Shadow;

replication
{
	// Variables the server should send to the client.
	//reliable if( ( RemoteRole==ROLE_SimulatedProxy && (bNetInitial || bSimulatedPawn) ) )
	//	GroundFriction;
	
	reliable if( Role==ROLE_Authority )
		Weapon, PlayerReplicationInfo, Health, Mana,
		AttSpell, DefSpell;
	reliable if( Role==ROLE_Authority && bNetOwner )
		 bIsPlayer, CarriedDecoration, SelectedItem,
		 GroundSpeed, WaterSpeed, AirSpeed, AccelRate, JumpZ, MaxStepHeight, AirControl,
		 ManaCapacity, ManaRefreshAmt, ManaRefreshTime,
		 bBehindView, GroundFriction, PlayerRestartState;
	unreliable if( (bNetOwner && bIsPlayer && bNetInitial && Role==ROLE_Authority) || bDemoRecording )
		ViewRotation;
	unreliable if( bNetOwner && Role==ROLE_Authority )
         MoveTarget;
    unreliable if( Role==ROLE_Authority )
         bCanFly, BaseEyeHeight;
	reliable if( bDemoRecording )
		EyeHeight;

	// Functions the server calls on the client side.
	reliable if( RemoteRole==ROLE_AutonomousProxy ) 
		ClientDying, ClientReStart, ClientGameEnded, ClientSetRotation, ClientSetLocation, ClientPutDown;
	unreliable if( (!bDemoRecording || bClientDemoRecording && bClientDemoNetFunc) && Role==ROLE_Authority )
		ClientHearSound;
	reliable if ( (!bDemoRecording || (bClientDemoRecording && bClientDemoNetFunc)) && Role == ROLE_Authority )
		ClientVoiceMessage;
	reliable if ( (!bDemoRecording || (bClientDemoRecording && bClientDemoNetFunc) || (Level.NetMode==NM_Standalone && IsA('PlayerPawn'))) && Role == ROLE_Authority )
		ClientMessage, TeamMessage, ReceiveLocalizedMessage;

	// Functions the client calls on the server.
	unreliable if( Role<ROLE_Authority )
		SendVoiceMessage, NextItem, SwitchToBestWeapon, bExtra0, bJump, bExtra2, bExtra3, TeamBroadcast;

	// Input sent from the client to the server.
	unreliable if( Role<ROLE_AutonomousProxy )
		bZoom, bRun, bLook, bDuck, bSnapLevel, bStrafe;

	unreliable if( Role<ROLE_Authority )
		Climb, ClimbDirection;
}

// Latent Movement.
//Note that MoveTo sets the actor's Destination, and MoveToward sets the
//actor's MoveTarget.  Actor will rotate towards destination

native(500) final latent function MoveTo( vector NewDestination, optional float Speed, optional float latenttime );
native(502) final latent function MoveToward(actor NewTarget, optional float Speed, optional float latenttime );
native(504) final latent function StrafeTo(vector NewDestination, vector NewFocus, optional float Speed);
native(506) final latent function StrafeFacing(vector NewDestination, actor NewTarget, optional float Speed);
native(508) final latent function TurnTo(vector NewFocus, optional int yawthresh);
native(510) final latent function TurnToward(actor NewTarget, optional int yawthresh);
native(513) final function bool RotateToView();

// native AI functions
//LineOfSightTo() returns true if any of several points of Other is visible 
// (origin, top, bottom)
native(514) final function bool LineOfSightTo(actor Other); 

// CanSee() similar to line of sight, but also takes into account Pawn's peripheral vision
native(533) final function bool CanSee(actor Other); 
native(516) final function PopRouteCache();
native(518) final function Actor FindPathTo(vector aPoint, optional bool bSinglePath, 
												optional bool bClearPaths);
native(517) final function Actor FindPathToward(actor anActor, optional bool bSinglePath, 
												optional bool bClearPaths);

/*
native(538) final function bool  IsCover(actor anEnemy, actor anCover);
native(535) final function Actor FindCover(out actor Dest, actor anEnemy, optional bool bToward);
*/

native(525) final function NavigationPoint FindRandomDest(optional bool bClearPaths);

native(522) final function ClearPaths();
native(523) final function vector EAdjustJump();

//Reachable returns what part of direct path from Actor to aPoint is traversable
//using the current locomotion method
native(521) final function bool pointReachable(vector aPoint);
native(520) final function bool actorReachable(actor anActor);

/* PickWallAdjust()
Check if could jump up over obstruction (only if there is a knee height obstruction)
If so, start jump, and return current destination
Else, try to step around - return a destination 90 degrees right or left depending on traces
out and floor checks
*/
native(526) final function bool PickWallAdjust();
native(524) final function int FindStairRotation(float DeltaTime);
native(527) final latent function WaitForLanding();
native(540) final function actor FindBestInventoryPath(out float MinWeight, bool bPredictRespawns);

native(529) final function AddPawn();
native(530) final function RemovePawn();

// Pick best pawn target
native(531) final function pawn PickTarget(out float bestAim, out float bestDist, vector FireDir, vector projStart);
native(534) final function actor PickAnyTarget(out float bestAim, out float bestDist, vector FireDir, vector projStart);

native(404) final function PlayFootSound
( 
	int Slot, //fix slot should be the same no matter what ? 
	texture HitTexture, 
	byte SoundType, 
	vector Location, 
	optional float Volume, 
	optional float Radius, 
	optional float Pitch 
);

//****************************************************************************
// <Begin> Sound trigger functions
// These functions used to trigger creature-specific SFX when animation that would
// normally do so has been inhibited or state code knows that animation can not
// use normal animation notification to play sound.
//****************************************************************************

// Play a sound, with parameters specified in a string (name).
// Used in animation notifies.
native(537) final function PlaySound_P( string Params );

function PlaySound_N( name Params )
{
	PlaySound_P( string(Params) );
}

// Force end to sleep
native function StopWaiting();

// event called prior to stepping skeletal animation
event PreSkelAnim()
{
	// Look in current view direction.
	if ( Health > 0 && LookJoint != '')
	{
		// Validate joint.
		if (JointIndex(LookJoint) < 0)
		{
			if (JointIndex('head') >= 0)
				LookJoint = 'head';
			else
				LookJoint = '';
		}

		if (LookJoint != '')
			AddTargetRot( LookJoint, ConvertRot(ViewRotation), true );
	}
	else
		ClearTargets();
}

event MayFall(); //return true if allowed to fall - called by engine when pawn is about to fall
event AlterDestination(); // called when using movetoward with bAdvancedTactics true to temporarily modify destination

simulated event RenderOverlays( canvas Canvas )
{
	if ( Weapon != None )
		Weapon.RenderOverlays(Canvas);
}

event WeaponFireNotify(name WeaponName, Pawn Attacker);
event SpellCastNotify(name SpellName, Pawn Caster);
event ProjectileStrikeNotify(Pawn P);

function PlayEffectAtJoint(name JointName, name JointType)
{
	local texture	HitTexture;
	local int		Flags, HitJoint;
	local vector 	JointLoc, HitLocation, HitNormal, end;
	local Decal 	D;
	local bool 		bSnowFootprints;
	local byte ImpactID;

	JointLoc = JointPlace(JointName).pos + vect(0,0,1) * (CollisionHeight * 0.5);
	end = JointLoc + vect(0,0,-1) * CollisionHeight * 2;

	HitTexture = TraceTexture(end, JointLoc, Flags, true );
	if ( HitTexture != none )
	{
		// organic texture? drop bloody footprint decals
		if ( HitTexture.ImpactID == TID_Organic )
			if (BloodMod != none)
				BloodMod.MyFeetAreBloody();

		if ( HitTexture.ImpactID == TID_Snow )
		{
			// for pawns without BloodMod
			bSnowFootprints = true;

			if (BloodMod != none)
				BloodMod.MyFeetAreSnowy();
		}

		Trace(HitLocation, HitNormal, HitJoint, end, JointLoc);
		if ( bWetFeet || FootRegion.Zone.bWaterZone )
		{
			// log("My Feet are Wet!", 'Misc');
			
			ImpactID = HitTexture.ImpactID;
			HitTexture.ImpactID = TID_Water;
			PlayFootSound( 3, HitTexture, 0, Location, 1.0 * VolumeMultiplier);
			
			// Set the texture flag back
			switch ( ImpactID )
			{
				case 0:
					HitTexture.ImpactID = TID_Default;
					break;
				case 1:
					HitTexture.ImpactID = TID_Glass;
					break;
				case 2:
					HitTexture.ImpactID = TID_Water;
					break;
				case 3:
					HitTexture.ImpactID = TID_Leaves;
					break;
				case 4:
					HitTexture.ImpactID = TID_Snow;
					break;
				case 5:
					HitTexture.ImpactID = TID_Grass;
					break;
				case 6:
					HitTexture.ImpactID = TID_Organic;
					break;
				case 7:
					HitTexture.ImpactID = TID_Carpet;
					break;
				case 8:
					HitTexture.ImpactID = TID_Earth;
					break;
				case 9:
					HitTexture.ImpactID = TID_Sand;
					break;
				case 10:
					HitTexture.ImpactID = TID_WoodHollow;
					break;
				case 11:
					HitTexture.ImpactID = TID_WoodSolid;
					break;
				case 12:
					HitTexture.ImpactID = TID_Stone;
					break;
				case 13:
					HitTexture.ImpactID = TID_Metal;
					break;
				case 14:
					HitTexture.ImpactID = TID_Extra1;
					break;
				case 15:
					HitTexture.ImpactID = TID_Extra2;
					break;
				case 16:
					HitTexture.ImpactID = TID_Extra3;
					break;
				case 17:
					HitTexture.ImpactID = TID_Extra4;
					break;
				case 18:
					HitTexture.ImpactID = TID_Extra5;
					break;
				case 19:
					HitTexture.ImpactID = TID_Extra6;
					break;
			}
		} else {
			if ( !IsA('PlayerPawn') || (!bIsWalking) )
				PlayFootSound( 3, HitTexture, 0, HitLocation, VolumeMultiplier );
		}
		
		if ( IsA('PlayerPawn') )
		{
			if (bIsWalking)
				MakeNoise(0.5 * VolumeMultiplier, 640 * VolumeMultiplier);
			else
				MakeNoise(1.0 * VolumeMultiplier, 1280 * VolumeMultiplier);
		}
		
		Dust(HitLocation, HitNormal, HitTexture, 0.65);

		if ( bSnowFootprints || (BloodMod != none && BloodMod.bSnowyFootprints) )
		{
			switch ( JointType )
			{
				case 'BackRight':
					if (BackRightSnowDecalClass != none)
					{
						D = Spawn(BackRightSnowDecalClass,self,, HitLocation, Rotator(HitNormal));
						D.AttachToSurface(Vector(rotation));
					}
					break;

				case 'BackLeft':
					if (BackLeftSnowDecalClass != none)
					{
						D = Spawn(BackLeftSnowDecalClass,self,, HitLocation, Rotator(HitNormal));
						D.AttachToSurface(Vector(rotation));
					}
					break;

				case 'FrontRight':
					if (FrontRightSnowDecalClass != none)
					{
						D = Spawn(FrontRightSnowDecalClass,self,, HitLocation, Rotator(HitNormal));
						D.AttachToSurface(Vector(rotation));
					}
					break;

				case 'FrontLeft':
					if (FrontLeftSnowDecalClass != none)
					{
						D = Spawn(FrontLeftSnowDecalClass,self,, HitLocation, Rotator(HitNormal));
						D.AttachToSurface(Vector(rotation));
					}
					break;
				
				default:
					break;
			}
		}
		else if ( BloodMod != None && BloodMod.bBloodyFootprints )
		{
			switch ( JointType )
			{
				case 'BackRight':
					if (BackRightDecalClass != none)
					{
						D = Spawn(BackRightDecalClass,self,, HitLocation, Rotator(HitNormal));
						D.AttachToSurface(Vector(rotation));
					}
					break;

				case 'BackLeft':
					if (BackLeftDecalClass != none)
					{
						D = Spawn(BackLeftDecalClass,self,, HitLocation, Rotator(HitNormal));
						D.AttachToSurface(Vector(rotation));
					}
					break;

				case 'FrontRight':
					if (FrontRightDecalClass != none)
					{
						D = Spawn(FrontRightDecalClass,self,, HitLocation, Rotator(HitNormal));
						D.AttachToSurface(Vector(rotation));
					}
					break;

				case 'FrontLeft':
					if (FrontLeftDecalClass != none)
					{
						D = Spawn(FrontLeftDecalClass,self,, HitLocation, Rotator(HitNormal));
						D.AttachToSurface(Vector(rotation));
					}
					break;
				
				default:
					break;
			}
		}
			
	} else {
		// log ("FootStep Impact Hit Texture = none");
	}
}

function C_BackRight()
{
	PlayEffectAtJoint('R_Ankle', 'BackRight');
}

function C_BackLeft()
{
	PlayEffectAtJoint('L_Ankle', 'BackLeft');
}

function C_FrontRight()
{
	PlayEffectAtJoint('R_Hand', 'FrontRight');
}

function C_FrontLeft()
{
	PlayEffectAtJoint('L_Hand', 'FrontLeft');
}

// This function is called by projectiles
final function PlayDamageMethodImpact(name ImpactMethod, vector HitLocation, vector HitNormal, optional name JointName)
{
	local float decision;
	Local Actor A;

	decision = FRand();

	MakeNoise(1.0, 1280);
	Switch (ImpactMethod)
	{
		case 'Stab':
			// Sounds
			if ( (decision > 0.66667) && (PI_StabSound.Sound_3 != none) )
				PlaySound(PI_StabSound.Sound_3,SLOT_Interact, RandRange(PI_StabSound.MinVolume,PI_StabSound.MaxVolume) ,,PI_StabSound.Radius, RandRange(PI_StabSound.MinPitch,PI_StabSound.MaxPitch));
			else if ( (decision > 0.33333334) && (PI_StabSound.Sound_2 != none) )
				PlaySound(PI_StabSound.Sound_2,SLOT_Interact, RandRange(PI_StabSound.MinVolume,PI_StabSound.MaxVolume) ,,PI_StabSound.Radius, RandRange(PI_StabSound.MinPitch,PI_StabSound.MaxPitch));
			else if (PI_StabSound.Sound_1 != none)
				PlaySound(PI_StabSound.Sound_1,SLOT_Interact, RandRange(PI_StabSound.MinVolume,PI_StabSound.MaxVolume) ,,PI_StabSound.Radius, RandRange(PI_StabSound.MinPitch,PI_StabSound.MaxPitch));

			// Effect
			if (Health <= 0)
			{
				// Pawn is dead - use Killed Eeffect
				if (PE_StabKilledEffect != none)
					spawn(PE_StabKilledEffect,self,,HitLocation, rotator(HitNormal));
			} else {
				if (PE_StabEffect != none)
					spawn(PE_StabEffect,self,,HitLocation, rotator(HitNormal));
			}

			// Decal
			if ( PD_StabDecal != none )
				Spawn(PD_StabDecal,self,,HitLocation, rotator(HitNormal));

			// Wounds
			if ( (StabWound != none) && (JointName != 'none') )
			{
				A = Spawn(StabWound,self,,HitLocation, rotator(HitNormal));
				if (A.IsA('Wound'))
				{
					Wound(A).AttachJoint = JointName;
					Wound(A).setup();
				}
			}
			
			break;

		case 'Bullet':
			// Sounds
			if ( (decision > 0.66667) && (PI_BulletSound.Sound_3 != none) )
				PlaySound(PI_BulletSound.Sound_3,SLOT_Interact, RandRange(PI_BulletSound.MinVolume,PI_BulletSound.MaxVolume) ,,PI_BulletSound.Radius, RandRange(PI_BulletSound.MinPitch,PI_BulletSound.MaxPitch));
			else if ( (decision > 0.33333334) && (PI_BulletSound.Sound_2 != none) )
				PlaySound(PI_BulletSound.Sound_2,SLOT_Interact, RandRange(PI_BulletSound.MinVolume,PI_BulletSound.MaxVolume) ,,PI_BulletSound.Radius, RandRange(PI_BulletSound.MinPitch,PI_BulletSound.MaxPitch));
			else if (PI_BulletSound.Sound_1 != none)
				PlaySound(PI_BulletSound.Sound_1,SLOT_Interact, RandRange(PI_BulletSound.MinVolume,PI_BulletSound.MaxVolume) ,,PI_BulletSound.Radius, RandRange(PI_BulletSound.MinPitch,PI_BulletSound.MaxPitch));

			// Effect
			if (Health <= 0)
			{
				if (PE_BulletKilledEffect != none)
					spawn(PE_BulletKilledEffect,self,,HitLocation, rotator(HitNormal));
			} else {
				if (PE_BulletEffect != none)
					spawn(PE_BulletEffect,self,,HitLocation, rotator(HitNormal));
			}

			// Decal
			if ( PD_BulletDecal != none )
				Spawn(PD_BulletDecal,self,,HitLocation, rotator(HitNormal));

			// Wounds
			if ( (BulletWound != none) && (JointName != 'none') )
			{
				A = Spawn(BulletWound,self,,HitLocation, rotator(HitNormal));
				if (A.IsA('Wound'))
				{
					Wound(A).AttachJoint = JointName;
					Wound(A).setup();
				}
			}

			break;

		case 'Bite':
			// Sounds
			if ( (decision > 0.66667) && (PI_BiteSound.Sound_3 != none) )
				PlaySound(PI_BiteSound.Sound_3,SLOT_Interact, RandRange(PI_BiteSound.MinVolume,PI_BiteSound.MaxVolume) ,,PI_BiteSound.Radius, RandRange(PI_BiteSound.MinPitch,PI_BiteSound.MaxPitch));
			else if ( (decision > 0.33333334) && (PI_BiteSound.Sound_2 != none) )
				PlaySound(PI_BiteSound.Sound_2,SLOT_Interact, RandRange(PI_BiteSound.MinVolume,PI_BiteSound.MaxVolume) ,,PI_BiteSound.Radius, RandRange(PI_BiteSound.MinPitch,PI_BiteSound.MaxPitch));
			else if (PI_BiteSound.Sound_1 != none)
				PlaySound(PI_BiteSound.Sound_1,SLOT_Interact, RandRange(PI_BiteSound.MinVolume,PI_BiteSound.MaxVolume) ,,PI_BiteSound.Radius, RandRange(PI_BiteSound.MinPitch,PI_BiteSound.MaxPitch));

			// Effect
			if (Health <= 0)
			{
				if (PE_BiteKilledEffect != none)
					spawn(PE_BiteKilledEffect,self,,HitLocation, rotator(HitNormal));
			} else {
				if (PE_BiteEffect != none)
					spawn(PE_BiteEffect,self,,HitLocation, rotator(HitNormal));
			}

			// Decal
			if ( PD_BiteDecal != none )
				Spawn(PD_BiteDecal,self,,HitLocation, rotator(HitNormal));

			// Wounds
			if ( (BiteWound != none) && (JointName != 'none') )
			{
				A = Spawn(BiteWound,self,,HitLocation, rotator(HitNormal));
				if (A.IsA('Wound'))
				{
					Wound(A).AttachJoint = JointName;
					Wound(A).setup();
				}
			}

			break;

		case 'Blunt':
			// Sounds
			if ( (decision > 0.66667) && (PI_BluntSound.Sound_3 != none) )
				PlaySound(PI_BluntSound.Sound_3,SLOT_Interact, RandRange(PI_BluntSound.MinVolume,PI_BluntSound.MaxVolume) ,,PI_BluntSound.Radius, RandRange(PI_BluntSound.MinPitch,PI_BluntSound.MaxPitch));
			else if ( (decision > 0.33333334) && (PI_BluntSound.Sound_2 != none) )
				PlaySound(PI_BluntSound.Sound_2,SLOT_Interact, RandRange(PI_BluntSound.MinVolume,PI_BluntSound.MaxVolume) ,,PI_BluntSound.Radius, RandRange(PI_BluntSound.MinPitch,PI_BluntSound.MaxPitch));
			else if (PI_BluntSound.Sound_1 != none)
				PlaySound(PI_BluntSound.Sound_1,SLOT_Interact, RandRange(PI_BluntSound.MinVolume,PI_BluntSound.MaxVolume) ,,PI_BluntSound.Radius, RandRange(PI_BluntSound.MinPitch,PI_BluntSound.MaxPitch));

			// Effect
			if (Health <= 0)
			{
				if (PE_BluntKilledEffect != none)
					spawn(PE_BluntKilledEffect,self,,HitLocation, rotator(HitNormal));
			} else {
				if (PE_BluntEffect != none)
					spawn(PE_BluntEffect,self,,HitLocation, rotator(HitNormal));
			}

			// Decal
			if ( PD_BluntDecal != none )
				Spawn(PD_BluntDecal,self,,HitLocation, rotator(HitNormal));

			// Wounds
			if ( (BluntWound != none) && (JointName != 'none') )
			{
				A = Spawn(BluntWound,self,,HitLocation, rotator(HitNormal));
				if (A.IsA('Wound'))
				{
					Wound(A).AttachJoint = JointName;
					Wound(A).setup();
				}
			}

			break;

		case 'RipSlice':
			// Sounds
			if ( (decision > 0.66667) && (PI_RipSliceSound.Sound_3 != none) )
				PlaySound(PI_RipSliceSound.Sound_3,SLOT_Interact, RandRange(PI_RipSliceSound.MinVolume,PI_RipSliceSound.MaxVolume) ,,PI_RipSliceSound.Radius, RandRange(PI_RipSliceSound.MinPitch,PI_RipSliceSound.MaxPitch));
			else if ( (decision > 0.33333334) && (PI_RipSliceSound.Sound_2 != none) )
				PlaySound(PI_RipSliceSound.Sound_2,SLOT_Interact, RandRange(PI_RipSliceSound.MinVolume,PI_RipSliceSound.MaxVolume) ,,PI_RipSliceSound.Radius, RandRange(PI_RipSliceSound.MinPitch,PI_RipSliceSound.MaxPitch));
			else if (PI_RipSliceSound.Sound_1 != none)
				PlaySound(PI_RipSliceSound.Sound_1,SLOT_Interact, RandRange(PI_RipSliceSound.MinVolume,PI_RipSliceSound.MaxVolume) ,,PI_RipSliceSound.Radius, RandRange(PI_RipSliceSound.MinPitch,PI_RipSliceSound.MaxPitch));

			// Effect
			if (Health <= 0)
			{
				if (PE_RipSliceKilledEffect != none)
					spawn(PE_RipSliceKilledEffect,self,,HitLocation, rotator(HitNormal));
			} else {
				if (PE_RipSliceEffect != none)
					spawn(PE_RipSliceEffect,self,,HitLocation, rotator(HitNormal));
			}

			// Decal
			if ( PD_RipSliceDecal != none )
				Spawn(PD_RipSliceDecal,self,,HitLocation, rotator(HitNormal));

			// Wounds
			if ( (RipSliceWound != none) && (JointName != 'none') )
			{
				A = Spawn(RipSliceWound,self,,HitLocation, rotator(HitNormal));
				if (A.IsA('Wound'))
				{
					Wound(A).AttachJoint = JointName;
					Wound(A).setup();
				}
			}

			break;

		case 'Large':
			// Sounds
			if ( (decision > 0.66667) && (PI_GenLargeSound.Sound_3 != none) )
				PlaySound(PI_GenLargeSound.Sound_3,SLOT_Interact, RandRange(PI_GenLargeSound.MinVolume,PI_GenLargeSound.MaxVolume) ,,PI_GenLargeSound.Radius, RandRange(PI_GenLargeSound.MinPitch,PI_GenLargeSound.MaxPitch));
			else if ( (decision > 0.33333334) && (PI_GenLargeSound.Sound_2 != none) )
				PlaySound(PI_GenLargeSound.Sound_2,SLOT_Interact, RandRange(PI_GenLargeSound.MinVolume,PI_GenLargeSound.MaxVolume) ,,PI_GenLargeSound.Radius, RandRange(PI_GenLargeSound.MinPitch,PI_GenLargeSound.MaxPitch));
			else if (PI_GenLargeSound.Sound_1 != none)
				PlaySound(PI_GenLargeSound.Sound_1,SLOT_Interact, RandRange(PI_GenLargeSound.MinVolume,PI_GenLargeSound.MaxVolume) ,,PI_GenLargeSound.Radius, RandRange(PI_GenLargeSound.MinPitch,PI_GenLargeSound.MaxPitch));

			// Effect
			if (Health <= 0)
			{
				if (PE_GenLargeKilledEffect != none)
					spawn(PE_GenLargeKilledEffect,self,,HitLocation, rotator(HitNormal));
			} else {
				if (PE_GenLargeEffect != none)
					spawn(PE_GenLargeEffect,self,,HitLocation, rotator(HitNormal));
			}

			// Decal
			if ( PD_GenLargeDecal != none )
				Spawn(PD_GenLargeDecal,self,,HitLocation, rotator(HitNormal));

			// Wounds
			if ( (GenLargeWound != none) && (JointName != 'none') )
			{
				A = Spawn(GenLargeWound,self,,HitLocation, rotator(HitNormal));
				if (A.IsA('Wound'))
				{
					Wound(A).AttachJoint = JointName;
					Wound(A).setup();
				}
			}

			break;

		case 'Medium':
			// Sounds
			if ( (decision > 0.66667) && (PI_GenMediumSound.Sound_3 != none) )
				PlaySound(PI_GenMediumSound.Sound_3,SLOT_Interact, RandRange(PI_GenMediumSound.MinVolume,PI_GenMediumSound.MaxVolume) ,,PI_GenMediumSound.Radius, RandRange(PI_GenMediumSound.MinPitch,PI_GenMediumSound.MaxPitch));
			else if ( (decision > 0.33333334) && (PI_GenMediumSound.Sound_2 != none) )
				PlaySound(PI_GenMediumSound.Sound_2,SLOT_Interact, RandRange(PI_GenMediumSound.MinVolume,PI_GenMediumSound.MaxVolume) ,,PI_GenMediumSound.Radius, RandRange(PI_GenMediumSound.MinPitch,PI_GenMediumSound.MaxPitch));
			else if (PI_GenMediumSound.Sound_1 != none)
				PlaySound(PI_GenMediumSound.Sound_1,SLOT_Interact, RandRange(PI_GenMediumSound.MinVolume,PI_GenMediumSound.MaxVolume) ,,PI_GenMediumSound.Radius, RandRange(PI_GenMediumSound.MinPitch,PI_GenMediumSound.MaxPitch));

			// Effect
			if (Health <= 0)
			{
				if (PE_GenMediumKilledEffect != none)
					spawn(PE_GenMediumKilledEffect,self,,HitLocation, rotator(HitNormal));
			} else {
				if (PE_GenMediumEffect != none)
					spawn(PE_GenMediumEffect,self,,HitLocation, rotator(HitNormal));
			}

			// Decal
			if ( PD_GenMediumDecal != none )
				Spawn(PD_GenMediumDecal,self,,HitLocation, rotator(HitNormal));

			// Wounds
			if ( (GenMediumWound != none) && (JointName != 'none') )
			{
				A = Spawn(GenMediumWound,self,,HitLocation, rotator(HitNormal));
				if (A.IsA('Wound'))
				{
					Wound(A).AttachJoint = JointName;
					Wound(A).setup();
				}
			}

			break;

		case 'Small':
			// Sounds
			if ( (decision > 0.66667) && (PI_GenSmallSound.Sound_3 != none) )
				PlaySound(PI_GenSmallSound.Sound_3,SLOT_Interact, RandRange(PI_GenSmallSound.MinVolume,PI_GenSmallSound.MaxVolume) ,,PI_GenSmallSound.Radius, RandRange(PI_GenSmallSound.MinPitch,PI_GenSmallSound.MaxPitch));
			else if ( (decision > 0.33333334) && (PI_GenSmallSound.Sound_2 != none) )
				PlaySound(PI_GenSmallSound.Sound_2,SLOT_Interact, RandRange(PI_GenSmallSound.MinVolume,PI_GenSmallSound.MaxVolume) ,,PI_GenSmallSound.Radius, RandRange(PI_GenSmallSound.MinPitch,PI_GenSmallSound.MaxPitch));
			else if (PI_GenSmallSound.Sound_1 != none)
				PlaySound(PI_GenSmallSound.Sound_1,SLOT_Interact, RandRange(PI_GenSmallSound.MinVolume,PI_GenSmallSound.MaxVolume) ,,PI_GenSmallSound.Radius, RandRange(PI_GenSmallSound.MinPitch,PI_GenSmallSound.MaxPitch));

			// Effect
			if (Health <= 0)
			{
				if (PE_GenSmallKilledEffect != none)
					spawn(PE_GenSmallKilledEffect,self,,HitLocation, rotator(HitNormal));
			} else {
				if (PE_GenSmallEffect != none)
					spawn(PE_GenSmallEffect,self,,HitLocation, rotator(HitNormal));
			}

			// Decal
			if ( PD_GenSmallDecal != none )
				Spawn(PD_GenSmallDecal,self,,HitLocation, rotator(HitNormal));

			// Wounds
			if ( (GenSmallWound != none) && (JointName != 'none') )
			{
				A = Spawn(GenSmallWound,self,,HitLocation, rotator(HitNormal));
				if (A.IsA('Wound'))
				{
					Wound(A).AttachJoint = JointName;
					Wound(A).setup();
				}
			}

			break;
	}
}

function OnFire(bool bOnFire)
{
	if ( FireMod != none )
	{
		if ( bOnFire && !Region.Zone.bWaterZone )
		{
			//log(".............Turning On Fire");
			FireMod.Activate();
		} else {
			//log(".............Turning Off Fire");
			FireMod.Deactivate();
		}
	}
}

function String GetHumanName()
{
	if ( PlayerReplicationInfo != None )
		return PlayerReplicationInfo.PlayerName;
	return NameArticle$MenuName;
}

function ClientPutDown(Weapon Current, Weapon Next)
{
	Current.ClientPutDown(Next);
}

function SetDisplayProperties(ERenderStyle NewStyle, texture NewTexture, bool bLighting, bool bEnviroMap )
{
	Style = NewStyle;
	texture = NewTexture;
	bUnlit = bLighting;
	bMeshEnviromap = bEnviromap;
	if ( Weapon != None )
		Weapon.SetDisplayProperties(Style, Texture, bUnlit, bMeshEnviromap);

	if ( !bUpdatingDisplay && (Inventory != None) )
	{
		bUpdatingDisplay = true;
		Inventory.SetOwnerDisplay();
	}
	bUpdatingDisplay = false;
}

function SetDefaultDisplayProperties()
{
	Style = Default.Style;
	texture = Default.Texture;
	bUnlit = Default.bUnlit;
	bMeshEnviromap = Default.bMeshEnviromap;
	if ( Weapon != None )
		Weapon.SetDisplayProperties(Weapon.Default.Style, Weapon.Default.Texture, Weapon.Default.bUnlit, Weapon.Default.bMeshEnviromap);

	if ( !bUpdatingDisplay && (Inventory != None) )
	{
		bUpdatingDisplay = true;
		Inventory.SetOwnerDisplay();
	}
	bUpdatingDisplay = false;
}

//
// Client gateway functions.
//
event ClientMessage( coerce string S, optional name Type, optional bool bBeep );
event TeamMessage( PlayerReplicationInfo PRI, coerce string S, name Type, optional bool bBeep );
event ReceiveLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject );

function BecomeViewTarget()
{
	bViewTarget = true;
}

event FellOutOfWorld()
{
	local DamageInfo DInfo;
	if ( Role < ROLE_Authority )
		return;
	Health = -1;
	SetPhysics(PHYS_None);
	Weapon = None;
	Died(None, 'Fell', Location, DInfo);
}

function PlayRecoil(float Rate) {
	if (self.IsA('PlayerPawn'))
	{
		PlayAnim('StillSmFr', Rate);//StillFRRP
	}
}

function SpecialFire();

function bool CheckFutureSight(float DeltaTime)
{
	return true;
}

function RestartPlayer();


function DamageInfo GetDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;
	
	if ( DamageType != 'none' )
		DInfo.DamageType = DamageType;
	
	DInfo.DamageMultiplier = 1.0;
	switch(DamageType)
	{
		case 'Fell':
			DInfo.Damage = -0.18 * (Velocity.Z + 1045);//(-0.15 * (Velocity.Z + 700 + JumpZ));
			break;
	
		case 'FellHard':
			DInfo.Damage = 1000;
			break;
		
		case 'Drown':
			DInfo.Damage = 10;
			break;
	};
	
	return DInfo;	
}

//
// Broadcast a message to all players, or all on the same team.
//
function TeamBroadcast( coerce string Msg)
{
	local Pawn P;
	local bool bGlobal;

	if ( Left(Msg, 1) ~= "@" )
	{
		Msg = Right(Msg, Len(Msg)-1);
		bGlobal = true;
	}

	if ( Left(Msg, 1) ~= "." )
		Msg = "."$VoicePitch$Msg;

	if ( bGlobal || !Level.Game.bTeamGame )
	{
		if ( Level.Game.AllowsBroadcast(self, Len(Msg)) )
			for( P=Level.PawnList; P!=None; P=P.nextPawn )
				if( P.bIsPlayer  || P.IsA('MessagingSpectator') )
					P.TeamMessage( PlayerReplicationInfo, Msg, 'Say' );
		return;
	}
		
	if ( Level.Game.AllowsBroadcast(self, Len(Msg)) )
		for( P=Level.PawnList; P!=None; P=P.nextPawn )
			if( P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team) )
			{
				if ( P.IsA('PlayerPawn') )
					P.TeamMessage( PlayerReplicationInfo, Msg, 'TeamSay' );
			}
}

//------------------------------------------------------------------------------
// Speech related

function SendGlobalMessage(PlayerReplicationInfo Recipient, name MessageType, byte MessageID, float Wait)
{
	SendVoiceMessage(PlayerReplicationInfo, Recipient, MessageType, MessageID, 'GLOBAL');
}


function SendTeamMessage(PlayerReplicationInfo Recipient, name MessageType, byte MessageID, float Wait)
{
	SendVoiceMessage(PlayerReplicationInfo, Recipient, MessageType, MessageID, 'TEAM');
}

function SendVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID, name broadcasttype)
{
	local Pawn P;
	local bool bNoSpeak;

	if ( Level.TimeSeconds - OldMessageTime < 2.5 )
		bNoSpeak = true;
	else
		OldMessageTime = Level.TimeSeconds;

	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
	{
		if ( P.IsA('PlayerPawn') )
		{  
			if ( !bNoSpeak )
			{
				if ( (broadcasttype == 'GLOBAL') || !Level.Game.bTeamGame )
					P.ClientVoiceMessage(Sender, Recipient, messagetype, messageID);
				else if ( Sender.Team == P.PlayerReplicationInfo.Team )
					P.ClientVoiceMessage(Sender, Recipient, messagetype, messageID);
			}
		}
		else if ( (P.PlayerReplicationInfo == Recipient) || ((messagetype == 'ORDER') && (Recipient == None)) )
			P.BotVoiceMessage(messagetype, messageID, self);
	}
}

function ClientVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID);
function BotVoiceMessage(name messagetype, byte MessageID, Pawn Sender);

//***************************************************************
function HandleHelpMessageFrom(Pawn Other);

function FearThisSpot(Actor ASpot);

function float GetRating()
{
	return 1000;
}

function AddVelocity( vector NewVelocity)
{
	if ( VSize(NewVelocity) > 0.5 )
	{
		if (Physics == PHYS_Walking)
			SetPhysics(PHYS_Falling);
		if ( (Velocity.Z > 380) && (NewVelocity.Z > 0) )
			NewVelocity.Z *= 0.5;
		Velocity += NewVelocity;
	}
}

function ClientSetLocation( vector NewLocation, rotator NewRotation )
{
	ClientSetRotation( NewRotation );
	SetLocation( NewLocation );
}

function ClientSetRotation( rotator NewRotation )
{
	ViewRotation = NewRotation;
	NewRotation.Pitch = 0;
	NewRotation.Roll  = 0;
	SetRotation( NewRotation );
}

function ClientDying(name DamageType, vector HitLocation, DamageInfo DInfo)
{
	PlayDying(DamageType, HitLocation, DInfo);
	GotoState('Dying');
}

function ClientReStart()
{
	//log("client restart");
	//Velocity = vect(0,0,0);
	//Acceleration = vect(0,0,0);
	BaseEyeHeight = Default.BaseEyeHeight;
	EyeHeight = BaseEyeHeight;
	PlayLocomotion( vect(0,0,0) );

	if ( Region.Zone.bWaterZone && (PlayerRestartState == 'PlayerWalking') )
	{
		if (HeadRegion.Zone.bWaterZone && (PainTime <= 0.0))
				PainTime = UnderWaterTime;
		setPhysics(PHYS_Swimming);
		GotoState('PlayerSwimming');
	}
	else
		GotoState(PlayerReStartState);
}

function ClientGameEnded()
{
	GotoState('GameEnded');
}

//=============================================================================
// Inventory related functions.

function float AdjustDesireFor(Inventory Inv)
{
	return 0;
}

// toss out the weapon currently held
function TossWeapon()
{
	local vector X,Y,Z;
	if ( Weapon == None )
		return;
	GetAxes(Rotation,X,Y,Z);
	Weapon.DropFrom(Location + 0.8 * CollisionRadius * X + - 0.5 * CollisionRadius * Y); 
}	

// The player/bot wants to select next item
exec function NextItem()
{
	local Inventory Inv;

	if (SelectedItem==None) {
		SelectedItem = Inventory.SelectNext();
		Return;
	}
	if (SelectedItem.Inventory!=None)
		SelectedItem = SelectedItem.Inventory.SelectNext(); 
	else
		SelectedItem = Inventory.SelectNext();

	if ( SelectedItem == None )
		SelectedItem = Inventory.SelectNext();
}

// FindInventoryType()
// returns the inventory item of the requested class
// if it exists in this pawn's inventory 

function Inventory FindInventoryType( class DesiredClass )
{
	local Inventory Inv;

	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )   
		if ( Inv.class == DesiredClass )
			return Inv;
	return None;
} 

// Add Item to this pawn's inventory. 
// Returns true if successfully added, false if not.
function bool AddInventory( inventory NewItem )
{
	// Skip if already in the inventory.
	local inventory Inv;
	local inventory InvFound;
	local inventory InvFoundExactParent, InvFoundExact;
	
	// The item should not have been destroyed if we get here.
	if (NewItem ==None )
		log("tried to add none inventory to "$self);

	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
		if( Inv == NewItem )
			return false;

	// Add to front of inventory chain.
	NewItem.SetOwner(Self);

	InvFound = None;
	InvFoundExactParent = None;

	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
	{		
		if (Inv.InventoryGroup < NewItem.InventoryGroup)
		{
			InvFound = Inv;								
		}
		// added class check since BookJournal and TimeIncantation have the same InventoryGroup
		if (Inv.Inventory != None && Inv.Inventory.InventoryGroup == NewItem.InventoryGroup && Inv.Inventory.class == NewItem.class)
		{
			InvFoundExactParent = Inv;
			InvFoundExact = Inv.Inventory;
			break;
		}
	}

	// fixes multiple inventory slots
	if (InvFoundExact != None && InvFoundExact.InventoryGroup > 0)
	{
		// add current ammo and copies to new pickup
		if (NewItem.IsA('Ammo'))
			Ammo(NewItem).AddAmmo(Ammo(InvFoundExact).AmmoAmount);
		else if (Pickup(NewItem).bCanHaveMultipleCopies)
			Pickup(NewItem).numCopies += Pickup(InvFoundExact).numCopies + 1;
		
		// replace references and remove current copy
		InvFoundExactParent.Inventory = NewItem;
		NewItem.Inventory = InvFoundExact.Inventory;
		InvFoundExact.Destroy();

		return true;
	}
		
	if ( InvFound != None )
	{
		NewItem.Inventory = InvFound.Inventory;
		InvFound.Inventory = NewItem;
	}
	else
	{
		NewItem.Inventory = Inventory;
		Inventory = NewItem;
	}
		
	
	return true;
}

// Remove Item from this pawn's inventory, if it exists.
// Returns true if it existed and was deleted, false if it did not exist.
function bool DeleteInventory( inventory Item )
{
	// If this item is in our inventory chain, unlink it.
	local actor Link;

	if ( Item == Weapon )
		Weapon = None;
	if ( Item == SelectedItem )
		SelectedItem = None;
	for( Link = Self; Link!=None; Link=Link.Inventory )
	{
		if( Link.Inventory == Item )
		{
			Link.Inventory = Item.Inventory;
			break;
		}
	}
	Item.SetOwner(None);
}

// Just changed to pendingWeapon
event ChangedWeapon()
{
	local Weapon OldWeapon;

	OldWeapon = Weapon;

	if (Weapon == PendingWeapon)
	{
		if ( Weapon == None )
			SwitchToBestWeapon();
		else if ( Weapon.IsInState('DownWeapon') ) 
			Weapon.BringUp();
		if ( Weapon != None )
			Weapon.SetDefaultDisplayProperties();
		Inventory.ChangedWeapon(); // tell inventory that weapon changed (in case any effect was being applied)
		PendingWeapon = None;
		return;
	}
	if ( PendingWeapon == None )
		PendingWeapon = Weapon;
	PlayWeaponSwitch(PendingWeapon);
	if ( (PendingWeapon != None) && (PendingWeapon.Mass > 20) && (carriedDecoration != None) )
		DropDecoration();
	if ( Weapon != None )
		Weapon.SetDefaultDisplayProperties();
		
	Weapon = PendingWeapon;
	Inventory.ChangedWeapon(); // tell inventory that weapon changed (in case any effect was being applied)
	if ( Weapon != None )
	{
		Weapon.RaiseUp(OldWeapon);
		if ( (Level.Game != None) && (Level.Game.Difficulty > 1) )
			MakeNoise(0.1 * Level.Game.Difficulty);		
	}
	PendingWeapon = None;
}

// If any spells pending then update now
function ChangedSpell()
{
    ChangedAttSpell();
    ChangedDefSpell();
}

function ChangedAttSpell()
{
    if ( PendingAttSpell != None && AttSpell == PendingAttSpell )
    {
        PendingAttSpell = None;
    }

	if ( PendingAttSpell != None )
    {
        PlaySpellSwitch(PendingAttSpell);

        AttSpell = PendingAttSpell;
		AttSpell.SetDefaultDisplayProperties();

        Inventory.ChangedSpell(); // tell inventory that spell changed (in case any effect was being applied)

	    PendingAttSpell = None;
    }
}

function ChangedDefSpell()
{
    if ( PendingDefSpell != None && DefSpell == PendingDefSpell )
    {
        PendingDefSpell = None;
    }

	if ( PendingDefSpell != None )
    {
        PlaySpellSwitch(PendingDefSpell);

        DefSpell = PendingDefSpell;
		DefSpell.SetDefaultDisplayProperties();

        Inventory.ChangedSpell(); // tell inventory that spell changed (in case any effect was being applied)

	    PendingDefSpell = None;
    }
}

exec function AddManaCapacity(int i)
{
	ManaCapacity = Clamp((ManaCapacity + i), 0, 200);
}

exec function AddMana(int i, optional bool bForceIncrease)
{
	Mana += i;
	if ( !bForceIncrease )
	{
		if ( Mana > ManaCapacity )
			Mana = ManaCapacity;
	}
}

exec function bool UseMana(int i)
{
	if ( i > Mana )
    {
		//ClientMessage("Out of Mana!");
		return false;
	}
    else
    {
		Mana -= i;
		//ClientMessage("Mana:"$Mana);
		return true;
	}
}

//==============
// Encroachment
event bool EncroachingOn( actor Other )
{
	if ( (Other.Brush != None) || (Brush(Other) != None) )
		return true;
		
	if ( (!bIsPlayer || bWarping) && (Pawn(Other) != None))
		return true;
		
	return false;
}

event EncroachedBy( actor Other )
{
	if ( Pawn(Other) != None )
		gibbedBy(Other);
		
}

function gibbedBy(actor Other)
{
	local pawn instigatedBy;
	local DamageInfo DInfo;

	if ( Role < ROLE_Authority )
		return;
	instigatedBy = pawn(Other);
	if (instigatedBy == None)
		instigatedBy = Other.instigator;
	health = -1000; //make sure gibs
	Died(instigatedBy, 'Gibbed', Location, DInfo);
}

event PlayerTimeOut()
{
	local DamageInfo DInfo;

	if (Health > 0)
		Died(None, 'Suicided', Location, DInfo);
}

//Base change - if new base is pawn or decoration, damage based on relative mass and old velocity
// Also, non-players will jump off pawns immediately
function JumpOffPawn()
{
	Velocity += 60 * VRand();
	Velocity.Z = 180;
	SetPhysics(PHYS_Falling);
}

function UnderLift(Mover M);

singular event BaseChange()
{
	local float decorMass;
	local DamageInfo DInfo;

	
	if ( (base == None) && (Physics == PHYS_None) )
		SetPhysics(PHYS_Falling);
	else if (Pawn(Base) != None)
	{
		DInfo = getDamageInfo();
		DInfo.Damage = (1-Velocity.Z/400)* Mass/Base.Mass;
		DInfo.DamageType = 'stomped';
		if ( Base.AcceptDamage(DInfo) )
			Base.TakeDamage( Self,Location,0.5 * Velocity , DInfo);
		JumpOffPawn();
	}
	else if ( (Decoration(Base) != None) && (Velocity.Z < -400) )
	{
		DInfo.Damage = -2* Mass/decorMass * Velocity.Z/400;
		DInfo.DamageType = 'stomped';
		decorMass = FMax(Decoration(Base).Mass, 1);
		if ( Base.AcceptDamage(DInfo) )
			Base.TakeDamage(Self, Location, 0.5 * Velocity, DInfo);
	}
}

event LongFall();

//=============================================================================
// Network related functions.


simulated event Destroyed()
{
	local Inventory Inv;
	local Pawn OtherPawn;

	if ( Shadow != None )
		Shadow.Destroy();
	if ( Role < ROLE_Authority )
		return;

	RemovePawn();

	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )   
		Inv.Destroy();
	Weapon = None;
	Inventory = None;
	if ( bIsPlayer && (Level.Game != None) )
		Level.Game.logout(self);
	if ( PlayerReplicationInfo != None )
		PlayerReplicationInfo.Destroy();
	for ( OtherPawn=Level.PawnList; OtherPawn!=None; OtherPawn=OtherPawn.nextPawn )
		OtherPawn.Killed(None, self, '');
	Super.Destroyed();
}

//=============================================================================
// functions.

//
// native client-side functions.
//
native simulated event ClientHearSound ( 
	actor Actor, 
	int Id, 
	sound S, 
	vector SoundLocation, 
	vector Parameters 
);

//
// Called immediately before gameplay begins.
//
event PreBeginPlay()
{
	AddPawn();
	Super.PreBeginPlay();
	if ( bDeleteMe )
		return;

	GroundFriction = 8.0;
	// Set instigator to self.
	Instigator = Self;
	DesiredRotation = Rotation;
	SightCounter = 0.2 * FRand();  //offset randomly 
	if ( Level.Game != None )
		Skill += Level.Game.Difficulty; 
	Skill = FClamp(Skill, 0, 3);
	PreSetMovement();
	
	// Set Damage Flags
	bAcceptMagicDamage = true;
	bAcceptDamage = true;

	VolumeMultiplier = 1.0;
	
	// Should we do this?	MJG: disable Health modification based on DrawScale
//	Health = Default.Health * DrawScale/Default.DrawScale;

	if (bIsPlayer)
	{
		if (PlayerReplicationInfoClass != None)
			PlayerReplicationInfo = Spawn(PlayerReplicationInfoClass, Self,,vect(0,0,0),rot(0,0,0));
		else
			PlayerReplicationInfo = Spawn(class'PlayerReplicationInfo', Self,,vect(0,0,0),rot(0,0,0));
		InitPlayerReplicationInfo();
	}

	if (!bIsPlayer) 
	{
		if ( BaseEyeHeight == 0 )
			BaseEyeHeight = 0.8 * CollisionHeight;
		EyeHeight = BaseEyeHeight;
		if (Fatness == 0) //vary monster fatness slightly if at default
			Fatness = 120 + Rand(8) + Rand(8);
	}

	if ( menuname == "" )
		menuname = GetItemName(string(class));

	if (SelectionMesh == "")
		SelectionMesh = string(Mesh);
}

event PostBeginPlay()
{
	Super.PostBeginPlay();
	SplashTime = 0;
	Climb = 0;
	ClimbDirection = 0;
}

// called after PostBeginPlay on net client
simulated event PostNetBeginPlay()
{
	if ( Role != ROLE_SimulatedProxy )
		return;

	if ( (PlayerReplicationInfo != None) 
		&& (PlayerReplicationInfo.Owner == None) )
		PlayerReplicationInfo.SetOwner(self);
}
	
/* PreSetMovement()
default for walking creature.  Re-implement in subclass
for swimming/flying capability
*/
function PreSetMovement()
{
	if (JumpZ > 0)
		bCanJump = true;
	bCanWalk = true;
	bCanSwim = false;
	bCanFly = false;
	MinHitWall = -0.6;
	if (Intelligence > BRAINS_Reptile)
		bCanOpenDoors = true;
	if (Intelligence == BRAINS_Human)
		bCanDoSpecial = true;
}

simulated function SetMesh()
{
	mesh = default.mesh;
}

//=============================================================================
// Replication
function InitPlayerReplicationInfo()
{
	if (PlayerReplicationInfo.PlayerName == "")
		PlayerReplicationInfo.PlayerName = class'GameInfo'.Default.DefaultPlayerName;
}
	

//=============================================================================

function bool MoveAnim( name Anim )
{
	return LoopAnim( Anim,, MOVE_Velocity,,0.15);
}

function PlayWaiting()
{
	if ( InWater() )
		LoopAnim('swim_idle');
	else if ( InCrouch() )
		LoopAnim( 'crouch_idle',,,, 0.2 );
	else if ( IsAlert() )
		LoopAnim('idle_alert') || LoopAnim('idle');
	else
		LoopAnim('idle') || LoopAnim('idle_alert');
}

// Trigger basic locomotion animations.
// dVector is local to the pawn and determines direction and type of animation.
function PlayLocomotion( vector dVector )
{
	local float		vLength;
	local float		dotX;

	vLength = VSize( dVector );

//	log( name $ ".PlayLocomotion(" $ GetStateName() $ "), @ " $ Level.TimeSeconds $ ", dVector is <" $ dVector $ ">, vLength is " $ vLength $ ", dotX is " $ dotX );
	if ( vLength < 0.01 )
	{
		PlayWaiting();
	}
	else
	{
		dotX = Normal(dVector).X;
		if ( Abs(dotX) < 0.5 )
		{
			// within 30 degrees of local Y axis -- strafe if possible.
			if ( dVector.Y < 0.0 )
			{
				// Left strafe.
				if ( InWater() )
				{
					if ( MoveAnim('swim_strafe_left') )
						return;
				}
				else if ( InCrouch() )
				{
					if ( MoveAnim('crouch_strafe_left') )
						return;
				}
				else
				{
					if ( MoveAnim('strafe_left') || MoveAnim('hunt_strafe_left') )
						return;
				}
			}
			else
			{
				// Right strafe.
				if ( InWater() )
				{
					if ( MoveAnim('swim_strafe_right') )
						return;
				}
				else if ( InCrouch() )
				{
					if ( MoveAnim('crouch_strafe_right') )
						return;
				}
				else
				{
					if ( MoveAnim('strafe_right') || MoveAnim('hunt_strafe_right') )
						return;
				}
			}
		}

		if ( dVector.X > 0.0 )
		{
			// Forward.
			if ( InWater() )
				MoveAnim('swim');
			else if ( InCrouch() )
				MoveAnim('crouch_walk');
			else if ( IsWalking( dVector ) )
			{
				if ( IsAlert() )
					MoveAnim('hunt') || MoveAnim('walk') || MoveAnim('run');
				else
					MoveAnim('walk') || MoveAnim('hunt') || MoveAnim('run');
			}
			else
				MoveAnim('run') || MoveAnim('hunt') || MoveAnim('walk');
		}
		else
		{
			// Reverse.
			if ( InWater() )
				MoveAnim('swim_backwards');
			else if ( InCrouch() )
				MoveAnim('crouch_walk_backwards');
			else if ( IsWalking( dVector ) )
			{
				if ( IsAlert() )
					MoveAnim('hunt_backwards') || MoveAnim('walk_backwards') || MoveAnim('run_backwards');
				else
					MoveAnim('walk_backwards') || MoveAnim('hunt_backwards') || MoveAnim('run_backwards');
			}
			else
				MoveAnim('run_backwards') || MoveAnim('hunt_backwards') || MoveAnim('walk_backwards');
		}
	}
}

// Conditions checked by animation functions.
// Overridable for players/NPCs.
function bool InCrouch()
{
	return false;
}

function bool InWater()
{
	return Region.Zone.bWaterZone;
}

function bool IsWalking( vector dir )
{
	return bIsWalking;
}

function bool IsAlert()
{
	return true;
}

function PlayWaitingAmbush()
{
	PlayWaiting();
}

// Play default idle animation with no tweening.
function SnapToIdle()
{
	LoopAnim( 'idle_alert',,,, 0.0 ) ||
	LoopAnim( 'idle',,,, 0.0 );
}


function PlayJump()			{	PlayAnim( 'jump_start',, MOVE_None );}
function PlayInAir()		{	LoopAnim( 'jump_cycle',, MOVE_None );}
function PlayLand()			{	PlayAnim( 'jump_end',, MOVE_None );}

// Note: all of these "TweenTo..." functions should be overridden in sub-classes

function TweenToStanding( float tweentime )
{
}

function TweenToFighter(float tweentime)
{
	TweenToStanding( tweentime );
}

function TweenToRunning(float tweentime)
{
	TweenToFighter(0.1);
}

function TweenToWalking(float tweentime)
{
	TweenToRunning(tweentime);
}

function TweenToPatrolStop(float tweentime)
{
	TweenToFighter(tweentime);
}

function TweenToWaiting(float tweentime)
{
	TweenToFighter(tweentime);
}

function PlayThreatening()
{
	TweenToFighter(0.1);
}

function PlayPatrolStop()
{
	PlayWaiting();
}

function PlayTurning()
{
	TweenToFighter(0.1);
}

function PlayBigDeath(name DamageType);
function PlayHeadDeath(name DamageType);
function PlayLeftDeath(name DamageType);
function PlayRightDeath(name DamageType);
function PlayGutDeath(name DamageType);

function PlayDying(name DamageType, vector HitLoc, DamageInfo DInfo)
{
	local vector X,Y,Z, HitVec, HitVec2D, HitLocation, HitNormal, End;
	local int HitJoint;
	local float DistToSurface, dotp;
	local bool bSpearDeath;

	switch (DamageType)
	{
		case 'spear':
			End = Location + Normal(DInfo.ImpactForce) * 256;
			Trace(HitLocation, HitNormal, HitJoint, End, Location, false);
			if ( HitLocation != vect(0,0,0) )
			{
				if ( HitNormal.z < 0.5 )
					bSpearDeath = true;
			}
			break;

		default:
			break;

	}

	if ( bSpearDeath )
	{
		//SetPhysics(PHYS_Falling);
		//Velocity = (Normal(DInfo.ImpactForce) + vect(0,0,0.35)) * 512;
		// GotoState('StuckToWall');
		//return;
	}
	
	if ( Velocity.Z > 250 )
	{
		PlayBigDeath(DamageType);
		return;
	}
	
	if ( DamageType == 'Decapitated' )
	{
		PlayHeadDeath(DamageType);
		return;
	}
			
	GetAxes(Rotation,X,Y,Z);
	X.Z = 0;
	HitVec = Normal(HitLoc - Location);
	HitVec2D= HitVec;
	HitVec2D.Z = 0;
	dotp = HitVec2D dot X;

	//first check for head hit
	if ( HitLoc.Z - Location.Z > 0.5 * CollisionHeight )
	{
		if (dotp > 0)
			PlayHeadDeath(DamageType);
		else
			PlayGutDeath(DamageType);
		return;
	}
	
	if (dotp > 0.71) //then hit in front
		PlayGutDeath(DamageType);
	else
	{
		dotp = HitVec dot Y;
		if (dotp > 0.0)
			PlayLeftDeath(DamageType);
		else
			PlayRightDeath(DamageType);
	}
}

function PlayGutHit(float tweentime)
{
	log("Error - play gut hit must be implemented in subclass of"@class);
}

function PlayHeadHit(float tweentime)
{
	PlayGutHit(tweentime);
}

function PlayLeftHit(float tweentime)
{
	PlayGutHit(tweentime);
}

function PlayRightHit(float tweentime)
{
	PlayGutHit(tweentime);
}

function FireWeapon();

/* TraceShot - used by instant hit weapons, and monsters 
*/
// TODO: perhaps HitJoint should be passed out via parameter list as is with HitLocation, HitNormal
function actor TraceShot(out vector HitLocation, out vector HitNormal, vector EndTrace, vector StartTrace)
{
	local actor Other;
	local int HitJoint;

	Other = Trace( HitLocation, HitNormal, HitJoint, EndTrace, StartTrace, True, True );
	if ( Other != None )
	{
		Other.LastJointHit = HitJoint;
	}

	return Other;
}

//NEEDMOH -PlayTakeHit needs to be reworked to properly identify head shots			
function PlayTakeHit(float tweentime, vector HitLoc, int damage)
{
	local vector X,Y,Z, HitVec, HitVec2D;
	local float dotp;
	
	GetAxes(Rotation,X,Y,Z);
	X.Z = 0;
	HitVec = Normal(HitLoc - Location);
	HitVec2D= HitVec;
	HitVec2D.Z = 0;
	dotp = HitVec2D dot X;

	//first check for head hit
	if ( HitLoc.Z - Location.Z > 0.5 * CollisionHeight )
	{
		if (dotp > 0)
			PlayHeadHit(tweentime);
		else
			PlayGutHit(tweentime);
		return;
	}
	
	if (dotp > 0.71) //then hit in front
		PlayGutHit( tweentime);
	else if (dotp < -0.71) // then hit in back
		PlayHeadHit(tweentime);
	else
	{
		dotp = HitVec dot Y;
		if (dotp > 0.0)
			PlayLeftHit(tweentime);
		else
			PlayRightHit(tweentime);
	}
}

function PlayVictoryDance()
{
	TweenToFighter(0.1);
}

function PlayOutOfWater()
{
	TweenToFalling();
}

function PlayDive();
function TweenToFalling();
function PlayDuck();
function PlayCrawling();

function PlayLanded(float impactVel)
{
	local float landVol;
	//default - do nothing (keep playing existing animation)
	landVol = impactVel/JumpZ;
	landVol = 0.005 * Mass * landVol * landVol;
	PlaySound(Land, SLOT_Interact, FMin(20, landVol));
	MakeNoise(2.0, 1560);
}

function PlayFiring();
function PlayWeaponSwitch(Weapon NewWeapon);
function TweenToSwimming(float tweentime);
function PlaySpellSwitch(Spell NewSpell);

//added by KSherr
function PlayRising();      //from crouch

function bool AddParticleToJoint( int i )
{
	return (i >= 0) && (i < NumJoints());
}

//-----------------------------------------------------------------------------
// Sound functions
function PlayTakeHitSound(int Damage, name damageType, int Mult)
{
	if ( Level.TimeSeconds - LastPainSound < 0.25 )
		return;

	if (HitSound1 == None)return;
	LastPainSound = Level.TimeSeconds;
	MakeNoise(1.0, 1280);
	if (FRand() < 0.5)
		PlaySound(HitSound1, SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0));
	else
		PlaySound(HitSound2, SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0));
}

function Gasp();

function DropDecoration()
{
	if (CarriedDecoration != None)
	{
		CarriedDecoration.bWasCarried = true;
		CarriedDecoration.SetBase(None);
		CarriedDecoration.SetPhysics(PHYS_Falling);
		CarriedDecoration.Velocity = Velocity + 10 * VRand();
		CarriedDecoration.Instigator = self;
		CarriedDecoration = None;
	}
}

function GrabDecoration()
{
	local vector lookDir, HitLocation, HitNormal, T1, T2, extent;
	local actor HitActor;
	local int HitJoint;

	if ( carriedDecoration == None )
	{
		//first trace to find it
		lookDir = vector(Rotation);
		lookDir.Z = 0;
		T1 = Location + BaseEyeHeight * vect(0,0,1) + lookDir * 0.8 * CollisionRadius;
		T2 = T1 + lookDir * 1.2 * CollisionRadius;
		HitActor = Trace(HitLocation, HitNormal, HitJoint, T2, T1, true);
		if ( HitActor == None )
		{
			T1 = T2 - (BaseEyeHeight + CollisionHeight - 2) * vect(0,0,1);
			HitActor = Trace(HitLocation, HitNormal, HitJoint, T1, T2, true);
		}
		else if ( HitActor == Level )
		{
			T2 = HitLocation - lookDir;
			T1 = T2 - (BaseEyeHeight + CollisionHeight - 2) * vect(0,0,1);
			HitActor = Trace(HitLocation, HitNormal, HitJoint, T1, T2, true);
		}	
		if ( (HitActor == None) || (HitActor == Level) )
		{
			extent.X = CollisionRadius;
			extent.Y = CollisionRadius;
			extent.Z = CollisionHeight;
			HitActor = Trace(HitLocation, HitNormal, HitJoint, Location + lookDir * 1.2 * CollisionRadius, Location, true, false, extent);
		}

		if ( Mover(HitActor) != None )
		{
			if ( Mover(HitActor).bUseTriggered )
				HitActor.Trigger( self, self );
		}		
		else if ( (Decoration(HitActor) != None)  && ((weapon == None) || (weapon.Mass < 20)) )
		{
			CarriedDecoration = Decoration(HitActor);
			if ( !CarriedDecoration.bPushable || (CarriedDecoration.Mass > 40) 
				|| (CarriedDecoration.StandingCount > 0) )
			{
				CarriedDecoration = None;
				return;
			}
			lookDir.Z = 0;				
			if ( CarriedDecoration.SetLocation(Location + (0.5 * CollisionRadius + CarriedDecoration.CollisionRadius) * lookDir) )
			{
				CarriedDecoration.SetPhysics(PHYS_None);
				CarriedDecoration.SetBase(self);
			}
			else
				CarriedDecoration = None;
		}
	}
}
	
function StopFiring();
function StopFiringAttSpell();
function StopFiringDefSpell();

function ShakeView( float shaketime, float RollMag, float vertmag);

function TakeFallingDamage()
{
	local DamageInfo DInfo;

	if (Velocity.Z < -1.4 * JumpZ)
	{
		MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
		if (Velocity.Z <= -750 - JumpZ)
		{
			if ( (Velocity.Z < -1650 - JumpZ) )
			{
				DInfo = GetDamageInfo('FellHard');
				if ( AcceptDamage(DInfo) )
				{
					log ("Taking FellHard Falling Damage ...", 'Misc');
					TakeDamage(None, Location, vect(0,0,0), DInfo);
				}
			}
			else if ( Role == ROLE_Authority )
			{
				DInfo = GetDamageInfo('Fell');
				if ( AcceptDamage(DInfo) )
				{
					log ("Taking Fell Falling Damage ...", 'Misc');
					TakeDamage(None, Location, vect(0,0,0), DInfo);
				}
			}
			ShakeView(0.175 - 0.00007 * Velocity.Z, -0.85 * Velocity.Z, -0.002 * Velocity.Z);
		}
	}
	else if ( Velocity.Z > 0.5 * Default.JumpZ )
		MakeNoise(0.35);				
}

/* AdjustAim()
ScriptedPawn version does adjustment for non-controlled pawns. 
PlayerPawn version does the adjustment for player aiming help.
Only adjusts aiming at pawns
allows more error in Z direction (full as defined by AutoAim - only half that difference for XY)
*/

function rotator AdjustAim(float projSpeed, vector projStart, int aimerror, bool bLeadTarget, bool bWarnTarget)
{
	return ViewRotation;
}

function rotator AdjustToss(float projSpeed, vector projStart, int aimerror, bool bLeadTarget, bool bWarnTarget)
{
	return ViewRotation;
}

function WarnTarget(Pawn shooter, float projSpeed, vector FireDir)
{
	// AI controlled creatures may duck
	// if not falling, and projectile time is long enough
	// often pick opposite to current direction (relative to shooter axis)
}

function SetMovementPhysics()
{
	//implemented in sub-class
}

function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
}

function PlayDeathHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
}

// adjust damage amount, based on JointName
function DamageInfo AdjustDamageByLocation (DamageInfo DInfo)
{
	switch( DInfo.JointName )
	{
		// Head shots
		// case 'Spine3':
		/* km - too easy to score head shots on howlers
		case 'R_Ear1':
		case 'R_Ear2':
		case 'R_Ear3':
		case 'L_Ear1':
		case 'L_Ear2':
		case 'L_Ear3':
		*/
		case 'Neck':
		case 'Head':
		case 'Hair1':
		case 'Hair2':
		case 'Hair3':
		case 'Hair4':
		case 'Hair5':
		case 'L_Ear':
		case 'R_Ear':
		case 'Jaw':
		case 'Mouth':
			DInfo.Damage *= 3.0;
			break;

		// Torso
		case 'Pelvis':
		case 'Spine1':
		case 'Spine2':
		case 'Spine3':
		case 'R_Shoulder':
		case 'L_Shoulder':
		case 'L_Hip1':
		case 'R_Hip1':
			DInfo.Damage *= 1.0;
			break;

		// Extremity
		case 'L_Index1':
		case 'R_Index1':
		case 'L_Thumb1':
		case 'R_Thumb1':
		case 'Tail':
		case 'Tail1':
		case 'Tail2':
		case 'Tail3':
		case 'Tail4':
		case 'Tail5':
		case 'R_Elbow':
		case 'R_Wrist':
		case 'L_Elbow':
		case 'L_Wrist':
		case 'R_Hand1':
		case 'L_Hand1':
		case 'L_Hip2':
		case 'R_Hip2':
		case 'R_Knee':
		case 'L_Knee':
		case 'L_Ball':
		case 'R_Ball':
		case 'L_Ankle':
		case 'R_Ankle':
		case 'L_Hand1':
		case 'R_Hand1':
			DInfo.Damage *= 0.5;
			break;
	

		default:
			DInfo.Damage *= 1.0;
			break;
	}

	return DInfo;
}

// ==================================================================================
// Take Damage
// ==================================================================================

function PlayDamageEffect(vector HitLocation, vector Momentum, DamageInfo DInfo);

function TakeDamage( Pawn InstigatedBy, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	local float actualDamage;
	local int intDamage, NJoints, i;
	local float JointDist, TempJointDist;
	local bool bAlreadyDead, bSplatterHUD;
	local Vector HitWallNormal;
	local Vector HitWallLocation;
	local Vector HitWallDirection;
	local int HitJoint;
	
	bSplatterHUD = true;
	if ( Role < ROLE_Authority )
	{
		log(self$" client damage type "$DInfo.DamageType$" by "$InstigatedBy);
		return;
	}

	if ( !Region.Zone.bNeutralZone && ((bAcceptDamage && !DInfo.bMagical) || (bAcceptMagicDamage && DInfo.bMagical)) )
	{
		//log(self@"take damage in state"@GetStateName());	
		bAlreadyDead = (Health <= 0);
	
		if (Physics == PHYS_None)
			SetMovementPhysics();
		if (Physics == PHYS_Walking)
			momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
		if ( InstigatedBy == self )
			momentum *= 0.6;
		momentum = momentum/Mass;
	
		actualDamage = Level.Game.ReduceDamage(DInfo.Damage, DInfo.DamageType, self, InstigatedBy);
		if ( bIsPlayer )
		{
			log("bIsPlayer and Damage = "$DInfo.Damage);
			if ( !bAcceptDamage && !bAcceptMagicDamage ) //God mode
				actualDamage = 0;
			else if (Inventory != None) //then check if carrying armor
				actualDamage = Inventory.ReduceDamage(actualDamage, DInfo.DamageType, HitLocation);
			else
				actualDamage = DInfo.Damage;
		}
		else if ( (InstigatedBy != None) &&
					(InstigatedBy.IsA(Class.Name) || self.IsA(InstigatedBy.Class.Name)) )
			ActualDamage = ActualDamage * FMin(1 - ReducedDamagePct, 0.35); 
		else if ( (!bAcceptDamage && !bAcceptMagicDamage) || 
			((ReducedDamageType != '') && (ReducedDamageType == DInfo.DamageType)) )
			actualDamage = actualDamage * (1 - ReducedDamagePct);
	
		// adjust the damage points, based on hit location
		if( DInfo.DamageLocation == vect(0,0,0) )
		{
			DInfo.DamageLocation = HitLocation;
		}
		actualDamage = (AdjustDamageByLocation( DInfo )).Damage;

		intDamage = int(actualDamage);
		if ( Level.Game.DamageMutator != None )
			Level.Game.DamageMutator.MutatorTakeDamage( intDamage, Self, InstigatedBy, HitLocation, Momentum, DInfo.DamageType );

		AddVelocity( momentum ); 

		if ( DInfo.JointName == 'none' )
		{
			JointDist = 32768.0;
			nJoints = NumJoints();
			for (i=0; i<NJoints; i++)
			{
				TempJointDist = VSize(HitLocation - JointPlace(JointName(i)).pos);
				if ( TempJointDist < JointDist)
				{
					JointDist = TempJointDist;
					DInfo.JointName = JointName(i);
				}
			}
		}

//		log( "DInfo.ImpactForce is " $ DInfo.ImpactForce );
		if ( VSize(DInfo.ImpactForce) > 0.5 )
		{
			if ( JointPlace(DInfo.JointName).pos.z > JointPlace(JointName(0)).pos.z )
				AddDynamic (DInfo.JointName, HitLocation, DInfo.ImpactForce,0.15);
		}

		if (bIsPlayer)
		{
			PlayDamageEffect(HitLocation, Momentum, DInfo);

			// Handle Actuator feedback
			if (actualDamage <= 10)
				PlayActuator (PlayerPawn(Self), EActEffects.ACTFX_LightShake, 0.3f);
			else if (actualDamage <= 20)
				PlayActuator (PlayerPawn(Self), EActEffects.ACTFX_NormalShake, 0.4f);
			else
				PlayActuator (PlayerPawn(Self), EActEffects.ACTFX_HardShake, 0.5f);
		}


		ActualDamage *= DInfo.DamageMultiplier;
		
		log("Reducing health by = "$actualDamage);
		Health -= actualDamage;
		Mana = max( Mana - DInfo.ManaCost, 0 );

		if ( ( InstigatedBy != none ) && InstigatedBy.IsA('PlayerPawn') )
			PlayerPawn(InstigatedBy).MyHud.LastDamageInflicted = actualDamage;
		if (CarriedDecoration != None)
			DropDecoration();
		if ( HitLocation == vect(0,0,0) )
			HitLocation = Location;
		if (Health > 0)
		{
			if ( (instigatedBy != None) && (instigatedBy != Self) )
				damageAttitudeTo(instigatedBy);
			PlayHit(actualDamage, hitLocation, DInfo.damageType, Momentum);
		} 
		else if ( !bAlreadyDead ) 
		{

			if ( bIsPlayer && DInfo.DamageType == 'Drown' )
			{
				PlaySound(Sound(DynamicLoadObject("Voiceover.Patrick.Pa_Drowning",class'Sound')),,2, [Flags]480);	
			}

			// we are just dying now
			if ( Gibbed(DInfo.DamageType) && ( actualDamage > GibDamageThresh ) )	// only gib if gibable
			{
				// Gibbed

				// the amount of damage we are recieving must be greater than the gib damage threshold to gib

				if (DInfo.ImpactForce == vect(0,0,0))
					SpawnGibbedCarcass(HitLocation-Location);
				else
					SpawnGibbedCarcass(DInfo.ImpactForce);

				if ( bIsPlayer )
				{
					HidePlayer();
					GotoState('Dying');
				}
				else
				{
					gibbedBy( InstigatedBy );
					Destroy();
				}
			} else {
				// Not Gibbed

				// Special Kill?
				if ( Level.NetMode==NM_Standalone &&
					 ( InstigatedBy != none ) &&
					 InstigatedBy.CanPerformSK(self) &&
					 ( PlayerPawn(self) != none ) )		// MJG: only PlayerPawns can do this
				{
					PlayerPawn(self).Killer = InstigatedBy;
					InstigatedBy.SetTargetPawn(self);
					InstigatedBy.PerformSK(self);
					GotoState('SpecialKill');
				} else {
					//log(self$" died");
					NextState = '';
					PlayDeathHit(actualDamage, hitLocation, DInfo.damageType, Momentum);
					if ( actualDamage > mass )
						Health = -1 * actualDamage;
					if ( (instigatedBy != None) && (instigatedBy != Self) )
						damageAttitudeTo(instigatedBy);
					Died(instigatedBy, DInfo.damageType, HitLocation, DInfo);
				}
			}
		} else {
			// we are already dead
			//Warn(self$" took regular damage while already dead");
			if ( Gibbed( DInfo.DamageType ) )	// only gib if gibable
			{
				// the amount of damage we are recieving must be greater than the gib damage threshold to gib
				if ( actualDamage > GibDamageThresh )
				{
					if (DInfo.ImpactForce == vect(0,0,0))
						SpawnGibbedCarcass(HitLocation-Location);
					else
						SpawnGibbedCarcass(DInfo.ImpactForce);

					if ( bIsPlayer )
					{
						HidePlayer();
						GotoState('Dying');
					}
					else
					{
						gibbedBy( InstigatedBy );
						Destroy();
					}
				}
			}
		}
		MakeNoise(1.0);		
	
		if ( bIsPlayer )
		{
			switch ( DInfo.DamageType )
			{
				// Some damage types should not generate screen blood				

				case 'Drown':
				case 'Fire':
					bSplatterHUD = false;
					break;
				default:
					bSplatterHUD = true;
					break;
			}

			if ( bSplatterHUD )
				SplatterHUD(ActualDamage, HitLocation);
		}
	}
}

// ===================================================
// Special Kill Support

// Can you perform a special Kill on this Pawn?
function bool CanPerformSK(Pawn P);

// Set My Special Kill Pawn
function SetTargetPawn(Pawn P);

// Perform a special kill on this Pawn
function PerformSK(Pawn P)
{
	GotoState('SpecialKill');
}

function pawn ViewSKFrom()
{
	return self;
}

// if the pawn is enroute to his start location for the special kill, this should return false
function bool CanStartSK();

//----------------------------------------------------------------------------

simulated function SplatterHUD(int ActualDamage, Vector HitLocation);

//----------------------------------------------------------------------------

// head-b-gone
function bool Decapitate(optional vector Dir)
{
	local name NeckName;
	local int Parent;
	local Actor B;
	
	NeckName = JointName(JointParent(JointIndex('Head')));

	B = DetachLimb('Head', Class 'BodyPart');

	if (Dir != vect(0,0,0))
		B.Velocity = Dir;
	else
		B.Velocity = vect(0,0,256);

	if (PersistentBlood != none)
	{
		PBlood = spawn(PersistentBlood,,,JointPlace(NeckName).pos);
		PBlood.SetBase(self, NeckName, 'root');
	}
	
	return true;
}

function Died(pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo)
{
	local pawn OtherPawn;
	local actor A;

	// mutator hook to prevent deaths
	// WARNING - don't prevent bot suicides - they suicide when really needed
	if ( Level.Game.BaseMutator.PreventDeath(self, Killer, damageType, HitLocation) )
	{
		Health = max(Health, 1); //mutator should set this higher
		return;
	}
	if ( bDeleteMe )
		return; //already destroyed
	Health = Min(0, Health);
	for ( OtherPawn=Level.PawnList; OtherPawn!=None; OtherPawn=OtherPawn.nextPawn )
		OtherPawn.Killed(Killer, self, damageType);
	if ( CarriedDecoration != None )
		DropDecoration();
	level.game.Killed(Killer, self, damageType);
	//log(class$" dying");
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
		{
			if ( A.IsA('Trigger') )
			{
				if ( Trigger(A).bPassThru )
					Trigger(A).PassThru(self);
			}
			A.Trigger( Self, Killer );
		}

	if ( !self.IsA('PlayerPawn') )
		Level.Game.DiscardInventory(self);
	Velocity.Z *= 1.3;
	/* MJG - all concussives were gibbing.  Gibbing is handled in TakeDamage() -- is this needed here?
	if ( Gibbed(damageType) )
	{
		SpawnGibbedCarcass(HitLocation-Location);
		if ( bIsPlayer )
			HidePlayer();
		else
			Destroy();
	}
	*/
	PlayDying(DamageType, HitLocation, DInfo);
	
	if ( Level.Game.bGameEnded )
		return;
	if ( RemoteRole == ROLE_AutonomousProxy )
		ClientDying(DamageType, HitLocation, DInfo);
	
//	if  (!(DInfo.DamageType == 'spear') || ( PlayerPawn(self) != none ) )
		GotoState('Dying');
//	else
		//GotoState('StuckToWall');
}

function bool Gibbed(name damageType)
{
}

function Carcass SpawnCarcass()
{
	log(self$" should never call base spawncarcass");
	return None;
}

function SpawnGibbedCarcass(vector Dir);
	
function HidePlayer()
{
	SetCollision(false, false, false);
	TweenToFighter(0.01);
	bHidden = true;
}

event HearNoise( float Loudness, Actor NoiseMaker);
event SeePlayer( actor Seen );
event SeeHatedPawn( pawn aPawn );
event UpdateEyeHeight( float DeltaTime );
event UpdateTactics(float DeltaTime); // for advanced tactics
event EnemyNotVisible();

function Killed(pawn Killer, pawn Other, name damageType)
{
	if ( Enemy == Other )
		Enemy = None;
}

//Typically implemented in subclass
function string KillMessage( name damageType, pawn Other )
{
	local string message;

	message = Level.Game.CreatureKillMessage(damageType, Other);
	return (Other.PlayerReplicationInfo.PlayerName$message$namearticle$menuname);
}

function damageAttitudeTo(pawn Other);

function Falling()
{
	//SetPhysics(PHYS_Falling); //Note - physics changes type to PHYS_Falling by default
	//log(class$" Falling");
	PlayInAir();
}

//LEGEND:begin
// Pawn interface called while PHYS_Walking and PHYS_Swimming to update the pawn with 
// the latest information about the walk surface
event WalkTexture( texture Texture, vector StepLocation, vector StepNormal );
//LEGEND:end

event Landed(vector HitNormal)
{
	SetMovementPhysics();
	if ( !IsAnimating() )
		PlayLanded(Velocity.Z);

    // jumping now makes more noise
	if (Velocity.Z < -0.5 * JumpZ)
		MakeNoise(-1.0 * Velocity.Z/(FMax(JumpZ, 150.0)));
	bJustLanded = true;

	// Activate actuator feeback
	PlayActuator (PlayerPawn (Self), EActEffects.ACTFX_Quick, 0.15f);
}

event FootZoneChange(ZoneInfo newFootZone)
{
	local actor HitActor;
	local vector HitNormal, HitLocation;
	local float splashSize;
	local actor splash;
	local int HitJoint;
	
	if ( Level.NetMode == NM_Client )
		return;
	if ( Level.TimeSeconds - SplashTime > 0.25 ) 
	{
		SplashTime = Level.TimeSeconds;
		if (Physics == PHYS_Falling)
			MakeNoise(2.0, 1560);
		else
			MakeNoise(0.5, 640);
		if ( FootRegion.Zone.bWaterZone )
		{
			if ( !newFootZone.bWaterZone && (Role==ROLE_Authority) )
			{
				MakeNoise(2.0, 2560);
				if ( FootRegion.Zone.ExitSound != None )
					PlaySound(FootRegion.Zone.ExitSound, SLOT_Interact, 1); 
				if ( FootRegion.Zone.ExitActor != None )
					Spawn(FootRegion.Zone.ExitActor,,,Location - CollisionHeight * vect(0,0,1));
			}
		}
		else if ( newFootZone.bWaterZone && (Role==ROLE_Authority) )
		{
			MakeNoise(1.0, 1280);
			splashSize = FClamp(0.000025 * Mass * (300 - 0.5 * FMax(-500, Velocity.Z)), 1.0, 4.0 );
			if ( newFootZone.EntrySound != None )
			{
				HitActor = Trace(HitLocation, HitNormal, HitJoint,
						Location - (CollisionHeight + 40) * vect(0,0,0.8), Location - CollisionHeight * vect(0,0,0.8), false);
				if ( HitActor == None )
					PlaySound(newFootZone.EntrySound, SLOT_Misc, 2 * splashSize);
				else 
					PlaySound(WaterStep, SLOT_Misc, 1.5 + 0.5 * splashSize);
				//if ( WetMod != none )
				//	WetMod.Activate();
			}
			if( newFootZone.EntryActor != None )
			{
				splash = Spawn(newFootZone.EntryActor,,,Location - CollisionHeight * vect(0,0,1));
				if ( splash != None )
					splash.DrawScale = splashSize;
			}
			//log("Feet entering water");
		}
	}
	
	if (FootRegion.Zone.bPainZone)
	{
		if ( !newFootZone.bPainZone && !HeadRegion.Zone.bWaterZone )
			PainTime = -1.0;
	}
	else if (newFootZone.bPainZone)
		PainTime = 0.01;
}
	
event HeadZoneChange(ZoneInfo newHeadZone)
{
	if ( Level.NetMode == NM_Client )
		return;
	if (HeadRegion.Zone.bWaterZone)
	{
		if (!newHeadZone.bWaterZone)
		{
			if ( bIsPlayer && (PainTime > 0) && (PainTime < 8) )
				Gasp();
			if ( Inventory != None )
				Inventory.ReduceDamage(0, 'Breathe', Location); //inform inventory of zone change
			bDrowning = false;
			if ( !FootRegion.Zone.bPainZone )
				PainTime = -1.0;
		}
	}
	else
	{
		if (newHeadZone.bWaterZone)
		{
			if ( !FootRegion.Zone.bPainZone )
				PainTime = UnderWaterTime;
			if ( Inventory != None )
				Inventory.ReduceDamage(0, 'Drowned', Location); //inform inventory of zone change
			//log("Can't breathe");
		}
	}
}

event SpeechTimer();

//Pain timer just expired.
//Check what zone I'm in (and which parts are)
//based on that cause damage, and reset PainTime
	
event PainTimer()
{
	local float depth;
	local DamageInfo DInfo;

	// DInfo.damage = int(float(FootRegion.Zone.DamagePerSec) * depth);
	//log("Pain Timer");
	if ( (Health < 0) || (Level.NetMode == NM_Client) )
		return;
		
	if ( FootRegion.Zone.bPainZone )
	{
		DInfo.DamageType = FootRegion.Zone.DamageType;
		DInfo.DamageString = FootRegion.Zone.DamageString;
		DInfo.bMagical = FootRegion.Zone.bMagicalDamage;
		DInfo.DamageMultiplier = 1.0;
		DInfo.damage = int(float(FootRegion.Zone.DamagePerSec));

		depth = 0.4;
		if (Region.Zone.bPainZone)
			depth += 0.4;
		if (HeadRegion.Zone.bPainZone)
			depth += 0.2;

		if (FootRegion.Zone.DamagePerSec > 0)
		{
			if ( IsA('PlayerPawn') )
				Level.Game.SpecialDamageString = FootRegion.Zone.DamageString;
			if ( AcceptDamage(DInfo) )
				TakeDamage(None, Location, vect(0,0,0), DInfo);
			//TakeDamage(int(float(FootRegion.Zone.DamagePerSec) * depth), None, Location, vect(0,0,0), FootRegion.Zone.DamageType); 
		}
		else if ( Health < Default.Health )
			Health = Min(Default.Health, Health - depth * FootRegion.Zone.DamagePerSec);

		if (Health > 0)
			PainTime = 1.0;

	} else if ( HeadRegion.Zone.bWaterZone ) {

		TakeDamage(None, Location + CollisionHeight * vect(0,0,0.5), vect(0,0,0), getDamageInfo('Drown')); 
		if ( Health > 0 )
			PainTime = 2.0;
	}
}		

function bool CheckWaterJump(out vector WallNormal)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, checkpoint, start, checkNorm, Extent;
	local int HitJoint;

	if (CarriedDecoration != None)
		return false;
	checkpoint = vector(Rotation);
	checkpoint.Z = 0.0;
	checkNorm = Normal(checkpoint);
	checkPoint = Location + CollisionRadius * checkNorm;
	Extent = CollisionRadius * vect(1,1,0);
	Extent.Z = CollisionHeight;
	HitActor = Trace(HitLocation, HitNormal, HitJoint, checkpoint, Location, true, false, Extent);
	if ( (HitActor != None) && (Pawn(HitActor) == None) )
	{
		WallNormal = -1 * HitNormal;
		start = Location;
		start.Z += 1.1 * MaxStepHeight;
		checkPoint = start + 2 * CollisionRadius * checkNorm;
		HitActor = Trace(HitLocation, HitNormal, HitJoint, checkpoint, start, true);
		if (HitActor == None)
			return true;
	}

	return false;
}

exec function bool SwitchToBestWeapon()
{
	local float rating;
	local int usealt;

	if ( Inventory == None )
		return false;

	PendingWeapon = Inventory.RecommendWeapon(rating, usealt);
	if ( PendingWeapon == Weapon )
		PendingWeapon = None;
	if ( PendingWeapon == None )
		return false;

	if ( Weapon == None )
		ChangedWeapon();
	if ( Weapon != PendingWeapon )
		Weapon.PutDown();

	return (usealt > 0);
}

State Dying
{
ignores SeePlayer, EnemyNotVisible, HearNoise, KilledBy, Trigger, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, Falling, WarnTarget, Died, LongFall, PainTimer;

	function TakeDamage( Pawn instigatedBy, Vector hitlocation, Vector momentum, DamageInfo DInfo)
	{
		if ( bDeleteMe )
			return;
		Health = Health - DInfo.Damage;
		Momentum = Momentum/Mass;
		AddVelocity( momentum ); 
		if ( !bHidden && Gibbed( DInfo.DamageType ) )
		{
			bHidden = true;
			if (DInfo.ImpactForce == vect(0,0,0))
				SpawnGibbedCarcass(HitLocation-Location);
			else
				SpawnGibbedCarcass(DInfo.ImpactForce);

			if ( bIsPlayer )
				HidePlayer();
			else
				Destroy();
		}
	}

	function Timer()
	{
		if ( !bHidden )
		{
			bHidden = true;
			SpawnCarcass();
			if ( bIsPlayer )
				HidePlayer();
			else
				Destroy();
		}
	}

	event Landed(vector HitNormal)
	{
		SetPhysics(PHYS_None);
	}

	function BeginState()
	{
		SetTimer(0.3, false);
	}
}

state GameEnded
{
ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, Falling, TakeDamage, WarnTarget, Died;

	function BeginState()
	{
		SetPhysics(PHYS_None);
		HidePlayer();
	}
}

exec function PlayerStateTrigger(optional float rSpeed, optional float aRate)
{

}


// Trace from my eye in the direction of my view and see what I hit.
function Actor EyeTrace(out vector HitLocation, out vector HitNormal, out int HitJoint, optional float Range, optional bool bTraceActors)
{
	local vector Start, End, eyeOffset;
	local Actor A;

	//log("EyeTrace Called ... "$Level.TimeSeconds, 'Misc');
	//LogStack('Misc');
	
	if (Range == 0)
		Range = 65536;

	eyeOffset.z = eyeHeight;
	
	Start = Location + eyeOffset;
	End = start + (Vector(ViewRotation) * Range);
	
	A = Trace(HitLocation, HitNormal, HitJoint, End, Start, bTraceActors, true);
	
	if (HitLocation == vect(0,0,0))
	{
		HitLocation = start + (Vector(ViewRotation) * 16384 );
		HitNormal = Normal(Start-End);
	}

	return A;

}

// returns a name of the texture surface type the pawn is standing on.
function name StandingOn()
{
	local vector End;
	local Texture HitTexture;
	local int Flags;
	
	End = Location + (vect(0,0,-1) * CollisionHeight);
	
	HitTexture = TraceTexture( location + vect(0,0,-1)*CollisionHeight*2, location, flags );
	// HitTexture = TraceTexture(Location, End, Flags);

	if (HitTexture != none)
	{
		GroundFriction = HitTexture.Friction * 8.0;
		switch(HitTexture.ImpactID)
		{
			case TID_Glass:
				return 'Glass';
				break;

			case TID_Water:
				return 'Water';
				break;

			case TID_Leaves:
				return 'Leaves';
				break;

			case TID_Snow:
				return 'Snow';
				break;

			case TID_Grass:
				return 'Grass';
				break;

			case TID_Organic:
				return 'Organic';
				break;

			case TID_Carpet:
				return 'Carpet';
				break;

			case TID_Earth:
				return 'Earth';
				break;

			case TID_Sand:
				return 'Sand';
				break;

			case TID_Metal:
				return 'Metal';
				break;

			case TID_WoodHollow:
				return 'WoodHollow';
				break;

			case TID_WoodSolid:
				return 'WoodSolid';
				break;

			case TID_Stone:
				return 'Stone';
				break;

			default:
				return 'undefined';
				break;
		}
	} else {
		return 'none';
	}
}

defaultproperties
{
     AvgPhysicsTime=0.1
     MaxDesiredSpeed=1
     GroundSpeed=320
     WaterSpeed=200
     AccelRate=500
     JumpZ=325
     MaxStepHeight=25
     AirControl=0.05
     LookJoint=''
     Visibility=128
     SightRadius=2500
     HearingThreshold=1
     Mana=100
     ManaCapacity=100
     ManaRefreshAmt=1
     ManaRefreshTime=0.2
     ClimbRate=3
     OrthoZoom=40000
     FovAngle=90
     Health=100
     AttitudeToPlayer=ATTITUDE_Hate
     Intelligence=BRAINS_Mammal
     noise1time=-10
     noise2time=-10
     PI_StabSound=(MaxVolume=1,MinVolume=1,Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_BiteSound=(MaxVolume=1,MinVolume=1,Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_BluntSound=(MaxVolume=1,MinVolume=1,Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_BulletSound=(MaxVolume=1,MinVolume=1,Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_RipSliceSound=(MaxVolume=1,MinVolume=1,Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_GenLargeSound=(MaxVolume=1,MinVolume=1,Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_GenMediumSound=(MaxVolume=1,MinVolume=1,Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_GenSmallSound=(MaxVolume=1,MinVolume=1,Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     FootSoundRadius=800
     DamageScaling=1
     GibDamageThresh=50
     HeartRate=90
     BloodPressure=200
     PlayerReStartState=PlayerWalking
     NameArticle=" "
     PlayerReplicationInfoClass=Class'Engine.PlayerReplicationInfo'
     bCanTeleport=True
     bStasis=True
     bIsPawn=True
     RemoteRole=ROLE_SimulatedProxy
     AnimSequence=Fighter
     bSavable=True
     RotationRate=(Pitch=4096,Yaw=50000,Roll=3072)
     bDirectional=True
     Texture=Texture'Engine.S_Pawn'
     ShadowImportance=1
     bIsKillGoal=True
     SoundRadius=16
     SoundVolume=240
     TransientSoundVolume=2
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
     bRotateToDesired=True
     NetPriority=2
}
