//=============================================================================
// PhysicsChanger.
//=============================================================================
class PhysicsChanger expands Info;

function Trigger(Actor Other, Pawn Instigator)
{
	local Actor A;
	
	ForEach AllActors(class 'Actor', A, Event)
	{
		if ((A.Owner == none) || (A.Owner == Level))
			A.SetPhysics(PHYS_Falling);
	}

}

defaultproperties
{
     bCollideWorld=True
}
