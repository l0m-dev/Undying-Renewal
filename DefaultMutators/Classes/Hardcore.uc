//=============================================================================
// LowGravity.
// makes all zones low gravity
//=============================================================================

class Hardcore expands Mutator;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if ( Other.IsA('ScriptedPawn') )
	{
		ScriptedPawn(Other).ScryeGlow = None;
		ScriptedPawn(Other).Health = ScriptedPawn(Other).Health * 1.5;
		ScriptedPawn(Other).InitHealth = ScriptedPawn(Other).Health;
		
		ScriptedPawn(Other).OutDamageScalar = 2.0;
		ScriptedPawn(Other).OutEffectScalar = 2.0;
		
		ScriptedPawn(Other).GroundSpeed = ScriptedPawn(Other).GroundSpeed * 1.25; 
	}

	bSuperRelevant = 0;
	return true;
}

/*
// Sent during actor initialization.
function PreBeginPlay()
{
	super.PreBeginPlay();

	if ( Level.Game.Difficulty == 0 )
	{
		Health = Health * 0.40;
		OutDamageScalar = 0.40;
		OutEffectScalar = 0.2;
	}
	else if ( Level.Game.Difficulty == 1 )
	{
		OutDamageScalar = 1.0;
		OutEffectScalar = 0.9;
	}
	else
	{
		Health = Health * 1.25;
		OutDamageScalar = 1.25;
		OutEffectScalar = 1.0;
	}

	// Adjust GroundSpeed +/- 10%
	GroundSpeed = FVariant( GroundSpeed, GroundSpeed * 0.10 );

	InitPeripheralVision = PeripheralVision;
	InitHearingThreshold = HearingThreshold;
	SetAlertness( Alertness );
}
*/