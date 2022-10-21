//=============================================================================
// LowGravity.
// makes all zones low gravity
//=============================================================================

class LowGravity expands Mutator;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if ( Other.IsA('ZoneInfo') )
	{
		ZoneInfo(Other).ZoneGravity = vect(0,0,-200); 
	}

	bSuperRelevant = 0;
	return true;
}