//=============================================================================
// LightingMutator.
//=============================================================================
class LightingMutator expands Mutators;

var() bool bTriggered;
var() bool bResetToDefaults;

function PreBeginPlay()
{
	super.PreBeginPlay();
	if ( (Owner == none) && !bTriggered )
	{
		Destroy();
	} else if (Owner != none) {
		// If I have an owner, I am being spawned in game, so just apply the lighting changes
		MutateRenderParams(Owner);
	}
}

function MutateRenderParams(Actor A)
{
	if (!bResetToDefaults)
	{
		A.Lighting[0] = Lighting[0];
		A.Lighting[1] = Lighting[1];
	} else {
		A.Lighting[0] = A.default.Lighting[0];
		A.Lighting[1] = A.default.Lighting[1];
	}
	Destroy();
}

function Trigger(Actor Other, Pawn Instigator)
{
	local Actor A;
	
	if ( Event != 'none' )
	{
		ForEach AllActors(class 'actor', A, Event)
		{
			MutateRenderParams(A);
		}
	}
}

defaultproperties
{
}
