//=============================================================================
// SPSpearProjectile.
//=============================================================================
class SPSpearProjectile expands Spear_proj;


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
}
