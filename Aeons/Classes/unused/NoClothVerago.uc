//=============================================================================
// NoClothVerago.
//=============================================================================
class NoClothVerago expands Verago;

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	ClearAnims();
	//ApplyMod( JointName(0), class'ClothCollapse' );
	KillPFX();
	AmbientSound = none;
	OpacityEffector.SetFade( 0, 0.2 );
}

 state Dying
{
	// *** ignored functions ***
	function CommMessage( actor sender, string message, int param ){}

	// *** overridden functions ***
	function BeginState()
	{
		//super.BeginState();
		DropProjectiles();
		BroadcastQuit();
		//Spawn(class 'SigilExplosion',,,JointPlace('Head').pos);
	}
	
	function StartTimer()
	{
		FadeOutTime = -1;
		FadeOutCount = -1;
		Super.StartTimer();
	}

	function bool CanBeInvoked()
	{
		return false;
	}

	// *** new (state only) functions ***
	function DropProjectiles()
	{
		local int		lp;

		for ( lp = 0; lp < ArrayCount(Projs); lp++ )
			if ( Projs[lp] != none )
			{
//				Projs[lp].GotoState( 'FallingState' );
//				Projs[lp].Velocity = vect(0,0,0);
//				Projs[lp].SetPhysics( PHYS_Falling );
				Projs[lp].Destroy();
				Projs[lp] = none;
			}
	}

}

defaultproperties
{
}
