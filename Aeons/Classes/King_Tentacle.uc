//=============================================================================
// King_Tentacle.
//=============================================================================
class King_Tentacle expands King_Part;
//#exec MESH IMPORT MESH=King_Tentacle_m SKELFILE=King_Tentacle.ngf

//#exec MESH NOTIFY SEQ=Attack2 TIME=0.448 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack2 TIME=0.483 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack2 TIME=0.552 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack2 TIME=0.655 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack2 TIME=0.690 FUNCTION=DoNearDamage

//#exec MESH NOTIFY SEQ=Attack2 TIME=0.333 FUNCTION=PlaySound_N ARG="WhooshHvy PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack2 TIME=0.363 FUNCTION=PlaySound_N ARG="HeavyHit PVar=0.25 VVar=0.1"


var(AICombat) float StayOutOfWaterTime;

var float	DelayTimer;
var bool	OutOfWater;

// Inflict melee (striking) damage.
function bool InflictNearDamage( actor Victim, int Damage, vector PushDir, int DamageNum, optional float EffectStrength )
{
	local DamageInfo	DInfo;

	if ( ( Victim == none ) || ( Health <= 0 ) )
		return false;

	// Check if still in melee range.
	if ( NearStrikeValid( Victim, DamageNum ) )
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

	if ( ( Square( XY ) + Square( Z ) ) < Square( Range ) )
		return true;
	else
		return false;
}

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	if( JointStrikeValid( Victim, 'Tent03', DamageRadius ) ||
		JointStrikeValid( Victim, 'Tent04', DamageRadius ) ||
		JointStrikeValid( Victim, 'Tent05', DamageRadius ) ||
		JointStrikeValid( Victim, 'Tent06', DamageRadius ) ||
		JointStrikeValid( Victim, 'Tent07', DamageRadius ) ||
		JointStrikeValid( Victim, 'Tent08', DamageRadius ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

function bool FlankEnemy()
{
	return false;
}

function vector FlankPosition( vector target )
{
	return target;
}

function Tick( float deltaTime )
{
	super.Tick( deltaTime );

	if( DelayTimer > 0.0 )
		DelayTimer -= deltaTime;
}

function PreBeginPlay()
{
	super.PreBeginPlay();
	OutOfWater = true;
	DelayTimer = 0.0;
	bHidden = true;
}

function PlayNearAttack()
{
	PlayAnim( 'Attack2' );
}

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
	function TakeDamage( Pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ) {}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();

		SetPhysics( PHYS_Rotating );
	}

	function EndState()
	{
		SetPhysics( PHYS_None );
		DelayTimer = StayOutOfWaterTime;

		super.EndState();
	}

	function AnimEnd() {}

	// *** new (state only) functions ***
	function PostAttack()
	{
		GotoState( 'AIAttackPlayer', 'Attacked' );
	}

// Default entry point
BEGIN:
	if( !OutOfWater )
	{
		bHidden = false;
		PlayAnim( 'Rise' );
		FinishAnim();
		OutOfWater = true;
	}
	else if( bHidden )
		bHidden = false;

	bDidMeleeDamage = false;
	TurnToward( Enemy, 0 );

	PlayNearAttack();
	FinishAnim();

// Entry point when returning from AITakeDamage
DAMAGED:

// Entry point when resuming this state
RESUME:

ATTACKED:
	PostAttack();
} // state AINearAttack

state AIAttackPlayer
{
	// *** new (state only) functions ***
	// dispatch to next appropriate (attack) state
	function Dispatch()
	{
		if( EnemyInRange() )
		{
			GotoState( 'AINearAttack' );
		}
	}

// Default entry point
BEGIN:
	if ( ( Enemy != none ) && ( Enemy.Health > 0 ) )
	{
		Dispatch();
	}

// Entry point when returning from AITakeDamage
DAMAGED:

// Entry point when resuming this state
RESUME:

Attacked:
	if( OutOfWater && (DelayTimer <= 0.0) )
	{
		PlayAnim( 'Fall' );
		FinishAnim();
		bHidden = true;
		OutOfWater = false;
	}
	else if( OutOfWater )
	{
		PlayWait();
	}
	
	Sleep(0.25);
	goto 'BEGIN';
}

defaultproperties
{
	 DrawScale=1.25
     StayOutOfWaterTime=15
     MaxSinePitch=2
     MinSinePitch=-2
     MaxTanYaw=1024
     MinTanYaw=-1024
     RootJointName=Tent01
     MeleeInfo(0)=(Damage=1000,EffectStrength=1,Method=RipSlice)
     DamageRadius=150
     MeleeRange=1500
     SoundSet=Class'Aeons.KingSoundSet'
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.King_Tentacle_m'
     CollisionRadius=100
     bCollideSkeleton=False
}
