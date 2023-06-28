//=============================================================================
// SPBoltProjectile.
//=============================================================================
class SPBoltProjectile expands Crossbow_Bolt;

function PreBeginPlay()
{
	super.PreBeginPlay();
	if (RGC())
	{
		Speed = 12000;
		MaxSpeed = 12000;
		SetCollisionSize(60, 42);
	}
}

function DamageInfo getDamageInfo( optional name DamageType )
{
	local DamageInfo	DInfo;

	DInfo = super.getDamageInfo( DamageType );
	if ( ScriptedPawn(Owner) != none )
		DInfo.DamageMultiplier = DInfo.DamageMultiplier * ScriptedPawn(Owner).OutDamageScalar;

	return DInfo;
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     LifeSpan=10
}
