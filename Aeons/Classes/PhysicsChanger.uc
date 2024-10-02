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
		{
			if (Inventory(A) != None)
			{
				Inventory(A).DropFrom(A.Location);
			}
			else
			{
				if (RemoteRole == ROLE_SimulatedProxy)
					RemoteRole = ROLE_DumbProxy;

				A.bSimFall = true;
				A.SetPhysics(PHYS_Falling);
			}
		}
	}

}

defaultproperties
{
     bCollideWorld=True
}
