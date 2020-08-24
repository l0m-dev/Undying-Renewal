//=============================================================================
// FlyingCreatureGenerator.
//=============================================================================
class FlyingCreatureGenerator expands CreatureGenerator;


//****************************************************************************
// Member vars.
//****************************************************************************
var() float					HoverAltitude;		//
var() float					HoverVariance;		//
var() float					HoverRadius;		//


//****************************************************************************
// Inherited member funcs.
//****************************************************************************
function ScriptedPawn SpawnCreature( class<ScriptedPawn> classID, GenCreatureInfo CInfo )
{
	local ScriptedPawn		lPawn;
	local ScriptedFlyer		lFlyer;

	lPawn = super.SpawnCreature( classID, CInfo );
	lFlyer = ScriptedFlyer(lPawn);
	if ( lFlyer != none )
	{
		if ( HoverAltitude > 0.0 )
			lFlyer.HoverAltitude = HoverAltitude;
		if ( HoverVariance > 0.0 )
			lFlyer.HoverVariance = HoverVariance;
		if ( HoverRadius > 0.0 )
			lFlyer.HoverRadius = HoverRadius;
	}
	return lPawn;
}


//****************************************************************************
// New member funcs.
//****************************************************************************


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     bGroundPlacement=False
}
