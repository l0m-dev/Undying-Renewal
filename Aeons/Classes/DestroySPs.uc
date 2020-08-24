//=============================================================================
// DestroySPs.
//=============================================================================
class DestroySPs expands Info;

var() bool bSameZone;

function Trigger (Actor Other, Pawn Instigator)
{
	local ScriptedPawn SP;
	
	if (bSameZone)
	{
		ForEach AllActors(class 'ScriptedPawn',SP)
		{
			// only scripted pawns within my zone!
			if (SP.Region.ZoneNumber == self.Region.ZoneNumber)
				SP.Destroy();
		}
	} else {
		ForEach AllActors(class 'ScriptedPawn',SP)
		{
			SP.Destroy();
		}
	}
}

defaultproperties
{
     bSameZone=True
}
