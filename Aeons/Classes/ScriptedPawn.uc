//=============================================================================
// ScriptedPawn.
//=============================================================================
class ScriptedPawn expands Pawn 
	abstract;

#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX
#exec OBJ LOAD FILE=..\Sounds\Impacts.uax PACKAGE=Impacts


//****************************************************************************
// Structure defs.
//****************************************************************************
// Held Prop Info Structure.
struct PropInfo
{
	var() class<HeldProp> Prop;
	var() name PawnAttachJointName;			// Attach Joint on me.
	var() name AttachJointName;		// Attach Joint on the Prop I'm holding.
};

// State stack element.
struct StateInfo
{
	var name	StateName;
	var name	StateLabel;
};

// Melee attack information.
struct MeleeAttackInfo
{
	var() float			Damage;
	var() float			EffectStrength;
	var() name			Method;
};

// Team messages.
enum ETeamMessage
{
	TM_TakeDamage,
	TM_EnemyAcquired,
	TM_Advance,
	TM_Retreat,
	TM_Killed,
	TM_KilledEnemy,
	TM_Alert
};

// Script stack element.
struct ScriptInfo
{
	var NarratorScript	ScriptObject;
	var int				ScriptAction;
};


//****************************************************************************
// Member vars.
//****************************************************************************
// Held Props.
var() PropInfo				MyPropInfo[4];		//
var HeldProp				MyProp[4];			//

// AI.
var bool			bEnemyIsPlayer;		//
var pawn			HatedEnemy;			// Hated enemy (will attack regardless of attitude).
var actor			PathObject;			// Intermediate pathing point.
var actor					LastPathObject;		// The object formerly known as PathObject.
var actor			TargetActor;		// Primary target actor, context-dependent based on AI state.
var vector			TargetPoint;		// Primary target coordinates for movement.
var vector					FlankPoint;			// Intermediate point we're going to on our way to the target.
var float					FlankMagnitude;		// Indicates how much this pawn should flank.
var bool					FlankPointReset;	// Indicates whether to reset our flank magnitude.
var bool					FlankDirection;		// True == right, False == left.
var actor			SensedActor;		// Actor that has been sensed.
var vector			SensedPoint;		// Location that sense came from.
var name					SensedSense;		// TEMP: sensor that detected stimulus.
var(AI) float				ReactionBase;		// Base reaction delay
var(AI) float				ReactionRand;		// Amount of randomization in reaction delay;
var(AI) name				AlarmTag;			// Tag of actor to go to when alarmed.
var float					InitPeripheralVision;	// Initial PeripheralVision.
var float					InitHearingThreshold;	// Initial HearingThreshold.
var float					MoveSpeed;			// How fast we're moving.
var() bool					bSpecialNavigation;	// Enable/disable special navigation.
var NavigationPoint			SpecialNavPoint;	// Special navigation point.
var(AI) float				HazardKnowledge;	// Level of intelligence regarding hazards.
var float					NearDamageDelay;	// Near damage application suspension.
var() float					CheckReloadDelay;	// Reload check governor.
var float					SpeakReloadDelay;	//
var() float					DamageSoundDelay;	// Taking damage SFX governor.
var(AI) int					DefCon;				// Activity mode / alertness state.
												// 0 - start
												// 1 - see player, hear player
												// 2 - alerted, taunted enemy
												// 3 - triggered
												// 5 - damage
var(AI) bool				bNoEncounterTaunt;	// Set to disable encounter taunting.
var(AI) bool				bTryStepForward;	// Set to have creature attempt forward step when can't reach enemy.
var(AI) bool				bTrySeekAlternate;	// Set to have creature attempt seeking alternate point when can't reach enemy.
var float					OutDamageScalar;	// Scale damage that I'm applying by this factor.
var float					OutEffectScalar;	// Scale effect that I'm applying by this factor.
var float			InitHealth;			// Initial health, adjusted for difficulty level.

// AI state control.
var name					LastState;			// Last state.
var name					LastLabel;			// Last state label.
var name					FallFromState;		// State when Falling occurs.
var name					WarnFromState;		// State when WarnTarget or WarnAvoidActor occurs.

// AI distances.
var(AIDistance) float		FollowDistance;		// When following, try to keep within this distance.
var(AIDistance) float		GreetDistance;		// Distance to keep when greeting another pawn.
var(AIDistance) float		SafeDistance;		// Distance to keep when retreating.
var(AIDistance) float		RunDistance;		// Distance beyond which creature will run to get to.
var(AIDistance) float		LongRangeDistance;	// Maximum reachable distance (usually via long-range attack).
var(AIDistance) float		MindshatterWander;	// Wander radius while under mindshatter effect.
var(AIDistance) float		JumpDownDistance;	// Maximum distance this creature will consider jumping down from.

// Boss.
var() bool					bIsBoss;			// Actor is a level boss.

// Combat, general behavior.
var(AICombat) float			Aggressiveness;		// Likelihood [0,1] of attacking.
var bool			bHasNearAttack;		// Can melee attack.
var(AICombat) bool	bHasFarAttack;		// Can attack from distance.
var(AICombat) bool			bUseCoverPoints;	// Will try to advance using cover points.
var(AICombat) MeleeAttackInfo	MeleeInfo[6];	// Melee attack damage information.
var name					NearAttackVerb;		// Past tense near damage verb.
var(AICombat) float			RetreatThreshold;	// Percentage of max. health below which creature will retreat.
var(AICombat) name			RetreatPointTag;	// Tag of AeonsCoverPoint to try to retreat to.
var AeonsPatrolPoint		PatrolPoint;		// Current patrol point.
var AeonsCoverPoint			RetreatPoint;		// Current retreat point.
var AeonsAlarmPoint			AlarmPoint;			// Current alarm point.
var AeonsScriptPoint		ScriptPoint;		// Current script point.
var NavigationPoint			AvoidPoint;			// Current avoidance point.
var pawn					OldEnemy;			// Enemy before acquiring NPC enemy.
var(AICombat) class<SPWeapon>	WeaponClass;	// Class of held weapon.
var(AICombat) name			WeaponJoint;		// Joint name I should attach WeaponClass to.
var(AICombat) name			WeaponAttachJoint;	// Joint in the weapon that attaches to WeaponJoint.
var SPWeapon				RangedWeapon;		// Held weapon.
var(AICombat) float			WeaponAccuracy;		// Accuracy [0,1] of weapon aim.
var(AICombat) bool			bNoAdvance;			// Never charge enemy.
var vector					StrafeToPoint;		// Location strafing to.
var(AICombat) bool			bCanSwitchToMelee;	// Set if can switch from long range to melee weapon.
var(AICombat) bool			bCanSwitchToRanged;	// Set if can switch from melee weapon to long range.
var(AICombat) float			MeleeSwitchDistance;// Distance that long range to melee weapon switch will occur.
var(AICombat) float			RangedSwitchDistance;	// Distance that melee weapon to long range switch will occur.
var(AICombat) float			ForfeitPursuit;		// Aptitude to forfeit pursuit.
var(AICombat) float			DamageRadius;		// Apply damage if Enemy's cylinder is within this distance from damage source.
var(AICombat) bool			bTakeHeadShot;		// Set if should try for head shots.
var(AICombat) bool			bTakeFootShot;		// Set if should try for ground near feet (for splatter damage).
var(AICombat) float			FarAttackBias;		// Liklihood of overriding DoFarAttack result with positive value.
var(AICombat) float			WeaponAttackFOV;	// (Cosine of) Maximum angle of deviation from 0 for ranged weapon attack.

// Special Kill
var(AISpecialKill) vector	SK_PlayerOffset;	// this is in player's local space
var vector			SK_WorldLoc;		// location in the world I need to go to to start my special kill.
var pawn			SK_TargetPawn;		// Pawn I am going to kill.
var bool			SK_Ready;			// Flags when ready to do special kill.
var(AISpecialKill) bool		bHasSpecialKill;	// Set if creature has a special kill.
var(AISpecialKill) float	SK_WalkDelay;		// Max. delay when walking to special kill point.
// Movement.
var vector					WalkVector;			// Vector in local X, at WalkSpeedScale.
var vector					LastLocomotion;		// Most recent locomotion vector.
var pawn					BumpedPawn;			// Pawn I bumped into and will try to avoid.
var vector					BumpPoint;			// Location to reach when avoiding bump.
var bool					bPendingBump;		// Buffers Bump event if it can be handled immediately.
var bool					bBumpPriority;		// Set if this creature has bump priority (others should try to avoid).
var Wind					BreakLikeTheWind;	// My wind.
var ZoneInfo				AnimZone;			// Zone used for animation checks.

// Orders.
var(AIOrders) name			OrderState;			// Initial AI state, actor will attempt to return to this state.
var(AIOrders) name			OrderTag;			// Tag associated with orders.
var actor			OrderObject;		// The object of my desires.
var actor					FirstPoint;			// Marks the first object of a cycle.

// Senses and effectors.
var SPEffector				FirstEffector;		// List of effectors.
var SPHearingEffector		HearingEffector;	// Persistent SPHearingEffector.
var SPVisionEffector		VisionEffector;		// Persistent SPVisionEffector.
var(AISenses) float			HearingEffectorThreshold;	// Delay until noise is detected.
var(AISenses) float			VisionEffectorThreshold;	// Delay until vision is detected (optimal sighting).
var SPLookAtManager			LookAtManager;		// Look manager.
var bool					bIsAiming;			// Set when aiming weapon.
var SPOpacityEffector		OpacityEffector;	//

// Team-based AI.
var(AITeam) bool			bIsTeamLeader;		// Set if I am team leader.
var bool					bIsTeamMember;		// Set if I am on any team.
var(AITeam) name			TeamTag;			// Tag for this actor's team.
var(AITeam) class<ScriptedPawnTeam>	TeamClass;	// Class for this actors team.
var ScriptedPawnTeam		Team;				// My team.
var ScriptedPawn			NextTeamMember;		// Next in the list of members.
var AeonsCoverPoint			CoverPoint;			// My cover point.

// Misc.
var() bool					bCanCrouch;			// Creature can crouch.
var bool			bInCrouch;			// Creature is crouched.
var bool			bGenerated;			// Set if spawned by generator.
var() class<Carcass>		CarcassClass;		// Actor's carcass class.
var(Movement) float			WalkSpeedScale;		// (Fractional) multiplier for walking speed.
var(Movement) float			FullSpeedScale;		// Multiplier for full speed, usually 1.0 but can be overridden on a per creature basis.
var(AI) EAttitude			AttitudeToEnemy;	// Attitude to enemy class.
var(Sounds) sound			GreetSound;			// Default sound to make when greeting.
var(Sounds) sound			GibbedSound;		// sound I make when I am gibbed.
var(Movement) float			JumpScalar;			// Jump Z velocity tweak (1.0 for "fast" creatures, higher for slower creatures).
var(Movement) float			MaxJumpZ;			// Maximum jump Z velocity.
var(AIDamage) bool			bGiveScytheHealth;	// 
var(AIDamage) float			PhysicalScalar;		// Scales physical damage.
var(AIDamage) float			MagicalScalar;		// Scales magical damage.
var(AIDamage) float			FireScalar;			// Scales fire damage.
var(AIDamage) float			ConcussiveScalar;	// Scales concussive damage.
var(AIDamage) float			DamageAcknowledge;	// Scale of full health above which damage is acknowledged.
var(AIDamage) float			FallDamageScalar;	// Scale of default Health to take as falling damage.
var(AIDamage) float			ReactToDamageThreshold;
var(Events) float			TriggerDelay;		// Delay until reacting to Trigger event.
var(Events) name			TriggerState;		// If specifed, state to enter when triggered.
var(Events) name			TriggerTag;			// Tag associated with TriggerState.
var(Events) name			AlertEvent;			// Fire this event when alerted.
var() float					FadeOutDelay;
var() float					FadeOutTime;		// Dead and fading time.
var float			FadeOutCount;		//
var StateInfo		StateStack[20];		// State stack.
var int				StateIndex;			// StateStack index.
var() class<Decal>			GoreDecal;			// Decal to lay under self when killed.
var bool					bDidMeleeDamage;	// Flags if melee damage was successful.
var bool					bDidMeleeAttack;	//
var ScryeGlowScriptedFX 	ScryeGlow;			// glow particle sys for showing a glow about the character when the player casts Scrye.
var(Display) float			DrawScaleVariance;	// As it says.
var(Display) byte			DiffuseColorVariance;	//
var(AIOrders) name			DelayedOrderState;	// Delayed state change state.
var(AIOrders) name			DelayedOrderTag;	// Delayed state change tag.
var(AIOrders) float			DelayedOrderTime;	// Delayed state change timer.
var bool					bKilledLastEnemy;	// Set if enemy was killed and new action needed.
var() bool					bUseLooking;		// Enable/disable looking.
var() bool					bNoBloodPool;		// Set if not to leave a pool of blood.
var() bool					bNoScytheTarget;	// Set if scythe is not to target.
var() bool					bIsEthereal;		// Set if creature is ethereal -- vulnerable to EtherTraps, etc.
var actor			PowderPending;		// Set when notified of Powder of Siren.
var float			PowderEffect;		//
var float			LastScriptTime;		//
var int				ScriptCounter;		//
var() int					LostCounter;		//
var() int					DispelAmplitude;	// Amplitude required to dispel.
var bool			InitCollideActors;	//
var bool			InitBlockActors;	//
var bool			InitBlockPlayers;	//
var(Sounds) float			AttackVocalDelay;	// Delay between allowable attack vocals.
var(Sounds) float			AttackVocalChance;	// Chance that a vocal is played when allowable.
var(Sounds) float			RetreatVocalDelay;	// Delay between allowable retreat vocals.
var float					FallTimer;
var() class<ScriptedPawn>	DeathCommClass;		// Class to send death message.
var() localized string		DeathCommMessage;	// Death message.
var() bool			bSpecialInvoke;		// Handle Invoke in a special way.
var bool			bIsInvoked;			//
var bool			bHacked;			//
var() bool					bHackable;			//
var() bool					bSpecialTurret;		//
var() bool					bIllumCrosshair;	// Illuminates the player's crosshair - default=TRUE
var() bool					bScryeGlow;			// Glows when the player is using Scrye spell
var pawn					MyKiller;			//

// Debug
var string					DebugInfo;			// Whatever info is placed in here will be displayed when DebugInfo is enabled.
var string					DebugInfo2;
var string					DebugInfo3;


// Modifier variables for spell effects, etc.
// -------------------------------------------------------------------------------------------
// Player Modifiers --------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
var PlayerModifier			SphereOfColdMod;	// Sphere of Cold Modifier.
var PlayerModifier			FireFlyMod;			// Firefly Modifier.
// -------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------

// Script following properties.
var NarratorScript	Script;				// Current script.
var(AIScript) name			ScriptTag;			// Tag of initial script.
var(AIScript) int	ScriptAction;		// First/current action within script.
var(AIScript) name			TriggerScriptTag;	// Tag of script to run when triggered (use current if '')
var(AIScript) int			TriggerScriptAction;// First action of trigger script.
var bool			bIsRunAction;		// Set if in a running action.
var int				ScriptSoundID;		// ID returned from PlaySound.
var float			ScriptSoundLen;		// Length of sound the player is playing.
var actor			ScriptTriggerer;	// Actor responsible for triggering.
var pawn			ScriptPlayer;		// The player.
var int				ScriptAnimGroup;	// Which animation group to play sequences from.
var bool			bIgnoreBump;		// Set if should ignore bumps.
var vector					PastLocation[15];	// Last buffered positions.
var int						PastIndex;			// Current index into PastLocation table.
var TractorBeam		PlayerLeash;		// Tractor beam used to drag the player around.
var bool			bIsLeashed;			// Set when player is leashed.
var(AIScript) int			LeashIndex;			// How close the leash point is to the narrator.
var(AIScript) float			ScriptSoundAmp;		//
var(AIScript) name			MouthAnim;			//
var bool			bDetectPlayer;		// Enable/disable player detection in script
var int				ScriptIndex;		// Position in script stack.
var ScriptInfo		ScriptStack[5];		//
var int						ScriptWaitCount;	//
var sound					ScriptLastSound;	//
var bool			bScriptTurret;		// Turret toward player.
var bool			bFastScript;		//
var int				LastScriptSound;	//

// TEMP
var actor					Marker;				// TEMP
var actor					Marker2;			// TEMP

var localized string CreatureDeathMessage;
var(DeathMessage) localized string CreatureDeathVerb;

replication
{
	//reliable if (Role == ROLE_Authority)
	//	DebugInfo, DebugInfo2, DebugInfo3;
	reliable if (Role == ROLE_Authority && bNetInitial)
		InitHealth;
}

//****************************************************************************
// <Begin> Probe functions/messages sent by the engine.
//****************************************************************************

// Default behavior.
function BeginState()
{
	DebugBeginState();
}

// Default behavior.
function EndState()
{
	DebugEndState();
}

// Called when engine processes Destroy() call.
simulated function Destroyed()
{
	CleanUp();
	KillHeldProps();
	super.Destroyed();
}

function PreSetMovement()
{
	super.PreSetMovement();
	bCanJump = false;
	bCanDoSpecial = true;
	SnapToIdle();
}

function HitWall( vector hitNormal, actor hitWall, byte textureID )
{
}

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );

	if ( Health > 0.0 )
		VelocityBias = GetTotalPhysicalEffect( DeltaTime );
	else
		VelocityBias = vect(0,0,0);

	if ( NearDamageDelay > 0.0 )
		NearDamageDelay = FMax( NearDamageDelay - DeltaTime, 0.0 );

	if ( DamageSoundDelay > 0.0 )
		DamageSoundDelay = FMax( DamageSoundDelay - DeltaTime, 0.0 );

	if ( AttackVocalDelay > 0.0 )
		AttackVocalDelay = FMax( AttackVocalDelay - DeltaTime, 0.0 );

	if ( RetreatVocalDelay > 0.0 )
		RetreatVocalDelay = FMax( RetreatVocalDelay - DeltaTime, 0.0 );

	if( (Team != none) && bIsTeamLeader )
		Team.Tick( DeltaTime );

	if ( DelayedOrderTime > 0.0 )
	{
		DelayedOrderTime = FMax( DelayedOrderTime - DeltaTime, 0.0 );
		if ( DelayedOrderTime == 0.0 )
			DelayedOrder( DelayedOrderState, DelayedOrderTag );
	}
	CheckReload( DeltaTime );

	if ( ( PowderPending != none ) && HandlePowderOfSiren( PowderPending ) )
		PowderPending = none;
	if ( PowderEffect > 0.0 )
		PowderEffect = FMax( PowderEffect - DeltaTime, 0.0 );
}

// Sent during actor initialization.
function PreBeginPlay()
{
	if (RGC())
	{
		TurnAnimRate = 1.0 + float(Level.Game.Difficulty);
		RotationRate.Yaw = FMin(RotationRate.Yaw + 10000.0 * Level.Game.Difficulty, 65535.0);
	}
	super.PreBeginPlay();

	if ( Level.Game.Difficulty == 0 )
	{
		Health = Health * 0.40;
		OutDamageScalar = 0.40;
		OutEffectScalar = 0.2;
	}
	else if ( Level.Game.Difficulty == 1 )
	{
		OutDamageScalar = 1.0;
		OutEffectScalar = 0.9;
	}
	else
	{
		Health = Health * 1.25;
		OutDamageScalar = 1.25;
		OutEffectScalar = 1.0;
	}

	InitHealth = Health;

	if ( DrawScale == default.DrawScale )
		DrawScale = FVariant( DrawScale, DrawScale * DrawScaleVariance );

	if ( Lighting[0].TextureMask == 0 )
	{
		Lighting[0].TextureMask = -1;
		Lighting[0].Diffuse.R = 255 - Rand(DiffuseColorVariance);
		Lighting[0].Diffuse.G = 255 - Rand(DiffuseColorVariance);
		Lighting[0].Diffuse.B = 255 - Rand(DiffuseColorVariance);
		Lighting[0].Diffuse.A = 255 - Rand(DiffuseColorVariance);
	}

	AnimZone = Region.Zone;

	ViewRotation = Rotation;
	WalkVector = vect(1,0,0) * WalkSpeedScale;

	ResetStateStack();

	// Adjust GroundSpeed +/- 10%
	GroundSpeed = FVariant( GroundSpeed, GroundSpeed * 0.10 );
	if ( bCanFly )
		AirSpeed = FVariant( AirSpeed, AirSpeed * 0.10 );
	
	// Initialize helper Effectors.
	InitEffectors();

	InitPeripheralVision = PeripheralVision;
	InitHearingThreshold = HearingThreshold;
	SetAlertness( Alertness );

	InitCollideActors = bCollideActors;
	InitBlockActors = bBlockActors;
	InitBlockPlayers = bBlockPlayers;

	// Give Spell Modifiers.
	GiveModifiers();

	// Add some wind.
	BreakLikeTheWind = Spawn( class'PlayerWind', self,, Location );
	BreakLikeTheWind.SetBase( self );

	// Held Props.
	InitHeldProps();

	if ( ( WeaponClass != none ) && ( WeaponJoint != 'none' ) )
	{
		RangedWeapon = Spawn( WeaponClass, self,, JointPlace(WeaponJoint).Pos, ConvertQuat(JointPlace(WeaponJoint).rot) );
		if ( RangedWeapon != none )
		{
			RangedWeapon.SetBase( self, WeaponJoint, WeaponAttachJoint );
			bHasFarAttack = true;
			if ( bScryeOnly )
				RangedWeapon.bScryeOnly = true;
		}
	}

	// particle system for generating a glow when the player casts Scrye
	ScryeGlow = Spawn( class'ScryeGlowScriptedFX', self,, Location );
	Script = FindScript( ScriptTag );

//	Marker = Spawn( class'SPDebugMarker', self,, Location );	// TEMP
//	Marker.Tag = self.name;										// TEMP
//	Marker2 = Spawn( class'SPDebugMarker', self,, Location );	// TEMP
}

// Sent during actor initialization.
function PostBeginPlay()
{
	super.PostBeginPlay();
	
	// Check and initialize team.
	if ( TeamTag != '' )
		InitializeTeam();
}

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	if (Level.NetMode == NM_Client)
	{
		ScryeGlow = Spawn( class'ScryeGlowScriptedFX', self,, Location );
	}
}

// Sent during actor initialization.
function SetInitialState()
{
	// Initialize physics mode.
	SetMovementPhysics();
	if ( ( Physics != PHYS_Flying ) && ( Physics != PHYS_Swimming ) )
		SetPhysics( PHYS_Falling );

	super.SetInitialState();
}

// Powder of Siren active nearby.
function PowderOfSirenNotify( actor Other )
{
	DebugInfoMessage( ".PowderOfSirenNotify() from " $ Other.name );
	PowderPending = Other;
}

//
function bool HandlePowderOfSiren( actor Other )
{
	return false;
}

//
function DispatchPowder( actor Other )
{
	local float		PDist;

	DebugInfoMessage( ".DispatchPowder() " $ Other.name );
//	DebugInfoMessage( ".DispatchPowder() " $ ( Enemy != none ) $ EyesCanSee( Enemy.Location ) $ EyesCanSee( Other.Location ) $ ( VSize(Other.Location - Location) < VSize(Enemy.Location - Location) ) $ ( Normal(Other.Location - Location) dot Normal(Enemy.Location - Location) ) );
	PDist = VSize(Other.Location - Location);

	if ( ( Enemy != none ) &&
		 ( ( PDist < ( CollisionRadius + 250.0 ) ) || 
		   ( EyesCanSee( Enemy.Location ) &&
			 EyesCanSee( Other.Location ) &&
			 ( PDist < VSize(Enemy.Location - Location) ) &&
			 ( ( Normal(Other.Location - Location) dot Normal(Enemy.Location - Location) ) > 0.90 ) ) ) )
	{
		StopMovement();
		PlayWait();
		SetEnemy( none );
		VisionEffector.SetSensorLevel( 0.0 );
		HearingEffector.SetSensorLevel( 0.0 );
		PowderEffect = 1.5;
		GotoState( 'AIWait' );
	}
}

//
function bool CanPerformSK( pawn P )
{
	local vector	X, Y, Z;
	local vector	DVect;

	if ( bHasSpecialKill )
	{
		// calculate the world location I need to go to to be in the correct position relative to the player so the animation works 
		GetAxes( P.Rotation, X, Y, Z );
		if ( bCanFly )
			SK_WorldLoc = P.Location + ( SK_PlayerOffset.X * X ) + ( SK_PlayerOffset.Y * Y ) + ( SK_PlayerOffset.Z * Z );
		else
			SK_WorldLoc = GetGotoPoint( P.Location + ( SK_PlayerOffset.X * X ) + ( SK_PlayerOffset.Y * Y ) + ( SK_PlayerOffset.Z * Z ) );
		DVect = P.Location - SK_WorldLoc;
		DVect.Z = Abs(DVect.Z) - Abs(P.CollisionHeight - CollisionHeight);
		if ( CanPathToPoint( SK_WorldLoc ) &&
			 ( VSize( DVect ) < VSize( SK_PlayerOffset ) * 1.25 ) )
			return true;
	}
	return false;
}

// Perform a special kill on this Pawn
function PerformSK( pawn P )
{
	GotoState( 'AISpecialKill' );
}

function SetTargetPawn( pawn P )
{
	SK_TargetPawn = P;
}

// ============
// Props
// ============
function InitHeldProps()
{
	local int	i;
	local place	MyJointPlace;

	for ( i=0; i<ArrayCount(MyProp); i++ )
	{
		if ( MyPropInfo[i].Prop != none )
		{
			MyJointPlace = JointPlace( MyPropInfo[i].PawnAttachJointName );
			MyProp[i] = Spawn( MyPropInfo[i].Prop, self,, MyJointPlace.pos, ConvertQuat(MyJointPlace.rot) );
			MyProp[i].Setup( MyPropInfo[i].PawnAttachJointName, MyPropInfo[i].AttachJointName );
			if ( bScryeOnly )
				MyProp[i].bScryeOnly = true;
		}
	}
}

function KillHeldProps()
{
	local int i;
	for( i=0; i<ArrayCount(MyProp); i++ )
	{
		if ( MyProp[i] != none )
		{
			MyProp[i].Destroy();
			MyProp[i] = none;
		}
	}
}

function DropProp()
{
	//if (MyProp != None)
	//{
	//	MyProp.Dropped();
	//}
}

function ThrowProp()
{
}

function PickupProp()
{
}

// Called when this pawn sees creature from hated class/alliance.
function SeeHatedPawn( pawn aPawn )
{
	if ( ( aPawn == Enemy ) || ( aPawn.Health <= 0 ) )
		return;		// this pawn is my current enemy
	if ( ( Enemy != none ) && ( ScriptedPawn(Enemy) != none ) && ( Enemy.Health > 0 ) )
		return;		// already attacking another living NPC
	DebugInfoMessage( ".SeeHatedPawn " $ aPawn.name );
	if ( PreCheckEncounter( aPawn ) )
	{
		if ( ( Enemy != none ) && Enemy.bIsPlayer )
			OldEnemy = Enemy;
		SetLastState( GetStateName(), 'RESUME' );
		SensedActor = aPawn;
		SensedPoint = aPawn.Location;
		SensedSense = 'SeeHatedPawn';
		GotoState( 'AIEncounter' );
	}
}

// Sent when this actor's zone changes.
function ZoneChange( ZoneInfo newZone )
{
	DebugInfoMessage( ".ZoneChange() into zone " $ newZone.name $ " @ " $ Level.TimeSeconds );
	AnimZone = newZone;
	if ( bCanSwim &&
		 ( ( Region.Zone.bWaterZone && !AnimZone.bWaterZone ) || ( !Region.Zone.bWaterZone && AnimZone.bWaterZone ) ) )
	{
		PlayLocomotion( LastLocomotion );
		if ( newZone.bWaterZone )
		{
			if ( Physics == PHYS_Falling )
				Landed( vect(0,0,1) );
			SetPhysics( PHYS_Swimming );
		}
//		else
//			SetMovementPhysics();
	}
	if ( Region.Zone.bWaterZone && !newZone.bWaterZone && !bCanFly )
		SetPhysics( PHYS_Falling );
}

function FootZoneChange( ZoneInfo newFootZone )
{
	super.FootZoneChange( newFootZone );
	if ( ( Physics == PHYS_Swimming ) && !newFootZone.bWaterZone )
	{
		SetMovementPhysics();
		DesiredRotation.Pitch = 0;
	}
}

// Sent when this actor begins to fall.
singular function Falling()
{
	if ( bCanFly )
	{
		SetPhysics( PHYS_Flying );
		return;
	}
	if ( Health > 0 )
		SetFall();
}

// Apply the falling damage
function TakeFallDamage( float ZVel )
{
	local DamageInfo	DInfo;

	if ( ZVel < -1400.0 )		// long fall landing
	{
		DInfo = getDamageInfo( 'hardfall' );
		DInfo.Damage = -ZVel * FallDamageScalar * FallDamageScalar;
		TakeDamage( none, Location, vect(0,0,0), DInfo );
	}
	else if ( ZVel < -850.0 )	// fall landing
	{
		TakeDamage( none, Location, vect(0,0,0), getDamageInfo( 'fall' ) );
	}
}

// Sent when this actor lands after a fall.
function Landed( vector hitNormal )
{
//	DebugInfoMessage( ".Landed(), Z is " $ Velocity.Z );
	SetMovementPhysics();
	TakeFallDamage( Velocity.Z );
}

// Sent when this actor collides with another, or is hit by the lantern light.
function Bump( actor Other )
{
	local actor		AOwner;

	DebugInfoMessage( ".Bump() from " $ Other.name );
	AOwner = Other;
	if ( Lantern(Other) != none )
		AOwner = Other.Owner;

	if ( ScriptedPawn(Other) != none )
		CreatureBump( pawn(Other) );
	else if ( !HandleBump( AOwner ) && PreCheckEncounter( AOwner ) )
	{
		SetLastState( GetStateName(), 'RESUME' );
		SensedActor = AOwner;
		SensedPoint = AOwner.Location;
		SensedSense = 'Bump';
		GotoState( 'AIEncounter' );
	}
	else if ( pawn(Other) != none )
		CreatureBump( pawn(Other) );
}

// Called by Bump(), any state that wants to act on the Bump() event should return true.
// Returning false will possibly cause AIEncounter state to be entered.
function bool HandleBump( actor Other )
{
	return false;
}

function EncroachedBy( actor Other )
{
	DebugInfoMessage( ".EncroachedBy() from " $ Other.name );
}

// Sent when this actor hears the noise passed.
function HearNoise( float Loudness, actor NoiseMaker )
{
//	DebugInfoMessage( ".HearNoise(), (" $ Loudness $ ") from " $ NoiseMaker.Instigator );
	HearingEffector.Stimulate( Loudness, NoiseMaker.Instigator );
}

// Sent from the HearingEffector when sensor threshold exceeded.
function EffectorHearNoise( actor Sensed )
{
	if ( PlayerPawn(Sensed) != none )
	{
		SendTeamAIMessage( self, TM_EnemyAcquired, Sensed );
		if ( PreCheckEncounter( Sensed ) )
		{
			SetLastState( GetStateName(), 'RESUME' );
			SensedActor = Sensed;
			SensedPoint = Sensed.Location;
			SensedSense = 'EffHearNoise';
			GotoState( 'AIEncounter' );
		}
	}
	else if ( ScriptedPawn(Sensed) != none )
	{
		// Handle noises from other AI.
		if ( ( ScriptedPawn(Sensed) != self ) && !IsTeamMember( ScriptedPawn(Sensed) ) )
		{
			SendTeamAIMessage( self, TM_Alert, Sensed );
			if ( DefCon == 0 )
				WorldEventAlert( Sensed );
			SetDefCon( 1 );
		}
	}
}

// Sent when this actor can see the player.
function SeePlayer( actor Other )
{
	local float		PVis, PDist;
	PVis = PlayerVisibility( AeonsPlayer(Other) );
	if ( PVis < 1.0 )
		VisionEffector.SetSensorLevel( FMin( VisionEffector.GetSensorLevel(), PVis ) );
	if ( PowderEffect > 0.0 )
		return;
	VisionEffector.Stimulate( 0.4 * PVis, Other );
	if (Level.NetMode != NM_Standalone && PVis > 0 && Pawn(Other) != None && Other != Enemy)
	{
		if (AttitudeTo(Pawn(Other)) == ATTITUDE_Hate)
		{
			if (PreCheckEncounter(Other))
			{
				PDist = PathDistanceTo(Other);
				if (PDist > 0.0 && PDist < PathDistanceTo(Enemy))
					SetEnemy(Pawn(Other));
			}
		}
	}
}

// Sent from the VisionEffector when sensor threshold exceeded.
function EffectorSeePlayer( actor Sensed )
{
	SendTeamAIMessage( self, TM_EnemyAcquired, Sensed );
	if ( PreCheckEncounter( Sensed ) )
	{
		SetLastState( GetStateName(), 'RESUME' );
		SensedActor = Sensed;
		SensedPoint = Sensed.Location;
		SensedSense = 'EffSeePlayer';
//		DebugInfoMessage( ".EffSeePlayer(), VisEff is " $ VisionEffector.GetSensorLevel() );
		GotoState( 'AIEncounter' );
	}
}

// Called when the actor has fallen for a long time.
function LongFall()
{
	DebugInfoMessage( ".LongFall()" );
	FallFromState = GetStateName();
	GotoState( 'AIFall', 'LONGFALL' );
}

function PointJoint( name JName )
{
	AddTargetRot( JName, ConvertRot(ViewRotation), true );
}

// Event called prior to stepping skeletal animation.
function PreSkelAnim()
{
	local vector	rVect;

//	ClearTargets();
	if ( bUseLooking && LookAtManager.IsTracking() )
	{
		rVect = LookAtManager.GetTargetLocation() - JointPlace('head').Pos;
		if ( Marker2 != none )
			Marker2.SetLocation( LookAtManager.GetTargetLocation() );
		ViewRotation = rotator(rVect);
		if ( ( rVect dot vector(Rotation) ) < 0.15 )
		{
			ClearTargets();
			return;
		}
//		if ( bIsAiming )
//			PointJoint( 'spine3' );
//		else
			PointJoint( 'head' );
	}
	else
	{
		ClearTargets();
	}
}

event Actor HeldPropRequest(int idx)
{
	if (idx < 4)
	{
		return MyProp[idx];
	}

	return none;
}

event Hacked(Pawn Other);

function StartLevel()
{
	DebugInfoMessage( ".StartLevel() @ " $ Level.TimeSeconds );
	super.StartLevel();
	if ( bEnemyIsPlayer )
	{
		SetEnemy( FindPlayer() );
		DebugInfoMessage( ".StartLevel(), Enemy is (was) player, so set it to " $ Enemy.name );
	}
}

//****************************************************************************
//  <End>  Probe functions/messages sent by the engine.
//****************************************************************************


//****************************************************************************
// <Begin> Message handlers for messages sent by scripted objects.
//****************************************************************************

function FallToDeathTrigger( Trigger Other )
{
	if ( !bCanFly )
		GotoState( 'AIFallToDeath' );
}

function RampOpacity( bool bUp )
{
	bHidden = !bUp;
}

// Sent when hit with G'Stone.
function Stoned( pawn Stoner )
{
	DebugInfoMessage( ".Stoned(), Z is " $ Velocity.Z );
	if ( !bCanFly &&
		 ( Velocity.Z > 0.0 ) &&
		 !Region.Zone.bWaterZone )
	{
		if ( Velocity.Z > 150.0 )
			PlayInAir();
		if ( GetStateName() != 'AIFall' )
			FallFromState = GetStateName();
		GotoState( 'AIFall' );
	}
}

// Sent immediately after being generated.
function Generated()
{
	SetDefCon( 1 );
}

// SOS notification.
function RespondToSOS( actor Caller )
{
}

// Handle SOS from calling actor.
function HandleSOS( actor Caller )
{
	if ( Intelligence >= BRAINS_Human )
	{
		TargetActor = Caller;
		GotoState( 'AIRespond' );
	}
}

// Sent by something that wants this creature's attention, at least for a little while.
function LookTargetNotify( actor Sender, float Duration )
{
	DebugInfoMessage( ".LookTargetNotify() from " $ Sender.name );
	if ( !bScryeOnly &&
		 ( Health > 0.0 ) )
		PushLookAt( Sender, Duration );
}

// First alerted by some world event.
function WorldEventAlert( actor Alerter )
{
	PlaySoundAlerted();
}

// Hit by lantern light.
function LanternBump( actor Other )
{
	if ( ( Other != none ) && ( pawn(Other.Owner) != none ) && ( pawn(Other.Owner).Health > 0 ) )
	{
		Bump( Other );
	}
}

// Handle fire notifier.
function OnFire( bool bOnFire )
{
	if ( bOnFire && ( FireMod != none ) && !FireMod.bActive )
	{
		// Just ignited.
		super.OnFire( bOnFire );
		if ( Health > 0.0 )
			PlaySoundBurn();
		Ignited();
	}
	else if ( !bOnFire && ( FireMod != none ) && FireMod.bActive )
	{
		super.OnFire( bOnFire );
		Extinguished();
	}
}

// Fire just ignited.
function Ignited()
{
	PushState( GetStateName(), 'RESUME' );
	GotoState( 'AIOnFire' );
}

// Fire just extinguished.
function Extinguished()
{
}

// Weapon wants to fire, return OK.
function bool PreWeaponFire( SPWeapon ThisWeapon )
{
	return true;
}

// Handle fired notification from SPWeapon.
function WeaponFired( SPWeapon ThisWeapon )
{
}

// Handle reload notification from SPWeapon.
function WeaponReload( SPWeapon ThisWeapon )
{
}

// Handle halted fire notification from SPWeapon.
function WeaponMisFired( SPWeapon ThisWeapon )
{
}

// Handle set-up immediately after being summoned.
function PostSummon( pawn Summoner )
{
}

// Sent when the player passed is completely in crouch.
function WarnPlayerCrouching( pawn Other )
{
	local SPWarnCrouchEffector		pEffector;

	pEffector = SPWarnCrouchEffector(SpawnEffector( class'SPWarnCrouchEffector', true ));
	if ( pEffector != none )
	{
		pEffector.Init( Other );
		pEffector.SetDuration( 1.0 );
	}
}

// Called when the WarnCrouch effector expires and conditions are still valid.
function EffectorWarnPlayerCrouching( pawn Other )
{
}

// Called to warn this pawn that it is being targeted.
function WarnTarget( pawn Other, float projSpeed, vector FireDir )
{
	local float			distToShooter;
	local float			timeToImpact;
	local SPEffector	pEffector;

	if ( Intelligence < BRAINS_Human )
		return;

	distToShooter = VSize(Location - Other.Location);
	timeToImpact = distToShooter / projSpeed;

	pEffector = SpawnEffector( class'SPWarnTargetEffector' );
	if ( pEffector != none )
	{
		SPWarnTargetEffector(pEffector).Init( Other.Location, projSpeed, FireDir );
		pEffector.SetDuration( timeToImpact * 0.5 );
	}
}

// Called by an effector to warn this pawn that it is being targeted.
function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir )
{
	local float		distToShooter;
	local float		timeToImpact;
	local vector	dVect;
	local vector	X, Y, Z;

	distToShooter = VSize(Location - shotLocation);
	timeToImpact = distToShooter / projSpeed;

	if ( timeToImpact < 0.10 )
		return;

	dVect = ( shotLocation - Location ) / distToShooter;
	GetAxes( Rotation, X, Y, Z );

	if ( ( dVect dot X ) < PeripheralVision )
		return;

	PushState( GetStateName(), 'DODGED' );
	if ( ( FireDir dot Y ) > 0.0 )
		GotoState( 'AIDodge', 'PICKLEFT' );
	else
		GotoState( 'AIDodge', 'PICKRIGHT' );
}

// Process the WarnAvoidActor event.
function ProcessWarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
{
	local SPHazardEffector		pEffector;

	pEffector = SPHazardEffector(SpawnEffector( class'SPHazardEffector' ));
	if ( pEffector != none )
		pEffector.Init( Other, FVariant( Duration, Duration * 0.25 ), Distance, true );
}

// Called to warn this pawn that it should avoid something.
function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
{
	if ( Intelligence < BRAINS_Human )
		return;
	ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
	WarnFromState = GetStateName();
	if ( Threat < 0.75 )
	{
		PushState( GetStateName(), 'RESUME' );
		if ( pawn(Other.Owner) == self )
			GotoState( 'AIAvoidHazard', 'SELF' );
		else
			GotoState( 'AIAvoidHazard' );
	}
	else
		GotoState( 'AIFleeHide' );
}

// Called when one pawn kills another.
function Killed( pawn Killer, pawn Other, name damageType )
{
//	DebugInfoMessage( ".Killed(), Other is " $ Other.name $ ", Enemy is " $ Enemy.name $ ", Killer is " $ Killer.name );
	if ( ( Other == Enemy ) && ( Other != none ) )
	{
		SetEnemy( none );
		if ( Other.bIsPlayer && Level.NetMode == NM_Standalone )
		{
			if ( Killer == self )
			{
				// I just killed player.
				SetLastState( GetStateName(), 'RESUME' );
				TargetActor = Other;
				GotoState( 'AIDance', 'KILLER' );
				return;
			}
			else
			{
				// Someone else just killed player.
				SetLastState( GetStateName(), 'RESUME' );
				TargetActor = Other;
				GotoState( 'AIDance' );
				return;
			}
		}
		else if ( Killer == self )
		{
			// I just killed NPC.
			bKilledLastEnemy = true;
		}
		GotoState( 'AIAttack' );
	}

	if ( Other == LookAtManager.KeyTargetActor() )
		SetLookAt( none );

	// Handle team member being killed.
	if ( bIsTeamMember && ( Killer != none ) )
		TeamMemberKilled( Other );
}

//Typically implemented in subclass
function string KillMessage( name damageType, pawn Other )
{
	return class'GameInfo'.Static.ParseKillMessage(menuname, Other.PlayerReplicationInfo.PlayerName, CreatureDeathVerb, CreatureDeathMessage);
}

function Trigger( actor Other, pawn EventInstigator )
{
//	DebugInfoMessage( ".Trigger() @ " $ Level.TimeSeconds $ ", Other is " $ Other.name $ ", Instigator is " $ EventInstigator.name );
	SetLastState( GetStateName(), 'RESUME' );
	SensedActor = EventInstigator;
	SensedPoint = EventInstigator.Location;
	SensedSense = 'Trigger';
	if ( ( TriggerState == '' ) && ( TriggerScriptTag != '' ) )
		TriggerState = 'AIRunScript';
	if ( TriggerState == 'AIRunScript' )
		ScriptTriggerer = Other;
	if ( TriggerDelay > 0.0 )
		GotoState( 'AIDelayTrigger' );
	else if ( TriggerState != '' )
	{
		if ( ( PlayerPawn(SensedActor) != none ) && ( AttitudeTo( pawn(SensedActor) ) < ATTITUDE_Ignore ) )
			SetEnemy( pawn(SensedActor) );
		if ( TriggerTag != '' )
		{
			OrderTag = TriggerTag;
		}
		GotoState ( 'AITriggerDispatch' );
	}
	else
		GotoState( 'AIEncounter' );
}

// Apply the mindshatter effector.
function ApplyMindshatter( pawn Instigator, int castingLevel )
{
	local SPEffector	pEffector;

	pEffector = SpawnEffector( class'SPMindshatterEffector', true );
	pEffector.SetDuration( ( castingLevel + 1 ) * 7.0 );
}

// Handle mindshatter.
function TakeMindshatter( pawn Instigator, int castingLevel )
{
	if ( Health <= 0 )
		return;

	ApplyMindshatter( Instigator, castingLevel );
	SensedActor = Instigator;
	PushState( GetStateName(), 'DAMAGED' );
	GotoState( 'AIMindshatter' );
}

// Check for non-conventional damage.
function bool HandleSpecialDamage( Pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo )
{
	if ( DInfo.DamageType == 'mindshatter' )
	{
		TakeMindshatter( Instigator, SpellProjectile(DInfo.Deliverer).castingLevel );
		return true;
	}
	return false;
}

// Adjust damage according to damage type and damage scalars.
function AdjustDamage( out DamageInfo DInfo )
{
	local float		fDamage;

	fDamage = DInfo.Damage;
	switch ( DInfo.Damagetype )
	{
		case 'scythe':
		case 'scythedouble':
		case 'bullet':
		case 'pellet':
		case 'spear':
		case 'gen_physical':
			fDamage *= PhysicalScalar;
			break;
		case 'silverbullet':
		case 'chargedspear':
		case 'sphereofcold':
		case 'chargedsphereofcold':
		case 'ectoplasm':
		case 'creepingrot':
		case 'powerword':
		case 'gen_magical':
			fDamage *= MagicalScalar;
			break;
		case 'fire':
		case 'electrical':
		case 'gen_fire':
			fDamage *= FireScalar;
			break;
		case 'dyn_concussive':
		case 'skull_concussive':
		case 'sigil_concussive':
		case 'lbg_concussive':
		case 'phx_concussive':
		case 'gen_concussive':
			fDamage *= ConcussiveScalar;
			break;
	}
	DInfo.Damage = fDamage;
}

// Trigger reaction to damage.
function ReactToDamage( pawn Instigator, DamageInfo DInfo )
{
//	if ( ( Instigator != none ) && ( Instigator != self ) )
	if ( Instigator != self )
	{
		SensedActor = Instigator;
		if ( Instigator != none )
			SensedPoint = Instigator.Location;
		else
			SensedPoint = Location;
		if ( PlayDamage( DInfo ) )
		{
			PushState( GetStateName(), 'DAMAGED' );
			GotoState( 'AITakeDamage' );
		}
//		else
//			GotoState( GetStateName(), 'DAMAGED' );
	}
}

// See if damage should be acknowledged.
function bool AcknowledgeDamageFrom( pawn Damager )
{
	return true;
}

// Handle conventional damage.
function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo )
{
//	DebugInfoMessage( ".TakeDamage(), taking " $ DInfo.Damage $ " HP damage " $ DInfo.DamageType $ " from " $ Instigator.name $ " at joint " $ DInfo.JointName );
	AdjustDamage( DInfo );

	if ( ( Instigator != none ) &&
		 Instigator.bIsPlayer )
	{
		SetAlertness( 1.0 );
		SetDefCon( 5 );
	}

	// Send team message on first damage.
	if ( Health == InitHealth )
		SendTeamAIMessage( self, TM_TakeDamage, Instigator );

	if ( ( Health <= 0 ) ||
		 ( DInfo.Damage < ( InitHealth * DamageAcknowledge ) ) ||
		 HandleSpecialDamage( Instigator, HitLocation, Momentum, DInfo ) )
		return;

//	DebugInfoMessage( ".TakeDamage(), calling super.TakeDamage() with " $ DInfo.Damage $ " HP damage " $ DInfo.DamageType $ " from " $ Instigator.name $ " at joint " $ DInfo.JointName );
	DebugInfoMessage( ".TakeDamage(), calling super.TakeDamage() with " $ DInfo.Damage $ " HP damage " $ DInfo.DamageType $ " at joint " $ DInfo.JointName );
	super.TakeDamage( Instigator, HitLocation, Momentum, DInfo );

	if ( Health <= 0 )
		return;

	if ( AcknowledgeDamageFrom( Instigator ) )
	{
		CheckEnemySwitch( Instigator );
		CheckHatedEnemy( Instigator );
		if ( DInfo.Damage > ReactToDamageThreshold )
		{
			if ( DamageSoundDelay == 0 )
			{
				PlaySoundDamage();
				DamageSoundDelay = FVariant( default.DamageSoundDelay, default.DamageSoundDelay * 0.20 );
			}
			ReactToDamage( Instigator, DInfo );
		}
	}
}

//****************************************************************************
//  <End>  Message handlers for messages sent by scripted objects.
//****************************************************************************


//****************************************************************************
// <Begin> animation trigger functions
//****************************************************************************
function PlayWaiting()
{
	if ( InWater() )
		LoopAnim( 'swim_idle', [TweenTime] 1.0 );
	else if ( InCrouch() )
		LoopAnim( 'crouch_idle',,,, 0.2 );
	else if ( IsAlert() )
		LoopAnim( 'idle_alert', [TweenTime] 1.0 ) || LoopAnim( 'idle', [TweenTime] 1.0 );
	else
		LoopAnim( 'idle', [TweenTime] 1.0 ) || LoopAnim( 'idle_alert', [TweenTime] 1.0 );
}

function PlayLocomotion( vector dVector )
{
	MoveSpeed = VSize(dVector);
	LastLocomotion = dVector;
	super.PlayLocomotion( dVector );
}

function bool IsWalking( vector dir )
{
	// Determine whether closer to WalkSpeed than to 1.0
	return VSize(dir) < WalkSpeedScale * 0.5 + 0.5;
}

function bool IsAlert()
{
	return DefCon > 0;
}

function bool InCrouch()
{
	return bInCrouch;
}

function bool InWater()
{
	return bCanSwim && AnimZone.bWaterZone;
}

function PlayWait()
{
	MoveSpeed = 0.0;
	LastLocomotion = vect(0,0,0);
	PlayWaiting();
}

function PlayWalk()
{
	PlayLocomotion( WalkVector );
}

function PlayRun()
{
	PlayLocomotion( vect(1,0,0) );
}

function PlayRunOnFire()
{
	PlayRun();
}

function PlayStrafe( vector Dest, float Vel )
{
	local vector	X, Y, Z;

	GetAxes( Rotation, X, Y, Z );

	if ( ( Y dot Normal(Dest - Location) ) > 0.0 )
	{
		PlayLocomotion( vect(0,1,0) * Vel );
	}
	else
	{
		PlayLocomotion( vect(0,-1,0) * Vel );
	}
}

function bool PlayLanding()
{
	// Override and trigger animation here, return true if animation plays
	return PlayAnim( 'jump_end',, MOVE_None );
}

// Play weapon firing animation.
function PlayFiring()
{
}

// Play close-range attack animation.
function PlayNearAttack()
{
}

// Play ranged attack animation.
function PlayFarAttack()
{
}

// Play the spell attack animation for this creature.
function PlaySpellAttack()
{
	if ( ( RangedWeapon != none ) && ( RangedWeapon.AimAnim != '' ) )
		PlayAnim( RangedWeapon.AimAnim );
}

// Play ranged jumping attack animation.
function PlayJumpAttack()
{
}

// Get length of in-air time for jumping attack
function float GetJumpAttackTime()
{
	return 1.0;
}

// Play greeting animation.
function PlayGreeting()
{
	PlayWait();
}

// Play victory dance animation.
function PlayVictoryDance()
{
	PlayTaunt();
}

// Play special kill animation.
function PlaySpecialKill()
{
}

function PlayStunDamage()
{
}

function PlayMindshatterDamage()
{
}

function PlayOnFireDamage()
{
	PlayStunDamage();
}

// Play damage animation, based on damage type.
function bool PlayDamage( DamageInfo DInfo )
{
	if ( InCrouch() )
		return false;

	if ( ( ( ( Health == InitHealth ) || ( MoveSpeed == 0.0 ) ) && ( FRand() < 0.70 ) ) ||
		 ( ( MoveSpeed < ( WalkSpeedScale * 1.1 ) ) && ( FRand() < 0.10 ) ) ||
		 ( FRand() < 0.01 ) )
	{
		PlayStunDamage();
		return true;
	}
	return false;
}

// Play death animation, based on damage type.
function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	// determine damage type (based on "damage" parameter) and trigger appropriate animation
}

// Play a speaking animation (perhaps selected from a set)
function PlaySpeak()
{
}

// Play a taunt animation (perhaps selected from a set)
function PlayTaunt()
{
}

function PlayAwaken()
{
}

//****************************************************************************
//  <End>  animation trigger functions
//****************************************************************************


//****************************************************************************
// <Begin> Sound trigger functions.
//****************************************************************************

// Play a take-damage sound.
function PlaySoundDamage()
{
	PlaySound_P( "VDamage" );
}

// Play a death sound.
function PlaySoundDeath()
{
	PlaySound_P( "VDeath" );
}

// Play a scream-type sound.
function PlaySoundScream()
{
	PlaySound_P( "EventScream" );
}

// Play an alerted sound.
function PlaySoundAlerted()
{
	DebugInfoMessage( ".PlaySoundAlerted()" );
	PlaySound_P( "EventAlert" );
	FireEvent( AlertEvent );
}

function PlaySoundAttack()
{
	PlaySound_P( "EventAttack" );
}

function PlaySoundRetreat()
{
	DebugInfoMessage( ".PlaySoundRetreat() @ " $ Level.TimeSeconds );
	PlaySound_P( "EventRetreat" );
}

function PlaySoundTaunt()
{
	PlaySound_P( "EventTaunt" );
}

function PlaySoundReload()
{
	PlaySound_P( "EventReload" );
}

function PlaySoundBurn()
{
	PlaySound_P( "EventBurn" );
}

function PlaySoundEventFearSpot()
{
	DebugInfoMessage( ".PlaySoundEventFearSpot() @ " $ Level.TimeSeconds );
	PlaySound_P( "EventFearSpot" );
}

// Play inflicting melee damage sound.
function PlaySoundMeleeDamage( int Which )
{
}

// Notification triggered foot SFX.
function C_BareFS()
{
	local texture	HitTexture;
	local int		Flags;

	HitTexture = TraceTexture( Location + vect(0,0,-1.5) * CollisionHeight, Location, Flags );
	if ( HitTexture != none )
		PlayFootSound( 1, HitTexture, 0, Location );
}

// Notification triggered foot SFX.
function C_ClawFS()
{
	local texture	HitTexture;
	local int		Flags;

	HitTexture = TraceTexture( Location + vect(0,0,-100), Location, Flags );
	if ( HitTexture != none )
		PlayFootSound( 1, HitTexture, 0, Location );
}

// Notification triggered footscuff SFX.
function C_FootScuff()
{
	local texture	HitTexture;
	local int		Flags;

	HitTexture = TraceTexture( Location + vect(0,0,-100), Location, Flags );
	if ( HitTexture != None )
		PlayFootSound( 1, HitTexture, 2, Location );
}

function PlayAttackVocal()
{
	if ( AttackVocalDelay <= 0.0 )
	{
		AttackVocalDelay = FVariant( default.AttackVocalDelay, default.AttackVocalDelay * 0.10 );
		if ( FRand() < AttackVocalChance )
			PlaySoundAttack();
	}
}

function PlayRetreatVocal()
{
	if ( RetreatVocalDelay <= 0.0 )
	{
		RetreatVocalDelay = FVariant( default.RetreatVocalDelay, default.RetreatVocalDelay * 0.10 );
		PlaySoundRetreat();
	}
}


//****************************************************************************
//  <End>  Sound trigger functions
//****************************************************************************


//****************************************************************************
// <Begin> gib/damage related functions
//****************************************************************************

// Clean up before destroying.
simulated function CleanUp()
{
	if ( RangedWeapon != none )
	{
		RangedWeapon.Destroy();
		RangedWeapon = none;
	}

	// Clean up effectors.
	KillEffectors();

	// Clean up modifiers.
	KillModifiers();

	if ( BreakLikeTheWind != none )
	{
		BreakLikeTheWind.Destroy();
		BreakLikeTheWind = none;
	}

	// Notify generator, if present.
	if ( bGenerated && ( Owner != none ) && ( CreatureGenerator(Owner) != none ) )
		CreatureGenerator(Owner).GenCreatureKilled( self );

	if ( Marker != none )
	{
		Marker.Destroy();
		Marker = none;
	}

	if ( ScryeGlow != none )
	{
		ScryeGlow.Destroy();
		ScryeGlow = none;
	}
}

// Just died.
function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo )
{
	DebugInfoMessage( ".Died(), Killer is " $ Killer $ " damage is " $ damageType );

	ClearAnims();

	MyKiller = Killer;
	super.Died( Killer, damageType, HitLocation, DInfo );
	DropWhenKilled = none;

	if ( ( damageType != 'gibbed' ) && !bHacked )
		PlaySoundDeath();
	MakeNoise( 2.0, 2560 );
	CallForHelp( 2560.0 );

	if ( DeathCommClass != none )
		SendClassComm( DeathCommClass, DeathCommMessage );

	if ( ( damageType == 'drown' ) || Region.Zone.bWaterZone )
		bNoBloodPool = true;
		
	// shotgun gore, on death
	if ( RGORE() && damageType == 'pellet' && bHackable && !bIsBoss )
	{
		if ( Patrick(Killer) != None )
		{
			if (FRand() > 0.5)
				Patrick(Killer).DetachJointEx();
			else
				Patrick(Killer).DestroyJointEx();
		}

		Spawn(class 'SmokyBloodFX',Killer,,HitLocation); // or SmokyBloodSmallFX
	}

	// Remove all non-persistent effectors.
	KillEffectorList();
}

function SendKilledNotifications( pawn Killer, name damageType )
{
	local pawn	P;

	for ( P = Level.PawnList; P != none; P = P.nextPawn )
		P.Killed( Killer, self, damageType );
}

// Return TRUE if can be gibbed, FALSE otherwise.
function bool Gibbed( name damageType )
{
	switch( DamageType )
	{
		case 'Skull_Concussive':
		case 'Sigil_Concussive':
		case 'LBG_Concussive':
		case 'Phx_Concussive':
		case 'Dyn_Concussive':
			return true;
			break;
		
		default:
			return false;
			break;
	};
}

// Spawn a gibbed version of this actor.
function SpawnGibbedCarcass( vector Dir )
{
	local int i;
	local Actor Gib;
	//local place P;
	local vector Vel;
	local float damageScale, DamageRadius, dist;
	
	if (RGORE())
	{
		DamageRadius = 640;
		
		if (Health <= 0 && bHackable && !IsA('Rat'))
		{
			for (i=NumJoints(); i>=0; i--)
			{
				if (FRand() > 0.25)
					continue;

				Gib = DetachLimb(JointName(i), Class 'BodyPart');

				if (Gib != None)
				{
					Gib.Velocity = -Dir * 2 + VRand() * 64;
					Gib.DesiredRotation = RotRand(true);
					Gib.SetCollisionSize((Gib.CollisionRadius * 0.65), (Gib.CollisionHeight * 0.15));
					
					ReplicateDetachLimb(self, JointName(i), Gib.Velocity, Gib.DesiredRotation);

					PlayDamageMethodImpact('Bullet', Gib.Location, Dir);
				}
				
				//SetBase(self, JointName(i));
			}

			bHacked = true;
			bHidden = true; // hide pawn since not all joints can be detached
			bHackable = false; // prevent re-entry
			bNoBloodPool = true;

			KillHeldProps();
		}
	}
	else
	{
		// km - this is a bit temp :)
		Spawn( class'Gibs',,, Location, Rotator(Dir) );
	}
	
	PlaySound( GibbedSound );
	if ( CarcassClass != none )
		Spawn( CarcassClass,,, Location );
}

// Spawn the carcass for this actor.
function Carcass SpawnCarcass()
{
	local carcass	carc;

	carc = Spawn( CarcassClass );
	if ( carc != None )
	{
		carc.Initfor( self );
	}

	return carc;
}

// Spawn gore decal(s) on ground after death.
function SpawnGoreDecal()
{
	if ( !bNoBloodPool )
		Spawn( GoreDecal, self,, Location, rotator(vect(0,0,1)) );
}

// Can I be invoked????
function bool CanBeInvoked()
{
	return false;
}

// do the invoking
function Invoke( actor Other );

//****************************************************************************
//  <End>  gib related functions
//****************************************************************************


//****************************************************************************
// <Begin> misc. support functions
//****************************************************************************

// Check if lost player visual as a result of invisibility
function bool LostPlayerVisual( pawn Other )
{
	if ( AeonsPlayer(Other) != none )
	{
		if ( ( PlayerVisibility( AeonsPlayer(Other) ) < 0.50 ) &&
			 ( VisionEffector.GetSensorLevel() < 0.05 ) )
			return true;
	}
	return false;
}

function bool ShouldPursue( pawn Other )
{
//	DebugInfoMessage( ".ShouldPursue(), Vis is " $ VisionEffector.GetSensorLevel() $ ", Hear is " $ HearingEffector.GetSensorLevel() );
	if ( Other != none )
	{
		if ( ( ScriptedPawn(Other) == none ) &&
			 ( VisionEffector.GetSensorLevel() < 0.05 ) &&
			 ( HearingEffector.GetSensorLevel() < 0.10 ) &&
			 ( FRand() < ForfeitPursuit ) )
			return false;
		else
			return true;
	}
	return false;
}

function vector GetTotalPhysicalEffect( float DeltaTime )
{
	local PhysicsEffector	PEffect;
	local vector			PVect;

	PVect = vect(0,0,0);
	foreach AllActors( class'PhysicsEffector', PEffect )
		if ( PEffect.bAffectAI )
			PVect += PEffect.EffectOn( Location );
	return PVect;
}

function CallForHelp( float Distance )
{
	local ScriptedPawn	SP;

	foreach RadiusActors( class'ScriptedPawn', SP, Distance )
		SP.RespondToSOS( self );
}

function bool IsInvoked()
{
	return ( PlayerPawn(Owner) != none );
}

function color MakeRGBA( int R, int G, int B, int A )
{
	local color		C;

	C.R = R;
	C.G = G;
	C.B = B;
	C.A = A;

	return C;
}

// TEMP
function vector SetMarker( vector Here )
{
	if ( Marker != none )
		Marker.SetLocation( Here );
	return Here;
}

// Called when DelayedOrderTime counts down to 0.
function DelayedOrder( name OState, name OTag )
{
	OrderState = OState;
	OrderTag = OTag;
	GotoState( OState );
}

// Called when player reload has been detected.
function PlayerReloading()
{
	local int			OCount;
	local ScriptedPawn	SP;

	if ( Health > 0 )
	{
		OCount = 0;
		foreach RadiusActors( class'ScriptedPawn', SP, 500.0 )
		{
			if ( SP.IsA( class.name ) && ( SP != self ) )
			{
				OCount += 1;
				SP.SpeakReloadDelay = 0.0;		// shut the others up
				SP.CheckReloadDelay = 0.0;
			}
		}
		if ( ( FRand() < 0.50 ) && ( OCount > 0 ) )
			PlaySoundReload();
	}
}

// Check if enemy player is reloading
function CheckReload( float DeltaTime )
{
	if ( SpeakReloadDelay > 0.0 )
	{
		if ( SpeakReloadDelay <= DeltaTime )
		{
			PlayerReloading();
			SpeakReloadDelay = 0.0;
		}
		else
			SpeakReloadDelay -= DeltaTime;
	}

	if ( CheckReloadDelay > 0.0 )
		CheckReloadDelay = FMax( CheckReloadDelay - DeltaTime, 0.0 );

	if ( ( CheckReloadDelay <= 0.0 ) &&
		 ( Intelligence >= BRAINS_Human ) &&
		 ( PlayerPawn(Enemy) != none ) &&
		 PlayerPawn(Enemy).bReloading )
	{
		CheckReloadDelay = default.CheckReloadDelay;
		SpeakReloadDelay = FVariant( 1.0, 0.25 );
	}
}

// Disable look targeting.
function NoLook()
{
	LookAtManager.SetActive( false );
	ClearTargets();
}

function int TurnTowardThreshold( int thresh )
{
	if ( bUseLooking && LookAtManager.IsTracking() )
		return thresh;
	else
		return 0;
}

// Set crouch attributes.
function SetCrouch()
{
	bInCrouch = true;
	BaseEyeHeight = 0.0;
	EyeHeight = BaseEyeHeight;
}

// Clear crouch attributes.
function UnSetCrouch()
{
	bInCrouch = false;
	BaseEyeHeight = default.BaseEyeHeight;
	EyeHeight = BaseEyeHeight;
}

// Returns the cosine of my location in my enemy's FOV
function float EnemyFOVAngle()
{
	if ( Enemy != none )
		return Normal(Location - Enemy.Location) dot vector(Enemy.ViewRotation);
	return 0.0;
}

// Returns the cosine of the angle to my enemy.
function float XYAngleToEnemy()
{
	local vector	DVect;

	if ( Enemy != none )
	{
		DVect = Enemy.Location - Location;
		DVect.Z = 0.0;
		return Normal(DVect) dot vector(Rotation);
	}

	return 0.0;
}

// Return location of eyes.
function vector EyeLocation()
{
	local vector	X, Y, Z;

	GetAxes( Rotation, X, Y, Z );
	return Location + ( Z * EyeHeight );
}

// Convert local vector to world location.
function vector LocalToWorld( vector Offset )
{
	local vector	X, Y, Z;

	GetAxes( Rotation, X, Y, Z );
	return Location + ( X * Offset.X ) + ( Y * Offset.Y ) + ( Z * Offset.Z );
}

// Determine if current location is fully exposed to the pawn passed.
function bool FullyExposed( pawn EPawn )
{
	local vector	EyeLoc;

	if ( ( EPawn != none ) &&
		 FastTrace( Location, EPawn.Location ) &&
		 FastTrace( EyeLocation(), EPawn.Location ) )
	{
		EyeLoc = EPawn.Location + vect(0,0,1) * EPawn.BaseEyeHeight;
		if ( FastTrace( Location, EyeLoc ) &&
			 FastTrace( EyeLocation(), EyeLoc ) )
			return true;
	}
	return false;
}

// Determine if direct line-of-sight from eyes.
function bool EyesCanSee( vector Loc )
{
	return FastTrace( Loc, EyeLocation() );
}

// Determine if Enemy has direct line-of-sight from eyes.
function bool EnemyCanSee( vector Loc )
{
	return ( ( Enemy != none ) &&
			 ( FastTrace( Loc, Enemy.Location ) ||
			   FastTrace( Loc, Enemy.Location + vect(0,0,1) * Enemy.BaseEyeHeight ) ) );
}

// Return Enemy location, if direct line of sight or LastSeenPos.
function vector EnemyAimSpot()
{
	local vector X, Y, Z;
	local vector EnemyLoc;

	if ( Enemy == none ) 
		return LastSeenPos;

	if ( bTakeHeadShot )
	{
		GetAxes( Enemy.Rotation, X, Y, Z );
		EnemyLoc = Enemy.Location + ( Z * Enemy.EyeHeight );
	}
	else
		EnemyLoc = Enemy.Location;

	if ( !Enemy.bIsPlayer || EyesCanSee( EnemyLoc ) )
		return EnemyLoc;

	return LastSeenPos;
}

// Return the location to move to when moving to Enemy.
function vector EnemyMoveToLocation()
{
	return Enemy.Location;
}

// Return first actor possibly hit by a shot fired from FromLoc to ToLoc.
function actor ClearShot( vector FromLoc, vector ToLoc )
{
	local vector		HitLocation, HitNormal;
	local actor			HitActor;
	local ScriptedPawn	HitSPawn;
	local int			HitJoint;

	HitActor = Trace( HitLocation, HitNormal, HitJoint, ToLoc, FromLoc, true );
	if ( ( HitActor != none ) && ( pawn(HitActor) == none ) )
		return HitActor;
	HitSPawn = ScriptedPawn(HitActor);
	if ( HitSPawn != none )
	{
		// TODO: check for own class, other classes?
		if ( ( HitSPawn != Enemy ) && ( HitSPawn.Intelligence > BRAINS_Mammal ) )
			return HitSPawn;
	}
	return none;
}

function int SetupGlowJoints( GlowScriptedFX GlowFX )
{
	GlowFX.SetupJoints( 0, NumJoints() );
	return NumJoints();
}

simulated function bool AddParticleToJoint( int i )
{
	return (i >= 0) && (i < NumJoints());
}

// Debug.
simulated function String GetDebugInfo()
{
	return DebugInfo;
}

simulated function String GetDebugInfo2()
{
	return DebugInfo2;
}

simulated function String GetDebugInfo3()
{
	return DebugInfo3;
}

// Used for debugging
simulated function SetDebugInfo( string s, optional bool bLog, optional bool bAlwaysUpdate )
{
	if ( ( s != DebugInfo3 ) || bAlwaysUpdate )
	{
		DebugInfo = DebugInfo2;
		DebugInfo2 = DebugInfo3;
		DebugInfo3 = s;

		if ( bLog )
			log( s, 'AI' );
	}
}

// Debug message on entering state.
function DebugBeginState( optional string Msg )
{
	local name	EneName;

	if ( Enemy == none )
		EneName = 'NONE';
	else
		EneName = Enemy.name;

	if ( Msg != "" )
		SetDebugInfo( name $ "." $ GetStateName() $ ".BeginState(" $ StateIndex $ ") @" $ Level.TimeSeconds $ ", H=" $ Health $ ", Ph=" $ Physics $ ", E=" $ EneName $ ", " $ Msg, true, true );
	else
		SetDebugInfo( name $ "." $ GetStateName() $ ".BeginState(" $ StateIndex $ ") @" $ Level.TimeSeconds $ ", H=" $ Health $ ", Ph=" $ Physics $ ", E=" $ EneName, true, true );
}

// Debug message on exiting state.
function DebugEndState( optional string Msg )
{
/*
	if ( Msg != "" )
		SetDebugInfo( name $ "." $ GetStateName() $ ".EndState(), " $ Msg, true, true );
	else
		SetDebugInfo( name $ "." $ GetStateName() $ ".EndState()", true, true );
*/
}

// Handle debugging error message.
function DebugErrorMessage( string Msg )
{
	SetDebugInfo( Msg, true, true );
}

// Handle debugging warning message.
function DebugWarnMessage( string Msg )
{
	SetDebugInfo( Msg, true, true );
}

// Handle debugging information message.
function DebugInfoMessage( string Msg )
{
	SetDebugInfo( name $ Msg, true, true );
}

function DebugLogMessage( string Msg )
{
//	log( Msg );
}

// Called when moving in state code, only handle bumping into other ScriptedPawns.
function CreatureBump( pawn Other )
{
	if ( ( Other == none ) ||
		 ( ( Other == Enemy ) && ( AttitudeTo( Other ) == ATTITUDE_Hate ) ) ||
		 ( Physics == PHYS_Falling ) )
		return;
	if ( ( ScriptedPawn(Other) != none ) ||
		 ( ( PlayerPawn(Other) != none ) && ( AttitudeTo( Other ) != ATTITUDE_Hate ) ) )
	{
		PushState( GetStateName(), 'RESUME' );
		BumpedPawn = Other;
		GotoState( 'AIBumpAvoid' );
	}
}

// Set a (new) DefCon level.
function SetDefCon( int NewValue, optional bool CanLower )
{
	local int	OldValue;

	OldValue = DefCon;
//	if ( OldValue == 0 )
//		PlaySoundAlerted();
	if ( ( NewValue < OldValue ) && !CanLower )
		return;
	DefCon = NewValue;
	if ( OldValue != NewValue )
		DefConChanged( OldValue, NewValue );
}

// Notification that the DefCon level has changed.
function DefConChanged( int OldValue, int NewValue )
{
}

// Remove self from level.
function Vanish()
{
	if ( !bDeleteMe )
	{
		Destroy();
	}
}

// Inter-ScriptedPawn messaging.
function CommMessage( actor sender, string message, int param )
{
}

// Send comm message to specific creature.
function SendCreatureComm( actor sendTo, string message, optional int param )
{
	if ( ScriptedPawn(sendTo) != none )
		ScriptedPawn(sendTo).CommMessage( self, message, param );
}

// Send comm message to all creatures of specified class.
function SendClassComm( class<ScriptedPawn> classID, string message, optional int param )
{
	local pawn	aPawn;

	aPawn = Level.PawnList;
	while ( aPawn != none )
	{
		if ( aPawn.IsA(classID.name) )	// TODO: check for self and exclude?
			ScriptedPawn(aPawn).CommMessage( self, message, param );
		aPawn = aPawn.nextPawn;
	}
}

// Send comm message to all creatures with specified event tag.
function SendTaggedComm( name thisTag, string message, optional int param )
{
	local pawn	aPawn;

	aPawn = Level.PawnList;
	while ( aPawn != none )
	{
		if ( ( aPawn.Tag == thisTag ) && ( ScriptedPawn(aPawn) != none ) )	// TODO: check for self and exclude?
			ScriptedPawn(aPawn).CommMessage( self, message, param );
		aPawn = aPawn.nextPawn;
	}
}

// Animation & movement trigger/control.
function StopMovement()
{
	Acceleration = vect(0,0,0);
	DesiredSpeed = 0.0;
	DesiredRotation = Rotation;
	MoveSpeed = 0.0;
	MoveTarget = none;
}

// Slow movement down (skid ?).
function SlowMovement()
{
	Acceleration *= 0.1;
	DesiredSpeed *= 0.5;
}

// Damage handling.
function DamageInfo getDamageInfo( optional name DamageType )
{
	local DamageInfo	DInfo;

	DInfo.Deliverer = self;
	DInfo.DamageMultiplier = OutDamageScalar;
	DInfo.DamageType = DamageType;

	switch ( DamageType )
	{
		case 'NearAttack':
			DInfo.Damage = MeleeInfo[0].Damage;
			DInfo.EffectStrength = FClamp( MeleeInfo[0].EffectStrength * OutEffectScalar, 0.0, 1.0 );
			break;
		case 'fall':
			DInfo.Damage = InitHealth * FallDamageScalar;
			break;
		case 'hardfall':
			DInfo.Damage = 1000;	// this gets changed in TakeFallDamage()
			break;
		case 'drown':
			DInfo.Damage = 10;
			break;
		case 'suicide':
			DInfo.Damage = Health * 100;
			break;
	}

	return DInfo;
}

// Return visibility of player passed (0.0 is invisible, 1.0 is fully visible).
function float PlayerVisibility( AeonsPlayer player )
{
	if ( ( player != none ) && ( StealthModifier(player.StealthMod) != none ) )
	{
		return StealthModifier(player.StealthMod).VisibleStealth;
	}
	return 1.0;
}

// Return yaw to point (0 is directly ahead, 16384 is right, 32768 is directly behind, 49152 is left).
function int YawTo( vector target )
{
	local rotator	drot;

	drot = rotator(target - Location) - Rotation;
	return drot.Yaw & 65535;
}

// Return pitch to point.
function int PitchTo( vector target )
{
	local rotator	drot;

	drot = rotator(target - Location);
	return drot.Pitch;
}

// Determines if the vectors to these two locations are within range of each other.
function bool IsForwardProgress( vector v1, vector v2, optional float Thresh )
{
	v1 = Normal(v1 - Location);
	v2 = Normal(v2 - Location);
	if ( ( v1 dot v2 ) > Thresh )
		return true;
	else
		return false;
}

// Determine if location passed is in front of creature.
function bool FacingToward( vector Loc, optional float Thresh )
{
	return IsForwardProgress( Loc, Location + vector(Rotation) * 100.0, Thresh );
}

// Compute a destination position for flanking to the target.
function vector FlankPosition( vector target )
{
	local vector delta;
	local vector perp;
	local vector fp;
	local float Scale;
	local float MaxPerpScale;
	local float NominalFlankDistance;
	local float FlankDistanceFactor;

	NominalFlankDistance = 75.0 * 256.0 / 12.0;	// Distance at which maximum spread is 45 degrees.
	FlankDistanceFactor = (1.0 / NominalFlankDistance) ** 2;

	delta = target - Location;
//	perp = vect( -delta.Y, delta.X, 0.0 );
	perp = vect(0, 0, 0);
	perp.X = -delta.Y;
	perp.Y = delta.X;
	Scale = delta dot delta;
	if( Scale < (0.125 * NominalFlankDistance * NominalFlankDistance) )
	{
		DebugInfoMessage(".FlankPosition() target is very close.");
		return Target;
	}

	MaxPerpScale = FlankDistanceFactor * Scale;
	if( MaxPerpScale > 1.0 )
		MaxPerpScale = 1.0 / MaxPerpScale;

	perp *= FlankMagnitude * MaxPerpScale;
	if ( !FlankDirection )
		perp *= -1;

	DebugInfoMessage(".FlankPosition() dist = " $ Sqrt(Scale) $ ", scale = " $ MaxPerpScale $ ", mag = " $ FlankMagnitude $ ", angle = " $ Atan( FlankMagnitude * MaxPerpScale ) * (45 / Atan(1)));

	if( Scale < 55000.0 )
		Scale = Sqrt( Scale / (Scale + (perp dot perp)) );
	else
		Scale = Sqrt( 55000.0 / (Scale + (perp dot perp)) );

	fp = Location + Scale * (delta + perp);

	return fp;
}

function vector StrafePosition( vector target )
{
	local vector delta;
	local vector perp;
	local vector fp;
	local float	 dist;

	delta = target - Location;
//	perp = vect( -delta.Y, delta.X, 0.0 );
	perp = vect(0, 0, 0);
	perp.X = -delta.Y;
	perp.Y = delta.X;

	perp = (100.0 + FlankMagnitude * 300.0) * Normal( perp );
	if ( !FlankDirection )
		perp *= -1;

	dist = VSize( delta );
	if( dist < 2.5 * MeleeRange )
	{
		delta = Normal( delta ) * (dist - 2.5 * MeleeRange);
	}
	else if( dist > 6.0 * MeleeRange )
	{
		delta = Normal( delta ) * (dist - 6.0 * MeleeRange);
	}
	else
	{
		delta = vect(0,0,0);
	}

	fp = Location + delta + perp;

	return fp;
}

function bool PathThrough( vector waypoint, actor target )
{
	if( pointReachable( waypoint ) && FastTrace( target.Location ) )
	{
		return true;
	}
	return false;
}

function bool FlankEnemy( )
{
	local float NominalFlankDistance;
	local vector Target;

	Target = Enemy.Location;

	if( FlankPointReset )
	{
		DebugInfoMessage(".FlankPosition() reset.");
		FlankDirection = (FRand() > 0.5);
		FlankMagnitude = sqrt( FRand() );
		FlankPointReset = false;
	}

	if( Enemy == none )
	{
		DebugInfoMessage(".FlankEnemy() no enemy.");
		return false;
	}

	if( bCanStrafe && bNoAdvance )
	{
		DebugInfoMessage( ".FlankEnemy() strafe move." );
		FlankPoint = StrafePosition( Target );
	}
	else
	{
		NominalFlankDistance = 75.0 * 256.0 / 12.0;	// Distance at which maximum spread is 45 degrees.
		FlankPoint = FlankPosition( Target );
		if( VSize( FlankPoint - Target ) < 25.0 )
		{
			DebugInfoMessage(".FlankEnemy() too close to enemy.");
			return false;
		}
	}

	if ( !PathThrough( FlankPoint, Enemy ) )
	{
		DebugInfoMessage(".FlankPosition() original flanking position not valid.");
		FlankMagnitude = 0.5 * FlankMagnitude;
		FlankDirection = ! FlankDirection;
		if( bCanStrafe && bNoAdvance )
			FlankPoint = StrafePosition( Target );
		else
			FlankPoint = FlankPosition( Target );
	}
	
	if ( !PathThrough( FlankPoint, Enemy ) )
	{
		DebugInfoMessage(".FlankPosition() secondary position not valid, using original target.");
		FlankPointReset = true;
		return false;
	}

	return true;
}

// Called by ScriptedPawn script when this actor has taken damage.
function TookDamage( actor Other )
{
	local bool	bEncounter;
	
	if (!Other.IsA('PlayerPawn'))
		return;
	
	bEncounter = false;
	if ( ( ScriptedPawn(Other) != none ) &&
		 ( HatedClass == none ) &&
		 ( Other != self ) )
		bEncounter = true;
	if ( bEncounter || PreCheckEncounter( Other ) )
	{
		SetLastState( GetStateName(), 'RESUME' );
		SensedActor = Other;
		SensedSense = 'TookDamage';
		HatedEnemy = pawn(Other);
		GotoState( 'AIEncounter' );
	}
}

// Inflict near damage, should be called by melee animation notifications, applies default damage (override for special cases).
function DoNearDamageX( int Which )
{
	local vector	HitLoc;
	local pawn		HitPawn;

	if ( ( Enemy != none ) && ( NearDamageDelay <= 0.0 ) )
	{
		HitPawn = Enemy;
		if ( InflictNearDamage( HitPawn, MeleeInfo[Which].Damage, MeleeInfo[Which].Damage * Normal(HitPawn.Location - Location) * 10.0 , Which + 1, MeleeInfo[Which].EffectStrength ) )
		{
			// Disable near damage application for this long.
			NearDamageDelay = 0.5;
			HitLoc = HitPawn.Location + Normal(HitPawn.Location - Location) * HitPawn.CollisionRadius;
			HitPawn.PlayDamageMethodImpact( MeleeInfo[Which].Method, HitLoc, Normal(Location-HitLoc) );
			PlaySoundMeleeDamage( Which );
			bDidMeleeDamage = true;
		}
	}
}

// Inflict near damage, should be called by melee animation notifications, applies default damage (override for special cases).
function DoNearDamage()
{
	DoNearDamageX( 0 );
}

function DoNearDamage2(){	DoNearDamageX( 1 );	}
function DoNearDamage3(){	DoNearDamageX( 2 );	}
function DoNearDamage4(){	DoNearDamageX( 3 );	}
function DoNearDamage5(){	DoNearDamageX( 4 );	}
function DoNearDamage6(){	DoNearDamageX( 5 );	}

// First possible second swipe damage.
function DoNearDamageReset()
{
	// Second swipe, so reset damage delay and apply damage.
	NearDamageDelay = 0.0;
	DoNearDamage();
}

function DoNearDamage2Reset(){	NearDamageDelay = 0.0; DoNearDamage2();	}
function DoNearDamage3Reset(){	NearDamageDelay = 0.0; DoNearDamage3();	}
function DoNearDamage4Reset(){	NearDamageDelay = 0.0; DoNearDamage4();	}
function DoNearDamage5Reset(){	NearDamageDelay = 0.0; DoNearDamage5();	}
function DoNearDamage6Reset(){	NearDamageDelay = 0.0; DoNearDamage6();	}

// Returns random value in range [ReactionBase - ReactionRand,ReactionBase + ReactionRand]
function float Reaction( float thisTime )
{
	return FVariant( ReactionBase, ReactionRand );
}

// Called from the BaseChange() event.
function JumpOffPawn()
{
	Velocity += ( 60 + CollisionRadius ) * VRand();
	Velocity.Z = 180 + CollisionHeight;
	if ( Health > 0 )
		SetFall();
}

// Set default movement physics for this class.
// Subclasses that swim or fly should override this.
function SetMovementPhysics()
{
//	DebugInfoMessage( ".SetMovementPhysics()" );
	if ( Physics == PHYS_Falling )
		return;

	if ( Region.Zone.bWaterZone )
		SetPhysics( PHYS_Swimming );
	else
		SetPhysics( PHYS_Walking );
}

// Called by FearSpot (Trigger) actors when this actor touches it.
function FearThisSpot( actor ASpot )
{
	DebugInfoMessage( ".FearThisSpot(), " $ ASpot.name );
	PlaySoundEventFearSpot();
	GotoState( 'AIRetreat' );
}

// Adjust variables used by engine for environmental detection.
final function SetAlertness( float NewAlertness )
{
	local float		thresh;

	NewAlertness = FClamp( NewAlertness, 0.0, 1.0 );

	// scale PV and HT closer to 0.0 as (New)Alertness approaches 1.0.
	PeripheralVision = InitPeripheralVision - ( InitPeripheralVision * NewAlertness );
	HearingThreshold = InitHearingThreshold - ( InitHearingThreshold * NewAlertness );

	// adjust effector sensitivity
	thresh = ( 1.0 - ( 0.5 * NewAlertness ) ) * VisionEffectorThreshold;
	VisionEffector.SetAlarmThreshold( thresh );
	VisionEffector.SetDecayRate( thresh * 0.10 );		// Default decay is 10% of alarm threshold value.
	VisionEffector.SetAlarmFrequency( thresh * 0.04 );	// Default frequency is about 4% of alarm threshold value.

	Alertness = NewAlertness;
}

// Deactivate all firing.
function StopFiring()
{
	bFire = 0;
//	RangedWeapon.StopFiring();
}

// Fire the current weapon by activating bFire.
function FireWeapon()
{
	bFire = 1;
	RangedWeapon.StartFiring();
}

// Turn off the timer.
function StopTimer()
{
	SetTimer( 0.0, false );
}

// See if within "striking" Z distance.
function bool WithinStrikingZ( actor Victim )
{
	return ( Abs(Location.Z - Victim.Location.Z) <= ( FMax(CollisionHeight, Victim.CollisionHeight) + 0.5 * FMin(CollisionHeight, Victim.CollisionHeight) ) );
}

// See if location is within specified distance of specified actor.
function bool LocationStrikeValid( actor Victim, vector Loc, float Range )
{
	local vector	DVect;
	local float		XY, Z;

	DVect = Victim.Location - Loc;
	Z = FMax( 0.0, Abs(DVect.Z) - Victim.CollisionHeight );
	DVect.Z = 0.0;
	XY = FMax( 0.0, VSize(DVect) - Victim.CollisionRadius );

	if ( ( ( Square( XY ) + Square( Z ) ) < Square( Range ) ) &&
		 FastTrace( Victim.Location, Loc ) )
		return true;
	else
		return false;
}

// See if location of specified joint is within specified distance of specified actor.
function bool JointStrikeValid( actor Victim, name JName, float Range )
{
	local vector	DLoc;
	local vector	DVect;
	local float		XY, Z;

	DLoc = JointPlace( JName ).pos;

	DVect = Victim.Location - DLoc;
	Z = FMax( 0.0, Abs(DVect.Z) - Victim.CollisionHeight );
	DVect.Z = 0.0;
	XY = FMax( 0.0, VSize(DVect) - Victim.CollisionRadius );

	if ( ( ( Square( XY ) + Square( Z ) ) < Square( Range ) ) &&
		 FastTrace( Victim.Location, DLoc ) )
		return true;
	else
		return false;
}

// See if melee strike is valid.
function bool NearStrikeValid( actor Victim, int DamageNum )
{
	if ( ( DistanceTo( Victim ) <= DamageRadius ) &&
		 ( ( Physics == PHYS_Flying ) ||
		   ( Physics == PHYS_Swimming ) ||
		   ( WithinStrikingZ( Victim ) ) ) )
		return true;
	else
		return false;
}

// Inflict melee (striking) damage.
function bool InflictNearDamage( actor Victim, int Damage, vector PushDir, int DamageNum, optional float EffectStrength )
{
	local DamageInfo	DInfo;

	if ( ( Victim == none ) || ( Health <= 0 ) )
		return false;

	// Check if still in melee range.
	if ( FastTrace( Victim.Location, Location ) &&
		 NearStrikeValid( Victim, DamageNum ) )
	{	
		DInfo = getDamageInfo( 'nearattack' );
		DInfo.Damage = Damage;
		DInfo.EffectStrength = EffectStrength;
		if ( Victim.AcceptDamage( DInfo ) )
			Victim.TakeDamage( self, Victim.Location + Normal(Location - Victim.Location), PushDir, DInfo );
		return true;
	}
	return false;
}

// See if we should hate this pawn.
function CheckHatedEnemy( pawn Other )
{
	if ( ( Other != none ) &&
		 ( Other != self ) &&
		 ( ( HatedEnemy == none ) || Other.bIsPlayer || ( HatedEnemy == Enemy ) ) )
	{
		HatedEnemy = Other;
	}
}

// Took damage from this pawn, see if should switch enemy.
function CheckEnemySwitch( pawn Other )
{
	if ( ( Other == none ) || ( Other == self ) )
		return;

	if ( OldEnemy == Other )
	{
		OldEnemy = none;
		SetEnemy( Other );
	}
	else if ( ( Enemy != none ) &&
			  ( Enemy != Other ) &&
			  ( OldEnemy == none ) &&
			  ( ( !Enemy.bIsPlayer && Other.bIsPlayer ) || ( !Other.bIsPlayer && ( FRand() < 0.99 ) ) ) )
	{
		OldEnemy = Enemy;

		// rgc: no infigting
		if ( !RGC() || Other.bIsPlayer || AttitudeToCreature( Other ) != ATTITUDE_Friendly )
			SetEnemy( Other );
	}
}

// Save state, label on state stack.
function bool PushState( name ThisState, name ThisLabel )
{
	if ( StateIndex < ArrayCount(StateStack) )
	{
		StateStack[StateIndex].StateName = ThisState;
		StateStack[StateIndex].StateLabel = ThisLabel;
		StateIndex += 1;
		return true;
	}
	else
	{
		DebugErrorMessage( name $ "**** REACHED STATE STACK LIMIT ****" );
	}
	return false;
}

// Pop top of state stack and go to it, or use forced state, label.
function bool PopState( optional name ForceState, optional name ForceLabel )
{
	local name		NextState;
	local name		NextLabel;

	if ( StateIndex > 0 )
	{
		StateIndex -= 1;
		if ( ForceState != '' )
			NextState = ForceState;
		else
			NextState = StateStack[StateIndex].StateName;
		if ( ForceLabel != '' )
			NextLabel = ForceLabel;
		else
			NextLabel = StateStack[StateIndex].StateLabel;
		GotoState( NextState, NextLabel );
		return true;
	}
	return false;
}

function ResetStateStack()
{
	StateIndex = 0;
}

// Set primary looking target.
function SetLookAt( actor Lookie )
{
	LookAtManager.SetTarget( Lookie );
}

// Add a (temporary) looking target to the manager.
function PushLookAt( actor NewTarget, optional float Duration )
{
	LookAtManager.PushTarget( NewTarget, Duration );
}

// Remover the top-most looking target from the manager.
function PopLookAt()
{
	LookAtManager.PopTarget();
}

// Set creature and prop Opacity.
function SetOpacity( float OValue )
{
	local int		PNum;

	Opacity = OValue;
	for ( PNum = 0; PNum < 4; PNum++ )
	{
		if ( MyProp[PNum] != none )
			MyProp[PNum].Opacity = OValue;
	}

	if ( RangedWeapon != none )
		RangedWeapon.Opacity = OValue;
}

// Set creature and prop DrawScale.
function SetDrawScale( float OValue )
{
	local int		PNum;

	DrawScale = OValue;
	for ( PNum = 0; PNum < 4; PNum++ )
	{
		if ( MyProp[PNum] != none )
			MyProp[PNum].DrawScale = DrawScale;
	}
}

function GiveModifiers()
{
	// give the player a SphereOfCold Modifier
	if ( FireMod == None )
		FireMod = Spawn(class 'FireModifier', self,,Location);

	// give the player a SphereOfCold Modifier
	if ( SphereOfColdMod == None )
		SphereOfColdMod = Spawn(class 'SphereOfColdModifier', self,,Location);

	// give the player a Shala's Vortex Modifier
	if ( FireFlyMod == None )
		FireFlyMod = Spawn(class 'FireFlyModifier', self,,Location);
}

function KillModifiers()
{
	if ( FireMod != none )
	{
		FireMod.Destroy();
		FireMod = none;
	}
	if ( SphereOfColdMod != none )
	{
		SphereOfColdMod.Destroy();
		SphereOfColdMod = none;
	}
	if ( FireFlyMod != none )
	{
		FireFlyMod.Destroy();
		FireFlyMod = none;
	}
}

function FireEvent( name EName )
{
	local actor		AActor;

	if ( EName != '' )
		foreach AllActors( class'actor', AActor, EName )
		{
			if ( AActor.IsA('Trigger') )
			{
				if ( Trigger(AActor).bPassThru )
				{
					Trigger(AActor).PassThru( self );
				}
			}
			AActor.Trigger( self, Instigator );
		}
}

function SetFrozenPhysics()
{
	SetPhysics( PHYS_Falling );
}

//****************************************************************************
//  <End>  misc. support functions.
//****************************************************************************


//****************************************************************************
// <Begin> sound functions
//****************************************************************************

// Calculate a random number with variance.
function int IVariant( int BaseVal, int Variant )
{
	return BaseVal - Variant + Rand( Variant * 2 );
}

// Plays a greeting sound
function PlayGreetSound()
{
	if ( GreetSound != none )
		PlaySound( GreetSound, SLOT_Talk, , true );
}


//****************************************************************************
//  <End>  sound functions
//****************************************************************************


//****************************************************************************
// <Begin> AI state transition functions
//****************************************************************************

function ClearOrdersIf( name ThisState )
{
	if ( OrderState == ThisState )
	{
		OrderState = '';
		OrderTag = '';
	}

	if ( LastState == ThisState )
	{
		LastState = '';
		LastLabel = '';
	}
}

// save the passed state and label in local members
function SetLastState( name ThisState, name ThisLabel )
{
	if ( LastState == '' )
	{
		LastState = ThisState;
		LastLabel = ThisLabel;
	}
}

function GotoLastState()
{
	if ( LastState != '' )
	{
		DebugInfoMessage( ".GotoLastState(), LastState is " $ LastState $ ", LastLabel is " $ LastLabel );
		GotoState( LastState, LastLabel );
		LastState = '';
	}
	else
	{
		DebugInfoMessage( ".GotoLastState(), LastState is none, going to AIWait." );
		GotoState( 'AIWait' );
	}
}

function GotoInitState()
{
	SetEnemy( none );
	NoLook();
	if ( OrderState != '' )
		GotoState( OrderState );
	else if ( DefCon == 0 )
		GotoState( 'AIWait' );
	else
		GotoState( 'AIAmbush' );
}

// set up the chaining AI state and animation when a fall begins
function SetFall()
{
	local actor		HitActor;
	local vector	HitLocation, HitNormal;
	local int		HitJoint;

	SetPhysics( PHYS_Falling );
	if ( Rotation.Roll != 0 )
	{
		DesiredRotation.Roll = 0;
		RotationRate.Roll = 10;
	}

	HitActor = Trace( HitLocation, HitNormal, HitJoint, Location + vect(0,0,-2000), Location, false );
	if ( ( HitActor == none ) || ( VSize(HitLocation - Location) > 1000 ) )
	{
//		PlaySoundScream();
		if ( GetStateName() != 'AIFall' )
			FallFromState = GetStateName();
		GotoState( 'AIFall', 'LONGFALL' );
	}
	else if ( VSize(HitLocation - Location) > ( CollisionHeight * 3 ) )
	{
		PlayInAir();
		if ( GetStateName() != 'AIFall' )
			FallFromState = GetStateName();
		GotoState( 'AIFall' );
	}
}

//****************************************************************************
//  <End>  AI state transition functions
//****************************************************************************


//****************************************************************************
// <Begin> AI utility/navigation functions
//****************************************************************************

function vector ComputeTeleportLocation( vector here )
{
	local vector	HitLocation, HitNormal;
	local int		HitJoint;

	Trace( HitLocation, HitNormal, HitJoint, here - vect(0,0,500), here, false );
	return HitLocation + ( vect(0,0,1) * CollisionHeight );
}

// See if there is an AeonsAmbushPoint duet that I can use when I'm lost.
function AeonsAmbushPoint FindAmbushWhenLost( vector FromHere )
{
	local AeonsAmbushPoint	AP;
	local vector			OLoc;

	foreach AllActors( class'AeonsAmbushPoint', AP )
	{
		DebugInfoMessage( ".FindAmbushWhenLost(), trying " $ AP.name $ ", AP.MatingPoint is " $ AP.MatingPoint.name );
		if ( ( AP.MatingPoint != none ) && 
			 ( VSize(AP.Location - FromHere) < 1500.0 ) && 
			 CanPathTo( AP.MatingPoint ) )
		{
			OLoc = Location;
			SetLocation( ComputeTeleportLocation( AP.Location ) );
			DebugInfoMessage( ".FindAmbushWhenLost(), after setting location, CanPathTo( Enemy ) is " $ CanPathTo( Enemy ) );
			if ( CanPathTo( Enemy ) )
			{
				SetLocation( OLoc );
				return AP.MatingPoint;
			}
			SetLocation( OLoc );
		}
	}
	return none;
}

// Check if creature can switch from long-range to melee weapon.
function bool TriggerSwitchToMelee()
{
	return ( bHasFarAttack && bCanSwitchToMelee && ( DistanceTo( Enemy ) < MeleeSwitchDistance ) && CanPathTo( Enemy ) );
}

function bool TriggerSwitchToRanged()
{
	return ( bHasNearAttack && bCanSwitchToRanged && ( ( DistanceTo( Enemy ) > RangedSwitchDistance ) || !CanPathTo( Enemy ) ) );
}

function vector GetStepLocation()
{
	return Location + ( vector(Rotation) * CollisionRadius * 4.0 );
}

// See if creature can safely step forward.
function bool CanStepForward()
{
	local vector	X, Y, Z;
	local vector	SPoint1;
	local vector	SPoint2;
	local vector	EPoint1;
	local vector	EPoint2;
	local vector	GPoint1;
	local vector	GPoint2;

	GetAxes( Rotation, X, Y, Z );
	SPoint1 = EyeLocation();
	EPoint1 = SPoint1 + ( X * CollisionRadius * 3.0 );
	SPoint2 = Location - ( Z * ( CollisionHeight - MaxStepHeight ) );
	EPoint2 = SPoint2 + ( X * CollisionRadius * 3.0 );
	if ( FastTrace( SPoint1, EPoint1 ) && FastTrace( SPoint2, EPoint2 ) )
	{
		DebugInfoMessage( ".CanStepForward(), clear from eye point straight ahead" );
		// Clear from eye point straight ahead a fair distance.
		GPoint1 = EPoint1 + vect(0,0,-1) * ( CollisionHeight + EyeHeight );
		if ( FastTrace( GPoint1, EPoint1 ) )
		{
			DebugInfoMessage( ".CanStepForward(), clear from that point down to feet" );
			// Clear from that point straight down to feet.
			GPoint2 = GPoint1 + vect(0,0,-1) * JumpDownDistance;
			// Returns true if step is not too far down.
			if ( FastTrace( GPoint2, GPoint1 ) )
			{
				DebugInfoMessage( ".CanStepForward(), too far from feet to point below" );
				return false;
			}
			else
			{
				DebugInfoMessage( ".CanStepForward(), from feet to point below hits level -- OK" );
				return true;
			}
//			return !FastTrace( GPoint2, OPoint );
		}
		else
		{
			DebugInfoMessage( ".CanStepForward(), NOT clear from that point down to feet" );
		}
	}
	else
	{
		DebugInfoMessage( ".CanStepForward(), NOT clear straight ahead" );
	}
	return false;
}

// See if creature should fly to point (if able to)
function bool FlightTo( vector TPoint, optional bool bNoPhysCheck )
{
	if ( bCanFly && FastTrace( TPoint ) )
	{
		if ( !bNoPhysCheck && ( Enemy != none ) )
			return ( Enemy.Physics == PHYS_Flying );
		return true;
	}
	else
		return false;
}

// See if should chase using flight.
function bool ShouldChasePoint( vector ThisPoint )
{
	return false;
}

// Calculate a flight chase point.
function vector FlightChasePoint( vector ActualPoint )
{
	return ActualPoint;
}

function bool UseFlightCutoff( pawn APawn )
{
	return ( ( DistanceTo( APawn ) > ( CollisionRadius * 5.0 ) ) &&
			 ( ( Normal(APawn.Velocity) dot Normal(APawn.Location - Location) ) < 0.0 ) );
}

// Return a location that leads the actor a bit
function vector FlightCutoffPoint( pawn APawn )
{
	return APawn.Location + ( APawn.BaseEyeHeight * vect(0,0,1) ) + ( APawn.Velocity * 1.5 );
}

// Calculate a target location based on the (navigation point) actor passed.
function vector FlightToNavPoint( actor NavPoint, float thisHeight )
{
	local vector	PLoc;
	local vector	HitLocation, HitNormal;
	local int		HitJoint;

	PLoc = NavPoint.Location;
	if ( FastTrace( PLoc, PLoc - vect(0,0,1.1) * thisHeight ) )
		return PLoc;	// point is in mid air, so aim for it as is
	else
	{
		Trace( HitLocation, HitNormal, HitJoint, PLoc - vect(0,0,500), PLoc, false );
		return HitLocation + vect(0,0,1.1) * thisHeight;
	}
}

// Adjust the calculated height of the pending jump.
function float AdjustJumpHeight( float oldZ )
{
	return oldZ * JumpScalar;
}

// Calculate the velocity vector needed to make jump.
function vector CalculateJump( vector ThisLoc )
{
	local vector	dVect;
	local vector	jVect;
	local float		xySpeed;
	local float		FallVelocity;
	local float		LiftVelocity;
	local float		Gravity;
	local float		ZDist;
	local float		FallTime;
	local float		ZHigh;
	local float		LiftTime;
	local float		ZVelocity;

	dVect = ThisLoc - ( Location - ( vect(0,0,1) * CollisionHeight ) );
	if ( dVect.Z < 0.0 )
	{
		ZDist = -dVect.Z + ( CollisionHeight * 0.60 );
		ZHigh = -dVect.Z;
	}
	else
	{
		ZDist = dVect.Z + ( CollisionHeight * 0.60 );
		ZHigh = dVect.Z;
	}

	ZDist = AdjustJumpHeight( ZDist );
	Gravity = Region.Zone.ZoneGravity.Z;
	FallTime = 0.0;
	LiftTime = 0.0;
	FallVelocity = 0.0;
	LiftVelocity = 0.0;

	while ( ( ZDist > 0.0 ) && ( FallTime < 10.0 ) )
	{
		if ( ZDist > ZHigh )
		{
			LiftTime = LiftTime + 0.05;
			LiftVelocity = LiftVelocity + ( Gravity * 0.05 );
		}
		FallVelocity = FallVelocity + ( Gravity * 0.05 );
		FallTime = FallTime + 0.05;
		ZDist = ZDist + ( FallVelocity * 0.05 );
	}

	if ( dVect.Z < 0.0 )
	{
		// Jump downward.
		ZVelocity = -LiftVelocity;
	}
	else
	{
		// Jump upward.
		ZVelocity = Min( MaxJumpZ, -FallVelocity );
	}
	jVect = Normal(dVect);
	dVect.Z = 0.0;
	xySpeed = ( VSize(dVect) / ( FallTime + LiftTime ) );
	xySpeed = Min( xySpeed, AirSpeed );
	DebugInfoMessage( ".CalculateJump(), xySpeed is " $ xySpeed );
	DesiredSpeed = xySpeed / GroundSpeed;
	jVect = jVect * xySpeed;
	jVect.Z = ZVelocity;
	return jVect;
}

// Determine if this encounter should be handled specially.
function bool HandleSpecialEncounter( actor Other )
{
	return false;
}

// Calculate a semi-valid goto point based on the location passed.
function vector GetGotoPoint( vector thisLocation )
{
	local vector	HitLocation, HitNormal;
	local int		HitJoint;

	Trace( HitLocation, HitNormal, HitJoint, thisLocation - vect(0,0,500), thisLocation, false );
	return HitLocation + ( vect(0,0,1) * CollisionHeight );
//	return HitLocation + ( vect(0,0,1) * ( CollisionHeight + BaseEyeHeight ) );
}

// Calculate a semi-valid flight goto point based on the location passed.
function vector GetFlightGotoPoint( vector thisLocation, float Altitude )
{
	local vector	HitLocation, HitNormal;
	local int		HitJoint;
	local vector	GPoint;

	Trace( HitLocation, HitNormal, HitJoint, thisLocation - vect(0,0,500), thisLocation, false );
	GPoint = HitLocation + ( vect(0,0,1) * Altitude );
	if ( FastTrace( GPoint, HitLocation ) )
		return GPoint;
	else
		return thisLocation;
}

// Calculate a semi-valid goto point (near ground is ensured) based on the location passed.
function vector GetGroundPoint( vector thisLocation )
{
	local vector	HitLocation, HitNormal;
	local int		HitJoint;

	Trace( HitLocation, HitNormal, HitJoint, thisLocation - vect(0,0,32000), thisLocation, false );
	return HitLocation + ( vect(0,0,1) * CollisionHeight );
//	return HitLocation + ( vect(0,0,1) * ( CollisionHeight + BaseEyeHeight ) );
}

// Get a point the specified distance from the location.
function vector GetEnRoutePoint( vector TargetLoc, float Distance )
{
	if ( Distance > 0.0 )
	{
		// Calculate point from current location.
		if ( VSize(TargetLoc - Location) > Distance )
			return Location + Normal(TargetLoc - Location) * Distance;
		else
			return TargetLoc;
	}
	else
	{
		// Calculate point from target location.
		if ( VSize(TargetLoc - Location) > -Distance )
			return TargetLoc - Normal(Location - TargetLoc) * Distance;
		else
			return Location;
	}
}

// determine if the (next) NavigationPoint needs special processing (override in special cases)
function bool UseSpecialNavigation( NavigationPoint navPoint )
{
	return false;
}

// Determine if creature should use a special nav move while pursuing the player in a direct path.
function bool UseSpecialDirect( vector TargetLoc )
{
	return false;
}

// determine if the (current) NavigationPoint needs special processing (override in special cases)
function bool SpecialNavChoiceAction( NavigationPoint navPoint )
{
	return false;
}

// Using special navigation at this point.
function SpecialNavChoiceActing( NavigationPoint navPoint )
{
}

// determine if the (current) NavChoiceTarget needs special processing (override in special cases)
function bool SpecialNavTargetAction( NavChoiceTarget NavTarget )
{
	return false;
}

// find nearest NavigationPoint to location passed
function NavigationPoint FindNearestNavPoint( vector here )
{
	local NavigationPoint	nPoint, bestPoint;
	local float				bestDist;

	bestPoint = none;
	for ( nPoint = Level.NavigationPointList; nPoint != none; nPoint = nPoint.NextNavigationPoint )
	{
		if ( ( bestPoint == none ) || ( VSize(here - nPoint.Location) < bestDist ) )
		{
			bestPoint = nPoint;
			bestDist = VSize(here - nPoint.Location);
		}
	}
	return bestPoint;
}

function bool CanTurnTo( vector OtherLoc )
{
	return true;
}

function bool CanTurnToward( actor Other )
{
	return true;
}

function bool ShouldRunTo( actor Other )
{
	DebugInfoMessage( ".ShoudRunTo(), distance is " $ PathDistanceTo( Other ) );
	return ( PathDistanceTo( Other ) > RunDistance );
}

function bool ShouldRunToPoint( vector OtherLoc )
{
	DebugInfoMessage( ".ShoudRunToPoint(), distance is " $ PathDistanceToPoint( OtherLoc ) );
	return ( PathDistanceToPoint( OtherLoc ) > RunDistance );
}

// Determine if actor can be reached (direct or path)
function bool CanPathTo( actor Other )
{
	return ( actorReachable( Other ) || ( PathToward( Other ) != none ) );
}

// Determine if point can be reached (direct or path)
function bool CanPathToPoint( vector OtherLoc )
{
	return ( pointReachable( OtherLoc ) || ( PathTowardPoint( OtherLoc ) != none ) );
}

// Calculate the distance (direct or path) to the actor
function float PathDistanceTo( actor Other )
{
	if ( actorReachable( Other ) )
		return DistanceTo( Other );
	else if ( PathToward( Other ) != none )
		return RouteDistance();
	else
		return -1.0;
}

// Calculate the distance (direct or path) to the location
function float PathDistanceToPoint( vector OtherLoc )
{
	if ( pointReachable( OtherLoc ) )
		return DistanceToPoint( OtherLoc );
	else if ( PathTowardPoint( OtherLoc ) != none )
		return RouteDistance();
	else
		return -1.0;
}

// Determine if the path to target actor passes the avoid actor.
function bool PathToPasses( actor Target, actor Avoid )
{
	local vector	DVect, sPoint, tPoint;
	local int		i;

	if ( actorReachable( Target ) )
	{
		DVect = Normal(Target.Location - Location);
		return ( ( Normal(Avoid.Location - Location) dot DVect ) > 0.50 ) && ( ( Normal(Avoid.Location - Target.Location) dot -DVect ) > 0.50 );
	}
	else if ( PathToward( Target ) != none )
	{
		sPoint = Location;
		for ( i = 0; i < 16; i++ )
		{
			if ( RouteCache[i] != none )
			{
				tPoint = RouteCache[i].Location;
				DVect = Normal(tPoint - sPoint);
				if ( ( ( Normal(Avoid.Location - sPoint) dot DVect ) > 0.50 ) && ( ( Normal(Avoid.Location - tPoint) dot -DVect ) > 0.50 ) )
					return true;
				sPoint = tPoint;
			}
			else
				break;
		}
		return false;
	}
	else
		return false;
}

// Calculate to distance between the point passed and the ground.
function float PointDistanceToGround( vector OtherLoc )
{
	local vector	HitLocation, HitNormal;
	local int		HitJoint;

	Trace( HitLocation, HitNormal, HitJoint, OtherLoc - vect(0,0,33000), OtherLoc, false );
	return OtherLoc.Z - HitLocation.Z;
}

// Calculate to distance between the location of the actor passed and the ground.
function float DistanceToGround( actor Other )
{
	return PointDistanceToGround( Other.Location );
}

// calculate the raw distance to the actor passed
function float DistanceTo( actor Other )
{
	local vector	DVect;

	if ( Other != none )
	{
		if ( Abs(Location.Z - Other.Location.Z) < ( CollisionHeight + Other.CollisionHeight ) )
		{
			// Z overlap.
			DVect = Location - Other.Location;
			DVect.Z = 0;
			return FMax( VSize(DVect) - CollisionRadius - Other.CollisionRadius, 0.0 );
		}
		/*
		else if ( ( Square(Location.X - Other.Location.X) + Square(Location.Y - Other.Location.Y) ) < Square(CollisionRadius + Other.CollisionRadius) )
		{
			// XY overlap.
			return VSize(Location - Other.Location) - CollisionHeight - Other.CollisionHeight;
		}
		*/
		else
			return FMax( VSize(Location - Other.Location) - FMax( Other.CollisionRadius, Other.CollisionHeight ) - FMax( CollisionRadius, CollisionHeight ), 0.0 );
	}
	return 0.0;
}

// calculate the raw distance to the location passed
function float DistanceToPoint( vector Other )
{
	return FMax( VSize(Other - Location) - CollisionRadius, 0.0 );
}

// determine if creature is close (in X-Y) to the location passed
// Z-distance is only considered WRT collision height
function bool CloseToPoint( vector Other, float rMult )
{
	return ( ( Abs(Location.Z - Other.Z) < CollisionHeight ) &&
			 ( Square(Location.X - Other.X) + Square(Location.Y - Other.Y) < Square(CollisionRadius * rMult) ) );
}

// find the (first) actor whose tag matches the tag passed
function actor FindTaggedActor( name aTag )
{
	local actor	aActor;

	if ( ATag != '' )
		foreach AllActors( class'actor', aActor, aTag )
			return aActor;

	return none;
}

// find the (first) pawn whose tag matches the tag passed
function pawn FindTaggedPawn( name aTag )
{
	local pawn	aPawn;

	if ( aTag != '' )
		foreach AllActors( class'Pawn', aPawn, aTag )
			return aPawn;

	return none;
}

// find the first PlayerPawn with bIsPlayer set
function pawn FindPlayer()
{
	local pawn	aPawn;

	if (Level.NetMode != NM_Standalone)
	{
		return FindClosestPlayer();
	}

	aPawn = Level.PawnList;
	while ( aPawn != none )
	{
		if ( ( PlayerPawn(aPawn) != none ) && aPawn.bIsPlayer )
		{
			return aPawn;
		}
		aPawn = aPawn.nextPawn;
	}

	return none;
}

function Pawn FindClosestPlayer()
{
	local Pawn P;
	local Pawn Best;
	local float BestDist, Dist;

	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
	{
		if ( PlayerPawn(P) != None && P.bIsPlayer )
		{
			//Dist = PathDistanceToPoint(P.Location);
			Dist = DistanceToPoint(P.Location);
			//Dist = VSize(P.Location - Location);
			//Dist = PathDistanceTo( P );
			if ( Best == None || Dist < BestDist )
			{
				BestDist = Dist;
				Best = P;
			}
		}
	}

	return Best;
}

function pawn FindAppropriateEnemy()
{
	local pawn		P, BestP;
	local float		D, BestD;

	if ( HatedClass != none )
	{
		BestP = none;
		foreach AllActors( class'pawn', P )
			if ( P.IsA(HatedClass.name) && P.bIsHated && CanPathTo( P ) )
			{
				D = PathDistanceTo( P );
				if ( ( BestP == none ) || ( D < BestD ) )
				{
					BestP = P;
					BestD = D;
				}
			}
	}
	if ( BestP != none )
		return BestP;
	else if ( AttitudeToPlayer == ATTITUDE_Hate )
		return FindPlayer();
	else
		return none;
}

// Enable the primary senses.
function EnableSenses()
{
	// Enable the sense effectors.
	VisionEffector.EnableSensor();
	HearingEffector.EnableSensor();
}

// Disable the primary senses.
function DisableSenses()
{
	// Disable the sense effectors.
	VisionEffector.DisableSensor( -1.0 );
	HearingEffector.DisableSensor( -1.0 );
}

// See if this pawn is hated by me.
function bool IsHatedPawn( pawn Other )
{
	return Other.bIsHated;
}

// see if we should even bother encountering this actor after a stimulus
function bool PreCheckEncounter( actor Other )
{
	if ( ( Other == self ) || ( pawn(Other) == none ) || ( pawn(Other).Health <= 0 ) )
		return false;
	if ( ( PlayerPawn(Other) == none ) && ( ScriptedPawn(Other) == none ) )
		return false;

	if ( ScriptedPawn(Other) != none )
	{
		// Other is a ScriptedPawn, only called when engine has called SeeHatedPawn, so encounter is valid
		return IsHatedPawn( pawn(Other) );
	}
	else
	{
		// Other is a PlayerPawn
		if ( AttitudeTo( pawn(Other) ) != ATTITUDE_Ignore )
			return true;
	}
	return false;
}

// Return world location of ranged weapon.
function vector WeaponLoc()
{
	return RangedWeapon.Location;
}

// Calculate and adjust aim at a target Pawn.  Adjust for speed of target and projectile, if desired.
// Will factor in BaseEyeHeight to try to make a head shot.
function rotator WeaponAimAt( pawn Target, vector ProjStart, float Accuracy, optional bool bLeadTarget, optional float ProjSpeed )
{
	local vector		TLocation;
	local vector		TX, TY, TZ;

	if ( EyesCanSee( Target.Location ) )
	{
		if ( bLeadTarget )
			TLocation = Target.Location + Target.Velocity * ( VSize(Target.Location - ProjStart) / ProjSpeed );
		else
			TLocation = Target.Location;
	}
	else
		TLocation = LastSeenPos;

	GetAxes( Target.Rotation, TX, TY, TZ );
	if ( bTakeHeadShot )
		TLocation = TLocation + TZ * Target.BaseEyeHeight;
	else if ( bTakeFootShot )
		TLocation = TLocation - TZ * Target.CollisionHeight;

	return WeaponAim( TLocation, ProjStart, Accuracy );
}

// Calculate and adjust aim at a target location.
// Accuracy is 0.0 to 1.0, 1.0 being most accurate.  At 0.0, yaw is affected by +/- 10 degrees, pitch by +/- 5 degrees.
function rotator WeaponAim( vector TLocation, vector ProjStart, float Accuracy )
{
	local rotator		DRot;

	Accuracy = 1.0 - FClamp( Accuracy, 0.0, 1.0 );
	DRot = rotator(TLocation - ProjStart);
	DRot.Yaw = ( DRot.Yaw + IVariant( 0, int(1800.0 * Accuracy ) ) ) & 65535;
	DRot.Pitch = ( DRot.Pitch + IVariant( 0, int(900.0 * Accuracy ) ) ) & 65535;
	return DRot;
}

// try to set a new enemy
function bool SetEnemy( pawn NewEnemy )
{
	if ( ( NewEnemy != none ) && NewEnemy.bIsPlayer )
		bEnemyIsPlayer = true;
	else
		bEnemyIsPlayer = false;
	Enemy = NewEnemy;
//	CheckHatedEnemy( NewEnemy );
	if ( NewEnemy != none )
		SetLookAt( NewEnemy );
	return true;
}

// calculate this actor's strength (considering health & weapon) relative to the pawn passed
// returns 0.0 if equal, > 0.0 if other is stronger, < 0.0 if other is weaker
// range of return values should be [-1,+1]
// when weapon AIRating value factors in, values above 0.3 increase owner's strength, values below 0.3 decrease owner's strength
function float RelativeStrength( pawn Other )
{
	local float		compare;
	local int		adjustedStrength, adjustedOther;
	local int		bTemp;

	adjustedStrength = Health;
	if ( Other.IsA('ScriptedPawn') )
		adjustedOther = 0.5 * ( Other.Health + ScriptedPawn(Other).InitHealth );	// average other's current and default health (result is potential health?)
	else
		adjustedOther = 0.5 * ( FMin(Other.Health, Other.default.Health) + Other.default.Health ); // RGC()? cap to Other.default.Health to prevent issues if player's health overcharged
	compare = 0.01 * float(adjustedOther - adjustedStrength);		// calculate strength factor as 1% of it's health less my health
	if ( Intelligence == BRAINS_Human )
	{
		if ( Weapon != none )
		{
			compare -= ( Weapon.RateSelf( bTemp ) - 0.3 );		// if I have a weapon, decrease the strength factor
			if ( bIsPlayer && ( Weapon.AIRating < 0.3 ) )
			{
				compare += 0.2;
				if ( ( Other.Weapon != None ) && ( Other.Weapon.AIRating >= 0.3 ) )
					compare += 0.3;
			}
		}
		if ( AttSpell != none )
		{
			compare -= AttSpell.RateSelf( bTemp );		// if I have an attack spell, decrease the strength factor
		}

		if ( Other.Weapon != none )						// if it has a weapon, increase the strength factor
		{
			compare += ( Other.Weapon.RateSelf( bTemp ) - 0.3 );
		}
		if ( Other.AttSpell != none )					// if it has an attack spell, increase the strength factor
		{
			compare += Other.AttSpell.RateSelf( bTemp );
		}
		if ( Other.DefSpell != none )
		{
		}
	}
	return compare;
}

// calculate this actor's attitude towards the pawn passed
function EAttitude AttitudeTo( pawn Other )
{
	if ( ( Other == none ) || ( Other.Health <= 0 ) )
		return ATTITUDE_Ignore;

	if ( Health < ( InitHealth * RetreatThreshold ) )
		return ATTITUDE_Fear;

	if ( HatedEnemy == Other )
		return ATTITUDE_Hate;		// if I really want this enemy, regardless of strength

	if ( Other.bIsPlayer )
	{
		// Other is the player
		if ( bGenerated && ( OrderState == 'AIRetreat' ) )
		{
			return ATTITUDE_Ignore;
		}
		else if ( AttitudeToPlayer == ATTITUDE_Hate )
		{
			if ( Aggression() > RelativeStrength( Other ) )
				return ATTITUDE_Hate;
			else
				return ATTITUDE_Fear;
		}
		else
			return AttitudeToPlayer;
	}
	else
	{
		// Other is not the player
		if ( ( HatedClass != none ) && ( Other.IsA(HatedClass.name) ) )
			return AttitudeToEnemy;
		if ( ( HatedTag != '' ) && ( Other.HatedID == HatedTag ) )
			return AttitudeToEnemy;
	}
	return ATTITUDE_Ignore;
}

// return this actor's attitude to the (usually non-player) pawn passed
function EAttitude AttitudeToCreature( pawn Other )
{
	if ( Other.IsA(Class.Name) || IsA(Other.Class.Name) )
		return ATTITUDE_Friendly;
	else
		return ATTITUDE_Ignore;
}

// try to return a navigation point on the way to the actor passed
function actor PathToward( actor Other )
{
	if ( Other != none )
		return FindPathToward( Other );
	else
		return none;
}

// try to return a navigation point on the way to the OrderObject, when OrderObject isn't directly reachable
function actor PathTowardOrder()
{
	if ( OrderObject != none )
		return FindPathToward( OrderObject );
	else
		return none;
}

// try to return a navigation point on the way to the point passed
function actor PathTowardPoint( vector aPoint )
{
	return FindPathTo( aPoint );
}

// return movement scalar, based on MoveSpeed
function float MoveScale()
{
	return MoveSpeed;
}

// returns the straight-line distance required to traverse the path held in RouteCache[]
function float RouteDistance()
{
	local int		i;
	local float		dist;
	local vector	frompoint;

	dist = 0.0;
	frompoint = Location;

	for ( i = 0; i < 16; i++ )
	{
		if ( RouteCache[i] != none )
		{
			dist = dist + VSize(frompoint - RouteCache[i].Location);
			frompoint = RouteCache[i].Location;
		}
		else
			break;
	}
	return dist;
}

// TEMP
function DisplayRouteCache()
{
	local int		i;

	for ( i = 0; i < 16; i++ )
	{
		if ( RouteCache[i] != none )
			SetDebugInfo( "RouteCache[" $ i $ "] is " $ RouteCache[i].name, true );
		else
			SetDebugInfo( "RouteCache[" $ i $ "] is NULL", true );
	}
}

// see whether creature wants a far attack
function bool DoFarAttack()
{
	local float		dist;

	if ( bHasFarAttack )
	{
		if ( RangedWeapon != none )
			return DoWeaponAttack();

		dist = DistanceTo( Enemy );

		if ( FRand() < FarAttackBias )
			return true;
		else if ( dist > ( MeleeRange * 5.0 ) )
		{
			if ( dist > LongRangeDistance )
				return ( FRand() < 0.05 );
			else
				return ( FRand() < 0.45 );
		}
		else if ( dist > ( MeleeRange * 3.5 ) )
			return ( FRand() < 0.25 );
		else
			return ( FRand() < 0.05 );
	}
	return false;
}

//
function bool DoWeaponAttack()
{
	local float		dist;

	dist = DistanceTo( Enemy );

	if ( Enemy != none )
	{
		if ( ( RangedWeapon == none ) || !RangedWeapon.ReadyToFire() || !EyesCanSee( Enemy.Location ) )
			return false;

		if ( FRand() < FarAttackBias )
			return true;
		else if ( dist > LongRangeDistance )
			return ( FRand() < 0.05 );
		else if ( dist > ( MeleeRange * 5.0 ) )
			return ( FRand() < 0.45 );
		else
			return ( FRand() < 0.85 );
	}
	else
		return ( RangedWeapon != none ) && RangedWeapon.ReadyToFire();
}

//
function bool DoEncounterAnim()
{
	return ( !bNoEncounterTaunt && ( DefCon < 2 ) && ( FRand() < 0.10 ) );
}

function bool DoAwakenAnim()
{
	return false;
}

//****************************************************************************
//  <End>  AI utility/navigation functions
//****************************************************************************


//****************************************************************************
// <Begin> Team AI utility functions
//****************************************************************************

function float Aggression()
{
	if( Team != none )
	{
		return Aggressiveness + Team.Aggression()*(1.0 - Aggressiveness);
	}
	else
	{
		return Aggressiveness;
	}
}

// initialize team information
function ScriptedPawnTeam GetTeamObject()
{
	local ScriptedPawnTeam aTeam;
	local ScriptedPawn TeamLeader;
	local pawn aPawn;

	foreach AllActors( class'ScriptedPawnTeam', aTeam, TeamTag )
	{
		return aTeam;
	}

	if( bIsTeamLeader )
	{
		aTeam = spawn( TeamClass );
	}
	else if( Team == none )
	{
		aPawn = Level.PawnList;
		while ( aPawn != none )
		{
			if( ( ScriptedPawn(aPawn) != none ) && 
				( ScriptedPawn(aPawn).bIsTeamLeader ) && 
				( ScriptedPawn(aPawn).TeamTag == TeamTag ) && 
				( aPawn != self) )
			{
				TeamLeader = ScriptedPawn(aPawn);
				TeamLeader.InitTeamObject();
				aTeam = TeamLeader.Team;
				aPawn = none;
			}
			else
				aPawn = aPawn.nextPawn;
		}
	}
	return aTeam;	
}

function InitTeamObject()
{
	if( Team == none )
	{
		Team = GetTeamObject();

		if( Team != none )
		{
			Team.Init();
			bIsTeamMember = true;
			Team.RegisterMember( self );
		}
		else
		{
			DebugErrorMessage(".InitTeamObject() couldn't find or create a Team object.");
			TeamTag = '';
		}
	}
}

function InitializeTeam()
{
	InitTeamObject();
}

// message all team members
singular function SendTeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator )
{
	if( Team != none )
	{
		Team.SendMessage( message, sender, instigator );
	}
}

function bool ShouldChargeCovered( ScriptedPawn sender, actor instigator )
{
	return IsCoveredState() && Team.ShouldCharge( self, sender, instigator );
}

function bool ShouldSupportAdvance( ScriptedPawn sender, actor instigator )
{
	return IsCoveredState() && Team.ShouldSupport( self, sender, instigator );
}

function TeamAdvanceMessage( ScriptedPawn sender, actor instigator )
{
	if ( ShouldChargeCovered( sender, instigator ) )
	{
		GotoState( 'AIChargeCovered', 'ADVANCE' );
	}
	else if ( ShouldSupportAdvance( sender, instigator ) )
	{
		PushState( GetStateName(), 'RESUME' );
		GotoState( 'AICoveredAttack', 'BEGIN' );
	}
}

// receive message from team leader
// ScriptedPawn can generate the following messages:
function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator )
{
	DebugInfoMessage( ".TeamAIMessage(), message = " $ message );
	// TODO: this is where all team communications arrive
	if ( (message == TM_TakeDamage) || (message == TM_EnemyAcquired) )
	{
		CheckHatedEnemy( pawn(instigator) );

		if ( PreCheckEncounter( instigator ) )
		{
			SetLastState( GetStateName(), 'RESUME' );
			SensedActor = instigator;
			SensedSense = 'TeamAIMessage';
			GotoState( 'AIEncounter', 'BEGIN_DELAYED' );
		}
	}
	else if ( message == TM_Advance )
	{
		TeamAdvanceMessage( sender, instigator );
	}
	else if ( message == TM_Alert )
	{
		SetDefCon( 1 );
	}
}

// handle team member being killed
function TeamMemberKilled( pawn killed )
{
	if( Team != none )
	{
		Team.MemberKilled( killed );
	}
}

// Called when this pawn becomes new team leader.
function TeamNewLeader( pawn OldLeader )
{
}

// TEMP function
function LogTeamList()
{
	if( Team != none )
	{
		Team.LogTeam();
	}
	else
	{
		DebugLogMessage( "** this actor has no team **" );
	}
}

// called to verify if this creature is covering the point passed
function bool IsCovering( AeonsCoverPoint thisPoint )
{
	return ( thisPoint == CoverPoint );
}

//
function bool IsCoveredState()
{
	return false;
}

function bool ExecutingState( name StateName )
{
	local int i;

	if( StateName == GetStateName() )
		return true;

	for(i = 0; i < StateIndex; ++i )
	{
		if( StateName == StateStack[i].StateName )
			return true;
	}

	return false;
}

function bool IsRetreating()
{
	return ExecutingState( 'AIRetreat' );
}

function bool IsTeamMember( ScriptedPawn member )
{
	if((member == none) || (Team == none))
		return false;

	return Team.IsMember( member );
}

//****************************************************************************
//  <End>  Team AI utility functions
//****************************************************************************


//****************************************************************************
// <Begin> Effector utility functions
//****************************************************************************

// add Effector to linked list (usually called by the Effector)
function AddEffector( SPEffector effector )
{
	effector.nextEffector = FirstEffector;
	FirstEffector = effector;
}

// remove Effector from list (usually called by the Effector)
function RemoveEffector( SPEffector effector )
{
	local SPEffector	pEffector;

	if ( FirstEffector == effector )
	{
		FirstEffector = effector.nextEffector;
		effector.nextEffector = none;
	}
	else
	{
		pEffector = FirstEffector;

		while ( pEffector != none )
		{
			if ( pEffector.nextEffector == effector )
			{
				pEffector.nextEffector = effector.nextEffector;
				effector.nextEffector = none;
				break;
			}
			pEffector = pEffector.nextEffector;
		}
	}
}

// notification that this Effector is about to be removed
function LosingEffector( SPEffector effector )
{
}

// notification that this effector is applying timed effect
function EffectorApplyEffect( SPEffector effector, int count )
{
}

// find the first effector of the specified class name
function SPEffector FindEffector( class<actor> classID )
{
	local SPEffector	pEffector;

	pEffector = FirstEffector;
	while ( pEffector != none )
	{
		if ( pEffector.IsA(classID.name) )
			return pEffector;
		pEffector = pEffector.nextEffector;
	}
	return none;
}

// spawn an effector of the class passed and attach it to this host
// if bLocate is true, try to find an existing one of the same class
function SPEffector SpawnEffector( class<actor> classID, optional bool bLocate, optional bool bNoInsert )
{
	local SPEffector	pEffector;

	if ( bLocate )
	{
		pEffector = FirstEffector;
		while ( pEffector != none )
		{
			if ( pEffector.IsA( classID.name ) )
				return pEffector;
			pEffector = pEffector.nextEffector;
		}
	}

	pEffector = SPEffector(Spawn( classID, self ));
	if ( ( pEffector != none ) && !bNoInsert )
		pEffector.AttachToHost( self );
	return pEffector;
}

// initialize local effectors for this ScriptedPawn
function InitEffectors()
{
	// TODO: may want to remove these special effectors from the linked list -- YES, WE DO
	if ( HearingEffector == none )
	{
		HearingEffector = SPHearingEffector(SpawnEffector( class'SPHearingEffector',, true ));
		HearingEffector.SetAlarmThreshold( HearingEffectorThreshold );
	}
	if ( VisionEffector == none )
	{
		VisionEffector = SPVisionEffector(SpawnEffector( class'SPVisionEffector',, true ));
		VisionEffector.SetAlarmThreshold( VisionEffectorThreshold );
	}
	if ( LookAtManager == none )
		LookAtManager = SPLookAtManager(SpawnEffector( class'SPLookAtManager',, true ));
	if ( OpacityEffector == none )
		OpacityEffector = SPOpacityEffector(SpawnEffector( class'SPOpacityEffector',, true ));
}

// kill persistent effectors for this ScriptedPawn
function KillEffectors()
{
	if ( HearingEffector != none )
	{
		HearingEffector.Destroy();
		HearingEffector = none;
	}
	if ( VisionEffector != none )
	{
		VisionEffector.Destroy();
		VisionEffector = none;
	}
	if ( LookAtManager != none )
	{
		LookAtManager.Destroy();
		LookAtManager = none;
	}
	if ( OpacityEffector != none )
	{
		OpacityEffector.Destroy();
		OpacityEffector = none;
	}
}

// delete the entire effector list
function KillEffectorList()
{
	local SPEffector	pEffector;
	local SPEffector	next;

	pEffector = FirstEffector;
	while ( pEffector != none )
	{
		next = pEffector.nextEffector;
		pEffector.Destroy();
		pEffector = next;
	}
	FirstEffector = none;
}

//****************************************************************************
//  <End>  Effector utility functions
//****************************************************************************

//****************************************************************************
// <Begin> Script following functions
//****************************************************************************

function FastScript( bool Flag )
{
}

function CustomScriptAction( name AName, sound ASound, float AFloat, bool ABool )
{
}

function NarratorScript FindScript( name ThisTag )
{
	local NarratorScript	pScript;

	if ( ThisTag != '' )
		foreach AllActors( class'NarratorScript', pScript, ThisTag )
			return pScript;
	return none;
}

function CheckRunon()
{
	if ( LastScriptTime == Level.TimeSeconds )
	{
		ScriptCounter += 1;
		if ( ScriptCounter > 50 )
		{
			DebugErrorMessage( name $ "**** RUN-ON SCRIPT ****" );
			GotoState( 'AIRunScript', 'ENDSCRIPT' );
		}
	}
	else
	{
		LastScriptTime = Level.TimeSeconds;
		ScriptCounter = 0;
	}
}

function NextAction()
{
	CheckRunon();
	if ( Script != none )
		ScriptAction = Script.NextAction( ScriptAction );
}

function NarratorScript.EScriptAction GetScriptAction()
{
	if ( Script != none )
		return Script.GetAction( ScriptAction );
	return ACTION_None;
}

function name GetScriptName()
{
	if ( Script != none )
		return Script.GetName( ScriptAction );
	return '';
}

function Sound GetScriptSound()
{
	if ( Script != none )
		return Script.GetSound( ScriptAction );
	return none;
}

function float GetScriptValue()
{
	if ( Script != none )
		return Script.GetValue( ScriptAction );
	return 0.0;
}

function bool GetScriptBool()
{
	if ( Script != none )
		return Script.GetBool( ScriptAction );
	return false;
}

//****************************************************************************
//  <End>  Script following functions
//****************************************************************************


//****************************************************************************
//****************************************************************************
//****************************************************************************
// BASE AI
//****************************************************************************
//****************************************************************************
//****************************************************************************


//****************************************************************************
// AIStart
// Default startup state
//****************************************************************************
auto state AIStart
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function LongFall(){}
	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo ){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}

	// *** overridden functions ***

	// *** new (state only) functions ***
	function TempStartup()
	{
		local pawn	P;
		local HUD	H;

		P = FindPlayer();
		if ( PlayerPawn(P) != none )
		{
			H = PlayerPawn(P).myHUD;
			if ( AeonsHUD(H) != none )
				DebugInfoMessage( ".AIStart, VersionMessage is " $ AeonsHUD(H).VersionMessage );
		}
	}


RESUME:
// Default entry point
BEGIN:
	TempStartup();
	EyeHeight = BaseEyeHeight;

	if ( OrderState != '' )
		GotoState( OrderState );

	GotoState( 'AIWait' );
} // state AIStart


//****************************************************************************
// AIWait
// wait for encounter at current location
//****************************************************************************
state AIWait
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***
	function BeginState()
	{
		ResetStateStack();
		DebugBeginState();
		StopTimer();
	}

	function Timer()
	{
		if ( DefCon == 0 )
		{
			TriggerEvent();
			GotoState( , 'ANIMWAIT' );
		}
		else
			GotoState( , 'ALERT' );
	}

	function DefConChanged( int OldValue, int NewValue )
	{
		PlayWait();
	}

	function RespondToSOS( actor Caller )
	{
		HandleSOS( Caller );
	}

	function bool HandlePowderOfSiren( actor Other )
	{
		DispatchPowder( Other );
		return true;
	}

	// *** new (state only) functions ***
	function TriggerEvent()
	{
	}

	function CueNextEvent()
	{
	}

	function PlayWaitAnim()
	{
		PlayWait();
	}


ALERT:
	PlayWait();
	goto 'END';

ANIMWAIT:
	FinishAnim();
	CueNextEvent();
	goto 'WAIT';

// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	WaitForLanding();
	StopMovement();
	CueNextEvent();

WAIT:
	PlayWaitAnim();

END:
} // state AIWait


//****************************************************************************
// AILookTest
//****************************************************************************
state AILookTest
{
	function BeginState()
	{
		SetLookAt( FindPlayer() );
		GotoState( 'AIWait' );
	}

} // state AILookTest


//****************************************************************************
// AISenseDebug
//****************************************************************************
state AISenseDebug
{
	// *** ignored functions ***
	function Bump( actor Other ){}
//	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function LongFall(){}
	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo ){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}

	// *** overridden functions ***
	function HearNoise( float Loudness, actor NoiseMaker )
	{
		DebugInfoMessage( " HearNoise() @ " $ Level.TimeSeconds $ ", Loudness = " $ Loudness $ ", Distance = " $ VSize(Location-NoiseMaker.Location) $ ", NoiseMaker = " $ NoiseMaker.name );
	}

	// *** new (state only) functions ***

BEGIN:
	WaitForLanding();
	StopMovement();
} // state AISenseDebug


//****************************************************************************
// AIAmbush
// wait for encounter in heightened alert
//****************************************************************************
state AIAmbush
{
	// *** ignored functions ***

	// *** overridden functions ***
	function RespondToSOS( actor Caller )
	{
		HandleSOS( Caller );
	}

// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:
DODGED:

// Default entry point
BEGIN:
	WaitForLanding();
	SetAlertness( 1.0 );
	StopMovement();
	PlayWait();
} // state AIAmbush


//****************************************************************************
// AIPatrol
// follow a pre-defined patrol route
//****************************************************************************
state AIPatrol
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***

	// *** new (state only) functions ***
	// Returns the first AeonsPatrolPoint on the patrol route
	function AeonsPatrolPoint GetFirstPatrol()
	{
		local AeonsPatrolPoint	aPoint;

		foreach AllActors( class'AeonsPatrolPoint', aPoint, OrderTag )
			return aPoint;
		return none;
	}

	// Returns the next AeonsPatrolPoint on the patrol route
	function AeonsPatrolPoint GetNextPatrol( AeonsPatrolPoint CurPoint )
	{
		if ( CurPoint != none )
		{
			if ( CurPoint.NextPoint == none )
				CurPoint.FindLinkPoint( OrderTag );

			// current point has link information
			return CurPoint.NextPoint;
		}
		else
		{
			// if current OrderObject is NONE, see if first patrol point can be found
			return GetFirstPatrol();
		}
	}

	function AtPoint()
	{
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Default entry point
BEGIN:
	WaitForLanding();
	PatrolPoint = GetFirstPatrol();
	FirstPoint = PatrolPoint;

// Entry point when resuming this state
RESUME:
GOTOACT:
	if ( PatrolPoint != none )
	{
		if ( actorReachable( PatrolPoint ) )
		{
			SetMarker( PatrolPoint.Location );	// TEMP
			DebugInfoMessage( ".AIPatrol, can reach " $ PatrolPoint.name $ " directly" );
			if ( PatrolPoint.bHasteToMe )
			{
				PlayRun();
				MoveToward( PatrolPoint, FullSpeedScale );
			}
			else
			{
				PlayWalk();
				MoveToward( PatrolPoint, WalkSpeedScale );
			}
			FirstPoint = none;
		}
		else if ( bCanFly && EyesCanSee( PatrolPoint.Location ) )
		{
			DebugInfoMessage( ".AIPatrol, can't reach " $ PatrolPoint.name $ " directly, but can fly and can see" );
			PlayWalk();
			if ( DistanceToPoint( PatrolPoint.Location ) > 750.0 )
			{
				MoveTo( SetMarker( GetEnRoutePoint( PatrolPoint.Location, 500.0 ) ), WalkSpeedScale );
			}
			else
			{
				SetMarker( PatrolPoint.Location );	// TEMP
				MoveToward( PatrolPoint, WalkSpeedScale );
			}
			FirstPoint = none;
			goto 'GOTOACT';
		}
		else
		{
			DebugInfoMessage( ".AIPatrol, can't reach " $ PatrolPoint.name $ " directly, trying to path" );
			PathObject = PathToward( PatrolPoint );
			if ( PathObject != none )
			{
				// can path to OrderObject
				SetMarker( PathObject.Location );	// TEMP
				if ( PatrolPoint.bHasteToMe )
				{
					PlayRun();
					MoveToward( PathObject, FullSpeedScale );
				}
				else
				{
					PlayWalk();
					MoveToward( PathObject, WalkSpeedScale );
				}
				goto 'GOTOACT';
			}
			else
			{
				// couldn't path to OrderObject
				DebugInfoMessage( ".AIPatrol, couldn't path to " $ PatrolPoint.name );
				if ( FirstPoint == none )
					FirstPoint = PatrolPoint;
				goto 'NEXTPT';
			}
		}

ATPOINT:
		DebugInfoMessage( ".AIPatrol, reached " $ PatrolPoint.name );
		AtPoint();

		if ( PatrolPoint.bVanishOnContact )
			Vanish();

		// do the action at the PatrolPoint
		if ( ( PatrolPoint.NextDelay > 0.0 ) ||
			 ( PatrolPoint.AnimCount > 0 ) ||
			 ( !PatrolPoint.bDontTurn ) )
			StopMovement();		// stop only if not walking through this point

		if ( PatrolPoint.bTurnFirst )
		{
			// turn before animation
			if ( !PatrolPoint.bDontTurn )
			{
				// do the turn
				if ( PatrolPoint.TurnPreDelay > 0.0 )
				{
					// a turn delay is specified
					PlayWait();
					Sleep( PatrolPoint.TurnPreDelay );
				}
				TurnTo( PatrolPoint.Location + PatrolPoint.LookVector );
			}
			if ( ( PatrolPoint.AnimCount > 0 ) &&
				 ( FRand() < PatrolPoint.AnimFrequency ) )
			{
				// do the animation
				PatrolPoint.AnimLoop = PatrolPoint.AnimCount;
				while ( PatrolPoint.AnimLoop > 0 )
				{
					if ( PatrolPoint.AnimPreDelay > 0.0 )
					{
						PlayWait();
						Sleep( PatrolPoint.AnimPreDelay );
					}
					PlaySound( PatrolPoint.AnimSound );
					PlayAnim( PatrolPoint.AnimName );
					FinishAnim();
					PatrolPoint.AnimLoop = PatrolPoint.AnimLoop - 1;
				}
			}
		}
		else
		{
			// animation before turn
			if ( ( PatrolPoint.AnimCount > 0 ) &&
				 ( FRand() < PatrolPoint.AnimFrequency ) )
			{
				// do the animation
				PatrolPoint.AnimLoop = PatrolPoint.AnimCount;
				while ( PatrolPoint.AnimLoop > 0 )
				{
					if ( PatrolPoint.AnimPreDelay > 0.0 )
					{
						PlayWait();
						Sleep( PatrolPoint.AnimPreDelay );
					}
					PlaySound( PatrolPoint.AnimSound );
					PlayAnim( PatrolPoint.AnimName );
					FinishAnim();
					PatrolPoint.AnimLoop = PatrolPoint.AnimLoop - 1;
				}
			}
			if ( !PatrolPoint.bDontTurn )
			{
				// do the turn
				if ( PatrolPoint.TurnPreDelay > 0.0 )
				{
					// a turn delay is specified
					PlayWait();
					Sleep( PatrolPoint.TurnPreDelay );
				}
				TurnTo( PatrolPoint.Location + PatrolPoint.LookVector );
			}
		}

DELAY:
		if ( PatrolPoint.NextDelay > 0.0 )
		{
			PlayWait();
			Sleep( PatrolPoint.NextDelay );
		}

NEXTPT:
		PatrolPoint = GetNextPatrol( PatrolPoint );
		if ( PatrolPoint == FirstPoint )
			goto 'LOST';
		DebugInfoMessage( ".AIPatrol, picked next point " $ PatrolPoint.name );
		goto 'GOTOACT';
	}

LOST:
	// FIXLOST
	// don't have a point to go to
	GotoState( 'AILost' );
} // state AIPatrol


//****************************************************************************
// AIGuard
// go to a point and guard it
//****************************************************************************
state AIGuard
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		StopTimer();
	}

	function Timer()
	{
		GotoState( , 'GOTOPT' );
	}

	/*
	function EffectorSeePlayer( actor sensed )
	{
		if ( sensed == Enemy )
			global.EffectorSeePlayer( sensed );
		else
		{
			SendTeamAIMessage( self, TM_EnemyAcquired, Sensed );
			if ( ( AeonsGuardPoint(OrderObject) != none ) && AeonsGuardPoint(OrderObject).bUseAsShield )
				GotoState( , 'GOTOPT' );
		}
	}
	*/

	// *** new (state only) functions ***
	// returns the first AeonsGuardPoint found whose tag matches the OrderTag, or none if not found
	function actor GetGuardPoint()
	{
		local AeonsGuardPoint	gPoint;

		foreach AllActors( class'AeonsGuardPoint', gPoint, OrderTag )
			return gPoint;

		return none;
	}

	function vector GetGuardLocationFromActor( actor aActor )
	{
		return GetGotoPoint( AeonsGuardPoint(OrderObject).GetGuardPoint( self, aActor ) );
	}

// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	WaitForLanding();
	if ( Alertness < 0.75 )
		SetAlertness( 0.75 );
	OrderObject = GetGuardPoint();
	TargetActor = FindPlayer();

GOTOPT:
	if ( AeonsGuardPoint(OrderObject) != none )
	{
		TargetPoint = GetGuardLocationFromActor( TargetActor );
		if ( !CloseToPoint( TargetPoint, 1.0 ) )
		{
KEEPMOVING:
			if ( pointReachable( TargetPoint ) )
			{
				PlayWalk();	// DistanceToPoint( TargetPoint ) );
				MoveTo( TargetPoint, MoveScale() );
			}
			else
			{
				PathObject = PathTowardPoint( TargetPoint );
				if ( PathObject != none )
				{
					// can path to OrderObject
					PlayWalk();	// RouteDistance() );
					MoveToward( PathObject, MoveScale() );
					goto 'GOTOPT';
				}
				else
				{
					// couldn't path to OrderObject
					Sleep( 5.0 );
				}
			}
		}
	}

	TargetPoint = GetGuardLocationFromActor( TargetActor );
	if ( !CloseToPoint( TargetPoint, 1.0 ) )
		goto 'KEEPMOVING';

	// don't have a point to go to
	StopMovement();
	PlayWait();

	TurnToward( TargetActor );
	if ( AeonsGuardPoint(OrderObject).bUseAsShield )
		goto '';
	Sleep( 0.1 );
	goto 'GOTOPT';
} // state AIGuard


//****************************************************************************
// AISearch
// follow a pre-defined search route searching for encounter
//****************************************************************************
state AISearch
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		FirstPoint = none;
	}

	function Timer()
	{
		EnableSenses();
	}

	// *** new (state only) functions ***
	// locate the nearest AeonsSearchPoint, set OrderObject to that point
	function GetNearestSearch( vector thisLoc )
	{
		local AeonsSearchPoint	sPoint, aPoint;
		local float				mindist;

		sPoint = none;
		TargetPoint = thisLoc;

		foreach AllActors( class'AeonsSearchPoint', aPoint )
		{
			if ( ( sPoint == none ) || ( VSize(aPoint.Location - thisLoc) < mindist ) )
			{
				sPoint = aPoint;
				mindist = VSize(aPoint.Location - thisLoc);
			}
		}

		OrderObject = sPoint;
	}

	// locate the named AeonsSearchPoint, set OrderObject to that point
	function GetNamedSearch( name TagName )
	{
		local AeonsSearchPoint	sPoint;

		TargetPoint = Location;

		foreach AllActors( class'AeonsSearchPoint', sPoint, TagName )
		{
			OrderObject = sPoint;
			return;
		}

		OrderObject = none;
	}

	// sets OrderObject to the next AeonsSearchPoint on the search route
	function GetNextSearch()
	{
		if ( AeonsSearchPoint(OrderObject) != none )
		{
			if ( AeonsSearchPoint(OrderObject).NextPoint == none )
			{
				AeonsSearchPoint(OrderObject).FindLinkPoint( OrderTag );
			}

			if ( AeonsSearchPoint(OrderObject).NextPoint != none )
			{
				// current point has link information
				OrderObject = AeonsSearchPoint(OrderObject).NextPoint;
			}
			else
			{
				OrderObject = none;
			}
		}
		else
		{
			// if current OrderObject is NONE, see if first patrol point can be found
			GetNearestSearch( Location );
		}
	}

TARGET:

CHEAT:
	GetNearestSearch( Enemy.Location );
	goto 'GOTOACT';

FINDPT:
	GetNearestSearch( Location );
	goto 'GOTOACT';

// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:
	DisableSenses();
	SetTimer( 3.0 + Reaction( 5.0 ), false );

	if ( AeonsSearchPoint(OrderObject) != none )
		goto 'GOTOACT';

// Default entry point
BEGIN:
	WaitForLanding();

	if ( OrderTag != '' )
		GetNamedSearch( OrderTag );
	else
		GetNearestSearch( Location );

GOTOACT:
	if ( ( OrderObject != none ) && ( OrderObject == FirstPoint ) )
		goto 'LOST';

	if ( AeonsSearchPoint(OrderObject) != none )
	{
		if ( actorReachable( OrderObject ) )
		{
			PlayWalk();	// DistanceToPoint( OrderObject.Location ) );
			MoveToward( OrderObject, MoveScale() );
			FirstPoint = none;
		}
		else
		{
			PathObject = PathTowardOrder();
			if ( PathObject != none )
			{
				// can path to OrderObject
				PlayWalk();	// RouteDistance() );
				MoveToward( PathObject, MoveScale() );
				goto 'GOTOACT';
			}
			else
			{
				// couldn't path to OrderObject
				if ( FirstPoint == none )
					FirstPoint = OrderObject;
			}
		}

		GetNextSearch();
		goto 'GOTOACT';
	}
	else
	{
		GotoLastState();
	}

LOST:
	// FIXLOST
	// don't have a point to go to
	GotoState( 'AILost' );
} // state AISearch


//****************************************************************************
// AIFollow
// follow the TargetActor actor
//****************************************************************************
state AIFollow
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		StopTimer();
	}

	function Timer()
	{
		GotoState( , 'PICKPT' );
	}

	function bool HandleBump( actor Other )
	{
		DebugInfoMessage( ".AIFollow, HandleBump()" );
		if ( Other == TargetActor )
		{
			GotoState( , 'BACKOFF' );
			return true;
		}
		return false;
	}

	// *** new (state only) functions ***
	// sets TargetPoint, based on TargetActor and FollowDistance
	function vector GetFollowPoint()
	{
		local vector	GPoint;

		if ( FastTrace( TargetActor.Location, Location ) )
		{
			// TODO: handle flying creatures?
			GPoint = GetGotoPoint( GetEnRoutePoint( TargetActor.Location, -( FollowDistance + CollisionRadius + TargetActor.CollisionRadius ) ) );
			if ( CanPathToPoint( GPoint ) )
				return GPoint;
		}
		return TargetActor.Location;
	}

	function AtPoint()
	{
	}

	function WaitPoint()
	{
	}


// Entry point for following the player
PLAYER:
//	DisableSenses();
	WaitForLanding();
	TargetActor = FindPlayer();
	goto 'PICKPT';

// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	WaitForLanding();
	if ( ( OrderState == 'AIFollow' ) && ( OrderTag != '' ) )
	{
		TargetActor = FindTaggedPawn( OrderTag );
		if ( TargetActor == none )
			goto 'LOST';
	}
	else
		TargetActor = FindPlayer();

PICKPT:
	if ( LineOfSightTo( TargetActor ) && ( DistanceTo( TargetActor ) < FollowDistance * 1.25 ) )
		goto 'ATPOINT';

BACKOFF:
	DebugInfoMessage( ".AIFollow, LABEL BACKOFF" );
	TargetPoint = GetFollowPoint();
	if ( CloseToPoint( TargetPoint, 1.0 ) )
		goto 'ATPOINT';

GOTOPT:
	SetMarker( TargetPoint );	// TEMP
	if ( pointReachable( TargetPoint ) )
	{
		if ( CloseToPoint( TargetPoint, 5.0 ) &&
			 ( DistanceTo( TargetActor ) < FollowDistance ) &&
			 ( ( ( YawTo( TargetPoint ) + 16384 ) & 65535 ) > 32768 ) )
		{
			// walk backwards to point
			PlayLocomotion( -WalkVector );
			MoveTo( TargetPoint, -WalkSpeedScale, 2.0 );
		}
		else
		{
			PlayWalk();	// DistanceToPoint( TargetPoint ) );
			MoveTo( TargetPoint, MoveScale(), 2.0 );
		}
	}
	else
	{
		PathObject = PathTowardPoint( TargetPoint );
		if ( PathObject != none )
		{
			// can path to TargetPoint
//			DisplayRouteCache();
			PlayWalk();	// RouteDistance() );
			MoveToward( PathObject, MoveScale(), 2.0 );
			if ( LineOfSightTo( TargetActor ) )
				goto 'PICKPT';
			else
				goto 'GOTOPT';
		}
		else
		{
			// couldn't path to OrderObject
			StopMovement();
			PlayWait();
			Sleep( 2.0 );
		}
	}
	goto 'PICKPT';

ATPOINT:
	AtPoint();
	StopMovement();
	PlayWait();

WAITPT:
	WaitPoint();
	TurnToward( TargetActor, 20 * DEGREES );
	TargetPoint = GetFollowPoint();
	if ( CloseToPoint( TargetPoint, 1.0 ) || ( LineOfSightTo( TargetActor ) && ( DistanceTo( TargetActor ) < FollowDistance * 1.25 ) ) )
	{
		if ( CloseToPoint( TargetActor.Location + vect(0,0,1) * ( CollisionHeight - TargetActor.CollisionHeight ), 3.0 ) )
			goto 'GOTOPT';
		Sleep( 0.2 );
		goto 'WAITPT';
	}
	else
		goto 'GOTOPT';

LOST:
	// FIXLOST
	// don't have a point to go to
	GotoState( 'AILost' );
} // state AIFollow


//****************************************************************************
// AIFollowOwner
// Follow my Owner.
//****************************************************************************
state AIFollowOwner
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		if ( Owner == none )
			SetOwner( FindPlayer() );
		if ( Owner == none )
			Destroy();
		SetTimer( 2.0, false );
	}

	function Timer()
	{
		PingOwnerEnemy();
		SetTimer( 0.2, false );
	}

	function bool HandleBump( actor Other )
	{
		DebugInfoMessage( ".AIFollowOwner, HandleBump()" );
		if ( Other == TargetActor )
		{
			GotoState( , 'BACKOFF' );
			return true;
		}
		return false;
	}

	function StartLevel()
	{
		global.StartLevel();
		if ( Owner == none )
			SetOwner( FindPlayer() );
		if ( Owner == none )
			Destroy();
		TargetActor = Owner;
	}

	// *** new (state only) functions ***
	function vector GetFollowPoint( actor Other )
	{
		local float		PDist;
		local vector	GPoint;

		if ( Other != none )
		{
			if ( FastTrace( Other.Location, Location ) )
			{
				// TODO: handle flying creatures?
				PDist = FollowDistance + CollisionRadius + Other.CollisionRadius;
				if ( VSize(Other.Location - Location) < PDist )
					GPoint = GetGotoPoint( Location + Normal(Location - Other.Location) * PDist * 1.25 );
				else
					GPoint = GetGotoPoint( GetEnRoutePoint( Other.Location, -PDist ) );
				if ( CanPathToPoint( GPoint ) )
					return GPoint;
			}
			return Other.Location;
		}
		return Location;
	}

	function AtPoint()
	{
	}

	function WaitPoint()
	{
	}

	function PingOwnerEnemy()
	{
		local ScriptedPawn		SP;

		// TODO check if able to attack
		foreach RadiusActors( class'ScriptedPawn', SP, SightRadius * 1.5 )
			if ( ( SP.Health > 0 ) &&
				 ( SP.Enemy != none ) &&
				 ( SP.Enemy == Owner ) &&
				 AttackCandidate( SP ) )
			{
				DebugInfoMessage( ".PingOwnerEnemy(), attacking " $ SP.name );
				SetEnemy( SP );
				GotoState( 'AIAttack' );
				return;
			}
	}

	function bool AttackCandidate( ScriptedPawn SP )
	{
		return ( CanPathTo( SP ) || ( ( bHasFarAttack || bCanSwitchToRanged ) && EyesCanSee( SP.Location ) ) );
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	TargetActor = Owner;
	WaitForLanding();

PICKPT:
	if ( LineOfSightTo( TargetActor ) && ( DistanceTo( TargetActor ) < FollowDistance * 1.50 ) )
		goto 'ATPOINT';

BACKOFF:
	TargetPoint = GetFollowPoint( TargetActor );
	if ( CloseToPoint( TargetPoint, 1.0 ) )
		goto 'ATPOINT';

GOTOPT:
	SetMarker( TargetPoint );	// TEMP
	if ( pointReachable( TargetPoint ) )
	{
		if ( ShouldRunToPoint( TargetPoint ) )
		{
			PlayRun();
			MoveTo( TargetPoint, FullSpeedScale, 2.0 );
		}
		else
		{
			PlayWalk();
			MoveTo( TargetPoint, WalkSpeedScale, 2.0 );
		}
	}
	else
	{
		PathObject = PathTowardPoint( TargetPoint );
		if ( PathObject != none )
		{
			// can path to TargetPoint
			if ( ShouldRunTo( PathObject ) )
			{
				PlayRun();
				MoveToward( PathObject, FullSpeedScale, 2.0 );
			}
			else
			{
				PlayWalk();
				MoveToward( PathObject, WalkSpeedScale, 2.0 );
			}
			if ( LineOfSightTo( TargetActor ) )
				goto 'PICKPT';
			else
				goto 'GOTOPT';
		}
		else
		{
			// couldn't path to OrderObject
			StopMovement();
			PlayWait();
			Sleep( 2.0 );
		}
	}
	goto 'PICKPT';

ATPOINT:
	AtPoint();
	StopMovement();
	PlayWait();

WAITPT:
	WaitPoint();
	TurnToward( TargetActor, 20 * DEGREES );
	TargetPoint = GetFollowPoint( TargetActor );
	if ( CloseToPoint( TargetPoint, 1.0 ) || ( LineOfSightTo( TargetActor ) && ( DistanceTo( TargetActor ) < FollowDistance * 1.50 ) ) )
	{
		if ( CloseToPoint( TargetActor.Location + vect(0,0,1) * ( CollisionHeight - TargetActor.CollisionHeight ), 3.0 ) )
			goto 'GOTOPT';
		Sleep( 0.2 );
		goto 'WAITPT';
	}
	else
		goto 'GOTOPT';

LOST:
	// FIXLOST
	// don't have a point to go to
	GotoState( 'AILost' );
} // state AIFollowOwner


//****************************************************************************
// AIHuntPlayer
// Follow the player until an encounter occurs.
//****************************************************************************
state AIHuntPlayer
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***

	// *** new (state only) functions ***
	function bool KeepHunting( actor target )
	{
		return (target != none);
	}

	function SpecialHunt()
	{
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Default entry point
BEGIN:
	WaitForLanding();
	TargetActor = FindPlayer();
	LostCounter = default.LostCounter;

// Entry point when resuming this state
RESUME:
GOTOACT:
	if ( KeepHunting(TargetActor) )
	{
		if ( actorReachable( TargetActor ) )
		{
			SetMarker( TargetActor.Location );	// TEMP
			DebugInfoMessage( ".AIHuntPlayer, can reach " $ TargetActor.name $ " directly" );
			PlayWalk();
			MoveToward( TargetActor, WalkSpeedScale );
			if ( !CloseToPoint( TargetActor.Location, 2.0 ) )
				goto 'GOTOACT';
			DebugInfoMessage( ".AIHuntPlayer, after direct MoveToward(), distance to TargetActor is " $ VSize(TargetActor.Location - Location) $ ", MoveTimer is " $ MoveTimer );
		}
		else if ( bCanFly && EyesCanSee( TargetActor.Location ) )
		{
			DebugInfoMessage( ".AIHuntPlayer, can't reach " $ TargetActor.name $ " directly, but can fly and can see" );
			PlayWalk();
			if ( DistanceToPoint( TargetActor.Location ) > 750.0 )
			{
				MoveTo( SetMarker( GetEnRoutePoint( TargetActor.Location, 500.0 ) ), WalkSpeedScale );
			}
			else
			{
				SetMarker( TargetActor.Location );	// TEMP
				MoveToward( TargetActor, WalkSpeedScale );
			}
			goto 'GOTOACT';
		}
		else
		{
			DebugInfoMessage( ".AIHuntPlayer, can't reach " $ TargetActor.name $ " directly, trying to path" );
			SpecialHunt();
			PathObject = PathToward( TargetActor );
			if ( PathObject != none )
			{
				// can path to OrderObject
				SetMarker( PathObject.Location );	// TEMP
				PlayWalk();
				MoveToward( PathObject, WalkSpeedScale );
				goto 'GOTOACT';
			}
			else
			{
				// couldn't path to OrderObject
				DebugInfoMessage( ".AIHuntPlayer, couldn't path to " $ TargetActor.name );
				LostCounter -= 1;
				if ( LostCounter <= 0 )
				{
					SetEnemy( pawn(TargetActor) );
					GotoState( 'AICantReachEnemy' );
				}
				else
				{
					StopMovement();
					PlayWait();
					Sleep( 2.0 );
					goto 'GOTOACT';
				}
			}
		}
		DebugInfoMessage( ".AIHuntPlayer, reached " $ TargetActor.name );

		// Should have encounter by now, but just in case...
		StopMovement();
		PlayWait();
		Sleep( 2.0 );
		goto 'GOTOACT';
	}
	else if ( pawn(TargetActor) != none )
	{
		SetEnemy( pawn(TargetActor) );
		GotoState( 'AICantReachEnemy' );
	}

} // state AIHuntPlayer


//****************************************************************************
// AIChasePlayer
// Follow the player (quickly) until an encounter occurs.
//****************************************************************************
state AIChasePlayer
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***

	// *** new (state only) functions ***
	function bool KeepChasing( actor target )
	{
		return (target != none );
	}

	function SpecialChase()
	{
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Default entry point
BEGIN:
	WaitForLanding();
	TargetActor = FindPlayer();
	LostCounter = default.LostCounter;

// Entry point when resuming this state
RESUME:
GOTOACT:
	if ( KeepChasing(TargetActor) )
	{
		if ( actorReachable( TargetActor ) )
		{
			SetMarker( TargetActor.Location );	// TEMP
			DebugInfoMessage( ".AIChasePlayer, can reach " $ TargetActor.name $ " directly" );
			PlayRun();
			MoveToward( TargetActor, FullSpeedScale );
			if ( !CloseToPoint( TargetActor.Location, 2.0 ) )
				goto 'GOTOACT';
		}
		else if ( bCanFly && EyesCanSee( TargetActor.Location ) )
		{
			DebugInfoMessage( ".AIChasePlayer, can't reach " $ TargetActor.name $ " directly, but can fly and can see" );
			PlayRun();
			if ( DistanceToPoint( TargetActor.Location ) > 750.0 )
			{
				MoveTo( SetMarker( GetEnRoutePoint( TargetActor.Location, 500.0 ) ), FullSpeedScale );
			}
			else
			{
				SetMarker( TargetActor.Location );	// TEMP
				MoveToward( TargetActor, FullSpeedScale );
			}
			goto 'GOTOACT';
		}
		else
		{
			DebugInfoMessage( ".AIChasePlayer, can't reach " $ TargetActor.name $ " directly, trying to path" );
			SpecialChase();
			PathObject = PathToward( TargetActor );
			if ( PathObject != none )
			{
				// can path to OrderObject
				SetMarker( PathObject.Location );	// TEMP
				PlayRun();
				MoveToward( PathObject, FullSpeedScale );
				goto 'GOTOACT';
			}
			else
			{
				// couldn't path to OrderObject
				DebugInfoMessage( ".AIChasePlayer, couldn't path to " $ TargetActor.name );
				LostCounter -= 1;
				if ( LostCounter <= 0 )
				{
					SetEnemy( pawn(TargetActor) );
					GotoState( 'AICantReachEnemy' );
				}
				else
				{
					StopMovement();
					PlayWait();
					Sleep( 2.0 );
					goto 'GOTOACT';
				}
			}
		}
		DebugInfoMessage( ".AIChasePlayer, reached " $ TargetActor.name );

		// Should have encounter by now, but just in case...
		StopMovement();
		PlayWait();
		Sleep( 2.0 );
		goto 'GOTOACT';
	}
	else if ( pawn(TargetActor) != none )
	{
		SetEnemy( pawn(TargetActor) );
		GotoState( 'AICantReachEnemy' );
	}
} // state AIChasePlayer


//****************************************************************************
// AIRespond
// Respond to a distress call from TargetActor.
//****************************************************************************
state AIRespond
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***

	// *** new (state only) functions ***


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Default entry point
BEGIN:
	WaitForLanding();
	if ( DistanceTo( TargetActor ) < FollowDistance )
		goto 'ATPOINT';
	TargetPoint = GetGotoPoint( GetEnRoutePoint( TargetActor.Location, -FollowDistance ) );

// Entry point when resuming this state
RESUME:
GOTOPT:
	if ( pointReachable( TargetPoint ) )
	{
		SetMarker( TargetPoint );	// TEMP
		DebugInfoMessage( ".AIRespond, can reach TargetPoint directly" );
		PlayWalk();
		MoveTo( TargetPoint, WalkSpeedScale );
	}
	else if ( bCanFly && EyesCanSee( TargetPoint ) )
	{
		DebugInfoMessage( ".AIRespond, can't reach TargetPoint directly, but can fly and can see" );
		PlayWalk();
		if ( DistanceToPoint( TargetPoint ) > 750.0 )
		{
			MoveTo( SetMarker( GetEnRoutePoint( TargetPoint, 500.0 ) ), WalkSpeedScale );
		}
		else
		{
			SetMarker( TargetPoint );	// TEMP
			MoveTo( TargetPoint, WalkSpeedScale );
		}
		goto 'GOTOPT';
	}
	else
	{
		DebugInfoMessage( ".AIRespond, can't reach TargetPoint directly, trying to path" );
		PathObject = PathTowardPoint( TargetPoint );
		if ( PathObject != none )
		{
			// can path to OrderObject
			SetMarker( PathObject.Location );	// TEMP
			PlayWalk();
			MoveToward( PathObject, WalkSpeedScale );
			goto 'GOTOPT';
		}
		else
		{
			// couldn't path to OrderObject
			DebugInfoMessage( ".AIRespond, couldn't path to TargetPoint, consider it reached" );
		}
	}
	DebugInfoMessage( ".AIRespond, reached TargetPoint" );

ATPOINT:
	StopMovement();
	PlayWait();
	GotoState( 'AIAmbush' );

} // state AIRespond


//****************************************************************************
// AIDelayTrigger
// Delay reaction to Trigger event.
//****************************************************************************
state AIDelayTrigger
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function LongFall(){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function Timer()
	{
		if ( TriggerState != '' )
		{
			if ( PlayerPawn(SensedActor) != none )
				SetEnemy( pawn(SensedActor) );
			if ( TriggerTag != '' )
				OrderTag = TriggerTag;
//			GotoState( TriggerState );
			GotoState( 'AITriggerDispatch' );
		}
		else
		{
			SensedSense = 'AIDelayTrigger';
			GotoState( 'AIEncounter' );
		}
	}

	// *** new (state only) functions ***


// Entry point when returning from AITakeDamage
DAMAGED:

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	SetTimer( TriggerDelay, false );
} // AIDelayTrigger


//****************************************************************************
// AIEncounter
// Handle encountering another pawn
//****************************************************************************
state AIEncounter
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState( "SensedActor is " $ SensedActor.name $ ", SensedSense is " $ SensedSense $ ", AttitudeToPlayer is " $ AttitudeToPlayer );
	}

	// *** new (state only) functions ***
	// dispatch to next state
	function Dispatch()
	{
		local pawn			thisPawn;
		local bool			bHasLOS;
		local EAttitude		attitude;

		thisPawn = pawn(SensedActor);

		if ( ( thisPawn == none ) || ( thisPawn.Health <= 0.0 ) )
		{
			// no enemy or dead enemy
			GotoLastState();
			return;
		}

		// see if we're set to trigger an alarm
		if ( AlarmTag != '' )
		{
			GotoState( 'AITriggerAlarm' );
			return;
		}

		if ( Health < ( InitHealth * RetreatThreshold ) )
		{
			SetEnemy( thisPawn );
			PlayRetreatVocal();
			GotoState( 'AIRetreat' );
			return;
		}

		bHasLOS = LineOfSightTo( thisPawn );
		attitude = AttitudeTo( thisPawn );

		switch ( attitude )
		{
			case ATTITUDE_Fear:
				SetAlertness( 1.0 );
				SetEnemy( thisPawn );
				PlayRetreatVocal();
				GotoState( 'AIRetreat' );
				return;

			case ATTITUDE_Hate:
			case ATTITUDE_Frenzy:
				SetAlertness( 1.0 );
				SetEnemy( thisPawn  );
				if ( DoEncounterAnim() )
				{
					SetDefCon( 2 );
					PushState( 'AIAttack', 'BEGIN' );
					GotoState( 'AIQuickTaunt' );
				}
				else
					GotoState( 'AIAttack' );
				return;

			case ATTITUDE_Threaten:
				SetAlertness( 1.0 );
				SetEnemy( thisPawn );
				if ( DoEncounterAnim() )
				{
					PushState( 'AIThreaten', 'BEGIN' );
					GotoState( 'AIQuickTaunt' );
				}
				else
					GotoState( 'AIThreaten' );
				return;

			case ATTITUDE_Friendly:
				SetAlertness( 0.5 );
				TargetActor = thisPawn;
				if ( DoAwakenAnim() )
				{
					PushState( 'AIGreet', 'BEGIN' );
					GotoState( 'AIQuickTaunt', 'AWAKEN' );
				}
				else
					GotoState( 'AIGreet' );
				return;

			case ATTITUDE_Follow:
				SetAlertness( 0.5 );
				if ( pawn(Owner) == thisPawn )
					GotoState( 'AIFollowOwner' );
				else if ( ( PlayerPawn(thisPawn) != none ) && PlayerPawn(thisPawn).bIsPlayer )
					GotoState( 'AIFollow', 'PLAYER' );
				else
					GotoState( 'AIFollow' );
				return;
		}

		GotoLastState();
	}

// Entry point when entering as the result of a team message.
BEGIN_DELAYED:
	SetDefCon( 1 );
	Sleep( Reaction( 1.0 ) );

	if ( Alertness <= 0.5 )
	{
		SensedPoint = SensedActor.Location;
		TurnTo( SensedPoint, 60 * DEGREES );
		Sleep( Reaction( 1.0 ) );
	}
	goto 'BEGIN';

// Entry point when returning from AITakeDamage
DAMAGED:

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	if ( HandleSpecialEncounter( SensedActor ) )
		goto 'END';
	StopMovement();
	PlayWait();
	if ( ( DefCon == 0 ) && ( FRand() < 0.20 ) )
	{
		PlaySoundAlerted();
		Sleep( 1.0 );
	}
	SetDefCon( 1 );

	// determine how to react
	Dispatch();

END:
} // state AIEncounter


//****************************************************************************
// AITriggerDispatch
// Dispatch to TriggerState.
//****************************************************************************
state AITriggerDispatch
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		SetDefCon( 3 );
	}

	// *** new (state only) functions ***


// Entry point when returning from AITakeDamage
DAMAGED:

// Default entry point
BEGIN:
	if ( TriggerScriptTag != '' )
		Script = FindScript( TriggerScriptTag );
	ScriptAction = TriggerScriptAction;

	if ( HandleSpecialEncounter( SensedActor ) )
		goto 'END';

// Entry point when resuming this state
RESUME:
	GotoState( TriggerState );

END:
} // state AITriggerDispatch


//****************************************************************************
// AIAttack
// primary attack dispatch state
//****************************************************************************
state AIAttack
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function BeginState()
	{
		ResetStateStack();
		if ( Enemy != none )
			DebugBeginState( " Enemy is " $ Enemy.name );
		else
			DebugBeginState( " Enemy is NONE" );
		if ( ( Enemy == none ) && ( OrderTag == 'player' ) )
			SetEnemy( FindPlayer() );
		if ( ( Enemy == none ) && ( OrderTag != '' ) )
			SetEnemy( FindTaggedPawn( OrderTag ) );
		if ( ( Enemy == none ) || ( Enemy.Health <= 0 ) )
			SetEnemy( FindAppropriateEnemy() );
		CoverPoint = none;
		PlayAttackVocal();
	}

	function bool HandlePowderOfSiren( actor Other )
	{
		DispatchPowder( Other );
		return true;
	}

	// *** new (state only) functions ***
	// dispatch to next appropriate (attack) state
	function Dispatch()
	{
		local float		Dist;
		local float		PDist;
		local bool		bFarAttack;

		if ( TriggerSwitchToMelee() )
		{
			PushState( GetStateName(), 'RESUME' );
			StopMovement();
			GotoState( 'AISwitchToMelee' );
			return;
		}
		else if ( TriggerSwitchToRanged() )
		{
			PushState( GetStateName(), 'RESUME' );
			StopMovement();
			GotoState( 'AISwitchToRanged' );
			return;
		}

		Dist = DistanceTo( Enemy );
		PDist = PathDistanceTo( Enemy );
		bFarAttack = DoFarAttack();

		if ( PDist < 0.0 )
		{
			if ( bFarAttack || ( bHasFarAttack && ( FRand() < 0.25 ) ) )
				GotoState( 'AIFarAttack' );
			else
				GotoState( 'AICantReachEnemy' );
			return;
		}

		if ( Dist <= ( MeleeRange * 1.35 ) )
		{
			if ( bNoAdvance ) // We're closer than we want to be.
			{
				GotoState( 'AICharge', 'NOEVAL' );	// AICharge has really become tactical movement.
			}
			else if ( bFarAttack )
			{
				GotoState( 'AIFarAttack' );
			}
			else if ( bHasNearAttack && FastTrace( Location, Enemy.Location ) )
			{
				GotoState( 'AINearAttack' );
			}
			else if ( bHasFarAttack )
			{
				GotoState( 'AIFarAttack' );
			}
		}
		else
		{
			if ( bFarAttack )
			{
				GotoState( 'AIFarAttack' );
			}
			else
			{
				// must charge to reach MeleeRange
				if ( bUseCoverPoints )
					GotoState( 'AIChargeCovered' );
				else
					GotoState( 'AICharge', 'NOEVAL' );
			}
		}
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	WaitForLanding();

	if ( ( Enemy == none ) ||
		 ( LostPlayerVisual( Enemy ) && ( HearingEffector.GetSensorLevel() < 0.10 ) ) )
	{
		DebugInfoMessage( " lost player sense" );
		GotoState( 'AIAmbush' );
	}

	if ( !ShouldPursue( Enemy ) )
	{
		// FIXLOST
		DebugInfoMessage( " lost enemy." );
//		ClearOrdersIf( GetStateName() );
//		GotoInitState();
		GotoState( 'AIHuntPlayer' );
	}

DISPATCH:
	if ( ( Enemy != none ) && ( Enemy.Health > 0 ) )
	{
		if ( AttitudeTo( Enemy ) == ATTITUDE_Fear )
		{
			DebugInfoMessage( ".AIAttack, switching to AIRetreat" );
			PlayRetreatVocal();
			GotoState( 'AIRetreat' );
		}
		else
		{
			Dispatch();
			DebugInfoMessage( ".AIAttack, after call to Dispatch(), state is " $ GetStateName() );
		}
	}
	DebugInfoMessage( ".AIAttack, switching to LastState" );
	GotoLastState();
} // state AIAttack


//****************************************************************************
// AIAttackPlayer
// Attack dispatch state for attacking player.
//****************************************************************************
state AIAttackPlayer extends AIAttack
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		SetEnemy( FindPlayer() );					// locate the player enemy
		VisionEffector.SetSensorLevel( 1.0 );		// peg the sensors
		HearingEffector.SetSensorLevel( 1.0 );
	}

	// *** new (state only) functions ***

} // state AIAttackPlayer


//****************************************************************************
// AINearAttack
// attack near enemy (melee)
//****************************************************************************
state AINearAttack
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function BeginState()
	{
		if ( Enemy != none )
			DebugBeginState( " Enemy is " $ Enemy.name );
		else
			DebugBeginState( " Enemy is NONE" );
		StopTimer();
		bPendingBump = false;
	}

	function AnimEnd()
	{
		if ( !bDidMeleeAttack )
		{
			DebugInfoMessage( ".AINearAttack.AnimEnd(), going to DOATTACK" );
			GotoState( , 'DOATTACK' );
		}
		else
		{
			DebugInfoMessage( ".AINearAttack.AnimEnd(), going to ATTACKED" );
			GotoState( , 'ATTACKED' );
		}
	}

	function Timer()
	{
		if ( !bDidMeleeAttack )
		{
			DebugInfoMessage( ".AINearAttack.Timer(), going to DOATTACK" );
			GotoState( , 'DOATTACK' );
		}
		else
		{
			DebugInfoMessage( ".AINearAttack.Timer(), going to ATTACKED" );
			GotoState( , 'ATTACKED' );
		}
	}

	function Bump( actor Other )
	{
		bPendingBump = true;
		BumpedPawn = pawn(Other);
	}

	function bool HandlePowderOfSiren( actor Other )
	{
		DispatchPowder( Other );
		return true;
	}

	// *** new (state only) functions ***
	function PostAttack()
	{
		GotoState( 'AIAttack' );
	}

	function bool MoveInAttack()
	{
		return bCanFly;
	}


// Entry point when returning from AITakeDamage
DAMAGED:

// Entry point when resuming this state
RESUME:
	GotoState( 'AIAttack' );

// Default entry point
BEGIN:
	if ( !bCanFly || ( VSize(Enemy.Velocity) < 10.0 ) )
	{
		StopMovement();
		PlayWait();
		bDidMeleeAttack = false;
		SetTimer( 2.0, false );
		TurnToward( Enemy, TurnTowardThreshold( 20 * DEGREES ) );
	}

DOATTACK:
	bDidMeleeDamage = false;
	bDidMeleeAttack = true;
	DebugInfoMessage( " playing near attack" );
	PlayNearAttack();
	SetTimer( 5.0, false );		// BUGBUG: using timer to bail out when no animation present

INATTACK:
	if ( MoveInAttack() )
	{
		MoveTarget = Enemy;
		if ( VSize(Enemy.Velocity) < 10.0 )
			MoveToward( Enemy, FullSpeedScale * 0.70 );
		else
			MoveToward( Enemy, FullSpeedScale );
	}
	else
	{
		MoveTarget = Enemy;
//		TurnToward( Enemy );
	}
	Sleep( 0.1 );
	goto 'INATTACK';

ATTACKED:
	StopTimer();
	if ( bPendingBump )
		CreatureBump( BumpedPawn );
	PostAttack();
} // state AINearAttack


//****************************************************************************
// AIFarAttack
// attack far enemy
//****************************************************************************
state AIFarAttack
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		if ( RangedWeapon != none )
		{
			if ( RangedWeapon.bIsMagical )
				GotoState( 'AISpellAttack' );
			else
				RangedWeapon.SetRefireFactor( 1.0 );
		}
		else
			GotoState( 'AIFarAttackAnim' );
	}

	function EndState()
	{
		DebugEndState();
		StopFiring();
	}

	function EnemyNotVisible()
	{
		if ( FRand() < 0.5 )
		{
			if ( bCanFly )
				TargetPoint = LastSeenPos;
			else
				TargetPoint = GetGotoPoint( LastSeenPos );
			GotoState( 'AIChargePoint' );
		}
	}

	function bool HandlePowderOfSiren( actor Other )
	{
		DispatchPowder( Other );
		return true;
	}

	// *** new (state only) functions ***
	// (re)evaluate attack strategy
	function Evaluate()
	{
		if ( !DoFarAttack() )
			GotoState( 'AIAttack' );
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:
	GotoState( 'AIAttack' );

// Default entry point
BEGIN:
	StopMovement();

MOVED:
	TurnTo( EnemyAimSpot(), 10 * DEGREES );
	PlayWait();
	if ( ClearShot( WeaponLoc(), EnemyAimSpot() ) == none )
	{
		PushState( GetStateName(), 'FIRED' );
		GotoState( 'AIFireWeapon' );
	}
	else
	{
		PushState( GetStateName(), 'MOVED' );
		GotoState( 'AIRepositionAttack' );
	}

FIRED:
	PlayWait();
	Evaluate();
	goto 'BEGIN';
} // state AIFarAttack


//****************************************************************************
// AIFarAttackAnim
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIFarAttackAnim
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function EnemyNotVisible(){}

	// *** overridden functions ***

	// *** new (state only) functions ***
	function AnimFinished()
	{
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Default entry point.
BEGIN:
	StopMovement();
	if ( CanTurnToward( Enemy ) )
		TurnToward( Enemy, 10 * DEGREES );
	PlayFarAttack();
	FinishAnim();
	AnimFinished();

// Entry point when resuming this state.
RESUME:
	GotoState( 'AIAttack' );
} // state AIFarAttackAnim


//****************************************************************************
// AIRepositionAttack
// return via state stack.
//****************************************************************************
state AIRepositionAttack
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function HitWall( vector hitNormal, actor hitWall, byte textureID )
	{
		GotoState( , 'ATPOINT' );
	}

	// *** new (state only) functions ***
	// Determine a good point for repositioned far attack.
	function vector GetRepoPoint()
	{
		local actor		HitActor;
		local vector	TargetLoc;
		local vector	X, Y, Z;
		local vector	TPoint;
		local float		MoveDist;
		local bool		Testing;

		TargetLoc = EnemyAimSpot();
		HitActor = ClearShot( WeaponLoc(), TargetLoc );
		GetAxes( rotator(Normal(TargetLoc - Location)), X, Y, Z );
		if ( ( Normal(HitActor.Location - Location) dot Y ) > 0.0 )
		{
			// Move left.
			MoveDist = -CollisionRadius * FVariant( 11.0, 1.0 );
		}
		else
		{
			// Move right.
			MoveDist = CollisionRadius * FVariant( 11.0, 1.0 );
		}
		Testing = true;
		while ( Testing )
		{
			TPoint = Location + Y * MoveDist;
			if ( FastTrace( TPoint ) && pointReachable( TPoint ) )
			{
				Testing = false;
			}
			else
			{
				MoveDist = MoveDist * 0.8;
				if ( abs(MoveDist) < CollisionRadius )
					Testing = false;
			}
		}
		return TPoint;
	}


// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	TargetPoint = GetRepoPoint();
	if ( pointReachable( TargetPoint ) )
	{
		TurnTo( TargetPoint, 30 * DEGREES );
		PlayWalk();
		MoveTo( TargetPoint, WalkSpeedScale * 0.5 + 0.5 );
ATPOINT:
		StopMovement();
		PlayWait();
	}
	else
		Sleep( 1.0 );
	PopState();
} // state AIRepositionAttack


//****************************************************************************
// AISwitchToMelee
// Switch to melee weapon, return via state stack.
//****************************************************************************
state AISwitchToMelee
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
	{
		ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
	}

	// *** new (state only) functions ***
	function bool PlayHolsterWeapon()
	{
		return false;
	}

	function bool PlaySwitchToMelee()
	{
		return false;
	}


// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	if ( Enemy != none )
		TurnToward( Enemy, 60 * DEGREES );
	bHasFarAttack = false;
	if ( PlayHolsterWeapon() )
		FinishAnim();
	if ( PlaySwitchToMelee() )
		FinishAnim();
	bHasNearAttack = true;
	PopState();
} // state AISwitchToMelee


//****************************************************************************
// AISwitchToRanged
// Switch to ranged weapon, return via state stack.
//****************************************************************************
state AISwitchToRanged
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
	{
		ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
	}

	// *** new (state only) functions ***
	function bool PlayHolsterMelee()
	{
		return false;
	}

	function bool PlaySwitchToRanged()
	{
		return false;
	}


// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	if ( Enemy != none )
		TurnToward( Enemy, 60 * DEGREES );
	bHasNearAttack = false;
	if ( PlayHolsterMelee() )
		FinishAnim();
	if ( PlaySwitchToRanged() )
		FinishAnim();
	bHasFarAttack = true;
	PopState();
} // state AISwitchToRanged


//****************************************************************************
// AIFireWeapon
// Fire ranged weapon and return via state stack.
//****************************************************************************
state AIFireWeapon
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		bIsAiming = true;
		StopTimer();
	}

	function EndState()
	{
		DebugEndState();
		bIsAiming = false;
		StopFiring();
	}

	function ReactToDamage( pawn Instigator, DamageInfo DInfo )
	{
		if ( ( ClearShot( WeaponLoc(), EnemyAimSpot() ) != none ) ||
			 !EyesCanSee( EnemyAimSpot() ) ||
			 ( FRand() > 0.95 ) )
			PopState();
		else
			global.ReactToDamage( Instigator, DInfo );
	}

	function WeaponReload( SPWeapon ThisWeapon )
	{
		if ( ( ( VisionEffector.GetSensorLevel() < 0.2 ) && ( ScriptedPawn(Enemy) != none ) ) ||
			 ( XYAngleToEnemy() < WeaponAttackFOV ) ||
			 ( FRand() < 0.75 ) )
			GotoState( , 'STOPFIRE' );
		else
			GotoState( , 'TURRET' );
	}

	function bool PreWeaponFire( SPWeapon ThisWeapon )
	{
		return ( XYAngleToEnemy() > ( WeaponAttackFOV * 0.75 ) );
	}

	function WeaponMisFired( SPWeapon ThisWeapon )
	{
		StopFiring();
		PopState();
	}

	function WeaponFired( SPWeapon ThisWeapon )
	{
		if ( ( ( VisionEffector.GetSensorLevel() < 0.2 ) && ( ScriptedPawn(Enemy) != none ) ) ||
			 ( XYAngleToEnemy() < WeaponAttackFOV ) ||
			 ( ClearShot( WeaponLoc(), EnemyAimSpot() ) != none ) ||
			 ( FRand() < 0.25 ) )
		{
			if ( RangedWeapon.RecoilAnim != '' )
			{
				ClearAnims();
				PlayAnim( RangedWeapon.RecoilAnim, [TweenTime] 0.0 );
			}
			GotoState( , 'STOPFIRE' );
		}
		else if ( RangedWeapon.RecoilAnim != '' )
		{
			ClearAnims();
			PlayAnim( RangedWeapon.RecoilAnim, [TweenTime] 0.0 );
			GotoState( , 'FIRED' );
		}
		else
			GotoState( , 'TURRET' );
	}

	function Timer()
	{
		PopState();
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	PopState();

// Entry point when resuming this state
RESUME:
	PopState( , 'RESUME' );

// Default entry point
BEGIN:
	TurnTo( EnemyAimSpot(), 10 * DEGREES );
	if ( RangedWeapon.AimAnim != '' )
	{
		PlayAnim( RangedWeapon.AimAnim );
		FinishAnim();
	}
	if ( ClearShot( WeaponLoc(), EnemyAimSpot() ) != none )
		PopState();
	FireWeapon();
	SetTimer( FVariant( 2.5, 0.50 ), false );

TURRET:
	TurnTo( EnemyAimSpot(), 10 * DEGREES );
	Sleep( 0.1 );
	goto 'TURRET';

STOPFIRE:
	StopFiring();
	FinishAnim();
	PopState();

FIRED:
	FinishAnim();
	goto 'TURRET';
} // state AIFireWeapon


//****************************************************************************
// AISpellAttack
// attack enemy with spell
//****************************************************************************
state AISpellAttack
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***


// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	StopMovement();
	if ( ClearShot( WeaponLoc(), EnemyAimSpot() ) == none )
	{
		PushState( GetStateName(), 'FIRED' );
		GotoState( 'AIFireSpell' );
FIRED:
		PlayWait();
	}
	else
		Sleep( FVariant( 1.0, 0.5 ) );
	GotoState( 'AIAttack' );
} // state AISpellAttack


//****************************************************************************
// AIFireSpell
// Fire spell weapon and return via state stack.
//****************************************************************************
state AIFireSpell
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		bIsAiming = true;
		StopTimer();
	}

	function EndState()
	{
		DebugEndState();
		bIsAiming = false;
		StopFiring();
	}

	function Timer()
	{
		GotoState( , 'FIRESPELL' );
	}

	function bool PreWeaponFire( SPWeapon ThisWeapon )
	{
		return ( XYAngleToEnemy() > ( WeaponAttackFOV * 0.75 ) );
	}

	function WeaponMisFired( SPWeapon ThisWeapon )
	{
		StopFiring();
		PopState();
	}

	function WeaponFired( SPWeapon ThisWeapon )
	{
		StopFiring();
		if ( RangedWeapon.RecoilAnim != '' )
			PlayAnim( RangedWeapon.RecoilAnim, [TweenTime] 0.0 );
		GotoState( , 'FIRED' );
	}


// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	TurnTo( EnemyAimSpot(), 30 * DEGREES );
	if ( RangedWeapon.AimAnim != '' )
	{
		PlayAnim( RangedWeapon.AimAnim );
		FinishAnim();
	}
	SetTimer( RangedWeapon.SpoolUpTime, false );

TURRET:
	TurnTo( EnemyAimSpot(), 2 * DEGREES );
	Sleep( 0.1 );
	goto 'TURRET';

FIRESPELL:
	FireWeapon();
	goto 'END';

FIRED:
	FinishAnim();
	PopState();

END:
} // state AIFireSpell


//****************************************************************************
// AICoveredAttack
// Attack from cover position (CoverPoint), return via state stack.
//****************************************************************************
state AICoveredAttack
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		if ( RangedWeapon != none )
		{
			if ( Health < ( InitHealth * 0.50 ) )
				RangedWeapon.SetRefireFactor( 1.0 );
			else
				RangedWeapon.SetRefireFactor( 4.0 );
		}
	}

	function bool IsCoveredState()
	{
		return true;
	}

	// *** new (state only) functions ***
	function vector GetStrafeToPoint()
	{
		local vector	X, Y, Z;

		GetAxes( CoverPoint.Rotation, X, Y, Z );
		if ( CoverPoint.bCanLeanRight )
		{
			if ( CoverPoint.LeanDistance > 0.0 )
				return CoverPoint.Location + ( Y * CoverPoint.LeanDistance );
			else
				return CoverPoint.Location + ( Y * CollisionRadius * 6.0 );
		}
		else if ( CoverPoint.bCanLeanLeft )
		{
			if ( CoverPoint.LeanDistance > 0.0 )
				return CoverPoint.Location - ( Y * CoverPoint.LeanDistance );
			else
				return CoverPoint.Location - ( Y * CollisionRadius * 6.0 );
		}
		else
			return CoverPoint.Location;
	}


// Entry point when resuming this state
RESUME:
	if ( bCanCrouch )
	{
		SetCrouch();
		PlayWait();
		FinishAnim();
	}
	PopState();

// Default entry point
BEGIN:
	if ( EyesCanSee( Enemy.Location ) )
	{
		TurnTo( EnemyAimSpot(), 60 * DEGREES );
		PushState( GetStateName(), 'NOLEAN' );
		goto 'LEANFIRE';
	}
	else if ( CoverPoint.bCanLeanLeft || CoverPoint.bCanLeanRight )
	{
		StrafeToPoint = GetStrafeToPoint();
		PlayStrafe( StrafeToPoint, WalkSpeedScale );
		StrafeTo( StrafeToPoint, EnemyAimSpot(), WalkSpeedScale );
		StopMovement();
		PushState( GetStateName(), 'LEANED' );
LEANFIRE:
		if ( ClearShot( WeaponLoc(), EnemyAimSpot() ) == none )
		{
			if ( RangedWeapon.bIsMagical )
				GotoState( 'AIFireSpell' );
			else
				GotoState( 'AIFireWeapon' );
		}
		else
		{
			Sleep( FVariant( 0.75, 0.25 ) );
			PopState();
		}
LEANED:
		PlayStrafe( CoverPoint.Location, WalkSpeedScale );
		StrafeTo( CoverPoint.Location, EnemyAimSpot(), WalkSpeedScale );
//		PlayWait();
	}
NOLEAN:
	PlayWait();
	PopState();

INCROUCH:
	SetCrouch();
	TurnTo( EnemyAimSpot(), 60 * DEGREES );

	if ( InCrouch() )
	{
		UnSetCrouch();
		PlayWait();
		Sleep( 0.3 );
		PushState( GetStateName(), 'CROUCH' );
	}
	else
	{
		PushState( GetStateName(), 'ATTACKED' );
	}
	if ( ClearShot( WeaponLoc(), EnemyAimSpot() ) == none )
	{
		if ( RangedWeapon.bIsMagical )
			GotoState( 'AIFireSpell' );
		else
			GotoState( 'AIFireWeapon' );
	}
	else
	{
		Sleep( FVariant( 0.75, 0.25 ) );
		PopState();
	}

CROUCH:
	SetCrouch();
	PlayWait();
	FinishAnim();

ATTACKED:
	PlayWait();
	PopState();
} // state AICoveredAttack


//****************************************************************************
// AICoveredPeek
// Peek from cover position (CoverPoint), return via state stack.
//****************************************************************************
state AICoveredPeek
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function bool IsCoveredState()
	{
		return true;
	}

	function EffectorSeePlayer( actor sensed )
	{
		SendTeamAIMessage( self, TM_EnemyAcquired, Sensed );
		GotoState( , 'SEEPLAYER' );
	}

	function vector GetStrafeToPoint()
	{
		local vector	X, Y, Z;

		GetAxes( CoverPoint.Rotation, X, Y, Z );
		if ( CoverPoint.bCanLeanRight )
			return CoverPoint.Location + ( Y * CollisionRadius * 6.0 );
		else
			return CoverPoint.Location - ( Y * CollisionRadius * 6.0 );
	}


// Entry point when resuming this state
RESUME:
	PopState();

// Default entry point
BEGIN:
	if ( CoverPoint.bCanLeanLeft || CoverPoint.bCanLeanRight )
	{
		StrafeToPoint = GetStrafeToPoint();
		PlayStrafe( StrafeToPoint, WalkSpeedScale );
		StrafeTo( StrafeToPoint, EnemyAimSpot(), WalkSpeedScale );
		StopMovement();
		PlayWait();
		Sleep( FVariant( 3.0, 0.5 ) );
		PlayStrafe( CoverPoint.Location, WalkSpeedScale );
		StrafeTo( CoverPoint.Location, EnemyAimSpot(), WalkSpeedScale );
SEEPLAYER:
		PlayWait();
	}
	PopState();
} // state AICoveredPeek


//****************************************************************************
// AICrouchedPeek
// Peek from cover position (CoverPoint), return via state stack.
//****************************************************************************
state AICrouchedPeek
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function bool IsCoveredState()
	{
		return true;
	}

	function EffectorSeePlayer( actor sensed )
	{
		if ( !InCrouch() )
		{
			SendTeamAIMessage( self, TM_EnemyAcquired, Sensed );
			GotoState( , 'SEEPLAYER' );
		}
	}

	function ReactToDamage( pawn Instigator, DamageInfo DInfo )
	{
		GotoState( , 'DAMAGED' );
	}


// Default entry point
BEGIN:
	TurnTo( EnemyAimSpot(), 60 * DEGREES );
	PlayWait();
	Sleep( FVariant( 3.0, 0.5 ) );

// Entry point when resuming this state
RESUME:
DAMAGED:
SEEPLAYER:
	SetCrouch();
	PlayWait();
	FinishAnim();
	PopState();
} // state AICrouchedPeek


//****************************************************************************
// AICharge
// Charge Enemy.
//****************************************************************************
state AICharge
{
	// *** ignored functions ***
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function BeginState()
	{
		ResetStateStack();
		DebugBeginState();
		StopTimer();
		if ( Enemy == none )
			GotoState( 'AIAttack' );
	}

	function Timer()
	{
		DebugInfoMessage( ".AICharge, Timer() fired" );
		if ( TriggerSwitchToRanged() )
		{
			PushState( GetStateName(), 'RECHECK' );
			StopMovement();
			GotoState( 'AISwitchToRanged' );
			return;
		}
		if ( DoFarAttack() )
		{
			GotoState( 'AIFarAttack' );
			return;
		}
		if ( AttitudeTo( Enemy ) != ATTITUDE_Hate )
			GotoState( 'AIAttack' );
		else if ( LineOfSightTo( Enemy ) && FacingToward( Enemy.Location, 0.70 ) )
		{
			SetTimer( FVariant( 0.6, 0.1 ), false );
			return;
		}
		else
			GotoState( , 'RECHECK' );
	}

	function bool HandlePowderOfSiren( actor Other )
	{
		DispatchPowder( Other );
		return true;
	}

	//
	function Bump( actor Other )
	{
		if ( pawn(Other) == Enemy )
			GotoState( , 'GOTOACT' );
		CreatureBump( pawn(Other) );
	}

	function EnemyNotVisible()
	{
		if ( bCanFly )
		{
			TargetPoint = LastSeenPos;
			GotoState( 'AIChargePoint' );
		}
	}

	function HitWall( vector hitNormal, actor hitWall, byte textureID )
	{
		GotoState( , 'HITWALL' );
	}


	// *** new (state only) functions ***
	// (re)evaluate attack strategy
	function Evaluate()
	{
		local float		distance;
		local bool		bFarAttack;

		if ( AttitudeTo( Enemy ) != ATTITUDE_Hate )
		{
			GotoState( 'AIAttack' );	// attitude has changed, re-evaluate attack
			return;
		}
		else if ( LostPlayerVisual( Enemy ) && ( HearingEffector.GetSensorLevel() < 0.10 ) )
		{
			DebugInfoMessage( " lost player sense" );
			GotoState( 'AIAmbush' );
		}
		else if ( !ShouldPursue( Enemy ) )
		{
			// FIXLOST
			// Lost enemy.
			DebugInfoMessage( " ShoudPursue() says NO!" );
			GotoState( 'AIHuntPlayer' );
			return;
		}

		distance = DistanceTo( Enemy );
		bFarAttack = DoFarAttack();
		if ( ( distance <= MeleeRange ) || ( ( distance >= ( MeleeRange * 3.5 ) ) && bFarAttack ) )
		{
			GotoState( 'AIAttack' );	// falling out of range, re-evaluate attack
			return;
		}
	}


HITWALL:
	PlayWait();
	StopMovement();
	goto 'GOTOACT';

NOEVAL:
	FlankPointReset = true;
	goto 'RESUME';

// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Default entry point
BEGIN:

GOTOACT:
RECHECK:
	Evaluate();

DODGED:
	if ( AttitudeTo( Enemy ) != ATTITUDE_Hate )
		GotoState( 'AIAttack' );	// attitude has changed, re-evaluate attack

// Entry point when resuming this state
RESUME:
	if ( LostPlayerVisual( Enemy ) && ( HearingEffector.GetSensorLevel() < 0.10 ) )
	{
		DebugInfoMessage( " lost player sense" );
		GotoState( 'AIAmbush' );
	}
	else if ( !ShouldPursue( Enemy ) )
	{
		// FIXLOST
		DebugInfoMessage( " ShouldPursue says NO!" );
		GotoState( 'AIHuntPlayer' );
	}

MOVEMENT:
	if ( actorReachable( Enemy ) && FlankEnemy() )
	{
		DebugInfoMessage( ".AICharge, charging using flank position" );
		if ( UseSpecialDirect( FlankPoint ) )
		{
			PushState( GetStateName(), 'GOTOACT' );
			TargetPoint = GetEnRoutePoint( FlankPoint, -CollisionRadius );
			GotoState( 'AISpecialDirect' );
		}
		PlayRun();
		SetTimer( FVariant( 0.6, 0.1 ), false );
		if ( ShouldChasePoint( FlankPoint ) )
		{
			if ( bCanStrafe )
				StrafeFacing( FlightChasePoint( FlankPoint ), Enemy, FullSpeedScale );
			else
				MoveTo( FlightChasePoint( FlankPoint ), FullSpeedScale );
		}
		else
		{
			if ( bCanFly )
				MoveTo( FlankPoint, FullSpeedScale * 0.75, 3.0 );
			else if ( bCanStrafe )
				StrafeFacing( FlankPoint, Enemy, FullSpeedScale );
			else
				MoveTo( FlankPoint, FullSpeedScale, 3.0 );
		}
		goto 'GOTOACT';
	}
	else if ( actorReachable( Enemy ) || FlightTo( Enemy.Location, true ) )
	{
		DebugInfoMessage( ".AICharge, actorReachable" );
		if ( UseSpecialDirect( Enemy.Location ) )
		{
			PushState( GetStateName(), 'GOTOACT' );
			TargetPoint = Enemy.Location;
			GotoState( 'AISpecialDirect' );
		}
		PlayRun();
		SetTimer( FVariant( 0.6, 0.1 ), false );
		if ( ShouldChasePoint( Enemy.Location ) )
		{
			MoveTo( SetMarker( FlightChasePoint( Enemy.Location ) ), FullSpeedScale );
		}
		else
		{
			DebugInfoMessage( ".AICharge, going to MoveToward( Enemy )" );
			SetMarker( Enemy.Location );
			if ( bCanFly )
			{
				if ( UseFlightCutoff( Enemy ) )
					MoveTo( FlightCutoffPoint( Enemy ), FullSpeedScale * 0.75, 3.0 );
				else
					MoveToward( Enemy, FullSpeedScale * 0.75, 3.0 );
			}
			else
				MoveToward( Enemy, FullSpeedScale, 3.0 );
		}
		goto 'GOTOACT';
	}
	else
	{
		DebugInfoMessage( ".AICharge, trying to path" );
		PathObject = PathToward( Enemy );

		if ( PathObject != none )
		{
			// can path to Enemy
			DebugInfoMessage( ".AICharge, trying to path using " $ PathObject.name $ ", CanPathTo() is " $ CanPathTo( Enemy ) );
			if ( UseSpecialNavigation( NavigationPoint(PathObject) ) )
			{
				PushState( GetStateName(), 'GOTOACT' );
				SpecialNavPoint = NavigationPoint(PathObject);
				GotoState( 'AISpecialNavigation' );
			}
			else
			{
				PlayRun();
				SetTimer( FVariant( 2.0, 0.75 ), false );
				MoveToward( PathObject, FullSpeedScale );
				if ( SpecialNavChoiceAction( NavigationPoint(PathObject) ) )
				{
					if ( ( AeonsNavChoicePoint(PathObject) != none ) &&
						 ( AeonsNavChoicePoint(PathObject).JumpToActor != none ) )
					{
						TargetPoint = GetGotoPoint( AeonsNavChoicePoint(PathObject).JumpToActor.Location );
						if ( IsForwardProgress( TargetPoint, Enemy.Location, 0.5 ) )
						{
							SpecialNavChoiceActing( NavigationPoint(PathObject) );
							PushState( GetStateName(), 'JUMPEDUP' );
							GotoState( 'AIJumpToPoint' );
JUMPEDUP:
							if ( pointReachable( TargetPoint ) && !CloseToPoint( TargetPoint, 2.0 ) )
							{
								PlayRun();
								MoveTo( TargetPoint, FullSpeedScale );
								StopMovement();
							}
							PlayWait();
							if ( SpecialNavTargetAction( NavChoiceTarget(AeonsNavChoicePoint(PathObject).JumpToActor) ) )
							{
								PushState( GetStateName(), 'TAUNTED' );
								GotoState( 'AIQuickTaunt' );
TAUNTED:
							}
						}
					}
				}
				goto 'GOTOACT';
			}
		}
		else
		{
			DebugInfoMessage( ".AICharge, couldn't path" );
		}
	}

	if ( Physics == PHYS_Falling )
	{
		DebugInfoMessage( ".AICharge, waiting in PHYS_Falling delay" );
		Sleep( 0.1 );
		goto 'GOTOACT';
	}

	// Can't do nuttin'.
	if ( Aggression() > 0.5 )
	{
		// Aggressive creatures will pursue.
		if ( bCanFly )
			TargetPoint = LastSeenPos;
		else
			TargetPoint = GetGotoPoint( LastSeenPos );
		GotoState( 'AIChargePoint' );
	}
	else
	{
		// TODO: determine if this is what we want to do here
		GotoState( 'AICantReachEnemy' );
	}
} // state AICharge


//****************************************************************************
// AIJumpToPoint
// try to jump to TargetPoint
//****************************************************************************
state AIJumpToPoint
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ) {}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Ignited(){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		StopTimer();
	}

	// trigger the jump to TargetPoint
	function TriggerJump()
	{
		JumpTo( TargetPoint );
		GotoState( , 'JUMPED' );
	}

	// *** new (state only) functions ***
	function JumpTo( vector thisLoc )
	{
		local vector	addVel;

		addVel = CalculateJump( thisLoc );
		AddVelocity( addVel );
	}

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
DAMAGED:
	StopMovement();
	PlayWait();
	TurnTo( TargetPoint, 20 * DEGREES );
	PlayJump();
	goto 'END';

JUMPED:
	WaitForLanding();
	StopMovement();
	if ( PlayLanding () )
		FinishAnim();
	else
		Sleep( 0.35 );
	PopState();

END:
} // state AIJumpToPoint


//****************************************************************************
// AIJumpAtEnemy
// try to jump toward Enemy
//****************************************************************************
state AIJumpAtEnemy
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ) {}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Ignited(){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		if ( ( Enemy == none ) && !IsInvoked() )
			GotoState( 'AIJumpAtPlayer' );
		ClearOrdersIf( GetStateName() );
		StopTimer();
	}

	// trigger the jump toward the enemy
	function TriggerJump()
	{
		JumpTo( Enemy.Location + ( Enemy.Velocity * GetJumpAttackTime() ) - ( vect(0,0,1) * Enemy.CollisionHeight ) );
		GotoState( , 'JUMPED' );
	}

	// *** new (state only) functions ***
	function JumpTo( vector thisLoc )
	{
		local vector	addVel;

		addVel = CalculateJump( thisLoc );
		AddVelocity( addVel );
	}

	function bool PlayJumpAttackLanding()
	{
		return PlayLanding();
	}


JUMPED:
	DebugInfoMessage( ".AIJumpAtEnemy, waiting for landing" );
	WaitForLanding();
	DebugInfoMessage( ".AIJumpAtEnemy, landed, calling FinishAnim(), IsAnimating is " $ IsAnimating() );
	StopMovement();
	if ( PlayJumpAttackLanding () )
		FinishAnim();
	else
		Sleep( 0.35 );
//	FinishAnim();
	DebugInfoMessage( ".AIJumpAtEnemy, after FinishAnim()" );

// Entry point when returning from AITakeDamage
DAMAGED:
	PopState();

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	TurnToward( Enemy, 30 * DEGREES );
	PlayJumpAttack();

END:
} // state AIJumpAtEnemy


//****************************************************************************
// AIJumpAtPlayer
// Set Enemy to Player and chain to AIJumpAtEnemy.
//****************************************************************************
state AIJumpAtPlayer
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ) {}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		ClearOrdersIf( GetStateName() );
	}

	// *** new (state only) functions ***

BEGIN:
	SetEnemy( FindPlayer() );
	CheckHatedEnemy( Enemy );
	PushState( 'AIAttackPlayer', 'BEGIN' );
	GotoState( 'AIJumpAtEnemy' );
} // state AIJumpAtPlayer


//****************************************************************************
// AIJumpDown
// Jump down from a location inaccessible via the navigation network
//****************************************************************************
state AIJumpDown
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ) {}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	// trigger the jump to TargetPoint
	function TriggerJump()
	{
		local vector	X, Y, Z;
		local vector	AddVel;

		GetAxes( Rotation, X, Y, Z );

		AddVel = X * GroundSpeed * WalkSpeedScale;
		AddVel.Z = 180 + CollisionHeight;
		AddVelocity( AddVel );
		GotoState( , 'JUMPED' );
	}

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
DAMAGED:
	StopMovement();
	PlayJump();
	goto 'END';

JUMPED:
	WaitForLanding();
	StopMovement();
	if ( PlayLanding() )
		FinishAnim();
	else
		Sleep( 0.10 );
	PopState();

END:
} // state AIJumpDown


//****************************************************************************
// AIChargePoint
// Charge to TargetPoint.
//****************************************************************************
state AIChargePoint
{
	// *** ignored functions ***
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function EffectorSeePlayer( actor Sensed )
	{
		SendTeamAIMessage( self, TM_EnemyAcquired, Sensed );
		if ( ( Sensed != Owner ) && ( AttitudeTo( pawn(Sensed) ) == ATTITUDE_Hate ) )
		{
			if ( actorReachable( Sensed ) || ( PathToward( Sensed ) != none ) || FlightTo( Sensed.Location, true ) )
			{
				SetEnemy( pawn(Sensed) );
				GotoState( 'AICharge', 'NOEVAL' );
			}
		}
	}

	function Bump( actor Other )
	{
		CreatureBump( pawn(Other) );
	}

	function bool HandlePowderOfSiren( actor Other )
	{
		DispatchPowder( Other );
		return true;
	}

	function HitWall( vector hitNormal, actor hitWall, byte textureID )
	{
		GotoState( , 'HITWALL' );
	}

	// *** new (state only) functions ***
	// (re)evaluate attack strategy
	function Evaluate()
	{
		local float		distance;

		distance = DistanceTo( Enemy );
		if ( ( distance <= MeleeRange ) || ( ( distance >= ( MeleeRange * 3.5 ) ) && DoFarAttack() ) )
		{
			GotoState( 'AIAttack' );	// falling out of range, re-evaluate attack
			return;
		}
	}

	function AtPoint()
	{
	}


DODGED:
	GotoState( 'AIAttack' );

// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Default entry point
BEGIN:
	FlankPointReset = true;
	LastPathObject = none;

// Entry point when resuming this state
RESUME:

GOTOPT:
	DebugInfoMessage(".AIChargePoint calling FlankPosition().");
	FlankPoint = FlankPosition(TargetPoint);
DontFlank:
	if ( pointReachable( FlankPoint ) || FlightTo( FlankPoint ) )
	{
DIRECT:
		DebugInfoMessage( ".AIChargePoint(), heading directly to TargetPoint" );
		if ( UseSpecialDirect( FlankPoint ) )
		{
//			PushState( GetStateName(), 'GOTOPT' );
			PushState( GetStateName(), 'ATPOINT' );
			TargetPoint = FlankPoint;
			GotoState( 'AISpecialDirect' );
		}
		PlayRun();
		if ( FastTrace( FlankPoint ) && ( DistanceToPoint( FlankPoint ) > 500.0 ) )
			MoveTo( FlankPoint, FullSpeedScale, 5.0 );
		else
			MoveTo( FlankPoint, FullSpeedScale );
		DebugInfoMessage( ".AIChargePoint(), got to TargetPoint" );
	}
	else
	{
		DebugInfoMessage( ".AIChargePoint(), can't get to TargetPoint <" $ FlankPoint $ ">, trying to path..." );
		PathObject = PathTowardPoint( FlankPoint );
		if ( PathObject != none )
		{
			DebugInfoMessage( ".AIChargePoint(), pathing to PathObject " $ PathObject.name  );
			// can path to TargetPoint
			if ( UseSpecialNavigation( NavigationPoint(PathObject) ) )
			{
				PushState( GetStateName(), 'GOTOPT' );
				SpecialNavPoint = NavigationPoint(PathObject);
				GotoState( 'AISpecialNavigation' );
			}
			else
			{
				PlayRun();
				if ( bCanFly && ( PathObject == LastPathObject ) )
				{
					DebugInfoMessage( ".AIChargePoint, ** flyer is slowing to reach path node **" );
					MoveToward( PathObject, FullSpeedScale * 0.30, FVariant( 1.5, 0.5 ) );
				}
				else
					MoveToward( PathObject, FullSpeedScale, FVariant( 1.5, 0.5 ) );
				LastPathObject = PathObject;
				DebugInfoMessage( ".AIChargePoint(), got to PathObject " $ PathObject.name );
				goto 'GOTOPT';
			}
		}
		else
		{
			// couldn't path to TargetPoint
			DebugInfoMessage( ".AIChargePoint(), unable to path to TargetPoint" );
			// Can't path, so see if can get directly to TargetPoint.
			if ( FlightTo( TargetPoint, true ) )
				goto 'DIRECT';
			if( TargetPoint != FlankPoint )
			{
				FlankPoint = TargetPoint;
				goto 'DontFlank';
			}
			// TODO: determine how to handle this case
			GotoState( 'AICantReachEnemy' );
		}
	}

HITWALL:
	StopMovement();
	PlayWait();

ATPOINT:
	AtPoint();
	if ( Enemy != none )
	{
		TurnToward( Enemy );
		TargetPoint = Enemy.Location;
		if ( EyesCanSee( Enemy.Location ) )
			GotoState( 'AIAttack' );
	}
	GotoState( 'AIChasePlayer' );
} // state AIChargePoint


//****************************************************************************
// AIChargePointToAttack
// Charge to TargetPoint, then go to AIAttack.
//****************************************************************************
state AIChargePointToAttack extends AIChargePoint
{
	// *** ignored functions ***

	// *** overridden functions ***
	function vector FlankPosition( vector TargetPt )
	{
		return TargetPt;
	}

	function AtPoint()
	{
		GotoState( 'AIAttack' );
	}

	// *** new (state only) functions ***

} // state AIChargePointToAttack


//****************************************************************************
// AIChargeCovered
// charge toward Enemy, using cover points
//****************************************************************************
state AIChargeCovered
{
	// *** ignored functions ***
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState( "Enemy is " $ Enemy.name );
		StopTimer();
	}

	function EndState()
	{
		DebugEndState();
		UnSetCrouch();
	}

	function bool IsCoveredState()
	{
		return true;
	}

	function Timer()
	{
		local AeonsCoverPoint	newTarget;
		local float				RandNum;
		local bool				bCanSeeEnemy;

		bCanSeeEnemy = ( VisionEffector.GetSensorLevel() > 0.20 );

		if ( !bCanSeeEnemy && bNoAdvance )
		{
			PushState( GetStateName(), 'PEEKED' );
			if ( InCrouch() )
				GotoState( 'AICrouchedPeek' );
			else
				GotoState( 'AICoveredPeek' );
			return;
		}

		newTarget = AssessCover();
		if ( ( newTarget != none ) && ( newTarget != CoverPoint ) )
		{
			DebugInfoMessage( ".AssessCover() changed CoverPoint to " $ CoverPoint.name );
			CoverPoint = newTarget;
			GotoState( , 'CHANGE_COVER' );
			return;
		}

		RandNum = FRand();
		if ( ( ( RandNum < 0.10 ) && !bNoAdvance ) || !bCanSeeEnemy )
		{
			newTarget = GetCoverPoint( true );
			if ( newTarget != none )
			{
				CoverPoint = newTarget;
				GotoState( , 'CHANGE_COVER' );
				return;
			}
			else
			{
				if ( ( FRand() < 0.25 ) && !bNoAdvance )
				{
					GotoState( 'AICharge' );
					return;
				}
			}
		}
		else if ( RandNum < 0.80 )
		{
			GotoState( , 'ATTACK' );
			return;
		}
		
		if ( !bCanSeeEnemy && ( FRand() < 0.40 ) )
		{
			PushState( GetStateName(), 'PEEKED' );
			if ( InCrouch() )
				GotoState( 'AICrouchedPeek' );
			else
				GotoState( 'AICoveredPeek' );
			return;
		}

		SetTimer( FVariant( 2.5, 0.5 ), false );
	}

	function Bump( actor Other )
	{
		CreatureBump( pawn(Other) );
	}

	function HitWall( vector hitNormal, actor hitWall, byte textureID )
	{
		StopMovement();
		PlayWait();
		GotoState( , 'HITWALL' );
	}

	// *** new (state only) functions ***
	// get a cover point to Enemy.  Optimal point is a closer, forward moving location.
	function AeonsCoverPoint GetCoverPoint( bool bOptimal )
	{
		local vector			cVect;
		local vector			dVect;
		local AeonsCoverPoint	cPoint;
		local AeonsCoverPoint	bestPoint;
		local float				bestDist;

		bestPoint = none;
		if ( bOptimal )
			bestDist = DistanceToPoint( Enemy.Location ) * 0.80;
		else
			bestDist = DistanceToPoint( Enemy.Location ) * 5.0;

		FlankPointReset = true;
//		dVect = Normal( FlankPosition( Enemy.Location ) - Location ); 
		dVect = Normal( Enemy.Location - Location ); 

		foreach RadiusActors( class'AeonsCoverPoint', cPoint, bestDist )
		{
			cVect = Normal(cPoint.Location - Location);
			if ( ( cPoint != CoverPoint ) &&
				 !EnemyCanSee( cPoint.Location ) &&
				 !cPoint.IsCovered() &&
				 !CloseToPoint( cPoint.Location, 1.5 ) &&
				 ( ( vector(cPoint.Rotation) dot Normal(Enemy.Location - cPoint.Location) ) > 0.5 ) &&
				 ( ((1.25 - (cVect dot dVect)) * DistanceToPoint( cPoint.Location )) < bestDist ) &&
				 ( actorReachable( cPoint ) || ( pathToward( cPoint ) != none ) ) )
			{
				// point is "between" Enemy and self, is facing Enemy, and is probably worth going to
				if ( !bOptimal || IsForwardProgress( cPoint.Location, Enemy.Location, 0.5 ) )
				{
					bestPoint = cPoint;
					bestDist = (2.0 - (cVect dot dVect)) * DistanceToPoint( cPoint.Location );
				}
			}
		}
		return bestPoint;
	}

	// See if we should move to another cover point.
	function AeonsCoverPoint AssessCover()
	{
		if ( ( CoverPoint != none ) &&
			 EnemyCanSee( CoverPoint.Location ) &&
			 EnemyCanSee( Location ) )
		{
			DebugInfoMessage( ".AssessCover(), looking for new cover" );
			return GetCoverPoint( false );
		}
		return CoverPoint;
	}


// Entry point when advancing.
CHANGE_COVER:
	SendTeamAIMessage( self, TM_Advance, Enemy ); // tell team members to advance.
	goto 'GOTOACT';

// Entry point when triggered by a team message.
ADVANCE:
	StopTimer();	// Don't want to reassess cover point while moving.
	goto 'BEGIN';

ATTACK:
	if ( !bHasFarAttack )
		GotoState( 'AICharge' );
	if ( TriggerSwitchToMelee() )
	{
		PushState( GetStateName(), 'ATTACK' );
		StopMovement();
		GotoState( 'AISwitchToMelee' );
	}
	PushState( GetStateName(), 'ATTACKED' );
	if ( InCrouch() && !FullyExposed( Enemy ) )
		GotoState( 'AICoveredAttack', 'INCROUCH' );
	else
		GotoState( 'AICoveredAttack' );

// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:
DODGED:
//	if ( CoverPoint != none )
//		goto 'GOTOACT';
	CoverPoint = none;

// Default entry point
BEGIN:
	CoverPoint = GetCoverPoint( true );

GOTOACT:
	if ( InCrouch() )
	{
		UnSetCrouch();
		PlayWait();
		Sleep( 0.3 );
	}

	if ( CoverPoint != none )
	{
		DebugInfoMessage( ".AIChargeCovered, CoverPoint is " $ CoverPoint.name );
		CoverPoint.SetCovering( self );
		if ( actorReachable( CoverPoint ) )
		{
			if ( UseSpecialNavigation( CoverPoint ) )
			{
				PushState( GetStateName(), 'GOTCOVER' );
				SpecialNavPoint = CoverPoint;
				GotoState( 'AISpecialNavigation' );
			}
			else
			{
				PlayRun();
				MoveToward( CoverPoint, FullSpeedScale );
			}
		}
		else
		{
			PathObject = PathToward( CoverPoint );
			if ( PathObject != none )
			{
				// can path to Enemy
				if ( UseSpecialNavigation( NavigationPoint(PathObject) ) )
				{
					PushState( GetStateName(), 'GOTOACT' );
					SpecialNavPoint = NavigationPoint(PathObject);
					GotoState( 'AISpecialNavigation' );
				}
				else
				{
					PlayRun();
					MoveToward( PathObject, FullSpeedScale );
					goto 'GOTOACT';
				}
			}
			else
			{
//				goto 'END';
				goto 'TURRET';
			}
		}
GOTCOVER:
		StopMovement();
		PlayWait();
		if ( bCanCrouch && ( FRand() <= CoverPoint.CrouchChance ) )
		{
			SetCrouch();
			PlayWait();
			Sleep( 0.3 );
		}

		// Move as close to cover as possible.
		if ( CoverPoint.bMoveToCover )
		{
			TurnTo( CoverPoint.LookAtPoint, 20 * DEGREES );
			PlayWalk();
			MoveTo( CoverPoint.LookAtPoint, WalkSpeedScale * 0.5 );
		}

HITWALL:
ATTACKED:
PEEKED:
		SetTimer( FVariant( 2.5, 0.5 ), false );

TURRET:
		TurnTo( EnemyAimSpot(), 30 * DEGREES );
		if ( FullyExposed( Enemy ) )
		{
			if ( FRand() < Aggressiveness )
				goto 'ATTACK';
			else
			{
				StopTimer();
				Timer();
			}
		}
		Sleep( 0.2 );
		goto 'TURRET';
	}
	else
	{
		DebugInfoMessage( ".AIChargeCovered(), CoverPoint is (suddenly) none" );
		GotoState( 'AICharge', 'NOEVAL' );
	}

END:
} // state AIChargeCovered


//****************************************************************************
// AIBlindCharge
// Charge toward TargetPoint, regardless of reachability.
//****************************************************************************
state AIBlindCharge
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function Timer()
	{
		GotoState( , 'RESUME' );
	}


// Default entry point
BEGIN:
	SetTimer( 3.0, false );
	PlayRun();
	MoveTo( TargetPoint, FullSpeedScale );

// Entry point when resuming this state
RESUME:
	PopState();
} // state AIBlindCharge


//****************************************************************************
// AICantReachEnemy
// can see, but can't reach Enemy
//****************************************************************************
state AICantReachEnemy
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function EnemyNotVisible(){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState( "Enemy.Location is <" $ Enemy.Location $ ">" );
		MoveTarget = none;
	}

	function Timer()
	{
		local vector	TPoint;
		local actor		TActor;

		if ( Enemy == none )
		{
			GotoState( 'AIAttack' );
			return;
		}

		DebugInfoMessage( ".AICantReachEnemy, CanPathTo( Enemy ) is " $ CanPathTo( Enemy ) );
		if ( CanPathTo( Enemy ) )
		{
			GotoState( 'AIAttack' );
			return;
		}

		TActor = FindAmbushWhenLost( Enemy.Location );
		if ( ( TActor != none ) && ( !CloseToPoint( TActor.Location, 2.0 ) ) )
		{
			DebugInfoMessage( ".AICantReachEnemy, FindAmbushWhenLost() found " $ TActor.name $ " as reachable ambush point" );
			TargetActor = TActor;
			GotoState( , 'AMBUSH' );
			return;
		}

		if ( !bCanFly && bTrySeekAlternate )
		{
			TActor = FindAlternatePoint( Enemy );
			if ( TActor != none )
			{
//				TargetPoint = TActor.Location;
				DebugInfoMessage( ".AICantReachEnemy, FindAlternatePoint() picked " $ TActor.name $ " as reachable NavPoint" $ ", CanPathTo() is " $ CanPathTo( TActor ) $ ", CanPathToPoint() is " $ CanPathToPoint( TActor.Location ) );
//				GotoState( 'AIChargePointToAttack' );
				TargetActor = TActor;
				GotoState( , 'GOTONAV' );
				return;
			}
			else
				DebugInfoMessage( ".AICantReachEnemy, FindAlternatePoint() found NONE" );
		}

		if ( !bCanFly && bTryStepForward && CanStepForward() )
		{
			TargetPoint = GetStepLocation();
			GotoState( , 'STEP' );
			return;
		}

		DebugInfoMessage( ".AICantReachEnemy, bHasFarAttack=" $ bHasFarAttack $ ", EyesCanSee() is " $ EyesCanSee( Enemy.Location ) $ ", DoFarAttack() returns " $ DoFarAttack() );
		if ( bHasFarAttack &&
			 EyesCanSee( Enemy.Location ) &&
			 ( DoFarAttack() || ( FRand() < 0.15 ) ) )
		{
			GotoState( 'AIFarAttack' );
			return;
		}

		if ( !bCanFly && ( FRand() < 0.40 ) )
		{
			TPoint = FindReachablePoint( Enemy );
			if ( CanPathToPoint( TPoint ) &&
				 ( VSize(TPoint - Enemy.Location) < DistanceTo( Enemy ) ) )
			{
				TargetPoint = TPoint;
				DebugInfoMessage( ".AICantReachEnemy, picked <" $ TargetPoint $ "> as reachable TargetPoint" );
				GotoState( 'AIChargePointToAttack' );
				return;
			}
		}

		if ( FRand() < 0.10 )
		{
			PushState( 'AIAttack', 'BEGIN' );
			GotoState( 'AIQuickTaunt' );
			return;
		}

		GotoState( 'AIAttack' );
	}

	function HitWall( vector hitNormal, actor hitWall, byte textureID )
	{
		GotoState( , 'HITWALL' );
	}

	// *** new (state only) functions ***
	// Check if I have a special navigation method from this lost position.
	function CheckSpecialNavigation()
	{
	}

	// Try to find a reachable point near this actor
	function vector FindReachablePoint( actor thisActor )
	{
		local rotator	DRot;
		local float		DMult;
		local vector	DVect;
		local int		lp, octant;

//		DRot = rotator(Location - thisActor.Location);
		DRot = rotator(VRand());
		DRot.Pitch = 0;
		DMult = FVariant( 9.0, 1.0 );
		for ( lp = 0; lp < 3; lp++ )
		{
			for ( octant = 0; octant < 8; octant++ )
			{
				DVect = GetGroundPoint( thisActor.Location + vector(DRot) * CollisionRadius * DMult );
				if ( CanPathToPoint( DVect ) )
					return DVect;
				DRot.Yaw = ( DRot.Yaw + 8192 ) & 65535;
			}
			DMult *= 2.0;
		}
		return thisActor.Location;
	}

	function actor FindAlternatePoint( actor ThisActor )
	{
		local float				EDist;
		local float				PDist;
		local float				BestDist;
		local NavigationPoint	Nav;
		local NavigationPoint	BestPt;
		local float				TDist;

		EDist = VSize(Location - ThisActor.Location);

		BestPt = none;
		foreach RadiusActors( class'NavigationPoint', Nav, 2500.0 )
		{
			TDist = VSize(Nav.Location - ThisActor.Location);
			if ( !FastTrace( Nav.Location, ThisActor.Location ) )
				TDist = TDist * 5.0;
			if ( TDist < EDist )
			{
				PDist = PathDistanceTo( Nav );
				if ( PDist > ( CollisionRadius * 5.0 ) )
				{
					BestPt = Nav;
					EDist = TDist;
				}
			}
		}
		return BestPt;
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:
DODGED:

// Default entry point
BEGIN:
	StopMovement();
	PlayWait();
	CheckSpecialNavigation();
//	SetTimer( FVariant( 3.0, 1.0 ), false );
	SetTimer( FVariant( 1.5, 0.5 ), false );

TURRET:
	TurnTo( EnemyAimSpot(), 30 * DEGREES );
	Sleep( 0.1 );
	goto 'TURRET';

STEP:
	if ( Abs(Location.Z - TargetPoint.Z) > ( MaxStepHeight * 1.0 ) )
	{
		DebugInfoMessage( ".AICantReachEnemy, trying to jump down" );
		PushState( GetStateName(), 'JUMPED' );
		GotoState( 'AIJumpToPoint' );
	}
	else
	{
		DebugInfoMessage( ".AICantReachEnemy, trying to step forward, bAvoid is " $ bAvoidLedges $ ", bStop is " $ bStopAtLedges );
		PlayWalk();
		SetMarker( TargetPoint );
		if ( !bCanJump )
		{
			// I know this is safe, so cheat the physics movement code to allow it.
			bCanJump = true;
			MoveTo( TargetPoint, WalkSpeedScale );
			bCanJump = false;

		}
		else
			MoveTo( TargetPoint, WalkSpeedScale );
	}
JUMPED:
HITWALL:
	StopMovement();
	PlayWait();
	GotoState( 'AIAttack' );

GOTONAV:
	if ( TargetActor != none )
	{
		SetTimer( FVariant( 3.0, 1.0 ), false );
GOTOPT:
		if ( actorReachable( TargetActor ) )
		{
			PlayRun();
			MoveToward( TargetActor, FullSpeedScale );
		}
		else
		{
			PathObject = PathToward( TargetActor );
			if ( PathObject != none )
			{
				// can path to OrderObject
				PlayRun();
				MoveToward( PathObject, FullSpeedScale );
				goto 'GOTOPT';
			}
		}
	}
	goto 'BEGIN';

AMBUSH:
	if ( TargetActor != none )
	{
		SetTimer( FVariant( 6.0, 1.0 ), false );
GOTOPT2:
		if ( actorReachable( TargetActor ) )
		{
			PlayRun();
			MoveToward( TargetActor, FullSpeedScale );
		}
		else
		{
			PathObject = PathToward( TargetActor );
			if ( PathObject != none )
			{
				// can path to OrderObject
				PlayRun();
				MoveToward( PathObject, FullSpeedScale );
				goto 'GOTOPT2';
			}
		}
	}
	if ( AeonsNavNode(TargetActor) != none )
		TurnTo( AeonsNavNode(TargetActor).LookAtPoint, 10 * DEGREES );
	GotoState( 'AIAmbush' );

} // state AICantReachEnemy


//****************************************************************************
// AIDodge
// Umm... dodge.
//****************************************************************************
state AIDodge
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***

	// *** new (state only) functions ***
	function vector SetTargetPoint( float distance )
	{
		local vector	X, Y, Z;
		local vector	gSpot;

		GetAxes( Rotation, X, Y, Z );
		gSpot = Location + ( Y * distance );

		if ( !FastTrace( gSpot, Location ) )
		{
			// hit geometry that direction, try other
			return Location - ( Y * distance );
		}
		else
			return gSpot;
	}

// Entry point when returning from AITakeDamage
DAMAGED:
//	TookDamage( SensedActor );
	StopMovement();
	PlayWait();
	PopState();

PICKRIGHT:
	TargetPoint = SetTargetPoint( CollisionRadius * 4.0 );
	goto 'DODGE';

PICKLEFT:
	TargetPoint = SetTargetPoint( -CollisionRadius * 4.0 );
	goto 'DODGE';

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	// pick random dodge direction
	if ( FRand() < 0.5 )
	{
		// go left
		TargetPoint = SetTargetPoint( -CollisionRadius * 4.0 );
	}
	else
	{
		// go right
		TargetPoint = SetTargetPoint( CollisionRadius * 4.0 );
	}

DODGE:
	if ( !bCanStrafe )
		goto 'GOTOPT';
	SetMarker( TargetPoint );	// TEMP
	PlayStrafe( TargetPoint, 1.0 );
	StrafeTo( TargetPoint, Location + vector(Rotation) * 32000.0, WalkSpeedScale );
	StopMovement();
	PopState();

GOTOPT:
	if ( pointReachable( TargetPoint ) )
	{
		PlayRun();
		MoveTo( TargetPoint, FullSpeedScale );
	}
	else
	{
		PathObject = PathTowardPoint( TargetPoint );
		if ( PathObject != none )
		{
			// can path to TargetPoint
			if ( UseSpecialNavigation( NavigationPoint(PathObject) ) )
			{
				PushState( GetStateName(), 'GOTOPT' );
				SpecialNavPoint = NavigationPoint(PathObject);
				GotoState( 'AISpecialNavigation' );
			}
			else
			{
				PlayRun();
				MoveToward( PathObject, FullSpeedScale );
				goto 'GOTOPT';
			}
		}
		else
		{
			// couldn't path to TargetPoint
			// TODO: determine how to handle this case
		}
	}
	StopMovement();
	PopState();
} // state AIDodge


//****************************************************************************
// AIAvoidHazard
// avoid effector-controlled hazard(s)
//****************************************************************************
state AIAvoidHazard
{
	// *** ignored functions ***
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ) {}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function BeginState()
	{
		global.BeginState();
		PushLookAt( none );
	}

	function EndState()
	{
		global.EndState();
		PopLookAt();
	}

	function Timer()
	{
		if ( ActiveHazards() > 0 )
			GotoState( , 'PICKPT' );
		else
		{
			StopMovement();
			PopState();
		}
	}

	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
	{
		ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
	}

	//
	function Bump( actor Other )
	{
		CreatureBump( pawn(Other) );
	}

	// *** new (state only) functions ***
	//
	function vector SetTargetPoint()
	{
		local SPEffector		pEffector;
		local SPHazardEffector	bEffector;
		local vector			gSpot;
		local vector			dVect;
		local vector			hSpot;

		gSpot = Location;
		pEffector = FirstEffector;
		while ( pEffector != none )
		{
			bEffector = SPHazardEffector(pEffector);
			if ( ( bEffector != none ) && ( bEffector.TrackingActor != none ) )
			{
				hSpot = GetGotoPoint( bEffector.TrackingActor.Location );
				dVect = hSpot - gSpot;
				if ( VSize(dVect) < bEffector.AvoidDistance )
				{
					dVect.Z = 0.0;
					gSpot = hSpot - ( Normal(dVect) * bEffector.AvoidDistance * 1.10 );
				}
			}
			pEffector = pEffector.nextEffector;
		}
		return GetGotoPoint( gSpot );
	}

	// get the count of valid hazards
	function int ValidHazards()
	{
		local SPEffector		pEffector;
		local SPHazardEffector	bEffector;
		local int				count;
		local vector			DVect;
		local float				DDist;

		pEffector = FirstEffector;
		count = 0;
		while ( pEffector != none )
		{
			bEffector = SPHazardEffector(pEffector);
			if ( ( bEffector != none ) &&
				 ( bEffector.TrackingActor != none ) )
			{
				DVect = GetGotoPoint( bEffector.TrackingActor.Location ) - Location;
				DDist = VSize(DVect);
				if ( ( DDist < bEffector.AvoidDistance ) ||
					 ( ( DDist < ( bEffector.AvoidDistance * 2 ) ) && ( ( Normal(DVect) dot Normal(Enemy.Location - Location) ) > 0.15 ) ) )
					count++;
			}
			pEffector = pEffector.nextEffector;
		}
		return count;
	}

	// get the count of active hazards
	function int ActiveHazards()
	{
		local SPEffector		pEffector;
		local int				count;

		pEffector = FirstEffector;
		count = 0;
		while ( pEffector != none )
		{
			if ( SPHazardEffector(pEffector) != none )
				count++;
			pEffector = pEffector.nextEffector;
		}
		return count;
	}

	// get the SPHazardEffector that's closest to expiring
	function actor GetPriorityHazard()
	{
		local SPEffector		pEffector;
		local actor				bestActor;
		local float				bestTime;

		pEffector = FirstEffector;
		bestActor = none;
		while ( pEffector != none )
		{
			if ( SPHazardEffector(pEffector) != none )
			{
				if ( ( bestActor == none ) || ( pEffector.GetDuration() < bestTime ) )
				{
					bestActor = SPHazardEffector(pEffector).GetTrackingActor();
					bestTime = pEffector.GetDuration();
				}
			}
			pEffector = pEffector.nextEffector;
		}
		return bestActor;
	}


SELF:
	StopMovement();
	PlayWait();
	Sleep( 2.0 );

// Entry point when returning from AITakeDamage
DAMAGED:

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	StopMovement();
	if ( ActiveHazards() == 0 )
		PopState();

PICKPT:
	SetTimer( 0.1, false );
	if ( ValidHazards() == 0 )
		goto 'ATPOINT';
	TargetPoint = SetTargetPoint();

GOTOPT:
	if ( CloseToPoint( TargetPoint, 1.0 ) )
		goto 'ATPOINT';

	if ( pointReachable( TargetPoint ) )
	{
		PlayRun();
		MoveTo( TargetPoint, FullSpeedScale );
	}
	else
	{
		PathObject = PathTowardPoint( TargetPoint );
		if ( PathObject != none )
		{
			// can path to TargetPoint
			if ( UseSpecialNavigation( NavigationPoint(PathObject) ) )
			{
				PushState( GetStateName(), 'PICKPT' );
				SpecialNavPoint = NavigationPoint(PathObject);
				GotoState( 'AISpecialNavigation' );
			}
			else
			{
				PlayRun();
				MoveToward( PathObject, FullSpeedScale );
				goto 'GOTOPT';
			}
		}
		else
		{
			// couldn't path to TargetPoint
			// TODO: determine how to handle this case
		}
	}

ATPOINT:
	StopMovement();
	PlayWait();

TURRET:
	if ( ValidHazards() == 0 )
		PopState();
	if ( Enemy != none )
	{
		TurnToward( Enemy, 60 * DEGREES );
	}
	else
	{
		TargetActor = GetPriorityHazard();
		if ( TargetActor != none )
		{
			TurnToward( TargetActor, 60 * DEGREES );
		}
	}
	Sleep( 0.1 );
	goto 'TURRET';
} // state AIAvoidHazard


//****************************************************************************
// AIFleeHide
// avoid effector-controlled hazard(s)
//****************************************************************************
state AIFleeHide
{
	// *** ignored functions ***
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ) {}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	//
	function Timer()
	{
		DebugInfoMessage( ".AIFleeHide.Timer()" );
		if ( PrimaryThreat() != none )
		{
			if ( LookAtManager.KeyTargetActor() == none )
				GotoState( , 'PICKPTANDTURN' );
			else
				GotoState( , 'PICKPT' );
		}
		else
		{
			DebugInfoMessage( ".AIFleeHide.Timer(), no PrimaryThreat found" );
//			StopMovement();
//			PopState();
			GotoState( WarnFromState, 'RESUME' );
		}
	}

	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
	{
		DebugInfoMessage( ".AIFleeHide.WarnAvoidActor()" );
		ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
	}

	//
	function Bump( actor Other )
	{
		CreatureBump( pawn(Other) );
	}

	// *** new (state only) functions ***
	//
	function actor	PrimaryThreat()
	{
		local SPEffector		pEffector;
		local SPHazardEffector	bEffector;
		local float				dist;
		local float				closestDist;
		local actor				closestThreat;

		pEffector = FirstEffector;
		while ( pEffector != none )
		{
			bEffector = SPHazardEffector(pEffector);
			if ( ( bEffector != none ) && ( bEffector.TrackingActor != none ) )
			{
				dist = VSize( bEffector.TrackingActor.Location - Location );
				if ( ( closestThreat == none ) || ( dist < closestDist ) )
				{
					closestDist = dist;
					closestThreat = bEffector.TrackingActor;
				}
			}
			pEffector = pEffector.nextEffector;
		}

		return closestThreat;
	}

	function vector SetTargetPoint()
	{
		local vector			gSpot;
		local vector			dVect;
		local vector			cVect;
		local vector			aVect;
		local AeonsCoverPoint	aPoint;
		local AeonsCoverPoint	cPoint;
		local float				coverDesireability;
		local float				bestCoverDesireability;
		local actor				threat;

		threat = PrimaryThreat();
		if ( threat == none )
		{
			return Location;
		}

		CoverPoint = none;
		dVect =	Location - threat.Location;	// Direction we'd like to move in -- away from threat.
		dVect = Normal(dVect);

		foreach RadiusActors( class 'AeonsCoverPoint', aPoint, 16000.0 )
		{
			cVect = aPoint.Location - threat.Location;
			aVect = aPoint.Location - Location;
			coverDesireability = VSize(aVect) * (2 - ( Normal(cVect) dot dVect ));
			if ( aPoint.IsCovered() )
			{
				// This cover point is less desireable than any other non-covered point within range.
				coverDesireability += 32000.0;
			}
			if ( FastTrace( threat.Location ) )
			{
				// This cover point it less desireable than any other cover point within range.
				coverDesireability += 64000.0;
			}
			if ( ( cPoint == none ) || ( coverDesireability < bestCoverDesireability ) )
			{
				cPoint = aPoint;
				gSpot = aPoint.Location;
				bestCoverDesireability = coverDesireability;
			}
		}

		if ( cPoint == none )
		{
			DebugInfoMessage( ".AIFleeHide() no cover point found." );
		}
		else
		{
			DebugInfoMessage( ".AIFleeHide() go to cover point " $ cPoint.name );
		}

		SetLookAt( threat );
		CoverPoint = cPoint;

		return GetGotoPoint( gSpot );
	}

	// get the count of valid hazards
	function int ValidHazards()
	{
		local SPEffector		pEffector;
		local SPHazardEffector	bEffector;
		local int				count;

		pEffector = FirstEffector;
		count = 0;
		while ( pEffector != none )
		{
			bEffector = SPHazardEffector(pEffector);
			if ( ( bEffector != none ) &&
				 ( bEffector.TrackingActor != none ) &&
				 ( VSize(bEffector.TrackingActor.Location - Location) < ( bEffector.AvoidDistance * 2 ) ) )
				count++;
			pEffector = pEffector.nextEffector;
		}
		return count;
	}

	// get the count of active hazards
	function int ActiveHazards()
	{
		local SPEffector		pEffector;
		local int				count;

		pEffector = FirstEffector;
		count = 0;
		while ( pEffector != none )
		{
			if ( SPHazardEffector(pEffector) != none )
				count++;
			pEffector = pEffector.nextEffector;
		}
		return count;
	}

	// get the SPHazardEffector that's closest to expiring
	function actor GetPriorityHazard()
	{
		local SPEffector		pEffector;
		local actor				bestActor;
		local float				bestTime;

		pEffector = FirstEffector;
		bestActor = none;
		while ( pEffector != none )
		{
			if ( SPHazardEffector(pEffector) != none )
			{
				if ( ( bestActor == none ) || ( pEffector.GetDuration() < bestTime ) )
				{
					bestActor = SPHazardEffector(pEffector).GetTrackingActor();
					bestTime = pEffector.GetDuration();
				}
			}
			pEffector = pEffector.nextEffector;
		}
		return bestActor;
	}

// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	if ( ActiveHazards() == 0 )
	{
		DebugInfoMessage( ".AIFleeHide(), no active hazards." );
		GotoState( WarnFromState, 'RESUME' );
	}

STOPPICKPTANDTURN:
	SetTimer( 0.25, false );
	if ( ValidHazards() == 0 )
		goto 'ATPOINT';
	TargetPoint = SetTargetPoint();
	
	if ( (CoverPoint != none) && !CoverPoint.IsCovered() )
	{
		CoverPoint.SetCovering( self );
	}

	StopMovement();
	PlayWait();
	
	goto 'GOTOPT';

PICKPTANDTURN:
	SetTimer( 0.25, false );
	if ( ValidHazards() == 0 )
		goto 'ATPOINT';
	TargetPoint = SetTargetPoint();
	
	if ( (CoverPoint != none) && !CoverPoint.IsCovered() )
	{
		CoverPoint.SetCovering( self );
	}
	goto 'GOTOPT';

PICKPT:
	SetTimer( 0.25, false );
	if ( ValidHazards() == 0 )
		goto 'ATPOINT';
	TargetPoint = SetTargetPoint();
	SetLookAt( none );
	
	if ( (CoverPoint != none) && !CoverPoint.IsCovered() )
	{
		CoverPoint.SetCovering( self );
	}

GOTOPT:
	if ( CloseToPoint( TargetPoint, 1.0 ) )
		goto 'ATPOINT';

	if ( pointReachable( TargetPoint ) )
	{
		DebugInfoMessage( ".AIFleeHide(), heading to TargetPoint" );
		PlayRun();
		MoveTo( TargetPoint, FullSpeedScale );
	}
	else
	{
		DebugInfoMessage( ".AIFleeHide(), can't get to TargetPoint, trying to path..." );
		PathObject = PathTowardPoint( TargetPoint );
		if ( PathObject != none )
		{
			// can path to TargetPoint
			if ( UseSpecialNavigation( NavigationPoint(PathObject) ) )
			{
				PushState( GetStateName(), 'PICKPT' );
				SpecialNavPoint = NavigationPoint(PathObject);
				GotoState( 'AISpecialNavigation' );
			}
			else
			{
				PlayRun();
				MoveToward( PathObject, FullSpeedScale );
				goto 'GOTOPT';
			}
		}
		else
		{
			// couldn't path to TargetPoint
			// TODO: determine how to handle this case
		}
	}

ATPOINT:
	StopMovement();
	PlayWait();

TURRET:
	if ( Enemy != none )
	{
		TurnToward( Enemy, 60 * DEGREES );
	}
	else
	{
		TargetActor = GetPriorityHazard();
		if ( TargetActor != none )
		{
			TurnToward( TargetActor, 60 * DEGREES );
		}
	}
	Sleep( 0.1 );
	goto 'TURRET';
} // state AIFleeHide


//****************************************************************************
// AIBumpAvoid
// Bumped into BumpedPawn, try to avoid or move around, return via state stack.
//****************************************************************************
state AIBumpAvoid
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function LookTargetNotify( actor Sender, float Duration ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		global.BeginState();
		PushLookAt( none );
	}

	function EndState()
	{
		global.EndState();
		PopLookAt();
	}

	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
	{
		ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
	}

	function HitWall( vector hitNormal, actor hitWall, byte textureID )
	{
		GotoState( , 'STOPWAIT' );
	}

	// *** new (state only) functions ***
	//
	function Dispatch()
	{
		local vector	X, Y, Z, EX;
		local vector	DVect;
		local float		ESpeed;
		local float		MySpeed;

		GetAxes( BumpedPawn.Rotation, EX, Y, Z );
		GetAxes( Rotation, X, Y, Z );
		ESpeed = VSize(BumpedPawn.Velocity);
		MySpeed = VSize(Velocity);
		DVect = BumpedPawn.Location - Location;
		DVect.Z = 0.0;
		DVect = Normal(DVect);

		// Check for different priorities first.
		if ( ScriptedPawn(BumpedPawn) != none )
		{
			if ( ScriptedPawn(BumpedPawn).bBumpPriority && !bBumpPriority )
			{
				BumpPoint = GetBumpPoint( Y, DVect );
				GotoState( , 'GOAROUND' );
				return;
			}
			else if ( !ScriptedPawn(BumpedPawn).bBumpPriority && bBumpPriority )
			{
				PopState();
				return;
			}
		}

		if ( BumpedPawn.Health <= 0 )
		{
			BumpPoint = GetBumpPoint( Y, DVect );
			GotoState( , 'GOAROUND' );
			return;
		}

		// Priorities are the same.
		if ( ( X dot EX ) > 0.0 )
		{
			// Headed in similar directions.
			if ( ( X dot DVect ) > 0.0 )
			{
				// I'm "behind" the BumpedPawn, so I'll stop or go around
				if ( ( ESpeed < 10.0 ) || ( ( ESpeed < MySpeed ) && ( FRand() < 0.90 ) ) )
				{
					BumpPoint = GetBumpPoint( Y, DVect );
					DebugInfoMessage( ".AIBumpAvoid, Headed in similar, I'm behind" );
					GotoState( , 'GOAROUND' );
				}
				else
					GotoState( , 'STOPWAIT' );
			}
			else
			{
				// Headed similar direction, I'm in front.
				if ( MySpeed < 10.0 )
				{
					BumpPoint = GetPointAhead( -DVect );
					DebugInfoMessage( ".AIBumpAvoid, Headed in similiar, I'm in front" );
					GotoState( , 'GOAROUND' );	// I'm blocking, better move.
				}
				else
					PopState();		// I'm moving, just continue
			}
		}
		else
		{
			// Headed in opposite directions.
			BumpPoint = GetBumpPoint( Y, DVect );
			DebugInfoMessage( ".AIBumpAvoid, Headed in opposite" );
			GotoState( , 'GOAROUND' );
		}
	}

	function float ScatterDistance()
	{
		return default.CollisionRadius * FVariant( 3.0, 1.0 );
	}

	function float GetWalkSpeedScale()
	{
		return WalkSpeedScale;
	}

	function vector GetBumpPoint( vector YAxis, vector EXAxis )
	{
		if ( ( YAxis dot EXAxis ) > 0.0 )
		{
			if ( bCanFly && ( Physics == PHYS_Flying ) )
				return Location - ( YAxis * default.CollisionRadius * FVariant( 3.5, 0.5) );
			else
				return GetGotoPoint( Location - ( YAxis * ScatterDistance() ) + vect(0,0,1) * CollisionHeight );
		}
		else
		{
			if ( bCanFly && ( Physics == PHYS_Flying ) )
				return Location + ( YAxis * default.CollisionRadius * FVariant( 3.5, 0.5) );
			else
				return GetGotoPoint( Location + ( YAxis * ScatterDistance() ) + vect(0,0,1) * CollisionHeight );
		}
	}

	function vector GetPointAhead( vector XAxis )
	{
		if ( bCanFly && ( Physics == PHYS_Flying ) )
			return Location + ( XAxis * default.CollisionRadius * FVariant( 3.5, 0.5) );
		else
			return GetGotoPoint( Location + ( XAxis * ScatterDistance() ) + vect(0,0,1) * CollisionHeight );
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	PopState( , 'DAMAGED' );
	goto 'END';

GOAROUND:
	SetMarker( BumpPoint );		// TEMP
	StopMovement();
	TurnTo( BumpPoint, 20 * DEGREES );
	PlayWalk();
	MoveTo( BumpPoint, GetWalkSpeedScale(), FVariant( 3.0, 0.50 ) );
	PopState();
	goto 'END';

STOPWAIT:
	SetMarker( Location );		// TEMP
	DebugInfoMessage( ".AIBumpAvoid, STOPWAIT" );
	StopMovement();
	PlayWait();
	Sleep( FVariant( 1.5, 0.5 ) );
	PopState();

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	Dispatch();

END:
} // state AIBumpAvoid


//****************************************************************************
// AIThreaten
// watch Enemy, maybe move around keeping distance, attack when too close?
//****************************************************************************
state AIThreaten
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorHearNoise( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function Timer()
	{
//		local float		rand;

		if ( AttitudeTo( Enemy ) == ATTITUDE_Hate )
		{
			if ( PreCheckEncounter( Enemy ) )
			{
				SensedActor = Enemy;
				SensedSense = 'Timer in AIThreaten';
				GotoState( 'AIEncounter' );
			}
		}
		else
		{
			switch ( Rand(3) )
			{
//				case 0:
//					TargetPoint = SetTargetPoint();
//					GotoState( , 'STEPBACK' );
//					break;
				case 1:
					GotoState( , 'ANIMATE' );
					break;
				case 0:
				default:
					TriggerNextAction();
					GotoState( , 'WATCH' );
					break;
			}
		}
	}

	// *** new (state only) functions ***
	function TriggerNextAction()
	{
		SetTimer( 4.0 + Reaction( 2.0 ), false );
	}

	//
	function vector SetTargetPoint()
	{
		local vector	dVect;

		dVect = Normal(Location - Enemy.Location);
		return Location + ( dVect * CollisionRadius * 2.0 );
	}

// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:
DODGED:

// Default entry point
BEGIN:
	StopMovement();
	PlayWait();
	WaitForLanding();
	TriggerNextAction();

WATCH:
	TurnToward( Enemy, 60 * DEGREES );
	Sleep( 0.2 );
	goto 'WATCH';

STEPBACK:
	PlayLocomotion( -WalkVector );
	MoveTo( TargetPoint, -WalkSpeedScale );
	StopMovement();
	PlayWait();
	TriggerNextAction();
	goto 'WATCH';

ANIMATE:
	PlayTaunt();
	FinishAnim();
	PlayWait();
	TriggerNextAction();
	goto 'WATCH';
} // state AIThreaten


//****************************************************************************
// AIDefendPoint
// Can't retreat, so watch Enemy and attack when too close
//****************************************************************************
state AIDefendPoint
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ) {}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		if ( Enemy == none )
			SetEnemy( FindPlayer() );
	}

	// *** new (state only) functions ***

// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	StopMovement();
	PlayWait();
	WaitForLanding();

TURRET:
	TurnToward( Enemy, 60 * DEGREES );
	if ( bHasNearAttack && ( DistanceTo( Enemy ) < ( MeleeRange * 1.35 ) ) )
		GotoState( 'AINearAttack' );
	Sleep( 0.2 );
	goto 'TURRET';
} // state AIDefendPoint


//****************************************************************************
// AIQuickTaunt
// Turret toward enemy and play taunt, then return
//****************************************************************************
state AIQuickTaunt
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorHearNoise( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function LookTargetNotify( actor Sender, float Duration ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		PushLookAt( none );
	}

	function EndState()
	{
		DebugEndState();
		PopLookAt();
	}

	// *** new (state only) functions ***

// Entry point when returning from AITakeDamage
DAMAGED:
	PopState( , 'DAMAGED' );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	StopMovement();
	PlayWait();
	WaitForLanding();

	if ( Enemy != none )
		TurnToward( Enemy, 15 * DEGREES );
	PlayTaunt();
	FinishAnim();
	PopState();

AWAKEN:
	StopMovement();
	PlayWait();
	WaitForLanding();
	PlayAwaken();
	FinishAnim();
	PopState();
} // state AIQuickTaunt


//****************************************************************************
// AIAlertReaction
// React to being alerted
//****************************************************************************
state AIAlertReaction
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorHearNoise( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		PushLookAt( none );
	}

	function EndState()
	{
		DebugEndState();
		PopLookAt();
	}

	// *** new (state only) functions ***

// Entry point when returning from AITakeDamage
DAMAGED:
	PopState( , 'DAMAGED' );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	PopState();
} // state AIAlertReaction


//****************************************************************************
// AIGreet
// friendly greeting for TargetActor
//****************************************************************************
state AIGreet
{
	// *** ignored functions ***
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		StopTimer();
	}

	function Timer()
	{
		GotoState( , 'GOTOPT' );
	}

	function Bump( actor Other )
	{
		if ( Other == TargetActor )
			GotoState( , 'DOGREET' );
		CreatureBump( pawn(Other) );
	}

	// *** new (state only) functions ***
	// sets TargetPoint, based on TargetActor and GreetDistance
	function vector GetGreetPoint()
	{
		/*
		local vector	dVect;
		local vector	HitLocation, HitNormal;
		local int		HitJoint;
		local actor		HitActor;

		dVect = Normal( Location - TargetActor.Location ) * GreetDistance;

		HitActor = Trace( HitLocation, HitNormal, HitJoint, TargetActor.Location + dVect, TargetActor.Location, false );
		if ( HitActor == none )
			return TargetActor.Location + dVect;
		else
			return TargetActor.Location;
		*/

		local vector	GPoint;

		if ( FastTrace( TargetActor.Location, Location ) )
		{
			// TODO: handle flying creatures?
			GPoint = GetGotoPoint( GetEnRoutePoint( TargetActor.Location, -( GreetDistance + CollisionRadius + TargetActor.CollisionRadius ) ) );
			if ( CanPathToPoint( GPoint ) )
				return GPoint;
		}
		return TargetActor.Location;
	}

	// (re)evaluate greeting strategy
	function Evaluate()
	{
		local float		distance;
		local bool		bHasLOS;

		distance = DistanceTo( TargetActor );
		bHasLOS = LineOfSightTo( TargetActor );

		if ( ( distance <= GreetDistance ) && bHasLOS )
		{
			// close enough to greet
			GotoState( , 'DOGREET' );
			return;
		}
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:

GOTOPT:
	Evaluate();
	TargetPoint = GetGreetPoint();
	SetMarker( TargetPoint );	// TEMP

	if ( pointReachable( TargetPoint ) )
	{
		SetTimer( FVariant( 1.0, 0.5 ), false );
		PlayWalk();
		MoveTo( TargetPoint, WalkSpeedScale );
		goto 'DOGREET';
	}
	else
	{
		PathObject = PathTowardPoint( TargetPoint );
		if ( PathObject != none )
		{
			// can path to TargetPoint
			SetTimer( FVariant( 1.0, 0.5 ), false );
			PlayWalk();
			MoveToward( PathObject, WalkSpeedScale );
		}
		else
		{
			// couldn't path to OrderObject
			StopMovement();
			PlayWait();
			TurnToward( TargetActor, 5 * DEGREES );
			Sleep( 2.0 );
		}
	}
	goto 'GOTOPT';

DOGREET:
	StopTimer();
	DebugInfoMessage( ".AIGreet, greeting, distance to Target is " $ VSize(Location - TargetActor.Location) $ ", coll radii are " $ CollisionRadius $ ", " $ TargetActor.CollisionRadius );
	StopMovement();
	TurnToward( TargetActor, 5 * DEGREES );
	PlayGreetSound();
	PlayGreeting();
	FinishAnim();
	if ( ( PlayerPawn(TargetActor) != none ) && PlayerPawn(TargetActor).bIsPlayer )
	{
		AttitudeToPlayer = ATTITUDE_Follow;
		GotoState( 'AIFollow' );
	}
	GotoLastState();
} // state AIGreet


//****************************************************************************
// AIRetreat
// retreat from Enemy, pick a retreat point and seek it
//****************************************************************************
state AIRetreat
{
	// *** ignored functions ***
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function BeginState()
	{
		ResetStateStack();
		DebugBeginState( "RetreatPointTag is " $ RetreatPointTag $ ", OrderTag is " $ OrderTag );
		SendTeamAIMessage( self, TM_Retreat, Enemy );
	}

	function Bump( actor Other )
	{
		CreatureBump( pawn(Other) );
	}

	function bool IsCovering( AeonsCoverPoint thisPoint )
	{
		return ( thisPoint == RetreatPoint );
	}

	function FearThisSpot( actor ASpot )
	{
		DebugInfoMessage( ".AIRetreat.FearThisSpot(), " $ ASpot.name );
	}

	// *** new (state only) functions ***
	// return the AeonsCoverPoint tagged with the name passed
	function AeonsCoverPoint GetTaggedCoverPoint( name thisTag )
	{
		local AeonsCoverPoint	cPoint;

		foreach AllActors( class'AeonsCoverPoint', cPoint, thisTag )
			return cPoint;
		return none;
	}

	// return closest cover point
	function AeonsCoverPoint FindNearCoverPoint( vector thisLoc )
	{
		local AeonsCoverPoint	cPoint, aPoint;
		local float				MinDist;
		local float				PointDist;
		local float				EnemyDist;

		cPoint = none;
		EnemyDist = VSize( Enemy.Location - thisLoc );
		foreach AllActors( class'AeonsCoverPoint', aPoint )
		{
			PointDist = VSize(aPoint.Location - thisLoc);
			if ( ( ( cPoint == none ) || ( PointDist < MinDist ) ) &&
				 !aPoint.IsCovered() &&
				 ( PointDist > EnemyDist ) &&
				 GoodCoverPoint( aPoint ) &&
				 CanPathTo( aPoint ) )
			{
				cPoint = aPoint;
				MinDist = PointDist;
			}
		}

		// if we've selected a point that isn't on a retreat path and it has a co-cover point that is, use that point instead
		if ( ( cPoint != none ) &&
			 ( cPoint.NextPoint == none ) &&
			 ( cPoint.CoCoverPoint != none ) &&
			 ( cPoint.CoCoverPoint.NextPoint != none ) )
			cPoint = cPoint.CoCoverPoint;

		return cPoint;
	}

	function bool GoodCoverPoint( AeonsCoverPoint cPoint )
	{
		local vector	ePoint;

		ePoint = cPoint.Location + vect(0,0,1) * ( CollisionHeight - cPoint.CollisionHeight );
		return !FastTrace( ePoint, Enemy.Location );
	}

	function bool SafeRetreatPoint( AeonsCoverPoint cPoint )
	{
		return !( ( Enemy != none ) && ( VSize(Enemy.Location - cPoint.Location) < SafeDistance ) && ( cPoint.NextPoint != none ) );
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	DebugInfoMessage( ".AIRetreat, label DAMAGED" );
	TookDamage( SensedActor );
	goto 'LOST';

// Entry point when resuming this state
RESUME:
	DebugInfoMessage( ".AIRetreat, label RESUME" );
DODGED:

// Default entry point
BEGIN:
	DebugInfoMessage( ".AIRetreat, label BEGIN" );
	WaitForLanding();
	SetAlertness( 1.0 );

GOTONEXT:
	if ( RetreatPoint == none )
	{
		if ( RetreatPointTag != '' )
			RetreatPoint = GetTaggedCoverPoint( RetreatPointTag );
		if ( ( RetreatPoint == none ) && ( OrderTag != '' ) )
			RetreatPoint = GetTaggedCoverPoint( OrderTag );
		if ( RetreatPoint == none )
			RetreatPoint = GetTaggedCoverPoint( class.name );
		if ( RetreatPoint == none )
			RetreatPoint = FindNearCoverPoint( Location );
		if ( RetreatPoint == none )
		{
			// TODO: ClearOrdersIf() call here?
			DebugInfoMessage( ".AIRetreat, COULDN'T FIND A RETREAT POINT!!!!!!!!!" );
			PlayWait();
			StopMovement();
			Sleep( 3.0 );
			GotoInitState();
		}
	}

GOTPOINT:
	DebugInfoMessage( ".AIRetreat, label GOTPOINT" );
	SetEnemy( none );
	WaitForLanding();
	if ( RetreatPoint == none )
		goto 'GOTONEXT';
	OrderObject = RetreatPoint;

	if ( ( RetreatPoint != none ) && ( RetreatPoint.CoCoverPoint != none ) && !GoodCoverPoint( RetreatPoint ) )
	{
		// if the assigned/selected cover point has poor coverage, has a co-cover point and that co-cover point has good coverage...
		if ( GoodCoverPoint( RetreatPoint.CoCoverPoint ) )
			OrderObject = RetreatPoint.CoCoverPoint;	// use the co-cover point
	}

	AeonsCoverPoint(OrderObject).SetCovering( self );
	DebugInfoMessage( ".AIRetreat, OrderObject is " $ OrderObject.name );

GOTOACT:
	if ( AeonsCoverPoint(OrderObject) != none )
	{
		if ( !CloseToPoint( OrderObject.Location, 1.5 ) && SafeRetreatPoint( AeonsCoverPoint(OrderObject) ) )
		{
			if ( actorReachable( OrderObject ) )
			{
				PlayRun();
				MoveToward( OrderObject, FullSpeedScale );
			}
			else
			{
				PathObject = PathTowardOrder();
				if ( PathObject != none )
				{
					// can path to OrderObject
					DebugInfoMessage( ".AIRetreat @" $ Level.TimeSeconds $ ", PathObject is " $ PathObject.name );
					PlayRun();
					MoveToward( PathObject, FullSpeedScale );
					if ( SpecialNavChoiceAction( NavigationPoint(PathObject) ) )
					{
						if ( ( AeonsNavChoicePoint(PathObject) != none ) &&
							 ( AeonsNavChoicePoint(PathObject).JumpToActor != none ) )
						{
							TargetPoint = GetGotoPoint( AeonsNavChoicePoint(PathObject).JumpToActor.Location );
							if ( IsForwardProgress( TargetPoint, AlarmPoint.Location ) )
							{
								SpecialNavChoiceActing( NavigationPoint(PathObject) );
								PushState( GetStateName(), 'JUMPEDUP' );
								GotoState( 'AIJumpToPoint' );
JUMPEDUP:
								if ( pointReachable( TargetPoint ) && !CloseToPoint( TargetPoint, 2.0 ) )
								{
									PlayRun();
									MoveTo( TargetPoint, FullSpeedScale );
									StopMovement();
								}
								PlayWait();
							}
						}
					}
					goto 'GOTOACT';
				}
				DebugInfoMessage( ".AIRetreat, PathObject is NONE (couldn't path), OrderObject is " $ OrderObject.name $ ", Phys is " $ Physics );
				goto 'LOST';
			}
		}
		else
			DebugInfoMessage( ".AIRetreat, in else clause" );

		if ( RetreatPoint.bVanishOnContact )
			Vanish();

		RetreatPoint = RetreatPoint.NextPoint;
		goto 'ATPOINT';
	}

LOST:
	// FIXLOST
	// don't have an assigned cover point to go to
	RetreatThreshold = 0.0;
	ClearOrdersIf( GetStateName() );
	GotoState( 'AIAttack' );

ATPOINT:
	StopMovement();
	if ( ( Enemy != none ) && ( LineOfSightTo( Enemy ) ) )
		TargetPoint = Enemy.Location;
	else
		TargetPoint = OrderObject.Location + AeonsCoverPoint(OrderObject).LookVector;
	TurnTo( TargetPoint, 20 * DEGREES );
	PlayWait();
	GotoState( 'AIAmbush' );

TURRET:
	if ( ( DistanceTo( Enemy ) < SafeDistance ) &&
		 ( RetreatPoint != none ) )
		goto 'GOTONEXT';
	if ( ( Enemy != none ) && ( LineOfSightTo( Enemy ) ) )
		TargetPoint = Enemy.Location;
	else
		TargetPoint = OrderObject.Location + AeonsCoverPoint(OrderObject).LookVector;
	TurnTo( TargetPoint, 60 * DEGREES );
	PlayWait();
	Sleep( 0.1 );
	if ( ( Enemy != none ) &&
		 FastTrace( Enemy.Location ) &&
		 EyesCanSee( Enemy.Location ) &&
		 EnemyCanSee( Location ) )
	{
		RetreatPoint = none;
		goto 'GOTONEXT';
	}
	goto 'TURRET';
} // state AIRetreat


//****************************************************************************
// AIAvoidEnemy
// Avoid Enemy within SafeDistance, pick a retreat point and seek it
//****************************************************************************
state AIAvoidEnemy
{
	// *** ignored functions ***
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function Bump( actor Other )
	{
		CreatureBump( pawn(Other) );
	}

	// *** new (state only) functions ***
	function NavigationPoint FindAvoidPoint( vector thisLoc )
	{
		local NavigationPoint	cPoint, aPoint;
		local float				MinDist;
		local float				pDist;
		local float				eDist;

		cPoint = none;
		eDist = SafeDistance * 1.20;
		foreach AllActors( class'NavigationPoint', aPoint )
		{
			pDist = VSize(aPoint.Location - thisLoc);
			if ( ( ( cPoint == none ) || ( pDist < MinDist ) ) &&
				 ( pDist > eDist ) &&
				 GoodAvoidPoint( aPoint ) &&
				 CanPathTo( aPoint ) )
			{
				if ( ( cPoint == none ) || !PathToPasses( aPoint, Enemy ) )
				{
					cPoint = aPoint;
					MinDist = pDist;
				}
			}
		}
		return cPoint;
	}

	// Check if point is (still, while pathing) a good avoidance point.
	function bool GoodAvoidPoint( NavigationPoint cPoint )
	{
		// Override to impose stricter rules, like the commented rule below.
		if ( EnemyCanSee( cPoint.Location ) || EnemyCanSee( cPoint.Location + vect(0,0,1) * CollisionHeight ) )
			return false;
		if ( VSize(cPoint.Location - Enemy.Location) < ( SafeDistance * 1.20 ) )
			return false;
		return true;
	}

	function Evaluate()
	{
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:
DODGED:

// Default entry point
BEGIN:
	WaitForLanding();

GOTONEXT:
	AvoidPoint = FindAvoidPoint( Location );
	if ( AvoidPoint == none )
	{
		DebugInfoMessage( " *** unable to find an AvoidPoint ***" );
		GotoInitState();
	}
	DebugInfoMessage( ".AIAvoidEnemy, AvoidPoint is " $ AvoidPoint.name );

GOTOACT:
	if ( AvoidPoint != none )
	{
		DebugInfoMessage( ".AIAvoidEnemy, got AvoidPoint " $ AvoidPoint.name );
		Evaluate();
		if ( !CloseToPoint( AvoidPoint.Location, 1.5 ) )
		{
			if ( actorReachable( AvoidPoint ) )
			{
				DebugInfoMessage( ".AIAvoidEnemy, AvoidPoint is reachable" );
				PlayRun();
				if ( bCanFly )
					MoveTo( FlightToNavPoint( AvoidPoint, CollisionHeight ), FullSpeedScale );
				else
					MoveToward( AvoidPoint, FullSpeedScale );
			}
			else
			{
				DebugInfoMessage( ".AIAvoidEnemy, AvoidPoint is not reachable, trying to path" );
				PathObject = PathToward( AvoidPoint );
				if ( PathObject != none )
				{
					DebugInfoMessage( ".AIAvoidEnemy, pathing to AvoidPoint" );
					// can path to OrderObject
					PlayRun();
					if ( bCanFly )
						MoveTo( FlightToNavPoint( PathObject, CollisionHeight ), FullSpeedScale, 2.5 );
					else
						MoveToward( PathObject, FullSpeedScale, 2.5 );
					if ( SpecialNavChoiceAction( NavigationPoint(PathObject) ) )
					{
						if ( ( AeonsNavChoicePoint(PathObject) != none ) &&
							 ( AeonsNavChoicePoint(PathObject).JumpToActor != none ) )
						{
							TargetPoint = GetGotoPoint( AeonsNavChoicePoint(PathObject).JumpToActor.Location );
							if ( IsForwardProgress( TargetPoint, AlarmPoint.Location ) )
							{
								SpecialNavChoiceActing( NavigationPoint(PathObject) );
								PushState( GetStateName(), 'JUMPEDUP' );
								GotoState( 'AIJumpToPoint' );
JUMPEDUP:
								if ( pointReachable( TargetPoint ) && !CloseToPoint( TargetPoint, 2.0 ) )
								{
									PlayRun();
									MoveTo( TargetPoint, FullSpeedScale );
									StopMovement();
								}
								PlayWait();
							}
						}
					}
					if ( GoodAvoidPoint( AvoidPoint ) )
						goto 'GOTOACT';
					else
						goto 'GOTONEXT';
				}
				else
				{
					DebugInfoMessage( ".AIAvoidEnemy, AvoidPoint is not pathable!!!???" );
				}
				goto 'LOST';
			}
		}
		goto 'ATPOINT';
	}

LOST:
	// FIXLOST
	GotoInitState();

ATPOINT:
	StopMovement();
	PlayWait();
	TurnToward( Enemy, 15 * DEGREES );
	GotoState( 'AIAmbush' );
} // state AIAvoidEnemy


//****************************************************************************
// AIAlarm
// find alarm point and seek it
//****************************************************************************
state AIAlarm
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***
	function Trigger( actor Other, pawn EventInstigator )
	{
		Disable( 'Trigger' );
		GotoState( , 'NEXTPT' );
	}

	function Timer()
	{
	}

	// *** new (state only) functions ***
	function AeonsAlarmPoint GetTaggedAlarmPoint( name ThisTag )
	{
		local AeonsAlarmPoint	APoint;

		foreach AllActors( class'AeonsAlarmPoint', APoint, ThisTag )
			return APoint;
		return none;
	}

	function vector GetWanderPoint( vector Here, float Distance )
	{
		local rotator	GRot;

		GRot.Yaw = Rand(65536);
		GRot.Pitch = 0;
		GRot.Roll = 0;

		return GetGotoPoint( Here + ( Distance * vector(GRot) * FVariant( 0.75, 0.25 ) ) );
	}

	function StartAlarmPathing()
	{
	}


// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	Disable( 'Trigger' );
	WaitForLanding();
	if ( AlarmPoint == none )
	{
		if ( AlarmTag != '' )
			AlarmPoint = GetTaggedAlarmPoint( AlarmTag );
		if ( ( AlarmPoint == none ) && ( OrderTag != '' ) )
			AlarmPoint = GetTaggedAlarmPoint( OrderTag );
		if ( AlarmPoint == none )
			AlarmPoint = GetTaggedAlarmPoint( class.name );
	}
	if ( AlarmPoint == none )
	{
		AlarmTag = '';
		GotoState( 'AIAmbush' );	// TEMP?
	}

	DebugInfoMessage( ".AIAlarm, AlarmPoint is " $ AlarmPoint.name );
// Entry point when returning from AITakeDamage
DAMAGED:
GOTOACT:
	if ( actorReachable( AlarmPoint ) )
	{
		DebugInfoMessage( ".AIAlarm, can reach AlarmPoint directly" );
		PlayRun();
		MoveToward( AlarmPoint, FullSpeedScale );
		goto 'ATPOINT';
	}
	else
	{
		DebugInfoMessage( ".AIAlarm, can't reach AlarmPoint directly, must path" );
		OrderObject = AlarmPoint;
		PathObject = PathTowardOrder();
		if ( PathObject != none )
		{
			DebugInfoMessage( ".AIAlarm, can path to AlarmPoint" );
			if ( UseSpecialNavigation( NavigationPoint(PathObject) ) )
			{
				PushState( GetStateName(), 'GOTOACT' );
				SpecialNavPoint = NavigationPoint(PathObject);
				GotoState( 'AISpecialNavigation' );
			}
			else
			{
				StartAlarmPathing();
				PlayRun();
				MoveToward( PathObject, FullSpeedScale );
				if ( SpecialNavChoiceAction( NavigationPoint(PathObject) ) )
				{
					if ( ( AeonsNavChoicePoint(PathObject) != none ) &&
						 ( AeonsNavChoicePoint(PathObject).JumpToActor != none ) )
					{
						TargetPoint = GetGotoPoint( AeonsNavChoicePoint(PathObject).JumpToActor.Location );
						if ( IsForwardProgress( TargetPoint, AlarmPoint.Location, 0.5 ) )
						{
							SpecialNavChoiceActing( NavigationPoint(PathObject) );
							PushState( GetStateName(), 'JUMPEDUP' );
							GotoState( 'AIJumpToPoint' );
JUMPEDUP:
							if ( pointReachable( TargetPoint ) && !CloseToPoint( TargetPoint, 2.0 ) )
							{
								PlayRun();
								MoveTo( TargetPoint, FullSpeedScale );
								StopMovement();
							}
							PlayWait();
						}
					}
				}
				goto 'GOTOACT';
			}
		}
		DebugInfoMessage( ".AIAlarm, couldn't path to AlarmPoint" );
	}

LOST:
	// FIXLOST
	GotoState( 'AILost' );

ATPOINT:
	AlarmPoint.Touch( self );

	// See if animation should be triggered.
	if ( AlarmPoint.AnimName != '' )
	{
		StopMovement();
		PlayWait();
		// TODO: check for turn toward AlarmPoint orientation
		Sleep( 0.10 );
		PlayAnim( AlarmPoint.AnimName );
		FinishAnim();
	}

	// See if creature should wait for trigger.
	if ( AlarmPoint.bWaitForTrigger )
	{
		StopMovement();
		PlayWait();
		Enable( 'Trigger' );
		goto 'END';
	}

	// See if creature should wait for player.

NEXTPT:
	if ( AlarmPoint.NextPoint != none )
	{
		AlarmPoint = AlarmPoint.NextPoint;
		goto 'GOTOACT';
	}
	if ( AlarmPoint.WanderRadius > 0.0 )
	{
		PlayWalk();
		MoveTo( GetWanderPoint( AlarmPoint.Location, AlarmPoint.WanderRadius ), WalkSpeedScale );
	}

	StopMovement();
	PlayWait();
	AlarmTag = '';
	if ( AlarmPoint.PostState != '' )
		GotoState( AlarmPoint.PostState );
	else
		GotoState( 'AIAmbush' );

END:
} // state AIAlarm


//****************************************************************************
// AITriggerAlarm
// Find alarm point and seek it.
// This state entered on encounter, only when AlarmTag is specified.
//****************************************************************************
state AITriggerAlarm
{
	// *** ignored functions ***
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***
	// Trigger next alarm.
	function Trigger( actor Other, pawn EventInstigator )
	{
		Disable( 'Trigger' );
		GotoState( , 'NEXTPT' );
	}

	function Bump( actor Other )
	{
		CreatureBump( pawn(Other) );
	}

	// *** new (state only) functions ***
	// Return the AeonsAlarmPoint tagged with the name passed.
	function AeonsAlarmPoint GetTaggedAlarmPoint( name ThisTag )
	{
		local AeonsAlarmPoint	APoint;

		foreach AllActors( class'AeonsAlarmPoint', APoint, ThisTag )
			return APoint;
		return none;
	}

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	Disable( 'Trigger' );
	WaitForLanding();
	if ( AlarmPoint == none )
	{
		if ( AlarmTag != '' )
			AlarmPoint = GetTaggedAlarmPoint( AlarmTag );
		if ( ( AlarmPoint == none ) && ( OrderTag != '' ) )
			AlarmPoint = GetTaggedAlarmPoint( OrderTag );
		if ( AlarmPoint == none )
			AlarmPoint = GetTaggedAlarmPoint( class.name );
	}
	if ( AlarmPoint == none )
	{
		AlarmTag = '';
		GotoState( 'AIEncounter' );	// TEMP?
	}

// Entry point when returning from AITakeDamage
DAMAGED:
GOTOACT:
	if ( actorReachable( AlarmPoint ) )
	{
		PlayRun();
		MoveToward( AlarmPoint, FullSpeedScale );
		goto 'ATPOINT';
	}
	else
	{
		OrderObject = AlarmPoint;
		PathObject = PathTowardOrder();
		if ( PathObject != none )
		{
			// can path to OrderObject
			PlayRun();
			MoveToward( PathObject, FullSpeedScale );
			goto 'GOTOACT';
		}
	}

LOST:
	// FIXLOST
	GotoState( 'AILost' );

ATPOINT:
	AlarmPoint.Touch( self );

	// See if animation should be triggered.
	if ( AlarmPoint.AnimName != '' )
	{
		StopMovement();
		PlayWait();
		// TODO: check for turn toward AlarmPoint orientation
		Sleep( 0.10 );		// BUGBUG: let wait anim finish
		PlayAnim( AlarmPoint.AnimName );
		FinishAnim();
	}

	// See if creature should wait for trigger.
	if ( AlarmPoint.bWaitForTrigger )
	{
		StopMovement();
		PlayWait();
		Enable( 'Trigger' );
		goto 'END';
	}

	// See if creature should wait for player.

NEXTPT:
	if ( AlarmPoint.NextPoint != none )
	{
		AlarmPoint = AlarmPoint.NextPoint;
		goto 'GOTOACT';
	}
	StopMovement();
	PlayWait();
	AlarmTag = '';
	GotoState( 'AIDefendPoint' );

END:
} // state AITriggerAlarm


//****************************************************************************
// AIScriptedAction
// Find script point and seek it.
//****************************************************************************
state AIScriptedAction
{
	// *** ignored functions ***
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function Bump( actor Other )
	{
		CreatureBump( pawn(Other) );
	}

	// *** new (state only) functions ***
	// Return the AeonsScriptPoint tagged with the name passed.
	function AeonsScriptPoint GetTaggedScriptPoint( name ThisTag )
	{
		local AeonsScriptPoint	SPoint;

		foreach AllActors( class'AeonsScriptPoint', SPoint, ThisTag )
			return SPoint;
		return none;
	}

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	WaitForLanding();
	if ( ScriptPoint == none )
	{
		if ( OrderTag != '' )
			ScriptPoint = GetTaggedScriptPoint( OrderTag );
		if ( ScriptPoint == none )
			ScriptPoint = GetTaggedScriptPoint( class.name );
	}
	if ( ScriptPoint == none )
		GotoState( 'AIEncounter' );	// TEMP?

// Entry point when returning from AITakeDamage
DAMAGED:
GOTOACT:
	if ( actorReachable( ScriptPoint ) )
	{
		PlayRun();
		MoveToward( ScriptPoint, FullSpeedScale );
		goto 'ATPOINT';
	}
	else
	{
		OrderObject = ScriptPoint;
		PathObject = PathTowardOrder();
		if ( PathObject != none )
		{
			// can path to OrderObject
			PlayRun();
			MoveToward( PathObject, FullSpeedScale );
			goto 'GOTOACT';
		}
	}

LOST:
	// FIXLOST
	GotoState( 'AILost' );

ATPOINT:
	if ( ScriptPoint.DelayedState != '' )
	{
		DelayedOrderState = ScriptPoint.DelayedState;
		DelayedOrderTag = ScriptPoint.DelayedTag;
		DelayedOrderTime = FMax( ScriptPoint.DelayedTime, 0.01 );	// can't be 0
	}

	if ( ScriptPoint.Action == SCRIPTACTION_GotoState )
	{
		if ( Enemy != none )
		{
			TurnToward( Enemy, 60 * DEGREES );
		}
		if ( ScriptPoint.ScriptTag != '' )
			OrderTag = ScriptPoint.ScriptTag;
		if ( ScriptPoint.ScriptState != '' )
			GotoState( ScriptPoint.ScriptState );
	}
	else if ( ( ScriptPoint.Action == SCRIPTACTION_Animate ) ||
			  ( ScriptPoint.Action == SCRIPTACTION_AnimateThenGotoState ) )
	{
		PlayWait();
		StopMovement();
		if ( ScriptPoint.AnimPreDelay > 0.0 )
			Sleep( ScriptPoint.AnimPreDelay );
		if ( ScriptPoint.AnimName != '' )
		{
			PlayAnim( ScriptPoint.AnimName );
			FinishAnim();
			PlayWait();
		}
		if ( ScriptPoint.Action == SCRIPTACTION_Animate )
			GotoState( 'AIWait' );
		else
		{
			if ( ScriptPoint.ScriptTag != '' )
				OrderTag = ScriptPoint.ScriptTag;
			if ( ScriptPoint.ScriptState != '' )
				GotoState( ScriptPoint.ScriptState );
		}
	}
	else if ( ScriptPoint.Action == SCRIPTACTION_NavChoice )
	{
		if ( ScriptPoint.JumpToActor != none )
		{
			TargetPoint = GetGotoPoint( ScriptPoint.JumpToActor.Location );
			PushState( GetStateName(), 'JUMPEDUP' );
			GotoState( 'AIJumpToPoint' );
JUMPEDUP:
			if ( pointReachable( TargetPoint ) && !CloseToPoint( TargetPoint, 2.0 ) )
			{
				PlayRun();
				MoveTo( TargetPoint, FullSpeedScale );
				StopMovement();
			}
			PlayWait();
			if ( SpecialNavTargetAction( NavChoiceTarget(ScriptPoint.JumpToActor) ) )
			{
				PushState( GetStateName(), 'TAUNTED' );
				GotoState( 'AIQuickTaunt' );
TAUNTED:
			}
		}
		if ( NavChoiceTarget(ScriptPoint.JumpToActor) != none )
		{
			if ( NavChoiceTarget(ScriptPoint.JumpToActor).bJumpDown )
			{
				TurnTo( NavChoiceTarget(ScriptPoint.JumpToActor).LookAtPoint, 20 * DEGREES );
				PushState( GetStateName(), 'JUMPEDDN' );
				GotoState( 'AIJumpDown' );
JUMPEDDN:
				PlayWait();
				StopMovement();
			}

			if ( NavChoiceTarget(ScriptPoint.JumpToActor).NextState != '' )
			{
				if ( NavChoiceTarget(ScriptPoint.JumpToActor).NextTag != '' )
					OrderTag = NavChoiceTarget(ScriptPoint.JumpToActor).NextTag;
				GotoState( NavChoiceTarget(ScriptPoint.JumpToActor).NextState );
			}
		}
	}

END:
} // state AIScriptedAction


//****************************************************************************
// AIDance
// Enemy was killed, dance around, be merry, ha ha ha
//****************************************************************************
state AIDance
{
	// *** ignored functions ***
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function LookTargetNotify( actor Sender, float Duration ){}

	// *** overridden functions ***
	function BeginState()
	{
		global.BeginState();
		StopTimer();
		PushLookAt( none );
	}

	function EndState()
	{
		global.EndState();
		PopLookAt();
	}

	function Timer()
	{
		GotoState( , 'GOHOME' );
	}

	function Bump( actor Other )
	{
		CreatureBump( pawn(Other) );
	}

	// *** new (state only) functions ***
	//
	function SetTargetPoint()
	{
		local float		Dist;
		local rotator	DRot;
		local int		Tries;
		local vector	TPoint;

		Tries = 0;
		while ( Tries < 4 )
		{
			Tries += 1;
			Dist = ( TargetActor.CollisionRadius + CollisionRadius ) * 5.0 + FVariant( 150.0, 50.0 );
			DRot.Yaw = 65535 * FRand();
			DRot.Pitch = 0;
			DRot.Roll = 0;
			TargetPoint = GetGotoPoint( TargetActor.Location + ( vector(DRot) * Dist ) );
			if ( FastTrace( TargetActor.Location, TargetPoint ) )
				return;
		}
	}

	// Called when point reached.
	function AtDancePoint()
	{
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	SetTimer( 5.0, false );

KILLER:
	WaitForLanding();
	SetTargetPoint();

GOTOPT:
	if ( pointReachable( TargetPoint ) )
	{
		PlayWalk();
		MoveTo( TargetPoint, WalkSpeedScale );
	}
	else
	{
		PathObject = PathTowardPoint( TargetPoint );
		if ( PathObject != none )
		{
			// can path to TargetPoint
			PlayWalk();
			MoveToward( PathObject, WalkSpeedScale );
			goto 'GOTOPT';
		}
		else
		{
			// couldn't path to OrderObject
			GotoState( 'AIWait' );
//			GotoLastState();
		}
	}

ATPOINT:
	AtDancePoint();
	StopMovement();
	PlayWait();
	TurnToward( TargetActor, 30 * DEGREES );
	SetTimer( FVariant( 12.5, 2.5 ), false );

DANCE:
	if ( FRand() < 0.20 )
		goto 'NOANIM';
	PlayVictoryDance();
	FinishAnim();
	PlayWait();

NOANIM:
	Sleep( FVariant( 2.0, 1.0 ) );
	goto 'DANCE';

GOHOME:
	FinishAnim();
	GotoState( 'AIWait' );
//	GotoLastState();

END:
} // state AIDance


//****************************************************************************
// AIIgnore
// dumbass mode
//****************************************************************************
state AIIgnore
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function TakeDamage( Pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function Trigger( actor Other, pawn EventInstigator ){}

} // state AIIgnore


//****************************************************************************
// AILost
// Lost (terminate script)
//****************************************************************************
state AILost
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function LongFall(){}
	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo ){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}

	// *** overridden functions ***


BEGIN:
	StopMovement();
	PlayWait();

	// return to wait state so AI doesn't appear to lockup
//	if ( OrderState != '' )
//		GotoState( OrderState );
//	GotoState( 'AIWait' );
	GotoState( 'AIHuntPlayer' );
} // state AILost


//****************************************************************************
// AITakeDamage
// take damage, animate
//****************************************************************************
state AITakeDamage
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function DelayedOrder( name OState, name OTag ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState( "Physics is " $ Physics );
		PushLookAt( none );
	}

	function EndState()
	{
		global.EndState();
		PopLookAt();
	}

	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
	{
		ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
	}

// Entry point when resuming this state
RESUME:
	PlayStunDamage();

// Default entry point
BEGIN:
	WaitForLanding();
	StopMovement();
	FinishAnim();
	PopState();
} // state AITakeDamage


//****************************************************************************
// AIMindshatter
// handle mindshatter effect
//****************************************************************************
state AIMindshatter
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function LongFall(){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function TakeMindshatter( pawn Instigator, int castingLevel ){}
	function DelayedOrder( name OState, name OTag ){}
	function LookTargetNotify( actor Sender, float Duration ){}
	function FearThisSpot( actor ASpot ){}
	function Stoned( pawn Stoner ){}
	function Ignited(){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState( "" $ Level.TimeSeconds );
		PushLookAt( none );
	}

	function EndState()
	{
		global.EndState();
		PopLookAt();
	}

	function EffectorApplyEffect( SPEffector effector, int count )
	{
		if ( effector.IsA('SPMindshatterEffector') )
		{
			TargetPoint = GetWanderPoint( Location, MindshatterWander );
			GotoState( , 'WANDER' );
		}
	}

	function LosingEffector( SPEffector effector )
	{
		if ( effector.IsA('SPMindshatterEffector') )
			GotoState( , 'DONE' );
	}

	function vector GetWanderPoint( vector ThisLoc, float Distance )
	{
		local rotator	GRot;

		GRot.Yaw = Rand(65536);
		GRot.Pitch = 0;
		GRot.Roll = 0;

		if ( bCanFly )
		{
			GRot.Pitch = Rand(65536);
			return ThisLoc + ( Distance * vector(GRot) * FVariant( 0.75, 0.25 ) );
		}
		else
			return GetGotoPoint( ThisLoc + ( Distance * vector(GRot) * FVariant( 0.75, 0.25 ) ) );
	}


// Entry point when returning from AITakeDamage
DAMAGED:
//	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	StopMovement();
	PlayMindshatterDamage();

WAIT:
	Sleep( 10.0 );		// let the effector do its thing
	goto 'WAIT';

DONE:
	PlayWait();
	StopMovement();
	PopState();

WANDER:
	PlayWalk();
	MoveTo( TargetPoint, WalkSpeedScale );
	PlayWait();
	goto 'BEGIN';
} // state AIMindshatter


//****************************************************************************
// AIOnFire
// Handle the pain and misery of being on fire.
//****************************************************************************
state AIOnFire
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function EnemyNotVisible(){}
	function LongFall(){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Ignited(){}
	function LookTargetNotify( actor Sender, float Duration ){}
	function FearThisSpot( actor ASpot ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		PushLookAt( none );
	}

	function EndState()
	{
		PopLookAt();
	}

	function Extinguished()
	{
		GotoState( , 'DONE' );
	}

	function Tick( float DeltaTime )
	{
		super.Tick( DeltaTime );
		if ( ( FireMod != none ) && !FireMod.bActive )
			GotoState( , 'DONE' );
	}

	// *** new (state only) functions ***
	//
	function AeonsNavMarker FindWaterCover()
	{
		local AeonsNavMarker	nMarker;
		local AeonsNavMarker	BestPoint;
		local float				BestDist;
		local float				PDist;

		BestPoint = none;
		foreach AllActors( class'AeonsNavMarker', nMarker )
		{
			if ( nMarker.bWaterHaven && nMarker.Region.Zone.bWaterZone )
			{
				PDist = PathDistanceTo( nMarker );
				if ( PDist > 0.0 )
				{
					if ( ( BestPoint == none ) || ( PDist < BestDist ) )
					{
						BestPoint = nMarker;
						BestDist = PDist;
					}
				}
			}
		}
		return BestPoint;
	}


// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	StopMovement();
	if ( ( Intelligence == BRAINS_Human ) && ( FireScalar > 0.0 ) )
	{
PICKPT:
		TargetActor = FindWaterCover();
		if ( TargetActor != none )
		{
			PlayRunOnFire();
GOTOPT:
			if ( actorReachable( TargetActor ) )
			{
				DebugInfoMessage( ".AIOnFire, TargetActor " $ TargetActor.name $ " is reachable" );
				MoveToward( TargetActor, FullSpeedScale );
			}
			else
			{
				DebugInfoMessage( ".AIOnFire, can't reach TargetActor directly, trying to path" );
				PathObject = PathToward( TargetActor );
				if ( PathObject != none )
				{
					DebugInfoMessage( ".AIOnFire, can't reach TargetActor directly, pathing to " $ PathObject.name );
					MoveToward( PathObject, FullSpeedScale );
					goto 'PICKPT';
				}
				else
				{
					DebugInfoMessage( ".AIOnFire, couldn't path to TargetActor, going to 'WAIT'" );
					goto 'WAIT';
				}
			}
			goto 'DONE';
		}
	}

	if ( ( FireScalar == 0.0 ) ||
		 ( ( Intelligence > BRAINS_Mammal ) || ( Enemy != none ) && ( CanPathTo( Enemy ) ) ) )
		goto 'DONE';

WAIT:
	PlayOnFireDamage();
	Sleep( FVariant( 4.0, 1.0 ) );
	PlaySoundBurn();
	goto 'WAIT';

DONE:
	StopMovement();
	PlayWait();
	PopState();
} // state AIOnFire


//****************************************************************************
// AIFall
// handle falling
//****************************************************************************
state AIFall
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function DelayedOrder( name OState, name OTag ){}
	function LookTargetNotify( actor Sender, float Duration ){}
	function Stoned( pawn Stoner ){}
	function Ignited(){}

	// *** overridden functions ***
	function Landed( vector hitNormal )
	{
		DebugInfoMessage( " AIFall.Landed()" );
		RotationRate.Roll = default.RotationRate.Roll;
		TakeFallDamage( Velocity.Z );
		if ( Health > 0 )
			GotoState( , 'LANDED' );
	}

	function Timer()
	{
		local actor		HitActor;
		local vector	HitLocation, HitNormal;
		local int		HitJoint;

		DebugInfoMessage( " AIFall.Timer(), Physics is " $ Physics );
		HitActor = Trace( HitLocation, HitNormal, HitJoint, Location - ( vect(0,0,1.5) * JumpDownDistance ), Location, false );
		if ( HitActor != none )
			DebugInfoMessage( " AIFall.Timer(), HitActor is " $ HitActor.name $ ", distance is " $ VSize(Location - HitLocation) );

		if ( FastTrace( Location, Location - ( vect(0,0,1.5) * JumpDownDistance ) ) )
		{
//			DebugInfoMessage( " AIFall.Timer(), playing scream" );
//			PlaySoundScream();
		}
		else
		{
			DebugInfoMessage( " AIFall.Timer(), OK so far" );
			SetTimer( 0.1, false );
		}
	}

	function LongFall()
	{
//		DebugInfoMessage( " AIFall.LongFall(), playing scream" );
//		PlaySoundScream();
		GotoState( , 'FALLING' );
	}

	function Tick( float DeltaTime )
	{
		DebugInfoMessage( " AIFall.Tick(), Physics is " $ Physics $ ", Acceleration is " $ Acceleration );
		global.Tick( DeltaTime );
		if ( FallTimer > 0.0 )
		{
			if ( FallTimer < DeltaTime )
				DesiredRotation.Roll = 0;
			else
				FallTimer -= DeltaTime;
		}
	}


LONGFALL:
	PlayInAir();

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	DebugInfoMessage( ".AIFall, FallFromState is " $ FallFromState );
	StopMovement();
	SetTimer( 0.1, false );
	FallTimer = 1.5;

FALLING:
	WaitForLanding();

LANDED:
	DesiredRotation.Roll = 0;
	if ( PlayLanding() )
//		FinishAnim();
		Sleep( 0.50 );
	else
		Sleep( 0.10 );
	GotoState( FallFromState, 'RESUME' );
} // state AIFall


//****************************************************************************
// AISpecialNavigation
// handle special navigation to SpecialNavPoint (default behavior just returns)
//****************************************************************************
state AISpecialNavigation
{
BEGIN:
	PopState();
} // state AISpecialNavigation


//****************************************************************************
// AISpecialDirect
// handle special navigation move directly to TargetPoint (default behavior just returns)
//****************************************************************************
state AISpecialDirect
{
BEGIN:
	PopState();
} // state AISpecialDirect


//****************************************************************************
// AIDoNothing
// 
//****************************************************************************
state AIDoNothing
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
//	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function LongFall(){}
	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo ){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function Ignited(){}
	function DelayedOrder( name OState, name OTag ){}
	function LookTargetNotify( actor Sender, float Duration ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		SetFrozenPhysics();
	}

	function EndState()
	{
		DebugEndState();
		SetMovementPhysics();
	}

	function Landed( vector hitNormal )
	{
		DebugInfoMessage( ".Landed(), Z is " $ Velocity.Z $ ", PH=" $ Physics);
		SetMovementPhysics();
	}

} // state AIDoNothing


//****************************************************************************
// AIScriptedState
// 
//****************************************************************************
state AIScriptedState expands AIDoNothing
{
	// *** ignored functions ***
	function Trigger( actor Other, pawn EventInstigator ){}

} // state AIScriptedState


//****************************************************************************
// AIFrozenState
// 
//****************************************************************************
state AIFrozenState expands AIDoNothing
{
	// *** overridden functions ***
	function BeginState()
	{
		SetEnemy( none );
		super.BeginState();
	}

	function EndState()
	{
		DebugEndState();
		ClearOrdersIf( 'AIFrozenState' );
		SetMovementPhysics();
	}

	function StartLevel()
	{
		global.StartLevel();
		SnapToIdle();
		ApplyAnim();
		PlayAnim( '' );
	}

	function Tick( float DeltaTime )
	{
		// fix T-Posing in multiplayer
		if (Level.NetMode != NM_Standalone)
			SnapToIdle();

		global.Tick( DeltaTime );
	}

RESUME:
Begin:
	PlayAnim( '' );

} // state AIFrozenState


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function LongFall(){}
	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo ){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function Ignited(){}
	function DelayedOrder( name OState, name OTag ){}
	function LookTargetNotify( actor Sender, float Duration ){}
	function FearThisSpot( actor ASpot ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState( "Health is " $ Health );
		StopTimer();
		PushLookAt( none );
		bCanJump = true;
		Buoyancy = 0;
	}

	function EndState()
	{
		global.EndState();
		PopLookAt();
	}

	function Timer()
	{
		if ( FadeOutCount < 0.0 )
		{
			Destroy();
			if ( FireMod != none )
				FireMod.Deactivate();
		}
		else
			StartTrueDeath();
	}

	function Tick( float DeltaTime )
	{
		local int	PNum;

		if ( FadeOutCount > 0.0 )
		{
			FadeOutCount = FadeOutCount - DeltaTime;
			if ( FadeOutCount < 0.0 )
			{
				SetOpacity( 0.0 );
				SetTimer( 1.0, false);
			}
			else
				SetOpacity( FadeOutCount / FadeOutTime );
		}

		global.Tick( DeltaTime );
	}

	// The player is trying to resurrect me....
	function bool CanBeInvoked()
	{
		return ( FadeOutCount == 0.0 ) &&
				 !bIsBoss &&
				 !bIsInvoked &&
				 !bHacked;
	}

	// Regenerate!!!
	function Invoke( actor Other )
	{
		bIsInvoked = true;
		//bClientAnim = false;
		//NetUpdateFrequency = default.NetUpdateFrequency;

		// Stop, fix fade-out.
		StopTimer();
		FadeOutCount = 0.0;
		SetOpacity( 1.0 );

		// Notify generator.
		if ( bGenerated && ( Owner != none ) && ( CreatureGenerator(Owner) != none ) )
			CreatureGenerator(Owner).GenCreatureKilled( self );

		// Visual effects.
		// Spawn( class'InvokeFX', self,, Location ); 	 		// Temp effect
//		AmbientGlow = 255;	// TEMP visual effect

		// Reset properties.
		Health = InitHealth * 1.25;
		GroundSpeed = default.GroundSpeed * 1.25;
		AirSpeed = default.AirSpeed * 1.25;
		SetCollision( InitCollideActors, InitBlockActors, InitBlockPlayers );

		// Set Owner and clear Enemy.
		SetOwner( Other );
		SetEnemy( none );
		HatedEnemy = none;
		AttitudeToPlayer = ATTITUDE_Follow;

		GotoState( , 'INVOKED' );
	}

	// *** new (state only) functions ***
	// Do this after the animation has finished.
	function PostAnim()
	{
		// for whatever reason the death animation loops on the client, prevent that here
		//bClientAnim = true;
		//NetUpdateFrequency = 0;
	}

	// Create an expanding pool of blood.
	function PoolOfBlood()
	{
		local vector	HitLocation, HitNormal;
		local int		HitJoint;
		local Decal		Blood;
		
		// Bleed out.
		Trace( HitLocation, HitNormal, HitJoint, Location + vect(0,0,-512), Location, true );
		Blood = Spawn( class'BigBloodDripDecal',,, HitLocation, rotator(HitNormal) );
		if ( Blood != none )
			Blood.bScryeOnly = bScryeOnly;
	}

	function StartTimer()
	{
		SetTimer( FadeOutDelay, false );
	}

	// Called when the creature is really dying (no longer invokable).
	function StartTrueDeath()
	{
		FadeOutCount = FadeOutTime;
//		if ( RangedWeapon != none )
//		{
//			RangedWeapon.Drop();
//			RangedWeapon = none;
//		}
	}


INVOKED:
	PlayWait();
	Sleep( 1.5 );
	GotoState( 'AIFollowOwner' );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	if ( RangedWeapon != none )
		RangedWeapon.DropPickups();		// drop the weapon pickups

	// if he has PersistentBlood going... shut it down.
	if ( PBlood != none )
		PBlood.Shutdown();

	if ( Region.Zone.bWaterZone )
		SetPhysics( PHYS_Falling );
	else
		WaitForLanding();
	StopMovement();
	DesiredRotation.Pitch = 0;
	DesiredRotation.Roll = 0;
	if ( RotationRate.Roll == 0 )
		RotationRate.Roll = 512;
	if ( RotationRate.Pitch == 0 )
		RotationRate.Pitch = 512;
	NoLook();
	SetCollision( true, false, false );	// km - set collision to true so traces work
	FinishAnim();
	PostAnim();
	if ( !bNoBloodPool )
		PoolOfBlood();

FALLEN:
	StartTimer();
} // state Dying


//****************************************************************************
// StuckToWall (override base class implementation)
// handle death (take it!)
//****************************************************************************
state StuckToWall
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Landed( vector hitNormal ){}
	function Invoke( actor Other ){}
	function Falling(){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function LongFall(){}
	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo ){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function Ignited(){}
	function DelayedOrder( name OState, name OTag ){}
	function LookTargetNotify( actor Sender, float Duration ){}
	function FearThisSpot( actor ASpot ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState( "Health is " $ Health );
		StopTimer();
		PushLookAt( none );
	}

	function EndState()
	{
		global.EndState();
		PopLookAt();
	}

	// Hit a wall - so stick to it!
	function HitWall( vector hitNormal, actor hitWall, byte textureID )
	{
		SetPhysics(PHYS_None);
		// ?? PlayAnim( StuckAnim ) ??
	}

	function Timer()
	{
		if ( FadeOutCount < 0.0 )
		{
			Destroy();
			if ( FireMod != none )
				FireMod.Deactivate();
		}
		else
			StartTrueDeath();
	}

	function Tick( float DeltaTime )
	{
		local int	PNum;
		
		if ( FadeOutCount > 0.0 )
		{
			FadeOutCount = FadeOutCount - DeltaTime;
			if ( FadeOutCount < 0.0 )
			{
				SetOpacity( 0.0 );
				SetTimer( 1.0, false);
			}
			else
				SetOpacity( FadeOutCount / FadeOutTime );
		}
		global.Tick( DeltaTime );
	}

	// The player is trying to resurrect me....
	function bool CanBeInvoked()
	{
		return false;
	}

	// *** new (state only) functions ***
	// Do this after the animation has finished.
	function PostAnim() {}

	// Create an expanding pool of blood.
	function PoolOfBlood() {}

	function StartTimer()
	{
		SetTimer( FadeOutDelay, false );
	}

	// Called when the creature is really dying (no longer invokable).
	function StartTrueDeath()
	{
		FadeOutCount = FadeOutTime;
//		if ( RangedWeapon != none )
//		{
//			RangedWeapon.Drop();
//			RangedWeapon = none;
//		}
	}


// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	bBounce = true;
	FinishAnim();
	PostAnim();

FALLEN:
	StartTimer();
} // state StuckToWall


//****************************************************************************
// AIFallToDeath
// handle falling death via FallToDeathTrigger
//****************************************************************************
state AIFallToDeath
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function LongFall(){}
	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo ){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function Ignited(){}
	function DelayedOrder( name OState, name OTag ){}
	function LookTargetNotify( actor Sender, float Duration ){}
	function FearThisSpot( actor ASpot ){}
	function Stoned( pawn Stoner ){}
	function FallToDeathTrigger( Trigger Other ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState( "Health is " $ Health );
		StopTimer();
	}

	function bool CanBeInvoked()
	{
		return false;
	}

	// *** new (state only) functions ***

// Default entry point
BEGIN:
	PlayInAir();
	TransientSoundRadius *= 5;
	PlaySoundScream();
	OpacityEffector.SetFade( 0.0, 1.0 );
	Sleep( 2.0 );
	Destroy();

} // state AIFallToDeath


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** ignored functions ***
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function LongFall(){}
	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo ){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function Ignited(){}
	function LookTargetNotify( actor Sender, float Duration ){}
	function FearThisSpot( actor ASpot ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function BeginState()
	{
		local pawn	P;

		global.BeginState();
		StopTimer();
		for ( P = Level.PawnList; P != none; P = P.nextPawn )
			P.Killed( self, SK_TargetPawn, '' );
	}

	function bool CanStartSK()
	{
		return SK_Ready;
	}
	
	function Timer()
	{
		PlayerRandomDeathAnim();
		GotoState( , 'LOST' );
	}

	function Bump( actor Other )
	{
		if ( !SK_Ready )
			global.Bump( Other );
	}

	function Destroyed()
	{
		if ( !SK_Ready )
			SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );
		global.Destroyed();
	}

	// *** new (state only) functions ***
	// Do this after the animation has finished.
	function PostSpecialKill()
	{
		SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );
	}

	// Play, on the player, a random generic death animation
	function PlayerRandomDeathAnim()
	{
		switch ( Rand(4) )
		{
			case 0:
				SK_TargetPawn.PlayAnim( 'death_powerword_end' );
				break;
			case 1:
				SK_TargetPawn.PlayAnim( 'death_revolver' );
				break;
			case 2:
				SK_TargetPawn.PlayAnim( 'death_gun_left' );
				break;
			default:
				SK_TargetPawn.PlayAnim( 'death_gun_face' );
				break;
		}
	}

	function BeginNav()
	{
	}

	function AtPoint()
	{
	}

	function StartSequence()
	{
		GotoState( , 'START_SEQ' );
	}

	function vector TurnToPoint( actor AActor )
	{
		local vector	DVect;

		DVect = AActor.Location;
		DVect.Z = Location.Z;
		return DVect;
	}

	function SetOrientation()
	{
		local vector	DVect;

		SetLocation( SK_WorldLoc );
		DVect = SK_TargetPawn.Location - SK_WorldLoc;
		DVect.Z = 0;
		DesiredRotation = rotator(DVect);
		SetRotation( DesiredRotation );
	}

	function PlayerBleedOutFromJoint( name JName )
	{
		local vector	DVect;
		local vector	HitLocation, HitNormal;
		local int		HitJoint;
		local Actor		A;

		DVect = SK_TargetPawn.JointPlace(JName).pos;
		A = Trace( HitLocation, HitNormal, HitJoint, DVect + vect(0,0,-256), DVect, true );
		if ( A != none )
			Spawn( class'BloodDripDecal',,, HitLocation, rotator(HitNormal) );
//			Spawn( class'BloodDripDecal',,, DVect, rotator(vect(0,0,1)) );
	}

	function DebugDistance( string Msg )
	{
		local vector	DVect;
		local vector	TVect;
		local vector	ZVect;

		DVect = Location - SK_TargetPawn.Location;
		DVect.Z = 0.0;
		TVect = Location - SK_WorldLoc;
		TVect.Z = 0.0;
		ZVect = Location - SK_TargetPawn.Location;
		DebugInfoMessage( ".AISpecialKill( " $ Msg $ " ), XY distance to Count is " $ VSize(DVect) $ ", distance to target point is " $ VSize(TVect) $ ", Z offset from target is " $ ZVect.Z );
	}


RESUME:
BEGIN:
	SK_Ready = false;
	bBumpPriority = true;
	WaitForLanding();
//	SetCollision( false, false, false );
	if ( bCanFly )
		SetCollisionSize( 5.0, 5.0 );
	else
		SetCollisionSize( 5.0, CollisionHeight );
	SetTimer( SK_WalkDelay, false );
	DebugInfoMessage( ".AISpecialKill, Loc is " $ Location $ ", target is " $ SK_WorldLoc $ ", distance is " $ VSize(Location - SK_WorldLoc) );
	BeginNav();

GOTOPT:
	SetMarker( SK_WorldLoc );	// TEMP
	if ( !CloseToPoint( SK_WorldLoc, 1.0 ) )
	{
		if ( pointReachable( SK_WorldLoc ) )
		{
			PlayWalk();
			MoveTo( SK_WorldLoc, WalkSpeedScale );
			DebugInfoMessage( ".AISpecialKill, reached target point" );
		}
		else
		{
			PathObject = PathTowardPoint( SK_WorldLoc );
			if ( PathObject != none )
			{
				// can path to TargetPoint
				PlayWalk();
				MoveToward( PathObject, WalkSpeedScale );
				goto 'GOTOPT';
			}
			else
			{
				// couldn't path to point -- what's an AI to do? -- sleep until the timer fires
				DebugInfoMessage( ".AISpecialKill, couldn't reach target point" );
				PlayWait();
				StopMovement();
				Sleep( 10.0 );
			}
		}
	}

	StopTimer();

ATPOINT:
	NoLook();
	AtPoint();
	PlayWait();
	StopMovement();
	DebugDistance( "before turn" );
//	TurnToward( SK_TargetPawn, 2 * DEGREES );
	TurnTo( TurnToPoint( SK_TargetPawn ), 2 * DEGREES );
	SetCollisionSize( default.CollisionRadius, CollisionHeight );
	Sleep( 1.0 );
	SetOrientation();
	SK_Ready = true;
	StartSequence();

// Play the animation
START_SEQ:
	NoLook();
	DebugDistance( "before anim" );
	PlaySpecialKill();
	FinishAnim();

LOST:
	SetCollisionSize( default.CollisionRadius, CollisionHeight );
	PlayWait();
	StopMovement();
	bBumpPriority = false;
	PostSpecialKill();

// End the sequence
END_SEQ:
} // state AISpecialKill


//****************************************************************************
// AIRunScript
// Follow the actions of the script.
//****************************************************************************
state AIRunScript
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		InitPastTable( Location, Location );
		SetTimer( 0.1, false );
		if ( Script == none )
		{
			ScriptAction = 0;
			Script = FindScript( ScriptTag );
		}
		if ( Script == none )
		{
			ScriptAction = 0;
			Script = FindScript( OrderTag );
		}
	}

	function EndState()
	{
		DebugEndState();
		SetCollision( InitCollideActors, InitBlockActors, InitBlockPlayers );
	}

	function Timer()
	{
		CheckCollision();
		CheckRotation();
		if ( VSize(Velocity) > 10 )
			UpdatePastTable( Location );
		SetTimer( 0.1, false );
	}

	function EffectorHearNoise( actor sensed )
	{
		if ( bDetectPlayer )
			global.EffectorHearNoise( sensed );
	}

	function EffectorSeePlayer( actor sensed )
	{
		if ( bDetectPlayer )
			global.EffectorSeePlayer( sensed );
	}

	function Bump( actor Other )
	{
		if ( bDetectPlayer )
			global.Bump( Other );
	}

	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator )
	{
		if ( bDetectPlayer )
			global.TeamAIMessage( sender, message, instigator );
	}

	function ReactToDamage( pawn Instigator, DamageInfo DInfo )
	{
		if ( bDetectPlayer && ( PlayerPawn(Instigator) != none ) )
			global.ReactToDamage( Instigator, DInfo );
	}

	function FastScript( bool Flag )
	{
		if ( Flag )
		{
			if ( ( Script != none ) && Script.bClickThrough )
			{
				bFastScript = true;
				if ( LastScriptSound > 0 )
					StopSound( LastScriptSound );
				GotoState( , 'ACTION' );
			}
		}
		else
			bFastScript = false;
	}


	// *** new (state only) functions ***
	function CheckCollision()
	{
		local pawn	P;

		P = FindPlayer();
		if ( P != None && P.IsA('PlayerPawn') && !PlayerPawn(P).bAllowMove )
		{
			SetCollision( false, false, false );
		}
		else
		{
			SetCollision( InitCollideActors, InitBlockActors, InitBlockPlayers );
		}
	}

	function CheckRotation()
	{
		local vector	DVect;
		local pawn	P;

		P = FindPlayer();
		if ( P == None )
			return;

		if ( bScriptTurret || ( bSpecialTurret && ( VSize(Velocity) < 10.0 ) ) )
		{
			DVect = P.Location - Location;
			if ( bCanFly )
				DVect.Z = DVect.Z * 0.5;
			else
				DVect.Z = 0.0;
			DesiredRotation = rotator(DVect);
		}
	}

	function actor FindNavPoint( name thisTag )
	{
		local NavigationPoint	nPoint;

		foreach AllActors( class'NavigationPoint', nPoint, thisTag )
			return nPoint;
		return none;
	}

	function vector GetPlayerPoint( float Offset )
	{
		Offset += 75.0;
		return GetGotoPoint( GetEnRoutePoint( FindPlayer().Location, -Offset ) );
	}

	function TriggerAction( name TriggerTag )
	{
		FireEvent( TriggerTag );
	}

	function bool GotoScriptAction( name NewScript, float NewAction )
	{
		local NarratorScript	NScript;

		NScript = FindScript( NewScript );
		if ( NScript != none )
		{
			Script = NScript;
			ScriptAction = NewAction;
			return true;
		}
		return false;
	}

	function bool CallScript( name NewScript, float NewAction )
	{
		if ( ScriptIndex < ArrayCount(ScriptStack) )
		{
			ScriptStack[ScriptIndex].ScriptObject = Script;
			ScriptStack[ScriptIndex].ScriptAction = ScriptAction;
			if ( GotoScriptAction( NewScript, NewAction ) )
			{
				ScriptIndex += 1;
				return true;
			}
		}
		return false;
	}

	function bool ReturnScript()
	{
		if ( ScriptIndex > 0 )
		{
			ScriptIndex -= 1;
			Script = ScriptStack[ScriptIndex].ScriptObject;
			ScriptAction = ScriptStack[ScriptIndex].ScriptAction;
			return true;
		}
		return false;
	}

	function UnlockPlayerAction()
	{
		local LockPlayerTrigger		Trig;
		local ScriptedPawn			SP;

		foreach AllActors( class'LockPlayerTrigger', Trig )
			if ( Trig.bLocked )
				Trig.Timer();

		foreach AllActors( class'ScriptedPawn', SP )
			SP.FastScript( false );
	}

	function ForcePlayerTouch( name TouchTag )
	{
		local pawn		P;
		local actor		A;

		P = FindPlayer();
		if ( TouchTag != '' )
			foreach AllActors( class'actor', A, TouchTag )
				A.Touch( P );
	}

	function AnimEnd()
	{
		DebugInfoMessage( ".AIRunScript, AnimEnd() @ " $ Level.TimeSeconds );
		PlayAnimFromGroup( ScriptAnimGroup );
	}

	function int Mumble( sound ASound )
	{
		local int	sID;
		local actor PlayerTarget;
		local bool near;

		if ( bFastScript )
			return 0;
		
		PlayerTarget = FindPlayer();
		if (PlayerTarget == None)
			return 0;
			
		if (PlayerPawn(PlayerTarget).ViewTarget != none)
			PlayerTarget = PlayerPawn(PlayerTarget).ViewTarget;
		
		if (VSize(Location - PlayerTarget.Location) > 2048.0)
			return 0;
		
		sID = 0;
		if ( ( ASound != none ) && ( ASound != ScriptLastSound ) )
		{
			ScriptLastSound = ASound;
			if (Level.NetMode == NM_Standalone)
				sID = PlayAnimSound( MouthAnim, ASound, ScriptSoundAmp, SLOT_Talk );
			DebugInfoMessage( ".Mumble, PlayAnimSound sID is " $ sID );
			if ( sID <= 0 )
				sID = PlaySound( ASound, SLOT_Talk );
			DebugInfoMessage( ".Mumble, sID is " $ sID );
		}
		LastScriptSound = sID;
		return sID;
	}

	function int PlaySpecialSound( sound ASound, int Flags )
	{
		local int	sID;

		if ( bFastScript )
			return 0;
		sID = 0;
		if ( ( ASound != none ) && ( ASound != ScriptLastSound ) )
		{
			ScriptLastSound = ASound;
			if (Level.NetMode == NM_Standalone)
				sID = PlayAnimSound( MouthAnim, ASound, ScriptSoundAmp, SLOT_Talk, [Flags] Flags );
			DebugInfoMessage( ".PlaySpecialSound, PlaySound sID is " $ sID );
			if ( sID <= 0 )
				sID = PlaySound( ASound, SLOT_Talk, [Flags] Flags );
			DebugInfoMessage( ".PlaySpecialSound, sID is " $ sID );
		}
		return sID;
	}

	function PlayAnimFromGroup( int Group )
	{
		local float		R;

		DebugInfoMessage( ".PlayAnimFromGroup(), Group is " $ Group );
		if ( Group != 0 )
		{
			if ( ScriptWaitCount > 0 )
			{
				ScriptWaitCount -= 1;
				PlayAnim( 'idle',[TweenTime] 1.0 );
//				LoopAnim( 'idle', [TweenTime] 2.0 );
				DebugInfoMessage( ".PlayAnimFromGroup(), played wait @ " $ Level.TimeSeconds );
			}
			else
			{
				ScriptWaitCount = 1;	// + Rand(4);
				R = FRand();
				switch ( Group )
				{
					// Casual, Imploring
					case 1:
					case 2:
						if ( R < 0.50 )
							PlayAnim( 'speaking_casual2', [TweenTime] 1.0 );
						else if ( R < 0.55 )
							PlayAnim( 'speaking_casual3', [TweenTime] 1.0 );
						else if ( R < 0.65 )
							PlayAnim( 'speaking_emphasis', [TweenTime] 1.0 );
						else
							PlayAnim( 'idle', [TweenTime] 1.0 );
						break;
					// Inquisitive.
					case 3:
						if ( R < 0.35 )
							PlayAnim( 'speaking_question1', [TweenTime] 1.0 );
						else if ( R < 0.45 )
							PlayAnim( 'speaking_question2', [TweenTime] 1.0 );
						else if ( R < 0.55 )
							PlayAnim( 'idle', [TweenTime] 1.0 );
						else if ( R < 0.65 )
							PlayAnim( 'speaking_emphasis', [TweenTime] 1.0 );
						else
							PlayAnim( 'speaking_casual2', [TweenTime] 1.0 );
						break;
				}
			}
		}
	}

	function LeashPlayer( bool Status )
	{
		if ( PlayerLeash != none )
		{
			bIsLeashed = Status;
			PlayerLeash.bIsActive = bIsLeashed;
			if ( bIsLeashed )
			{
				InitPastTable( Location, FindPlayer().Location );
				UpdateLeash();
			}
		}
	}

	function InitPastTable( vector Here, vector There )
	{
		local int		lp;
		local vector	DVect;

		DVect = ( There - Here ) / ArrayCount(PastLocation);
		for ( lp=0; lp<ArrayCount(PastLocation); lp++ )
			PastLocation[lp] = There - ( DVect * lp );
		PastIndex = ArrayCount(PastLocation);
	}

	function UpdatePastTable( vector ThisLoc )
	{
		PastIndex += 1;
		if ( PastIndex >= ArrayCount(PastLocation) )
			PastIndex = 0;
		PastLocation[PastIndex] = ThisLoc;
		UpdateLeash();
	}

	function UpdateLeash()
	{
		local int	Index;

		Index = PastIndex + 1 + LeashIndex;
		if ( Index >= ArrayCount(PastLocation) )
			Index -= ArrayCount(PastLocation);

		if ( PlayerLeash != none )
			PlayerLeash.SetLocation( PastLocation[Index] );
	}

	function vector GetJumpPoint( vector thisLocation )
	{
		local vector	HitLocation, HitNormal;
		local int		HitJoint;

		Trace( HitLocation, HitNormal, HitJoint, thisLocation - vect(0,0,32000), thisLocation, false );
		return HitLocation;
	}

	function DieAction()
	{
		local DamageInfo	DInfo;

		if ( GetScriptValue() != 0.0 )
			FadeOutTime = GetScriptValue();
		DInfo = getDamageInfo( 'suicide' );
		DInfo.DamageType = GetScriptName();
		if ( AcceptDamage( DInfo ) )
			TakeDamage( none, Location, vect(0,0,0), DInfo );
	}


DAMAGED:
RESUME:
BEGIN:
	WaitForLanding();
	PlayWait();

TRIGGER:
ACTION:
	if ( Script == none )
		GotoState( 'AINoScript' );
	if ( GetScriptAction() != ACTION_None )
		DebugInfoMessage( ".AIRunScript, Script Tag is " $ Script.Tag $ ", line " $ ScriptAction );
	switch ( GetScriptAction() )
	{
		case ACTION_None:
			break;
		case ACTION_WalkToPoint:
			TargetActor = FindNavPoint( GetScriptName() );
			DebugInfoMessage( ".AIRunScript, WALKTOPOINT " $ TargetActor.name );
			bIsRunAction = false;
			Mumble( GetScriptSound() );
			goto 'GOTOACT';
			break;
		case ACTION_RunToPoint:
			TargetActor = FindNavPoint( GetScriptName() );
			DebugInfoMessage( ".AIRunScript, RUNTOPOINT " $ TargetActor.name );
			bIsRunAction = true;
			Mumble( GetScriptSound() );
			goto 'GOTOACT';
			break;
		case ACTION_WalkToPlayer:
			DebugInfoMessage( ".AIRunScript, WALKTOPLAYER " $ GetScriptValue() );
			TargetPoint = GetPlayerPoint( GetScriptValue() );
			Mumble( GetScriptSound() );
			bIsRunAction = false;
			goto 'GOTOPLAYER';
		case ACTION_RunToPlayer:
			DebugInfoMessage( ".AIRunScript, RUNTOPLAYER " $ GetScriptValue() );
			TargetPoint = GetPlayerPoint( GetScriptValue() );
			bIsRunAction = true;
			Mumble( GetScriptSound() );
			goto 'GOTOPLAYER';
			break;
		case ACTION_SpeakCasual:
			DebugInfoMessage( ".AIRunScript, SPEAKCASUAL" );
			goto 'SPEAKCASUAL';
			break;
		case ACTION_SpeakImplore:
			DebugInfoMessage( ".AIRunScript, SPEAKIMPLORE" );
			goto 'SPEAKIMPLORE';
			break;
		case ACTION_SpeakInquisitive:
			DebugInfoMessage( ".AIRunScript, SPEAKINQUISITIVE" );
			goto 'SPEAKINQUISITIVE';
			break;
		case ACTION_SpeakMumble:
			Mumble( GetScriptSound() );
			if ( GetScriptValue() > 0.0 )
				Sleep( GetScriptValue() );
			break;
		case ACTION_PlayAnimation:
			DebugInfoMessage( ".AIRunScript, PLAYANIM " $ GetScriptName() );
			goto 'PLAYANIM';
			break;
		case ACTION_LoopAnimation:
			DebugInfoMessage( ".AIRunScript, LOOPANIM " $ GetScriptName() );
			goto 'LOOPANIM';
			break;
		case ACTION_Trigger:
			DebugInfoMessage( ".AIRunScript, TRIGGER " $ GetScriptName() );
			Mumble( GetScriptSound() );
			TriggerAction( GetScriptName() );
			Sleep( GetScriptValue() );
			break;
		case ACTION_Wait:
			DebugInfoMessage( ".AIRunScript, WAIT " $ GetScriptValue() );
			if ( !GetScriptBool() )
				PlayWait();
			Mumble( GetScriptSound() );
			if ( !bFastScript )
				Sleep( GetScriptValue() );
			break;
		case ACTION_Goto:
			DebugInfoMessage( ".AIRunScript, GOTO " $ GetScriptValue() );
			ScriptAction = GetScriptValue();
			CheckRunon();
			goto 'ACTION';
			break;
		case ACTION_GotoState:
			DebugInfoMessage( ".AIRunScript, GOTOSTATE " $ GetScriptName() );
			GotoState( GetScriptName() );
			break;
		case ACTION_GotoScript:
			DebugInfoMessage( ".AIRunScript, GOTOSCRIPT " $ GetScriptName() $ ", " $ GetScriptValue() );
			if ( GotoScriptAction( GetScriptName(), GetScriptValue() ) )
				goto 'ACTION';
			break;
		case ACTION_UnlockPlayer:
			DebugInfoMessage( ".AIRunScript, UNLOCKPLAYER " $ ScriptTriggerer.name );
			UnlockPlayerAction();
			if ( !GetScriptBool() )
				SetLookAt( none );
			break;
		case ACTION_PlayerSpeak:
			DebugInfoMessage( ".AIRunScript, PLAYERSPEAK" );
			goto 'PLAYERSPEAK';
			break;
		case ACTION_Unlook:
			DebugInfoMessage( ".AIRunScript, UNLOOK" );
			SetLookAt( none );
			break;
		case ACTION_LeashPlayer:
			DebugInfoMessage( ".AIRunScript, LEASHPLAYER set to " $ GetScriptBool() );
			LeashPlayer( GetScriptBool() );
			break;
		case ACTION_JumpToPoint:
			TargetActor = FindNavPoint( GetScriptName() );
			DebugInfoMessage( ".AIRunScript, JUMPTOPOINT " $ TargetActor.name );
			Mumble( GetScriptSound() );
			goto 'JUMPACT';
			break;
		case ACTION_Vanish:
			DebugInfoMessage( ".AIRunScript, VANISH -- Goodbye cruel world!" );
			Mumble( GetScriptSound() );
			Vanish();
			break;
		case ACTION_PlayerDetect:
			DebugInfoMessage( ".AIRunScript, PLAYERDETECT set to " $ GetScriptBool() );
			bDetectPlayer = GetScriptBool();
			break;
		case ACTION_EndScript:
			DebugInfoMessage( ".AIRunScript, ENDSCRIPT" );
			goto 'ENDSCRIPT';
			break;
		case ACTION_CallState:
			DebugInfoMessage( ".AIRunScript, CALLSTATE " $ GetScriptName() );
			Mumble( GetScriptSound() );
			goto 'CALLSTATE';
			break;
		case ACTION_CallScript:
			DebugInfoMessage( ".AIRunScript, CALLSCRIPT " $ GetScriptName() $ ", " $ GetScriptValue() );
			if ( CallScript( GetScriptName(), GetScriptValue() ) )
				goto 'ACTION';
			break;
		case ACTION_Return:
			DebugInfoMessage( ".AIRunScript, RETURN" );
			ReturnScript();
			break;
		case ACTION_SetTag:
			DebugInfoMessage( ".AIRunScript, SETTAG, set to " $ GetScriptName() );
			Tag = GetScriptName();
			break;
		case ACTION_Die:
			DebugInfoMessage( ".AIRunScript, DIE " $ GetScriptName() );
			DieAction();
			break;
		case ACTION_FadeIn:
			DebugInfoMessage( ".AIRunScript, FADEIN " $ GetScriptValue() );
			OpacityEffector.SetFade( 1.0, GetScriptValue() );
			break;
		case ACTION_FadeOut:
			DebugInfoMessage( ".AIRunScript, FADEOUT " $ GetScriptValue() );
			OpacityEffector.SetFade( 0.0, GetScriptValue() );
			break;
		case ACTION_LookAt:
			DebugInfoMessage( ".AIRunScript, LOOKAT" $ GetScriptName() $ " found " $ FindTaggedActor( GetScriptName() ).name );
			SetLookAt( FindTaggedActor( GetScriptName() ) );
			break;
		case ACTION_PlaySpecialSound:
			DebugInfoMessage( ".AIRunScript, PLAYSPECIALSOUND" $ GetScriptSound().name $ " with flags " $ int(GetScriptValue()) );
			PlaySpecialSound( GetScriptSound(), int(GetScriptValue()) );
			break;
		case ACTION_Turret:
			DebugInfoMessage( ".AIRunScript, TURRET set to " $ GetScriptBool() );
			bScriptTurret = GetScriptBool();
			break;
		case ACTION_Custom:
			DebugInfoMessage( ".AIRunScript, CUSTOM action " $ GetScriptName() );
			CustomScriptAction( GetScriptName(), GetScriptSound(), GetScriptValue(), GetScriptBool() );
			break;
		case ACTION_ForcePlayerTouch:
			DebugInfoMessage( ".AIRunScript, FORCEPLAYERTOUCH " $ GetScriptName() );
			ForcePlayerTouch( GetScriptName() );
			break;
	}

NEXT:
	bIgnoreBump = false;
	ScriptAnimGroup = 0;
	NextAction();
	if ( ( ScriptAction == 0 ) && ( ScriptIndex > 0 ) )
	{
		ReturnScript();
		goto 'NEXT';
	}
	goto 'ACTION';

//
GOTOACT:
	if ( bFastScript )
	{
		SetLocation( ComputeTeleportLocation( TargetActor.Location ) );
		if ( !GetScriptBool() )
		{
			StopMovement();
			PlayWait();
//			TurnTo( Location + vector(TargetActor.Rotation) * 500.0, 5 * DEGREES );
			DesiredRotation = TargetActor.Rotation;
			SetRotation( DesiredRotation );
		}
		goto 'NEXT';
	}
	bScriptTurret = false;
	bMRM = default.bMRM;
	if ( TargetActor != none )
	{
		if ( actorReachable( TargetActor ) )
		{
			if ( bIsRunAction )
			{
				PlayRun();
				MoveToward( TargetActor, FullSpeedScale );
			}
			else
			{
				PlayWalk();
				MoveToward( TargetActor, WalkSpeedScale );
			}
		}
		else
		{
			PathObject = PathToward( TargetActor );
			if ( PathObject != none )
			{
				// can path to OrderObject
				if ( bIsRunAction )
				{
					PlayRun();
					MoveToward( PathObject, FullSpeedScale );
				}
				else
				{
					PlayWalk();
					MoveToward( PathObject, WalkSpeedScale );
				}
				goto 'GOTOACT';
			}
			else
			{
				// couldn't path to OrderObject
				DebugInfoMessage( ".AIRunScript, couldn't path to " $ TargetActor.name );
				goto 'NONAV';
			}
		}
		if ( !GetScriptBool() )
		{
			StopMovement();
			PlayWait();
			TurnTo( Location + vector(TargetActor.Rotation) * 500.0, 5 * DEGREES );
		}
		Sleep( GetScriptValue() );
	}
	goto 'NEXT';

//
GOTOPLAYER:
//	bScriptTurret = true;
	bMRM = false;
	if ( bFastScript )
	{
		SetLocation( ComputeTeleportLocation( TargetPoint ) );
		StopMovement();
		PlayWait();
//		TurnToward( FindPlayer(), 5 * DEGREES );
		DesiredRotation = rotator(FindPlayer().Location - Location);
		DesiredRotation.Pitch = 0;
		SetRotation( DesiredRotation );
		SetLookAt( FindPlayer() );
		goto 'NEXT';
	}
	if ( pointReachable( TargetPoint ) )
	{
		if ( bIsRunAction )
		{
			PlayRun();
			MoveTo( TargetPoint, FullSpeedScale );
		}
		else
		{
			PlayWalk();
			MoveTo( TargetPoint, WalkSpeedScale );
		}
	}
	else
	{
		PathObject = PathTowardPoint( TargetPoint );
		if ( PathObject != none )
		{
			// can path to OrderObject
			if ( bIsRunAction )
			{
				PlayRun();
				MoveToward( PathObject, FullSpeedScale );
			}
			else
			{
				PlayWalk();
				MoveToward( PathObject, WalkSpeedScale );
			}
			goto 'GOTOPLAYER';
		}
		else
		{
			// couldn't path to OrderObject
			DebugInfoMessage( ".AIRunScript, couldn't path to TargetPoint" );
			goto 'NONAV';
		}
	}
	StopMovement();
	PlayWait();
	TurnToward( FindPlayer(), 5 * DEGREES );
	bScriptTurret = true;
	SetLookAt( FindPlayer() );
	goto 'NEXT';

//
JUMPACT:
	bScriptTurret = false;
	bMRM = default.bMRM;
	bIgnoreBump = true;
//	TargetPoint = GetGotoPoint( TargetActor.Location );
	TargetPoint = TargetActor.Location;
	PushState( GetStateName(), 'JUMPED');
	GotoState( 'AIJumpToPoint' );
JUMPED:
	goto 'NEXT';

//
CALLSTATE:
	PushState( GetStateName(), 'CALLED');
	GotoState( GetScriptName() );
CALLED:
	WaitForLanding();
	goto 'NEXT';

//
SPEAKCASUAL:
	ScriptAnimGroup = 1;
	goto 'SPEAKING';

//
SPEAKIMPLORE:
	ScriptAnimGroup = 2;
	goto 'SPEAKING';

//
SPEAKINQUISITIVE:
	ScriptAnimGroup = 3;
	goto 'SPEAKING';

SPEAKING:
	if ( bFastScript )
	{
		ScriptAnimGroup = 0;
		goto 'NEXT';
	}
	bIgnoreBump = true;
	ScriptSoundID = Mumble( GetScriptSound() );
	ScriptWaitCount = 0;
	PlayAnimFromGroup( ScriptAnimGroup );
	if ( GetScriptSound() != none )
		ScriptSoundLen = GetSoundDuration( GetScriptSound() );
	else
		ScriptSoundLen = 0.0;
	DebugInfoMessage( " GetSoundDuration() for ID " $ ScriptSoundID $ " returns " $ ScriptSoundLen );
	if ( GetScriptValue() == 0.0 )
		Sleep( ScriptSoundLen + 0.75 );
	else
		Sleep( ScriptSoundLen + GetScriptValue() );
	ScriptAnimGroup = 0;
	PlayWait();
	Sleep( GetScriptValue() + 0.75 );
	goto 'NEXT';

//
PLAYERSPEAK:
	if ( bFastScript )
		goto 'NEXT';
	bIgnoreBump = true;
	ScriptPlayer = FindPlayer();
	PlayWait();
	if ( GetScriptSound() != none )
		ScriptSoundLen = GetSoundDuration( GetScriptSound() );
	else
		ScriptSoundLen = 0.0;
	DebugInfoMessage( ".AIRunScript, player speaking, sound length is " $ ScriptSoundLen );
	ScriptSoundID = ScriptPlayer.PlaySound( GetScriptSound(), SLOT_Talk );
	if ( GetScriptValue() == 0.0 )
		Sleep( ScriptSoundLen + 0.75 );
	else
		Sleep( ScriptSoundLen + GetScriptValue() );
	goto 'NEXT';

//
PLAYANIM:
	bIgnoreBump = true;
	Mumble( GetScriptSound() );
	PlayAnim( GetScriptName() );
	DebugInfoMessage( ".AIRunScript, played anim " $ GetScriptName() $ " @" $ Level.TimeSeconds );
	if ( bFastScript )
		goto 'NEXT';
	if ( GetScriptBool() )
		FinishAnim();
	Sleep( GetScriptValue() );
	goto 'NEXT';

//
LOOPANIM:
	bIgnoreBump = true;
	Mumble( GetScriptSound() );
	LoopAnim( GetScriptName() );
	if ( bFastScript )
		goto 'NEXT';
	Sleep( GetScriptValue() );
	goto 'NEXT';

//
NONAV:					// TEMP lost
	StopMovement();		// TEMP lost
	PlayWait();			// TEMP lost
//	AmbientGlow = 255;	// TEMP lost
NONAVLP:
	Sleep( 10.0 );		// TEMP lost
	goto 'NONAVLP';		// TEMP lost

//
ENDSCRIPT:
} // state AIRunScript


//****************************************************************************
// AINoScript
// No or lost script.
//****************************************************************************
state AINoScript
{
	// *** ignored functions ***

	// *** overridden functions ***

	// *** new (state only) functions ***

RESUME:
BEGIN:
	WaitForLanding();
	PlayWait();
} // state AINoScript


//****************************************************************************
// Def props.
//****************************************************************************
/*	TEMP - copy to subclasses that need to have these properties cleared
	PI_StabSound=(Sound_1=none,Sound_2=none,Sound_3=none)
	PI_BiteSound=(Sound_1=none,Sound_2=none,Sound_3=none)
	PI_BluntSound=(Sound_1=none,Sound_2=none,Sound_3=none)
	PI_BulletSound=(Sound_1=none,Sound_2=none,Sound_3=none)
	PI_RipSliceSound=(Sound_1=none,Sound_2=none,Sound_3=none)
	PI_GenLargeSound=(Sound_1=none,Sound_2=none,Sound_3=none)
	PI_GenMediumSound=(Sound_1=none,Sound_2=none,Sound_3=none)
	PI_GenSmallSound=(Sound_1=none,Sound_2=none,Sound_3=none)
	PE_StabEffect=none
	PE_StabKilledEffect=none
	PE_BiteEffect=none
	PE_BiteKilledEffect=none
	PE_BluntEffect=none
	PE_BluntKilledEffect=none
	PE_BulletEffect=none
	PE_BulletKilledEffect=none
	PE_RipSliceEffect=none
	PE_RipSliceKilledEffect=none
	PE_GenLargeEffect=none
	PE_GenLargeKilledEffect=none
	PE_GenMediumEffect=none
	PE_GenMediumKilledEffect=none
	PE_GenSmallEffect=none
	PE_GenSmallKilledEffect=none
	PD_StabDecal=none
	PD_BiteDecal=none
	PD_BluntDecal=none
	PD_BulletDecal=none
	PD_RipSliceDecal=none
	PD_GenLargeDecal=none
	PD_GenMediumDecal=none
	PD_GenSmallDecal=none
*/

defaultproperties
{
     ReactionBase=0.5
     ReactionRand=0.25
     CheckReloadDelay=5
     DamageSoundDelay=1
     bTryStepForward=True
     bTrySeekAlternate=True
     FollowDistance=150
     GreetDistance=50
     SafeDistance=800
     RunDistance=300
     LongRangeDistance=20000
     MindshatterWander=100
     JumpDownDistance=100
     bHasNearAttack=True
     NearAttackVerb=clobbered
     WeaponJoint=L_Palm
     ForfeitPursuit=0.75
     DamageRadius=150
     WeaponAttackFOV=0.707
     SK_WalkDelay=6
     HearingEffectorThreshold=2
     VisionEffectorThreshold=1
     TeamClass=Class'Aeons.ScriptedPawnTeam'
     WalkSpeedScale=0.5
     FullSpeedScale=1
     AttitudeToEnemy=ATTITUDE_Hate
     JumpScalar=1
     MaxJumpZ=1000
     PhysicalScalar=1
     MagicalScalar=1
     FireScalar=1
     ConcussiveScalar=1
     FallDamageScalar=0.5
     ReactToDamageThreshold=4
     FadeOutDelay=100
     FadeOutTime=5
     DrawScaleVariance=0.05
     DiffuseColorVariance=100
     bUseLooking=True
     LostCounter=4
     DispelAmplitude=-1
     AttackVocalDelay=10
     AttackVocalChance=0.4
     RetreatVocalDelay=10
     bHackable=True
     bIllumCrosshair=True
     bScryeGlow=True
     LeashIndex=13
     ScriptSoundAmp=1
     MouthAnim=SpeakMorph_Morph
     MeleeRange=150
     GroundSpeed=10
     AirSpeed=10
     AccelRate=200
     PeripheralVision=0.707107
     HearingThreshold=0.3
     OnFireParticles=Class'Aeons.OnFireParticleFX'
     UnderWaterTime=5
     PI_StabSound=(Sound_1=Sound'Impacts.GoreSpecific.E_Imp_FleshStab01',Sound_2=Sound'Impacts.GoreSpecific.E_Imp_FleshStab02')
     PI_BiteSound=(Sound_1=Sound'Impacts.GoreSpecific.E_Imp_FleshBite01',Sound_2=Sound'Impacts.GoreSpecific.E_Imp_FleshBite02')
     PI_BluntSound=(Sound_1=Sound'Impacts.GoreSpecific.E_Imp_FleshBlunt01',Sound_2=Sound'Impacts.GoreSpecific.E_Imp_FleshBlunt02')
     PI_BulletSound=(Sound_1=Sound'Impacts.GoreSpecific.E_Imp_FleshBullet01',Sound_2=Sound'Impacts.GoreSpecific.E_Imp_FleshBullet02')
     PI_RipSliceSound=(Sound_1=Sound'Impacts.GoreSpecific.E_Imp_FleshSlice01',Sound_2=Sound'Impacts.GoreSpecific.E_Imp_FleshSlice02')
     PE_StabEffect=Class'Aeons.CombinedBlood'
     PE_BiteEffect=Class'Aeons.CombinedBlood'
     PE_BluntEffect=Class'Aeons.BloodPuffFX'
     PE_BulletEffect=Class'Aeons.CombinedBlood'
     PE_BulletKilledEffect=Class'Aeons.CombinedBlood'
     PE_RipSliceEffect=Class'Aeons.CombinedBlood'
     PD_StabDecal=Class'Aeons.BloodSplatDecal'
     PD_BiteDecal=Class'Aeons.BloodSplatDecal'
     PD_BluntDecal=Class'Aeons.BloodSplatDecal'
     PD_BulletDecal=Class'Aeons.BloodSplatDecal'
     PD_RipSliceDecal=Class'Aeons.BloodSplatDecal'
     PD_GenLargeDecal=Class'Aeons.BloodSplatDecal'
     PD_GenMediumDecal=Class'Aeons.BloodSplatDecal'
     PD_GenSmallDecal=Class'Aeons.BloodSplatDecal'
     PersistentBlood=Class'Aeons.BloodParticles'
     Buoyancy=10
     bTimedTick=True
     MinTickTime=0.1
     RotationRate=(Pitch=0,Yaw=32000,Roll=0)
     DrawType=DT_Mesh
     ShadowRange=512
     TransientSoundVolume=1
     TransientSoundRadius=750
     CreatureDeathMessage="%k %w %o."
     CreatureDeathVerb="killed"
}
