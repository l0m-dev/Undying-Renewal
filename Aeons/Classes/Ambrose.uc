//=============================================================================
// ambrose.
//=============================================================================
class ambrose expands ScriptedBiped;
//#exec MESH IMPORT MESH=ambrose_m SKELFILE=ambrose.ngf INHERIT=ScriptedBiped_m
//#exec MESH JOINTNAME Neck=Head
//#exec MESH MODIFIERS Cloth01:Cloth

// notifiers for proper hand holding.
//#exec MESH NOTIFY SEQ=attack_scythe TIME=0.0 FUNCTION=PutAxeInRightHand
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.0 FUNCTION=PutAxeInRightHand
//#exec MESH NOTIFY SEQ=attack_jumplift TIME=0.0 FUNCTION=PutAxeInRightHand
//#exec MESH NOTIFY SEQ=attack_jumpcycle TIME=0.0 FUNCTION=PutAxeInRightHand
//#exec MESH NOTIFY SEQ=attack_jumpland TIME=0.0 FUNCTION=PutAxeInRightHand
//#exec MESH NOTIFY SEQ=grow TIME=0.0 FUNCTION=PutAxeInLeftHand
//#exec MESH NOTIFY SEQ=shrink TIME=0.0 FUNCTION=PutAxeInLeftHand
//#exec MESH NOTIFY SEQ=stoneslaminaxe TIME=0.0 FUNCTION=PutAxeInLeftHand
//#exec MESH NOTIFY SEQ=defense_houndthrow TIME=0.0 FUNCTION=PutAxeInLeftHand
//#exec MESH NOTIFY SEQ=defense_houndshake TIME=0.0 FUNCTION=PutAxeInLeftHand
//#exec MESH NOTIFY SEQ=weakened TIME=0.0 FUNCTION=PutAxeInLeftHand
//#exec MESH NOTIFY SEQ=idle_alert TIME=0.0 FUNCTION=PutAxeInRightHand
//#exec MESH NOTIFY SEQ=idle_alert_giant TIME=0.0 FUNCTION=PutAxeInRightHand
//#exec MESH NOTIFY SEQ=attack_scythe TIME=0.0 FUNCTION=PutAxeInRightHand
//#exec MESH NOTIFY SEQ=specialkill_swat TIME=0.0 FUNCTION=PutAxeInRightHand
//#exec MESH NOTIFY SEQ=walk_giant TIME=0.0 FUNCTION=PutAxeInRightHand

//#exec MESH NOTIFY SEQ=attack_scythe TIME=0.205 FUNCTION=DoNearDamage		//
//#exec MESH NOTIFY SEQ=attack_scythe TIME=0.231 FUNCTION=DoNearDamage		//

//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.000 FUNCTION=SuspendLookAt
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.236 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.245 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.255 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.264 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.273 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.282 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.291 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=1.000 FUNCTION=ResumeLookAt

//#exec MESH NOTIFY SEQ=attack_jumplift TIME=0.286 FUNCTION=TriggerJump		//
//#exec MESH NOTIFY SEQ=attack_jumplift TIME=1.000 FUNCTION=PlayInAir			//

//#exec MESH NOTIFY SEQ=attack_jumpland TIME=0.250 FUNCTION=DoNearDamage3
//#exec MESH NOTIFY SEQ=attack_jumpland TIME=0.750 FUNCTION=DoNearDamage3

//#exec MESH NOTIFY SEQ=grow TIME=.641 FUNCTION=AmbroseGrow
//#exec MESH NOTIFY SEQ=grow TIME=1.00 FUNCTION=AmbroseStartGiantNormal
//#exec MESH NOTIFY SEQ=shrink TIME=.100 FUNCTION=AmbroseShrink
////#exec MESH NOTIFY SEQ=shrink TIME=1.00 FUNCTION=AmbroseStartWeakened

////#exec MESH NOTIFY SEQ=stoneslaminaxe TIME=0.00 FUNCTION=AmbrosePutStoneOnGround
//#exec MESH NOTIFY SEQ=stoneslaminaxe TIME=0.440 FUNCTION=AmbrosePutStoneInHand
//#exec MESH NOTIFY SEQ=stoneslaminaxe TIME=0.980 FUNCTION=AmbrosePutStoneInAxe

//#exec MESH NOTIFY SEQ=defense_houndthrow TIME=1.00 FUNCTION=AmbroseHoundThrown

//#exec MESH NOTIFY SEQ=specialkill_swat TIME=0.153 FUNCTION=Obliterate

////#exec MESH NOTIFY SEQ=walk_giant_intro TIME=1.000 FUNCTION=walk_giant
////#exec MESH NOTIFY SEQ=walk_giant TIME=1.0 FUNCTION=walk_giant


//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.146 FUNCTION=PlaySound_N ARG="VEffortA CHANCE=0.7 PVar=0.1"
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.271 FUNCTION=PlaySound_N ARG="AxeWhshGnt PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.292 FUNCTION=PlaySound_N ARG="AxeHitGnt PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.520 FUNCTION=PlaySound_N ARG="AxeWhshGnt PVar=0.1 V=.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=attack_axeslam_giant TIME=0.813 FUNCTION=PlaySound_N ARG="VEffortB CHANCE=0.5 PVar=0.1 V=0.75 VVar=0.1"

//#exec MESH NOTIFY SEQ=attack_jumpland TIME=0.100 FUNCTION=PlaySound_N ARG="AxeWhshGnt PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=attack_jumpland TIME=0.250 FUNCTION=PlaySound_N ARG="AxeHitGnt"
//#exec MESH NOTIFY SEQ=attack_jumpland TIME=0.150 FUNCTION=PlaySound_N ARG="GiantFS"
//#exec MESH NOTIFY SEQ=attack_jumpland TIME=0.200 FUNCTION=PlaySound_N ARG="GiantFS"

//#exec MESH NOTIFY SEQ=attack_jumplift TIME=0.533 FUNCTION=PlaySound_N ARG="VEffortA CHANCE=0.7 PVar=0.1"
//#exec MESH NOTIFY SEQ=attack_jumplift TIME=0.520 FUNCTION=PlaySound_N ARG="GiantFSScuff"
//#exec MESH NOTIFY SEQ=attack_jumplift TIME=0.600 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.1 VVar=0.1

//#exec MESH NOTIFY SEQ=attack_scythe TIME=0.075 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.1 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=attack_scythe TIME=0.125 FUNCTION=PlaySound_N ARG="AxeWhsh"
//#exec MESH NOTIFY SEQ=attack_scythe TIME=0.2 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.1 V=0.5 VVar=0.1"

//#exec MESH NOTIFY SEQ=death_beheadspin TIME=0.0 FUNCTION=PlaySound_N ARG="BSpin"

////#exec MESH NOTIFY SEQ=defense_houndthrow TIME=0.46 FUNCTION=C_FS
////#exec MESH NOTIFY SEQ=defense_houndthrow TIME=0.8 FUNCTION=C_FS

//#exec MESH NOTIFY SEQ=grow TIME=0.0 FUNCTION=PlaySound_N ARG="GrowA"
//#exec MESH NOTIFY SEQ=grow TIME=0.27665 FUNCTION=PlaySound_N ARG="GiantFS"
//#exec MESH NOTIFY SEQ=grow TIME=0.291878 FUNCTION=PlaySound_N ARG="GiantFSScuff"
//#exec MESH NOTIFY SEQ=grow TIME=0.474619 FUNCTION=PlaySound_N ARG="GiantFSScuff"
//#exec MESH NOTIFY SEQ=grow TIME=0.733503 FUNCTION=PlaySound_N ARG="GiantFS"
//#exec MESH NOTIFY SEQ=grow TIME=0.761421 FUNCTION=PlaySound_N ARG="GiantFS"
//#exec MESH NOTIFY SEQ=grow TIME=0.92132 FUNCTION=PlaySound_N ARG="GiantFS"
//#exec MESH NOTIFY SEQ=grow TIME=0.951777 FUNCTION=PlaySound_N ARG="GiantFSScuff"

//#exec MESH NOTIFY SEQ=shrink TIME=0.0 FUNCTION=PlaySound_N ARG="GrowC"
//#exec MESH NOTIFY SEQ=shrink TIME=0.131868 FUNCTION=PlaySound_N ARG="GiantFS"
//#exec MESH NOTIFY SEQ=shrink TIME=0.32967 FUNCTION=PlaySound_N ARG="GiantFSScuff"

//#exec MESH NOTIFY SEQ=taunt_axe TIME=0.0434783 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.1 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt_axe TIME=0.130435 FUNCTION=PlaySound_N ARG="AxeWhsh"
//#exec MESH NOTIFY SEQ=taunt_axe TIME=0.217391 FUNCTION=PlaySound_N ARG="GiantFSScuff"
//#exec MESH NOTIFY SEQ=taunt_axe TIME=0.25 FUNCTION=PlaySound_N ARG="AxeWhsh"
//#exec MESH NOTIFY SEQ=taunt_axe TIME=0.413043 FUNCTION=PlaySound_N ARG="AxeWhsh"
//#exec MESH NOTIFY SEQ=taunt_axe TIME=0.521739 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=taunt_axe TIME=0.597826 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.1 V=0.5 VVar=0.1"

//#exec MESH NOTIFY SEQ=taunt_axeGIANT TIME=0.0434783 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.1 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt_axeGIANT TIME=0.130435 FUNCTION=PlaySound_N ARG="AxeWhsh"
//#exec MESH NOTIFY SEQ=taunt_axeGIANT TIME=0.217391 FUNCTION=PlaySound_N ARG="GiantFSScuff"
//#exec MESH NOTIFY SEQ=taunt_axeGIANT TIME=0.25 FUNCTION=PlaySound_N ARG="AxeWhsh"
//#exec MESH NOTIFY SEQ=taunt_axeGIANT TIME=0.413043 FUNCTION=PlaySound_N ARG="AxeWhsh"
//#exec MESH NOTIFY SEQ=taunt_axeGIANT TIME=0.521739 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=taunt_axeGIANT TIME=0.597826 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.1 V=0.5 VVar=0.1"

//#exec MESH NOTIFY SEQ=walk_giant TIME=0.583 FUNCTION=PlaySound_N ARG="VEffortB CHANCE=0.5 PVar=0.1 V=.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=walk_giant TIME=0.583 FUNCTION=PlaySound_N ARG="GiantFS"
//#exec MESH NOTIFY SEQ=walk_giant TIME=0.806 FUNCTION=PlaySound_N ARG="GiantFSScuff"
////#exec MESH NOTIFY SEQ=walk_giant TIME=0.722222 FUNCTION=C_FS

//#exec MESH NOTIFY SEQ=defense_houndshake TIME=0.354 FUNCTION=PlaySound_N ARG="GrabA CHANCE=0.5 PVar0.2 VVar=0.2"

//#exec MESH NOTIFY SEQ=defense_houndthrow TIME=0.386 FUNCTION=PlaySound_N ARG="VEffortA"

//#exec MESH NOTIFY SEQ=stoneslaminaxe TIME=0.246 FUNCTION=PlaySound_N ARG="Stone"

//#exec MESH NOTIFY SEQ=specialkill_swat TIME=0.109 FUNCTION=PlaySound_N ARG="VEffortA"
//#exec MESH NOTIFY SEQ=specialkill_swat TIME=0.000 FUNCTION=PlaySound_N ARG="SPKill"
//#exec MESH NOTIFY SEQ=specialkill_swat TIME=0.900 FUNCTION=PlaySound_N ARG="VTaunt"
//#exec MESH NOTIFY SEQ=specialkill_swat TIME=0.141 FUNCTION=PlaySound_N ARG="PatDeath"

//#exec MESH NOTIFY SEQ=Idle_Alert_Giant TIME=0.0 FUNCTION=PlaySound_N ARG="VEffortB"


enum EAmbroseBossFightState
{
	ABF_None,
	ABF_Normal,
	ABF_Growing,
	ABF_Giant,
	ABF_StartHound,
	ABF_HoundStruggle,
	ABF_Shrinking,
	ABF_Weakened
};

var EAmbroseBossFightState	BossFightState;
var Hound					AmbroseHound;
var SPDrawScaleEffector		DrawScaleEffector;
var(BossFight) float		HoundTimer;
var(BossFight) vector		HoundBitePoint;
var(BossFight) float		GiantGroundSpeed;
var GhelziabahrStone		GhelzStone;
var AmbroseAxe				MyAxe;
var bool			StoneInAxe;

var GhelzTrailFX			GhelzStoneTrail;
var GhelzSmallGlowScriptedFX	GhelzStoneGlow;

function PreBeginPlay()
{
	super.PreBeginPlay();
	DrawScaleEffector = SPDrawScaleEffector(SpawnEffector( class'SPDrawScaleEffector' ));
	BossFightState = ABF_None;
	HoundTimer = 0.0;
	StoneInAxe = false;
}

function PostBeginPlay()
{
	MyAxe = AmbroseAxe( MyProp[0] );
	if( MyAxe == none )
		DebugInfoMessage( ".PostBeginPlay() too early to hook up axe." );
}

function bool FlankEnemy()
{
	return false;
}

function InitGhelzStone()
{
	local pawn aPlayer;

	if( GhelzStone == none )
	{
		aPlayer = FindPlayer();
		if( (aPlayer != none) && (GhelziabahrStone( aPlayer.Weapon ) != none) )
		{
			GhelzStone = GhelziabahrStone( aPlayer.Weapon );
		}

		if( GhelzStone == none )
		{
			foreach AllActors( class'GhelziabahrStone', GhelzStone )
			{
				break;
			}
		}

		if( GhelzStone == none )
			DebugInfoMessage( ".InitGhelzStone() couldn't fine GhelziabahrStone." );
	}
}

function PutAxeInRightHand()
{
	MyProp[0].Setup( 'RTHandle', 'axe_2' );
}

function PutAxeInLeftHand()
{
	MyProp[0].Setup( 'LTHandle', 'axe_1' );
}

function SuspendLookAt()
{
//	PushLookAt( none );
}

function ResumeLookAt()
{
//	PopLookAt();
}

function AmbroseGrow()
{
	DrawScaleEffector.SetFade( 2.0, 1.0 );
//	MyAxe.PlayAnim( 'grow' );
}

function AmbroseShrink()
{
	DrawScaleEffector.SetFade( default.DrawScale, 1.0 );
//	MyAxe.PlayAnim( 'shrink' );
}

function AmbroseStartGiantNormal()
{
	GotoState( 'AmbroseBossFightGiantNormal' );
}

function AmbrosePutStoneOnGround()
{
	if( GhelzStone.Owner != none )
	{
		GhelzStone.SetBase( none );
		GhelzStone.DropFrom( GhelzStone.Owner.Location );
	}
	GhelzStone.bHeldItem = false;
	GhelzStone.SetCollision( false, false, false );

	if( GhelzStoneTrail == none )
		GhelzStoneTrail = spawn( class'GhelzTrailFX', GhelzStone,, GhelzStone.JointPlace('Stone5').pos );
	if( GhelzStoneTrail != none )
	{
		GhelzStoneTrail.SetBase( GhelzStone, 'Stone5' );
	}
}

function AmbrosePutStoneInHand()
{
	GhelzStone.SetBase( self, 'RTHandle', 'Stone5' );
	GhelzStone.bHeldItem = false;
}

function AmbrosePutStoneInAxe()
{
	local AeonsPlayer P;
	local Actor Glow;

	GhelzStone.SetCollision( false, false, false );
	GhelzStone.SetBase( MyProp[0], 'axe_4', 'Stone5' );
	GhelzStone.bHeldItem = false;
	StoneInAxe = true;

	if( GhelzStoneTrail == none )
		GhelzStoneTrail = spawn( class'GhelzTrailFX', GhelzStone,, GhelzStone.JointPlace('Stone5').pos );
	if( GhelzStoneTrail != none )
	{
		GhelzStoneTrail.SetBase( GhelzStone, 'Stone5' );
	}

	if (Level.TimeSeconds > 1)
	{
		ForEach AllActors(class 'AeonsPlayer', P)
		{
			P.ClientFlash( 1, vect(0,1000,0));
		}

		Glow = spawn(class 'DebugLocationMarker',,,MyProp[0].JointPlace('Axe_4').pos );
		Glow.texture = WetTexture'FX.Gglow_wet';
		Glow.DrawScale = 0.5;
		Glow.SetBase(MyProp[0], 'axe_4', 'root');
		Glow.Lifespan = 0.25;
	}
}

function AmbroseStartWeakened()
{
	GotoState( 'AmbroseBossFightWeakened' );
}

function AmbroseHoundThrown()
{
	if( BossFightState == ABF_Shrinking )
		GotoState( 'AmbroseBossFightShrink' );
	else
		GotoState( 'AmbroseBossFightGiantNormal' );
}

// Play close-range attack animation.
function PlayNearAttack()
{
	if( BossFightState == ABF_Giant )
		PlayAnim( 'attack_axeslam_giant', 1.0 );
	else
		PlayAnim( 'attack_scythe', 1.0 );
}

function PlayWait()
{
	MoveSpeed = 0.0;
	LastLocomotion = vect(0,0,0);
	if( BossFightState == ABF_Giant )
		LoopAnim( 'Idle_Alert_Giant', 1.0 );
	else
		PlayWaiting();
}

function PlaySpecialKill()
{
	PlayAnim( 'specialkill_swat' );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	PlayAnim( 'death_beheadspin' );
}

function pawn ViewSKFrom()
{
	return SK_TargetPawn;
}

function vector WorldLocation( vector v )
{
	local vector X;
	local vector Y;
	local vector Z;

	GetAxes( Rotation, X, Y, Z );
	return Location + (v.X * X) + (v.Y * Y) + (v.Z * Z);
}
	
// Calculate a semi-valid point based on the location and height passed.
function vector CalcGroundPoint( vector thisLocation, float thisHeight )
{
	local actor		HitActor;
	local vector	HitLocation, HitNormal;
	local int		HitJoint;

	HitActor = Trace( HitLocation, HitNormal, HitJoint, thisLocation + vect(0,0,-500), thisLocation, false );
	return HitLocation + ( vect(0,0,1) * thisHeight );
}

function vector HoundLocation()
{
	local int i;
	local SpawnPoint aSpawnPoint, HoundSpawnPoint;
	local class<pawn> HoundClass;
	local float BestSpawnAngle, SpawnAngle;
	local vector X;
	local vector Y;
	local vector Z;

	GetAxes( Rotation, X, Y, Z );

	BestSpawnAngle = 2.0;
	HoundSpawnPoint = none;
	foreach AllActors( class'SpawnPoint', aSpawnPoint )
	{
		SpawnAngle = 1.0 - (Normal(aSpawnPoint.Location - Location) dot Y);
		if( (SpawnAngle < BestSpawnAngle) || (HoundSpawnPoint == none) )
		{
			HoundSpawnPoint = aSpawnPoint;
			BestSpawnAngle = SpawnAngle;
		}
	}

	HoundClass = class 'Hound';
	return CalcGroundPoint( HoundSpawnPoint.Location , HoundClass.default.CollisionHeight );
}

function Rotator HoundRotation()
{
	local vector X;
	local vector Y;
	local vector Z;

	GetAxes( Rotation, X, Y, Z );

	return Rotator( -1.0 * Y );
}

function vector WorldBitePoint()
{
	return WorldLocation( HoundBitePoint );
}
	
function PlayLocomotion( vector dVector )
{
	if( VSize( dVector ) < 0.001 )
		PlayWait();
	else if( BossFightState == ABF_Giant )
		MoveAnim( 'Walk_Giant' );
	else
		super.PlayLocomotion( dVector );
}

function PlayTaunt()
{
	if( (BossFightState == ABF_None) || (BossFightState == ABF_Normal) )
		PlayAnim( 'taunt_axe' );
	else
		PlayAnim( 'taunt_axeGIANT' );
}

function bool Decapitate( optional vector Dir )
{
	return false;
}

function AdjustDamage( out DamageInfo DInfo )
{
	super.AdjustDamage( DInfo );
	DInfo.Damage = 0.0;
	if ( DamageSoundDelay == 0 )
	{
		PlaySoundDamage();
		DamageSoundDelay = FVariant( default.DamageSoundDelay, default.DamageSoundDelay * 0.20 );
	}
}

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );

	if( Health > 0.0 )
		HealthBar.SetPercent(0.5 + (HoundTimer / default.HoundTimer) / 2.0);

	if( HoundTimer > 0.0 )
	{
		HoundTimer -= DeltaTime;
		if( HoundTimer <= 0.0 )
		{
			StartHoundFight();
		}
	}
}

function StartHoundFight()
{
	GotoState( 'AmbroseBossFightGiantStartHound' );
}

function StoneHit()
{
	if( StoneInAxe && (BossFightState == ABF_HoundStruggle) )
	{
		GhelzStone.SetBase( none );
		if( GhelzStone.SetLocation( MyProp[0].JointPlace( 'axe_4' ).pos ) )
		{
			GhelzStone.DropFrom( MyProp[0].JointPlace( 'axe_4' ).pos );
			GhelzStone.bHeldItem = false;

			StoneInAxe = false;

			if( GhelzStoneTrail != none )
			{
				GhelzStoneTrail.Destroy();
				GhelzStoneTrail = none;
			}

			if( GhelzStoneGlow != none )
			{
				GhelzStoneGlow.Destroy();
				GhelzStoneGlow = none;
			}

			if( BossFightState == ABF_HoundStruggle )
			{
				BossFightState = ABF_Shrinking;
				GotoState( 'AmbroseBossFightGiantThrowHound' );
			}
			else if( BossFightState == ABF_Giant )
			{
				GotoState( 'AmbroseBossFightShrink' );
			}
		}
		else
			GhelzStone.SetBase( MyProp[0], 'axe_4', 'Stone5' );
	} 
	else if ( StoneInAxe )
	{
		DebugInfoMessage(".StoneHit() not dropping stone.");
		spawn( class'GhelzSmallRingFX',,, GhelzStone.JointPlace( 'Stone5' ).pos );
	}
}

function CommMessage( actor sender, string message, optional int param )
{
	if( message == "HoundAttack" )
		GotoState( 'AmbroseBossFightGiantHoundStruggle' );	
}

state AmbroseBossFightStart
{
	function BeginState()
	{
		BossFightState = ABF_Normal;
		HoundTimer = 0.0;
		SetEnemy( FindPlayer() );
		super.BeginState();
	
		MyAxe = AmbroseAxe( MyProp[0] );
		if( MyAxe == none )
			DebugInfoMessage( ".AmbroseBossFightStart.BeginState() too early to hook up axe." );

		// Health bar.
		if( HealthBar == None )
			HealthBar = class'HealthBar'.static.CreateHealthBar(self, true);
		HealthBar.State = HBS_Invulnerable;
	}

	function Timer()
	{
		DebugInfoMessage( ".AmbroseBossFightStart couldn't find Ghelziabahr stone object in level." );
		GotoState( , 'HaveStone' );
	}

Begin:
	SetTimer( 3.0, false );
	while( GhelzStone == none )
	{
		InitGhelzStone();
		Sleep(0.1);
	}

HaveStone:
	DebugInfoMessage( ".AmbroseBossFightStart found Ghelziabahr stone." );
	SetEnemy( FindPlayer() );
	SetDrawScale(2.0);
	GhelzStone.DropFrom( GhelzStone.Location );
	GhelzStone.SetBase( none );
	GhelzStone.SetCollision( false, false, false );
	GhelzStone.bHeldItem = false;
	AmbrosePutStoneInAxe();
	MyAxe.PlayAnim( 'grow', 100.0 );
	GotoState( 'AmbroseBossFightGiantNormal' );
}

state AmbroseBossFightGrow expands AIScriptedState
{
	function BeginState()
	{
		super.BeginState();
		BossFightState = ABF_Growing;
		HoundTimer = 0.0;
	}

Begin:
	PlayAnim( 'grow', 1.0f );
	MyAxe.PlayAnim( 'grow' );
}

state AmbroseBossFightGiantNormal
{
	function BeginState()
	{
		super.BeginState();
		BossFightState = ABF_Giant;
		GroundSpeed = GiantGroundSpeed;
		MeleeRange = DrawScale * default.MeleeRange;
		DamageRadius = DrawScale * default.DamageRadius;
		HoundTimer = Default.HoundTimer;
		HealthBar.State = HBS_Invulnerable;
	}

Begin:
	SetEnemy( FindPlayer() );
	HatedEnemy = Enemy;
	GotoState( 'AIAttack' );
}

state AmbroseBossFightGiantStartHound expands AIScriptedState
{
	function BeginState()
	{
		super.BeginState();
		BossFightState = ABF_StartHound;
		HoundTimer = 0.0;
	}

	function EndState()
	{
		super.EndState();
		if( AmbroseHound != none )
			PopLookAt();
	}
		
	function Timer()
	{
		StopTimer();
		DebugInfoMessage( ".AmbrosBossFightGiantStartHound couldn't spawn hound -- give up." );
		GotoState( 'AmbroseBossFightGiantNormal' );
	}
		
Begin:
	SetTimer( 0.5, false );
	StopMovement();
	PlayAnim( 'taunt_axeGIANT' );

SpawnHound:
	AmbroseHound = Spawn(class 'AmbroseHound',,, HoundLocation(), HoundRotation() );
	if( AmbroseHound != none )
	{
		StopTimer();
		PushLookAt(AmbroseHound);
		AmbroseHound.SetAmbrose( self, WorldBitePoint() );
		FinishAnim();
		LoopAnim( 'Idle_Alert_Giant', 1.0 );
	}
	else
	{
		DebugInfoMessage( ".AmbrosBossFightGiantStartHound couldn't spawn hound -- retry." );
		Sleep( 0.1 );
		goto 'SpawnHound';
	}
}

state AmbroseBossFightGiantHoundStruggle expands AIScriptedState
{
	function EndState()
	{
		if( GhelzStoneGlow != none )
		{
			GhelzStoneGlow.Direction = -1.0;
			GhelzStoneGlow.Enable('Tick');
		}
		HealthBar.InfoIcon = none;
	}

	function BeginState()
	{
		super.BeginState();
		BossFightState = ABF_HoundStruggle;
		HoundTimer = 0.0;
		PushLookAt( none );

		if( GhelzStoneGlow == none )
		{
			GhelzStoneGlow = spawn( class'GhelzSmallGlowScriptedFX', GhelzStone,, GhelzStone.Location );
		}
		if( GhelzStoneGlow != none )
		{
			GhelzStoneGlow.Direction = 1.0;
			GhelzStoneGlow.Enable('Tick');
		}
		HealthBar.InfoIcon = Texture'Aeons.Icons.Ghelz_Icon';
	}

Begin:
	AmbroseHound.StartStruggle();
	LoopAnim( 'defense_houndshake', 1.0 );
}

state AmbroseBossFightGiantThrowHound expands AIScriptedState
{
	function BeginState()
	{
		super.BeginState();
		HoundTimer = 0.0;
	}

	function EndState()
	{
		PopLookAt();
	}

Begin:
	AmbroseHound.GetThrown();
	PlayAnim( 'defense_houndthrow', 1.0f );
}

state AmbroseBossFightShrink expands AIScriptedState
{
	function BeginState()
	{
		super.BeginState();
		BossFightState = ABF_Shrinking;
		HoundTimer = 0.0;
	}

	function StoneHit()
	{
	}

Begin:
	StopMovement();
	PlayAnim( 'shrink', 1.0f );
	MyAxe.PlayAnim( 'shrink' );
	FinishAnim();
	GotoState( 'AmbroseBossFightWeakened' );	
}

state AmbroseBossFightWeakened expands AIScriptedState
{
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ) 
	{ 
		global.TakeDamage( Instigator, HitLocation, Momentum, DInfo );
	}

	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo )
	{
		global.Died( Killer, damageType, HitLocation, DInfo );
	}

	function Killed( pawn Killer, pawn Other, name damageType )
	{
		global.Killed( Killer, Other, damageType );
	}
	
	function KilledBy( pawn EventInstigator )
	{
		global.KilledBy( EventInstigator );
	}

	function bool Decapitate( optional vector Dir )
	{
		return super.Decapitate( Dir );
	}

	function AdjustDamage( out DamageInfo DInfo )
	{
		global.AdjustDamage( DInfo );
		switch( DInfo.Damagetype )
		{
		case 'scythe':
		case 'scythedouble':
			DInfo.Damage = 2.0 * InitHealth; // make sure he dies.
			DInfo.JointName = 'head';
			HealthBar.SetPercent(0);
			break;
		}
	}

	function StoneHit()
	{
	}

	function BeginState()
	{
		super.BeginState();
		BossFightState = ABF_Weakened;
		HoundTimer = 0.0;
		GroundSpeed = Default.GroundSpeed;
		HealthBar.State = HBS_VulnerableScythe;
	}

	function Timer()
	{
		Health = InitHealth;	// Ambrose is restored.
		GotoState( 'AmbroseBossFightRecoverStone' );
	}

Begin:
	SetTimer( 10.0, false );	// stay in this state for 10 seconds.
	StopMovement();
	LoopAnim( 'weakened' );
}

state AmbroseBossFightRecoverStone expands AIScriptedState
{
	function BeginState()
	{
		super.BeginState();
		BossFightState = ABF_Normal;
		HoundTimer = 0.0;
		HealthBar.State = HBS_Invulnerable;
	}

	function Timer()
	{
		if( GhelzStone == none )
		{
			DebugInfoMessage( ".AmbroseBossFightRecoverStone couldn't find Ghelziabahr stone object in level." );
			GotoState( , 'HaveStone' );
		}
	}

	function StoneHit()
	{
	}

Begin:
	SetTimer( 3.0, false );
	while( GhelzStone == none )
	{
		InitGhelzStone();
		Sleep(0.1);
	}

HaveStone:
	AmbrosePutStoneOnGround();
	SetEnemy( FindPlayer() );
	TurnToward( GhelzStone );
	PlayAnim( 'stoneslaminaxe', 1.0f );
	FinishAnim();
	GotoState( 'AmbroseBossFightGrow' );
}

state AINearAttack
{
	function BeginState()
	{
		super.BeginState();
		if( BossFightState == ABF_Giant )
		{
//			PushLookAt( none );
		}
	}

	function EndState()
	{
		super.EndState();
		if( BossFightState == ABF_Giant )
		{
//			PopLookAt( );
		}
	}
}

function PlayJumpAttack()
{
	if( BossFightState == ABF_Giant )
		PlayAnim( 'attack_jumplift' );
	else
		super.PlayJumpAttack();
}

function PlayInAir()
{
	if( BossFightState == ABF_Giant )
		LoopAnim( 'attack_jumpcycle' );
	else
		super.PlayInAir();
}

//****************************************************************************
// AIJumpAtEnemy
// try to jump toward Enemy
//****************************************************************************
state AIJumpAtEnemy
{
	function bool PlayJumpAttackLanding()
	{
		local AmbroseQuake EQ;

		if( BossFightState == ABF_Giant )
		{
			EQ = spawn( class'AmbroseQuake', self,, Location );
			if( EQ != none )
				EQ.Trigger( none, none );

			return PlayAnim( 'attack_jumpland' );
		}
		else
			super.PlayJumpAttackLanding();
	}
}

//****************************************************************************
// AIFarAttackAnim
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIFarAttackAnim
{
	// *** ignored functions ***

	// *** overridden functions ***

	// *** new (state only) functions ***
	// (Re)evaluate attack strategy.
	function Evaluate()
	{
		local float		distance;

		distance = DistanceTo( Enemy );
		if ( distance <= ( MeleeRange * 3.5 ) )
		{
			// Enemy is closer, re-evaluate attack.
			GotoState( 'AIAttack' );
			return;
		}
	}

JUMPED:
	FinishAnim();
	GotoState( 'AIAttack' );

// Entry point when returning from AITakeDamage.
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state.
RESUME:

// Default entry point.
BEGIN:
	SlowMovement();
	PushState( GetStateName(), 'JUMPED' );
	GotoState( 'AIJumpAtEnemy' );
} // state AIFarAttackAnim


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** overridden functions ***
	function StartHoundFight(){}

	// *** new (state only) functions ***
	function Obliterate()
	{
		local vector	DVect;
		local int		lp;
		local actor		Blood;

		DVect = SK_TargetPawn.JointPlace('pelvis').pos;
		for ( lp = 0; lp < 2; lp++ )
			Spawn( class'Aeons.WeakGibBits',,, DVect, rotator(VRand()) );
		Blood = Spawn( class'Aeons.BloodParticles',,, DVect, SK_TargetPawn.Rotation );
		Blood.SetBase( SK_TargetPawn, 'pelvis', 'root');

		Spawn( class'Gibs',,, SK_TargetPawn.Location, rotator(vect(0,0,100)) );
		SK_TargetPawn.DestroyLimb( 'spine1' );
		ReplicateDestroyLimb( SK_TargetPawn, 'spine1' );
		SK_TargetPawn.PlayAnim( 'death_gun_backhead' );
	}

} // state AISpecialKill

defaultproperties
{
     HoundTimer=40
     HoundBitePoint=(X=117.308,Y=90.238)
     GiantGroundSpeed=100
     MyPropInfo(0)=(Prop=Class'Aeons.AmbroseAxe',PawnAttachJointName=RTHandle,AttachJointName=axe_2)
     LongRangeDistance=1000
     bIsBoss=True
     Aggressiveness=1
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=30,Method=RipSlice)
     MeleeInfo(1)=(Damage=60,Method=RipSlice)
     MeleeInfo(2)=(Damage=60,Method=RipSlice)
     WeaponJoint=L_Wrist
     WeaponAccuracy=0.9
     DamageRadius=85
     SK_PlayerOffset=(X=150)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.6
     WalkSpeedScale=0.55
     PhysicalScalar=0.5
     FireScalar=0.5
     bNoBloodPool=True
     MeleeRange=60
     AirSpeed=1000
     AccelRate=900
     Alertness=1
     SightRadius=9000
     BaseEyeHeight=52
     Health=150
     Intelligence=BRAINS_Human
     SoundSet=Class'Aeons.AmbroseSoundSet'
     PI_StabSound=(Sound_1=None,Sound_2=None)
     PI_BiteSound=(Sound_1=None,Sound_2=None)
     PI_BluntSound=(Sound_1=None,Sound_2=None)
     PI_BulletSound=(Sound_1=None,Sound_2=None)
     PI_RipSliceSound=(Sound_1=None,Sound_2=None)
     PE_StabEffect=None
     PE_BiteEffect=None
     PE_BluntEffect=None
     PE_BulletEffect=None
     PE_BulletKilledEffect=None
     PE_RipSliceEffect=None
     PD_StabDecal=None
     PD_BiteDecal=None
     PD_BluntDecal=None
     PD_BulletDecal=None
     PD_RipSliceDecal=None
     PD_GenLargeDecal=None
     PD_GenMediumDecal=None
     PD_GenSmallDecal=None
     FootSoundClass=Class'Aeons.DefaultFootSoundSet'
     FootSoundRadius=1500
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.ambrose_m'
     DrawScale=1.1
     TransientSoundVolume=5
     TransientSoundRadius=5000
     CollisionRadius=22
     CollisionHeight=57
     Mass=2000
     MenuName="Ambrose"
     CreatureDeathVerb="butchered"
}