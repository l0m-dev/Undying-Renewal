//=============================================================================
// TrsantiChucker.
//=============================================================================
class TrsantiChucker expands Trsanti;

//****************************************************************************
// Member vars.
//****************************************************************************
var() float					DynRecharge;		//
var float					DynDelay;			//
var Projectile				InvokeCigar;		//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayFarAttack()
{
	PlayAnim( 'attack_throw' );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function bool DoFarAttack()
{
	if ( DynDelay <= 0.0 )
		return super.DoFarAttack();
	else
		return false;
}

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );
	DynDelay = FMax(DynDelay - DeltaTime, 0.0);
}

function bool CanBeInvoked()
{
//	DebugInfoMessage( ".CanBeInvoked(), class.name is " $ class.name $ ", Health is " $ Health $ ", bSpecialInvoke is " $ bSpecialInvoke );
	if ( Health > 0 )
		return bSpecialInvoke;
	else
		return super.CanBeInvoked();
}

function Invoke( actor Other )
{
//	DebugInfoMessage( ".Invoke(), Health is " $ Health );
	if ( Health > 0 )
	{
		bIsInvoked = true;
		Instigator = Pawn(Other); // will set instigator for SPDynamiteProj and prevent SpecialKill cutscene
		GotoState( 'AIInvokeDeath' );
	}
	else
		super.Invoke( Other );
}


//****************************************************************************
// New class functions.
//****************************************************************************
function SendWarning( actor projActor, float Radius, float Duration, float Distance )
{
	local ScriptedPawn		sPawn;

	foreach RadiusActors( class'ScriptedPawn', sPawn, Radius )
	{
		sPawn.WarnAvoidActor( projActor, Duration, Distance, 0.50 );
	}
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AIFarAttackAnim
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIFarAttackAnim
{
	// *** ignored functions ***

	// *** overridden functions ***

	// *** new (state only) functions ***
	function AttackThrow()
	{
		local vector		X, Y, Z;
		local vector		PLoc;
		local Projectile	Proj;
		local vector		TargetDirection;

		GetAxes( Rotation, X, Y, Z );
		PLoc = JointPlace('l_wrist').pos + ( X * 30.0 );
		TargetDirection = vector(WeaponAimAt( Enemy, PLoc, WeaponAccuracy, true, 1000.0 ));

		Proj = Spawn( class'SPDynamiteProj', self,, PLoc, rotator(TargetDirection) );
		if ( Proj != none )
		{
			DynDelay = DynRecharge;
			SendWarning( Proj, 2000.0, 2.0, 512.0 );

			Proj.GotoState('Throw');
		}
	}

} // state AIFarAttackAnim


//****************************************************************************
// AISwitchToMelee
// Switch to melee weapon, return via state stack.
//****************************************************************************
state AISwitchToMelee
{
	// *** ignored functions ***

	// *** overridden functions ***
	function bool PlayHolsterWeapon()
	{
		return false;
	}

	function bool PlaySwitchToMelee()
	{
		return PlayAnim( 'draw_back', 1.50, MOVE_None );
	}

	// *** new (state only) functions ***
	function DrawWeaponBack()
	{
		MyProp[0].SetBase( self, 'swordhand', 'swordcontact' );
		PlaySound_P( "SwordWhsh PVar=0.2 V=0.8 VVar=0.2" );
	}

} // state AISwitchToMelee


//****************************************************************************
// AISwitchToRanged
// Switch to ranged weapon, return via state stack.
//****************************************************************************
state AISwitchToRanged
{
	// *** ignored functions ***

	// *** overridden functions ***
	function bool PlayHolsterMelee()
	{
		PlaySound_P( "SwordWhsh PVar=0.2 V=0.8 VVar=0.2" );
		return PlayAnim( 'draw_back', 1.50, MOVE_None );
	}

	function bool PlaySwitchToRanged()
	{
		return false;
	}

	// *** new (state only) functions ***
	function DrawWeaponBack()
	{
//		DebugInfoMessage( " sword to back" );
		MyProp[0].SetBase( self, 'sword_back', 'swordcontact' );
	}

} // state AISwitchToRanged


//****************************************************************************
// AIInvokeDeath
// 
//****************************************************************************
state AIInvokeDeath
{
	// *** ignored functions ***
	function PlayDying( name damage, vector HitLocation, DamageInfo DInfo ){}

	// *** overridden functions ***
	function bool CanBeInvoked()
	{
		return false;
	}

	function BleedOut()
	{
	}

	function bool TriggerSwitchToRanged()
	{
		return ( !bHasFarAttack && bCanSwitchToRanged );
	}

	// *** new (state only) functions ***
	function SpawnCigar()
	{
		local vector		DVect;
		local Projectile	Proj;

		DVect = JointPlace('swordhand').pos;
		InvokeCigar = Spawn( class'SPDynamiteProj', self,, DVect, Rotation );
		if ( InvokeCigar != none )
		{
			InvokeCigar.SetBase( self, 'swordhand', 'root' );
			SendWarning( Proj, 2000.0, 2.0, 512.0 );

			InvokeCigar.GotoState('Throw');
		}
	}

	function PopACap()
	{
		if ( InvokeCigar != none )
			InvokeCigar.GotoState('Blow');
		SpawnGibbedCarcass( vect(0,0,1) );
		Destroy();
	}


BEGIN:
	bSpecialInvoke = false;
	Health = 5.0;
	GibDamageThresh = 0.0;
	StopMovement();
	if ( TriggerSwitchToRanged() )
	{
		PushState( GetStateName(), 'BEGIN' );
		GotoState( 'AISwitchToRanged' );
	}
	PlaySoundInvoked();
	SpawnCigar();
	PlayAnim( 'invoke_death' );
	FinishAnim();

} // state AIInvokeDeath


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     DynRecharge=2.5
     WeaponClass=None
     MeleeSwitchDistance=300
     RangedSwitchDistance=600
     bTakeHeadShot=True
}
