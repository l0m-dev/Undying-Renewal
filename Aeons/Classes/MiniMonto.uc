//=============================================================================
// MiniMonto.
//=============================================================================
class MiniMonto expands Monto;


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AINearAttack
// attack near enemy (melee)
//****************************************************************************
state AINearAttack
{
	// *** ignored functions ***

	// *** overridden functions ***
	function bool MoveInAttack()
	{
		return !CloseToPoint( Enemy.Location + vect(0,0,0.7) * Enemy.CollisionHeight, 2.0 );
	}

	// *** new (state only) functions ***

} // state AINearAttack


//****************************************************************************
// AIFarAttackAnim
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIFarAttackAnim
{
	// *** ignored functions ***

	// *** overridden functions ***

	// *** new (state only) functions ***

BEGIN:
	StopTimer();
	GotoState( 'AIEnergyBlast' );
} // state AIFarAttackAnim


//****************************************************************************
// AIEnergyBlast
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIEnergyBlast
{
	// *** ignored functions ***

	// *** overridden functions ***
	function FireFrom( vector StartLoc )
	{
		local vector			X, Y, Z;
		local vector			TDir;
		local LtngBlast_proj	LB;

		GetAxes( Rotation, X, Y, Z );
		StartLoc = StartLoc + X * 50.0;
		TDir = vector(WeaponAimAt( Enemy, StartLoc, WeaponAccuracy, false, 3000 ));
		LB = Spawn( class'LtngBlast_proj', self,, StartLoc, rotator(TDir) );
		if ( LB != none )
		{
			LB.CastingLevel = 0;
			LB.StartLoc = StartLoc;
			LB.Charge = 0;
		}
	}

	function FireLightning()
	{
		if ( bLightning )
		{
			FireFrom( JointPlace('l_lowerarm').pos );
			FireFrom( JointPlace('r_lowerarm').pos );
			AmbientSound = none;
			PlaySound_P( "LightFire" );
		}
	}

	// *** new (state only) functions ***

} // state AIEnergyBlast


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	// *** overridden functions ***
	function PostAnim()
	{
	}

} // state Dying


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     bHasFarAttack=False
     MeleeInfo(0)=(Damage=10,EffectStrength=0.2)
     MeleeInfo(1)=(Damage=20,EffectStrength=0.1)
     DamageRadius=35
     bHasSpecialKill=False
     MeleeRange=30
     AirSpeed=500
     MaxStepHeight=15
     BaseEyeHeight=18
     Health=100
     SoundSet=Class'Aeons.MiniMontoSoundSet'
     DrawScale=0.25
     SoundRadius=32
     TransientSoundRadius=750
     CollisionRadius=30
     CollisionHeight=30
}
