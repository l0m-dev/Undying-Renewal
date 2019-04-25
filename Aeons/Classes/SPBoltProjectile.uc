//=============================================================================
// SPBoltProjectile.
//=============================================================================
class SPBoltProjectile expands Crossbow_Bolt;


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
	 Speed=12000
     MaxSpeed=12000
	 CollisionRadius=60
     CollisionHeight=42
}
