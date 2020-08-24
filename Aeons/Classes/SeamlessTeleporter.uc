//=============================================================================
// SeamlessTeleporter.
//=============================================================================
class SeamlessTeleporter expands Teleporter;

var vector Offset;

// Teleporter was touched by an actor.
simulated function Touch( actor Other )
{
	local SeamlessTeleporter Dest;
	local int i;
	local Actor A;
	
	if ( !bEnabled )
		return;

	if( Other.bCanTeleport && Other.PreTeleport(Self)==false )
	{
		// Teleport to a random teleporter in this local level, if more than one pick random.

		foreach AllActors( class 'SeamlessTeleporter', Dest )
			if( string(Dest.tag)~=URL && Dest!=Self )
				break;

		if( Dest != None )
		{
			Dest.Offset = Other.Location - Location;
			Dest.Accept( Other, self );

			if( (Event != '') && (Other.IsA('Pawn')) )
				foreach AllActors( class 'Actor', A, Event )
					A.Trigger( Other, Other.Instigator );

		} else if ( Role == ROLE_Authority )
			Pawn(Other).ClientMessage( "Teleport destination for "$self$" not found!" );
	}
}


// Accept an actor that has teleported in.
simulated function bool Accept( actor Incoming, Actor Source )
{
	local rotator newRot, oldRot;
	local int oldYaw;
	local float mag;
	local vector oldDir;
	local pawn P;

	// Move the actor here.
	Disable('Touch');

	if ( Pawn(Incoming) != None )
	{
		//tell enemies about teleport
		if ( Role == ROLE_Authority )
		{
			P = Level.PawnList;
			While ( P != None )
			{
				if (P.Enemy == Incoming)
					P.LastSeenPos = Incoming.Location; 
				P = P.nextPawn;
			}
		}
		Pawn(Incoming).SetLocation(Location + Offset);
	}

	Enable('Touch');
	return true;
}

defaultproperties
{
}
