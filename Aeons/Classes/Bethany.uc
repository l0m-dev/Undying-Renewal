//=============================================================================
// Bethany.
//=============================================================================
class Bethany expands ScriptedFlyer;
//#exec MESH IMPORT MESH=Bethany_m SKELFILE=Bethany.ngf INHERIT=Verago_m
//#exec MESH MODIFIERS Sac1:Jello

//#exec MESH NOTIFY SEQ=telekinesis TIME=0.90 FUNCTION=CastWard
//#exec MESH NOTIFY SEQ=spell_circle TIME=0.90 FUNCTION=SummonCreature
//#exec MESH NOTIFY SEQ=spell_draw TIME=0.90 FUNCTION=SummonCreature2
//#exec MESH NOTIFY SEQ=forceblast TIME=0.200 FUNCTION=PushBack		

//#exec MESH NOTIFY SEQ=death_behead TIME=0.5 FUNCTION=LoseMyHead
//#exec MESH NOTIFY SEQ=death_behead TIME=0.970 FUNCTION=LoopFallingDeath

//#exec MESH NOTIFY SEQ=Blooddip TIME=0.086 FUNCTION=PlaySound_N ARG="BloodDip PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_Land TIME=0.140 FUNCTION=PlaySound_N ARG="Whoosh"
//#exec MESH NOTIFY SEQ=Death_Land TIME=0.183 FUNCTION=C_FS
//#exec MESH NOTIFY SEQ=Death_Land TIME=0.394 FUNCTION=PlaySound_N ARG="Whoosh"
//#exec MESH NOTIFY SEQ=Death_Land TIME=0.436 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=Death_Land TIME=0.535 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=Forceblast TIME=0.033 FUNCTION=PlaySound_N ARG="BlastA PVar=0.20 VVar=0.1"
//#exec MESH NOTIFY SEQ=Forceblast TIME=0.350 FUNCTION=PlaySound_N ARG="BlastB PVar=0.20 V=1.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Recharge_Cycle TIME=0.000 FUNCTION=PlaySound_N ARG="RechargeLp PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Specialkill_Headtwist TIME=0.084 FUNCTION=PlaySound_N ARG="SpecialKill V=1.5"
//#exec MESH NOTIFY SEQ=Spell_Circle TIME=0.000 FUNCTION=PlaySound_N ARG="SpellA PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Spell_Draw TIME=0.000 FUNCTION=PlaySound_N ARG="SpellA PVar=0.25 VVar=0.1"


enum ESummonedCreature
{
	E_Monto,
//	E_Mists,
	E_Stalker
};

var() float					DodgeDistance;		// TEMP for tweaking
var(AICombat) float			ManaMaximum;
var(AICombat) float			ManaRechargeRate;
var(AICombat) float			RechargingRate;
var(AICombat) float			ManaWeakenedThreshold;
var(AICombat) float			WeakenedTime;
var(AICombat) float			RechargeTime;
var float					Mana;
var float					LastDeltaTime;
var(AICombat) float			MontoManaCost;
var(AICombat) float			StalkerManaCost;
var(AICombat) float			WardManaCost;
var FlickeringStalker		Stalkers[2];
var Monto					Montos;
var ESummonedCreature		SummonedCreature;
var(AICombat) float			MomentumTransfer;	// Coefficient used for "push back" attack.
var AeonsHomeBase 			Home;
var(AICombat) float			HomeDistance;
var(AICombat) float			HomeAltitude;
var SPDrawScaleEffector		DrawScaleEffector;
var int						HandmaidensKilled;

function PostBeginPlay()
{
	local float BestDist;
	local AeonsHomeBase aHome;

	super.PostBeginPlay();

	Mana = ManaMaximum;

	DrawScaleEffector = SPDrawScaleEffector(SpawnEffector( class'SPDrawScaleEffector' ));

	SetDrawScale( 1.0 + Mana / ManaMaximum );

	BestDist = 0.0;
	Home = none;
	foreach AllActors( class'AeonsHomeBase', aHome )
	{
		if( (Home == none) || (VSize(aHome.Location - Location) < BestDist) )
		{
			BestDist = VSize(aHome.Location - Location);
			Home = aHome;
		}
	}
}

function Killed( pawn Killer, pawn Other, name damageType )
{
	if( Other.IsA( 'Handmaiden' ) )
	{
		LogStack();
		DebugInfoMessage(".Killed() A Handmaiden has been killed.");
		HandmaidensKilled++;
	}

	super.Killed( Killer, Other, damageType );
}

function ReactToDamage( pawn Instigator, DamageInfo DInfo )
{
	if( Instigator.IsA( 'Bethany' ) ||
		Instigator.IsA( 'Handmaiden' ) ||
		Instigator.IsA( 'BethanyFlickeringStalker' ) ||
		Instigator.IsA( 'BethanyMonto' ) )
		return;
	else
		super.ReactToDamage( Instigator, DInfo );	
}

function TookDamage( actor Other )
{
	if( Other.IsA( 'Bethany' ) ||
		Other.IsA( 'Handmaiden' ) ||
		Other.IsA( 'BethanyFlickeringStalker' ) ||
		Other.IsA( 'BethanyMonto' ) )
		return;
	else
		super.TookDamage( Other );
}

function PlayTaunt()
{
	PlayAnim( 'lotuspose' );
}

function PushBack()
{
	local vector x, y, z, momentum, dir;
	
	DebugInfoMessage( ".PushBack() called." );
	GetAxes(ViewRotation, x, y, z);
	
	// spawn(class 'GhelziabahrRing',self,,Location,rot(0,0,0));
	spawn(class 'GhelzRingFX',self,,Location + 100*x,rot(0,0,0));
		
	spawn(class 'PulseWind',,,Location + 100*x);

	if( Enemy != none )
	{
		dir = Enemy.Location - Location;
		if( VSize( dir ) < 2.0 * MeleeRange )
		{
			dir.Z = 0.0;
			dir = Normal(dir);
			if( (dir dot x) > 0.0 )
			{
				Enemy.SetPhysics( PHYS_Falling );
				dir.Z = 0.25;
				momentum = dir * MomentumTransfer;
				DebugInfoMessage( ".PushBack() on " $ Enemy.Name $ " momentum = " $ momentum $ "." );
				Enemy.Velocity = momentum;
			}
			else
				DebugInfoMessage( ".PushBack() not facing." );
		}
		else
			DebugInfoMessage( ".PushBack() too far away." );
	}
}
	
//****************************************************************************
// Inherited functions.
//****************************************************************************
// see whether creature wants a far attack
function bool CanSummonStalker()
{
	return 	( (HandMaidensKilled == 0) && (Stalkers[0] == none) ) ||
			( (HandMaidensKilled == 1) && ((Stalkers[0] == none) || (Stalkers[1] == none)) );
}

function bool CanSummonMonto()
{
	return (HandmaidensKilled >= 2) && (Montos==none) && (Stalkers[0] == none) && (Stalkers[1] == none);
}

function bool CanCastWard()
{
	local float		Dist;

	Dist = DistanceTo( Enemy );

	return (Dist <= LongRangeDistance) && (FRand() < 0.40);
}

function bool DoFarAttack()
{
	return CanSummonStalker() || CanSummonMonto() || CanCastWard();
}

function SummonMonto()
{
	local Monto creature;
	local vector X, Y, Z;

	DebugInfoMessage(".SummonMonto() called.");

	getAxes( Rotation, X, Y, Z );
	creature = Spawn( class 'BethanyMonto',self,, Location + X * 700.0, Rotation );

	if( creature == none )
	{
		creature = Spawn( class 'BethanyMonto',self,, Location + X * 700.0 + Z * 700.0, Rotation );
	}

	if( creature != none )
	{
		Mana -= MontoManaCost;
		DrawScaleEffector.SetFade( 1.0 + Mana / ManaMaximum, 1.0 );

		creature.GotoState( 'AIAttackPlayer' );
		Montos = creature;
	}
}

function SummonStalker()
{
	local FlickeringStalker creature;
	local vector summonSpot;
	
	if( (Stalkers[0] == none) || ((HandmaidensKilled > 0) && (Stalkers[1] == none)) )
	{
		Mana -= StalkerManaCost;

		DrawScaleEffector.SetFade( 1.0 + Mana / ManaMaximum, 1.0 );

		summonSpot = Location + Vector(Rotation)*300.0;

		creature = Spawn( class'BethanyFlickeringStalker',self,, summonSpot, Rotation );

		creature.GotoState( 'AIAttackPlayer' );

		if( (Stalkers[0] != none) && (HandmaidensKilled > 0) )
			Stalkers[1] = creature;
		else
			Stalkers[0] = creature;
	}
}

function CastWard()
{
	local rotator RAim;
	local vector start, end, norm, hit;
	local int joint, flags;
	local BethanySigil_proj s;

	DebugInfoMessage(".CastWard().");

	Mana -= WardManaCost;

	DrawScaleEffector.SetFade( 1.0 + Mana / ManaMaximum, 1.0 );

	norm = Normal( Enemy.Location - Location );
	start = Location + norm*64.0;
	RAim = WeaponAimAt(Enemy, start, WeaponAccuracy, true, class'CreepingRot_proj'.default.MaxSpeed );
	s = spawn(class 'BethanySigil_proj',self,,start, RAim);
}

function SummonCreature()
{
	if( SummonedCreature == E_Monto )
	{
		PlayAnim( 'spell_draw' );
	}		
	else
	{
		SummonStalker();
	}
}

function SummonCreature2()
{
	SummonMonto();
}

function PlayFarAttack()
{
}

function GotoInitState()
{
	DebugInfoMessage( ".GotoInitState()" );
	LogStack();
	GotoState( 'AIHuntPlayer' );
}

function Tick( float deltaTime )
{
	super.Tick( deltaTime );

	LastDeltaTime = deltaTime;

	if( (Stalkers[0] != none) && (Stalkers[0].Health <= 0.0) )
		Stalkers[0] = none;
	if( (Stalkers[1] != none) && (Stalkers[1].Health <= 0.0) )
		Stalkers[1] = none;

	if( (Montos != none) && (Montos.Health <= 0.0) )
		Montos = none;

	Mana += ManaRechargeRate*deltaTime;

	if( Mana > ManaMaximum )
		Mana = ManaMaximum;

	DrawScaleEffector.SetFade( 1.0 + Mana / ManaMaximum, 1.0 );

	if( (Home != none) && 
		(Health > 0) &&
		(VSize( Home.Location - Location ) > HomeDistance ) && 
		(StateIndex == 0) &&
		(GetStateName() != 'AIRetreat') &&
		(GetStateName() != 'AIFarAttackAnim') &&
		(FRand() < deltaTime) )
	{
		RetreatPoint = Home;
		PushState( 'AIRetreat', 'BEGIN' );
		GotoState( 'AIQuickTaunt' );
	}
}

function TakeMindshatter( pawn Instigator, int castingLevel )
{
}

function bool AcceptDamage( DamageInfo DInfo )
{
	DebugInfoMessage( ".AcceptDamage() type is " $ DInfo.DamageType );
	if( (DInfo.DamageType == 'recharge') || (DInfo.DamageType == 'scythe') || (DInfo.DamageType == 'scythedouble') )
		return true;
	else return false;
}

function bool AcknowledgeDamageFrom( pawn Instigator )
{
	DebugInfoMessage( ".AcknowledgeDamageFrom() Instigator is a " $ Instigator.class.name );
	if( Instigator.IsA( 'Bethany' ) ||
		Instigator.IsA( 'Handmaiden' ) ||
		Instigator.IsA( 'BethanyFlickeringStalker' ) ||
		Instigator.IsA( 'BethanyMonto' ) )
	{
		DebugInfoMessage(".AcknowledgeDamageFrom() Ignoring damage.");
		return false;
	}
	else
		super.AcknowledgeDamageFrom( Instigator );
}

function AdjustDamage( out DamageInfo DInfo )
{
	super.AdjustDamage( DInfo );
	switch( DInfo.Damagetype )
	{
		case 'recharge':
			Mana += LastDeltaTime * RechargingRate;
			if( Mana > ManaMaximum )
				Mana = ManaMaximum;
		 	DrawScaleEffector.SetFade( 1.0 + Mana / ManaMaximum, 1.0 );
			DInfo.Damage = 0.0;
			break;
		default:
			DInfo.Damage = 0.0;
			break;
	}
}

function CommMessage( actor sender, string message, int param )
{
	if( message == "recharging" )
	{
		Mana += LastDeltaTime * RechargingRate;
		if( Mana > ManaMaximum )
			Mana = ManaMaximum;
	 	DrawScaleEffector.SetFade( 1.0 + Mana / ManaMaximum, 1.0 );
		GotoState( 'AIRecharging' );
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

state AIRecharging expands AIWait
{
	function BeginState()
	{
		local SoundContainer.CreatureSoundGroup		SGroup;

		super.BeginState();

		SGroup = class'BethanySoundSet'.default.RechargeLp;
		AmbientSound = SGroup.Sound0;
	}

	function EndState()
	{
		super.EndState();

		SendClassComm( class'Handmaiden', "recharged", 0 );
		AmbientSound = none;
	}

	function Tick( float deltaTime )
	{
		Mana += RechargingRate*deltaTime;

		if( Mana > ManaMaximum )
			Mana = ManaMaximum;

		DrawScaleEffector.SetFade( 1.0 + Mana / ManaMaximum, 1.0 );

		super.Tick( deltaTime );
	}

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
	function LongFall(){}
	function PainTimer(){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function Ignited(){}
	function DelayedOrder( name OState, name OTag ){}
	function LookTargetNotify( actor Sender, float Duration ){}

	function Timer()
	{
		DebugInfoMessage(".Recharged");
		GotoState( 'AIAttack' );
	}

Begin:
	SetTimer( RechargeTime, false );

	PlayAnim( 'recharge_start' );
	FinishAnim();
	LoopAnim( 'recharge_cycle' );
}

state AIWeakened expands AIWait
{
	function BeginState()
	{
		super.BeginState();
		
		Mana = ManaWeakenedThreshold;
		SendClassComm( class'Handmaiden', "weakened", 0 );
	}

	function EndState()
	{
		super.EndState();
	}

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
	function LongFall(){}
	function PainTimer(){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function Ignited(){}
	function DelayedOrder( name OState, name OTag ){}
	function LookTargetNotify( actor Sender, float Duration ){}

	function SnuffMyMinions()
	{
		if( Montos != none )
		{
			Montos.Destroy();
			Montos = none;
		}

		if( Stalkers[0] != none )
		{
			Stalkers[0].Destroy();
			Stalkers[0] = none;
		}

		if( Stalkers[1] != none )
		{
			Stalkers[1].Destroy();
			Stalkers[1] = none;
		}
	}

	function AdjustDamage( out DamageInfo DInfo )
	{
		global.AdjustDamage( DInfo );
		switch( DInfo.Damagetype )
		{
			case 'scythe':
			case 'scythedouble':
				DInfo.Damage = 2.0 * Health; // make sure she dies.
				DInfo.JointName = 'head';
				SnuffMyMinions();
				break;
			case 'recharge':
				Mana += LastDeltaTime * RechargingRate;
				if( Mana > ManaMaximum )
					Mana = ManaMaximum;
			 	DrawScaleEffector.SetFade( 1.0 + Mana / ManaMaximum, 1.0 );
				DInfo.Damage = 0.0;
				GotoState( 'AIRecharging' );
				break;
		}
	}

	function Timer()
	{
		DebugInfoMessage(".Weakened timeout.");
		SendClassComm( class'Handmaiden', "recharged", 0 );
		GotoState( 'AIAttack' );
	}

Begin:
	SetTimer( WeakenedTime, false );

GOTOACT:
	LoopAnim( 'weakened', 1.0 );

MOVEMENT:
	if ( (Home != none ) && (actorReachable( Home ) || FlightTo( Home.Location, true )) )
	{
		DebugInfoMessage( ".AIWeakened, actorReachable" );
		if ( UseSpecialDirect( Home.Location ) )
		{
			PushState( GetStateName(), 'GOTOACT' );
			TargetPoint = Home.Location;
			GotoState( 'AISpecialDirect' );
		}
		DebugInfoMessage( ".AIWeakened, going to MoveToward( Home )" );
		SetMarker( Home.Location );
		MoveToward( Home, WalkSpeedScale, 3.0 );
		goto 'GOTOACT';
	}
	else if( Home != none )
	{
		DebugInfoMessage( ".AIWeakened, trying to path" );
		PathObject = PathToward( Home );

		if ( PathObject != none )
		{
			// can path to Enemy
			DebugInfoMessage( ".AIWeakened, trying to path using " $ PathObject.name $ ", CanPathTo() is " $ CanPathTo( Home ) );
			if ( UseSpecialNavigation( NavigationPoint(PathObject) ) )
			{
				PushState( GetStateName(), 'GOTOACT' );
				SpecialNavPoint = NavigationPoint(PathObject);
				GotoState( 'AISpecialNavigation' );
			}
			else
			{
				MoveToward( PathObject, WalkSpeedScale );
				goto 'GOTOACT';
			}
		}
		else
		{
			DebugInfoMessage( ".AIWeakened, couldn't path" );
		}
	}
}

state AIPushBackEnemy
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Bump( actor Other ){}

Begin:
	TurnToward( Enemy );
	PlayAnim( 'forceblast', 1.0 );
	FinishAnim();

Resume:
Damaged:
Dodged:
	GotoState('AIAttack');
}

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
	function Timer()
	{
		DebugInfoMessage(".AIFarAttackAnim.Timer() fired.");
		GotoState( , 'Resume' );
	}

	function PlayWait()
	{
		LogStack();
	}
	// *** new (state only) functions ***

	function PlayAnimFailed( string AnimName )
	{
		DebugInfoMessage(".AIFarAttackAnim PlayAnim ( " $ AnimName $ " ) failed.");
		GotoState('AICharge', 'NOEVAL');
	}

// Default entry point.
BEGIN:
	SetTimer( 25, false );
	StopMovement();
	DebugInfoMessage(".AIFarAttackAnim turning toward enemy.");
	TurnToward( Enemy, 20*DEGREES );
	if( CanSummonMonto() )
	{
		DebugInfoMessage(".AIFarAttackAnim summoning Monto");
		if( PlayAnim( 'spell_draw' ) )
		{
			FinishAnim();
			if( PlayAnim( 'spell_circle' ) )
			{
				FinishAnim();
				SummonMonto();
			}
			else
				PlayAnimFailed( "spell_circle" );
		}
		else
			PlayAnimFailed( "spell_draw" );
	}
	else if( CanSummonStalker() )
	{
		DebugInfoMessage(".AIFarAttackAnim summoning Stalker");
		if(	PlayAnim( 'spell_circle' ) )
		{
			FinishAnim();
			SummonStalker();
		}
		else
			PlayAnimFailed( "spell_circle" );
	}
	else
	{
		DebugInfoMessage(".AIFarAttackAnim casting Ward");
		if( PlayAnim( 'telekinesis' ) )
		{
			FinishAnim();
			CastWard();
		}
		else
			PlayAnimFailed( "telekinesis" );
	}

// Entry point when resuming this state.
RESUME:
Damaged:
Dodged:
	if( Mana < ManaWeakenedThreshold )
		GotoState( 'AIWeakened' );
	else
		GotoState( 'AIAttack' );
} // state AIFarAttackAnim


//****************************************************************************
// AIAvoidEnemy
// Avoid Enemy within SafeDistance, pick a retreat point and seek it
//****************************************************************************
state AIAvoidEnemy
{
	/*** overridden functions ***/

	// Check if point is (still, while pathing) a good avoidance point.
	function bool GoodAvoidPoint( NavigationPoint cPoint )
	{
		if( (Home != none) && ((VSize( cPoint.Location - Home.Location ) > HomeDistance) || 
							   ((cPoint.Location.Z - Home.Location.Z) > HomeAltitude)) )
			return false;
		if ( VSize( cPoint.Location - Enemy.Location ) < (1.2 * SafeDistance) )
			return false;
		if ( cPoint.Location.Z < (Enemy.Location.Z - 4*CollisionHeight) )
			return false;
		return true;
	}

	function GotoInitState()
	{
		GotoState( 'AIFarAttack' );
	}

}

state AICharge
{
	function Evaluate()
	{
		local float Dist;

		Dist = DistanceTo( Enemy );

		if( Dist < LongRangeDistance )
			GotoState( 'AIFarAttack' );
		else
			super.Evaluate();
	}
}

//****************************************************************************
// AIAttack
// primary attack dispatch state
//****************************************************************************
state AIAttack
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Dispatch()
	{
		DebugInfoMessage( ".AIAttack.Dispatch(), DefCon is " $ DefCon $ ", Health=" $ Health);

		if ( DistanceTo( Enemy ) < 1.25 * MeleeRange )
		{
			DebugInfoMessage( ".AIAttack.Dispatch(), Dist is < 1.25*MeleeRange" );
			GotoState( 'AIPushBackEnemy' );
		}
		else if ( DistanceTo( Enemy ) < SafeDistance )
		{
			DebugInfoMessage( ".AIAttack.Dispatch(), Dist is < SafeDistance" );
			GotoState( 'AIAvoidEnemy' );
		}
		else if ( ( ScriptedPawn(Enemy) == none ) &&
			 ( VisionEffector.GetSensorLevel() < 0.25 ) &&
			 ( HearingEffector.GetSensorLevel() < 0.10 ) )
		{
			// Lost enemy.
			DebugInfoMessage( ".AIAttack, lost enemy." );
//			GotoInitState();
			GotoState('AIHuntPlayer');
		}
		else if( DoFarAttack() )
		{
			GotoState('AIFarAttack');
		}
		else
			GotoState('AICharge', 'NOEVAL');
	}

	// *** new (state only) functions ***

} // state AIAttack


//****************************************************************************
// AIDodge
// Umm... dodge.
//****************************************************************************
state AIDodge
{
	// *** ignored functions ***

	// *** overridden functions ***
	function vector SetTargetPoint( float distance )
	{
		local vector	X, Y, Z;
		local vector	gSpot;

		if ( distance < 0.0 )
			distance = -DodgeDistance;
		else
			distance = DodgeDistance;

		GetAxes( Rotation, X, Y, Z );
		gSpot = Location + ( Y * FVariant( distance, distance * 0.10 ) );

		if ( !FastTrace( gSpot, Location ) )
		{
			// hit geometry that direction, try other
			return Location - ( Y * FVariant( distance, distance * 0.10 ) );
		}
		else
			return gSpot;
	}

	// *** new (state only) functions ***

} // state AIDodge

// Play death animation, based on damage type.
function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	DebugInfoMessage( ".PlayDying(), damage name is " $ damage $ ", delta to HitLocation is " $ (HitLocation - Location) );

	PlayAnim( 'death_behead' );
}

function LoseMyHead()
{
	local actor B;
	local vector HitLocation, Velocity;
	local float Dist;
	local PersistentWound Wound;

	HitLocation = JointPlace( 'head' ).pos;

	B = DetachLimb('head', Class 'BodyPart');

	Velocity = vect(0,0,64);
	B.Velocity = Velocity;
	B.DesiredRotation = RotRand(true);
	B.bBounce = true;
	B.SetCollisionSize((B.CollisionRadius * 0.35), (B.CollisionHeight * 0.15));

	ReplicateDetachLimb(self, 'head', B.Velocity, B.DesiredRotation);

	Spawn(class 'InstantScytheWound',self,,HitLocation);
	Wound = Spawn(class 'ScytheWound',self,,HitLocation);
	Wound.AttachJoint = 'head';
	Wound.setup();

	bHacked = true;
	Hacked(FindPlayer());
}

function LoopFallingDeath()
{
	LoopAnim( 'death_fall' );
	SetPhysics( PHYS_Falling );
}

//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	function Landed( vector hitNormal )
	{
		PlayAnim( 'death_land' );
	}

	// *** new (state only) functions ***

} // state Dying

defaultproperties
{
     DodgeDistance=125
     ManaMaximum=100
     ManaRechargeRate=2
     RechargingRate=30
     ManaWeakenedThreshold=25
     WeakenedTime=7
     RechargeTime=3
     MontoManaCost=100
     StalkerManaCost=65
     WardManaCost=5
     MomentumTransfer=1000
     HomeDistance=1300
     HomeAltitude=600
     HoverAltitude=180
     HoverVariance=70
     HoverRadius=10
     bCanHover=True
     WaitGlideScalar=0.3
     bNoDeathSpin=True
     bNoGroundHover=True
     SafeDistance=640
     LongRangeDistance=1500
     bIsBoss=True
     Aggressiveness=1
     bHasNearAttack=False
     bHasFarAttack=True
     RetreatThreshold=0.1
     bNoAdvance=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.3
     PhysicalScalar=0.25
     FireScalar=0.25
     bCanStrafe=True
     AirSpeed=300
     MaxStepHeight=35
     SightRadius=2000
     PeripheralVision=0.25
     BaseEyeHeight=70
     Health=120
     SoundSet=Class'Aeons.BethanySoundSet'
     FootSoundClass=Class'Aeons.HeelFootSoundSet'
     RotationRate=(Pitch=1000,Yaw=60000,Roll=0)
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Bethany_m'
     SoundRadius=50
     CollisionRadius=24
     CollisionHeight=76
     Mass=2000
     MenuName="Bethany"
     CreatureDeathVerb="putrified"
}
