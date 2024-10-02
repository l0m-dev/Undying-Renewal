class King_Part expands ScriptedPawn;

var(AICombat)	float	MaxSinePitch;
var(AICombat)	float 	MinSinePitch;
var(AICombat)	float	MaxTanYaw;
var(AICombat)	float	MinTanYaw;
var(KingPart)	name	RootJointName;
var(KingPart)	float	IdleSpeed;
var(KingPart)	float	AttackSpeed;
var(KingPart)	bool	bTakesDamage;
var(AICombat)	float	AcidicSkinDamage;
var				actor	TouchingActor;

function bool FlankEnemy()
{
	return false;
}

function vector FlankPosition( vector target )
{
	return target;
}

function GiveModifiers()
{
}

function KillModifiers()
{
}

function AcidicSkin( float DeltaTime )
{
	local DamageInfo DInfo;

	DebugInfoMessage(".AcidicSkin() called.");
	DInfo.Deliverer = self;
	DInfo.DamageMultiplier = 1.0;
	DInfo.EffectStrength = 0.05;
	DInfo.DamageType = 'acid';
	DInfo.Damage = AcidicSkinDamage * DeltaTime;

	TouchingActor.TakeDamage( self, TouchingActor.Location, vect(0,0,0), DInfo ); 
}

function Touch( actor Other )
{
	if( Other.IsA('PlayerPawn') )
	{
		DebugInfoMessage(" Touching actor " $ Other.name);
		TouchingActor = Other;
		AcidicSkin( 1.0 );
	}
	super.Touch( Other );
}

function UnTouch( actor Other )
{
	if( Other == TouchingActor )
	{
		DebugInfoMessage(" Untouching actor " $ Other.name);
		TouchingActor = none;
	}
	super.UnTouch( Other );
}

function Attach( actor Other )
{
	if( Other.IsA('PlayerPawn') )
	{
		DebugInfoMessage(" Touching actor " $ Other.name);
		TouchingActor = Other;
		AcidicSkin( 1.0 );
	}
	super.Attach( Other );
}

function Detach( actor Other )
{
	if( Other == TouchingActor )
	{
		DebugInfoMessage(" Untouching actor " $ Other.name);
		TouchingActor = none;
	}
	super.Detach( Other );
}

function CreatureBump( pawn Other )
{
	if( !Other.IsA( 'King_Part' ) )
		super.CreatureBump( Other );
}

function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo )
{
	if( (Instigator != none) && ((Instigator == self) || (Instigator.Owner == self)) )
		DebugInfoMessage(".TakeDamage() ignoring damage from self.");
	else
	{
		if( bTakesDamage )
		{
			super.TakeDamage( Instigator, HitLocation, Momentum, DInfo );
		}
		else if( King_Body(Owner) != none )
		{
			DebugInfoMessage(".TakeDamage() passing damage to owner.");
			Owner.TakeDamage( Instigator, HitLocation, Momentum, DInfo );
		}
		else
			DebugInfoMessage(".TakeDamage() can't pass damage to owner.");
	}
}

function EncroachedBy( actor Other )
{
}

function bool Decapitate( vector dir )
{
	return false;
}

function SetInitialState()
{
	bScriptInitialized = true;
	if( InitialState!='' )
		GotoState( InitialState );
	else
		GotoState( 'Auto' );
}

//function SetMovementPhysics()
//{
//	DebugInfoMessage( ".SetMovementPhysics(), bCollideWorld = " $ bCollideWorld $ "." );
//}

//function Attach( actor anActor )
//{
//	DebugInfoMessage( ".Attach( " $ anActor.name $ " )." );
//	super.Attach( anActor );
//}

//function Detach( actor anActor )
//{
//	DebugInfoMessage( ".Detach( " $ anActor.name $ " )." );
//	super.Detach( anActor );
//}

function BaseChange()
{
//	DebugInfoMessage( ".BaseChange()." );
	if( King_Part(Base) == none )
		super.BaseChange();
}

function PlayMultiBrainShot()
{
	PlayAnim( 'Multi_Brainshot' );
}

function StartMultiBrainShot()
{
	DebugInfoMessage( ".StartMultiBrainShot() called." );
	GotoState( 'MultiBrainShot' );
}

function PlayMultiMouthShot()
{
	PlayAnim( 'Multi_Mouthshot_Start' );
}

function LoopMultiMouthShotCycle()
{
	LoopAnim( 'Multi_Mouthshot_cycle' );
}

function StartMultiMouthShot()
{
	DebugInfoMessage( ".StartMultiMouthShot() called." );
	GotoState( 'MultiMouthShot' );
}

function bool PlayMultiMouthShotRecover()
{
	return false;
}

function RecoverMultiMouthShot()
{
	DebugInfoMessage( ".RecoverMultiMouthShot() called." );
	GotoState( 'MultiMouthShotRecover' );
}

function Tick( float deltaTime )
{
	// in multiplayer a player doesn't exist on StartLevel so we need to set an enemy later
	if ( Enemy == None )
	{
		SetEnemy( FindPlayer() );
	}

	super.Tick( deltaTime );

	if( TouchingActor != none )
		AcidicSkin( deltaTime );
//	bMovable = false;
}

function PlayWait()
{
	LoopAnim( 'Idle', IdleSpeed );
}

function PlayNearAttack()
{
	PlayAnim( 'Attack', AttackSpeed );
}

function Ignited()
{
}

state AIWait
{
	function BeginState()
	{
		super.BeginState();
	
		PlayWait();
		GotoState( 'AIAttackPlayer' );
	}
}

state MultiBrainShot expands AIScriptedState
{
	function BeginState()
	{
		DebugBeginState();
	}

	function EndState()
	{
		DebugEndState();
	}

Resume:
Damaged:
Dodged:
Begin:
	PlayMultiBrainShot();
	FinishAnim();
	GotoState('AIAttackPlayer');
}

state MultiMouthShot expands AIScriptedState
{
	function BeginState()
	{
		DebugBeginState();
	}

	function EndState()
	{
		DebugEndState();
	}

Resume:
Damaged:
Dodged:
Begin:
	PlayMultiMouthShot();
	FinishAnim();
	LoopMultiMouthShotCycle();
}

state MultiMouthShotRecover expands AIScriptedState
{
	function BeginState()
	{
		DebugBeginState();
	}

	function EndState()
	{
		DebugEndState();
	}

Resume:
Damaged:
Dodged:
Begin:
	if( PlayMultiMouthShotRecover() )
		FinishAnim();
	GotoState('AIAttackPlayer');
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
		// end of animation triggers next stage of AI state
//		DebugInfoMessage( ".AINearAttack.AnimEnd()" );
		GotoState( , 'ATTACKED' );
	}

	function Timer()	// BUGBUG: this function is here just until animation notifys are again working
	{
//		DebugInfoMessage( ".AINearAttack.Timer()" );
		GotoState( , 'ATTACKED' );
	}

	function Bump( actor Other )
	{
		bPendingBump = true;
		BumpedPawn = pawn(Other);
	}

	// *** new (state only) functions ***
	function PostAttack()
	{
		GotoState( 'AIAttackPlayer' );
	}

// Entry point when returning from AITakeDamage
DAMAGED:
Dodged:

// Entry point when resuming this state
RESUME:
	GotoState( 'AIAttackPlayer' );

// Default entry point
BEGIN:

	bDidMeleeDamage = false;
	PlayNearAttack();
	SetTimer( 3.0, false );		// BUGBUG: using timer to bail out when no animation present

INATTACK:
	Sleep( 0.1 );
	goto 'INATTACK';

ATTACKED:
	StopTimer();
	if ( bPendingBump )
		CreatureBump( BumpedPawn );
	PostAttack();
} // state AINearAttack


function bool EnemyInRange()
{
	local Place RootJoint;
	local vector Delta;
	local vector X, Y, Z;
	local float SineYaw, CosineYaw;

	RootJoint = JointPlace( RootJointName );
	Delta = Enemy.Location - RootJoint.pos;

	if( VSize( Delta ) < MeleeRange )
	{
		Delta = Normal( Delta );
		getAxes( ConvertQuat(RootJoint.rot), X, Y, Z );
		if( ((Delta dot Z) < MaxSinePitch) && ((Delta dot Z) > MinSinePitch) )
		{
			SineYaw = Delta dot Y;
			CosineYaw = Delta dot X;

			if( (SineYaw > CosineYaw * MinTanYaw) && (SineYaw < CosineYaw * MaxTanYaw) )
				return true;
//			else
//				DebugInfoMessage( ".EnemyInRange() enemy too far left or right." );
		}
//		else
//			DebugInfoMessage( ".EnemyInRange() enemy too high or too low." );
	}
//	else
//		DebugInfoMessage( ".EnemyInRange() dist = " $ VSize( Delta ) $ ", MeleeRange = " $ MeleeRange $ ", enemy too far away." );

	return false;
}

state AIAttackPlayer
{
	// *** new (state only) functions ***
	// dispatch to next appropriate (attack) state
	function Dispatch()
	{
		if( EnemyInRange() )
			GotoState( 'AINearAttack' );
	}

// Entry point when returning from AITakeDamage
DAMAGED:
Dodged:

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	if ( ( Enemy != none ) && ( Enemy.Health > 0 ) )
	{
		Dispatch();
	}

Attacked:
	PlayWait();	
	Sleep( 0.25 );
	goto 'RESUME';
}

defaultproperties
{
     MaxSinePitch=0.5
     MinSinePitch=-0.25
     MaxTanYaw=1
     MinTanYaw=-1
     RootJointName=root
     IdleSpeed=1
     AttackSpeed=1
     AcidicSkinDamage=2.5
     bIsBoss=True
     DamageRadius=100
     bHackable=False
     bStasis=False
     TransientSoundRadius=5000
     CollisionRadius=1000
     CollisionHeight=1000
     bCollideSkeleton=True
     bCollideWorld=False
     bBlockActors=False
     Mass=1e+009
     MenuName="Undying King"
     CreatureDeathVerb="doomsdayed"
}
