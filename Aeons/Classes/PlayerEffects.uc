//=============================================================================
// PlayerEffects.
//=============================================================================
class PlayerEffects expands Effects;

// The "Player Effects" classes automaticly attach themselves to their owner
// and perform audio visual effects that require a bit more logic than
// piggy-backing another effect or actor.

function PreBeginPlay()
{
	if ( (Owner != None) && (Owner.IsA('Pawn')) )
	{
		// log("PlayerEffects:PreBeginPlay:SetBase");
		if (Physics != PHYS_Trailer)
			SetBase(Pawn(Owner));
	} else {
		// log("PlayerEffects:PreBeginPlay:Destroy");
		Destroy();
	}
	
	super.PreBeginPlay();

}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
}
