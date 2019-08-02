//=============================================================================
// SpeedModifier.
//=============================================================================
class SpeedModifier expands PlayerModifier;

var float defaultSpeed;

function PreBeginPlay()
{
	super.PreBeginPlay();

	if (Owner == none)
		Destroy();
	else
		defaultSpeed = PlayerPawn(Owner).default.groundSpeed;	
}

function LockPosition()
{
	if ( (Owner != None) && (PlayerPawn(Owner) != None) )
	{
		bActive = true;
		PlayerPawn(Owner).default.GroundSpeed = 0;
		PlayerPawn(Owner).GroundSpeed = 0;
	}
}

function ReleasePosition()
{
	if ( (Owner != None) && (PlayerPawn(Owner) != None) )
	{
		PlayerPawn(Owner).default.GroundSpeed = defaultSpeed;
		PlayerPawn(Owner).GroundSpeed = defaultSpeed;
		bActive = false;
	}
}

defaultproperties
{
}
