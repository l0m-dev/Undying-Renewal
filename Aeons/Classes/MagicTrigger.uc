//=============================================================================
// MagicTrigger.
//=============================================================================
class MagicTrigger expands Trigger;

//#exec TEXTURE IMPORT NAME=TrigMagic FILE=TrigMagic.pcx GROUP=System Mips=Off Flags=2

function PreBeginPlay()
{
	super.PreBeginPlay();
	bInitiallyActive = false;
}

function int Dispel(optional bool bCheck)
{
	local PlayerPawn P;
	
	if ( bCheck )
	{
		log("Magic Trigger checked - returning 0", 'Misc');
		return 0;
	}

	log("Magic Trigger Dispelled - returning 0", 'Misc');
	// Find the player
	ForEach AllActors(class 'PlayerPawn', P)
	{
		break;
	}

	bInitiallyActive = true;
	// Player touches....
	Super.Touch(P);
	gotoState('Unlocked');
	return 0;
}



State Unlocked
{
	// Already dispelled - can't dispel again....
	function int Dispel(optional bool bCheck)
	{
		if ( bCheck )
			return -1;
		return 0;
	}
	
	Begin:
		
	
}

defaultproperties
{
     Texture=Texture'Aeons.System.TrigMagic'
     DrawScale=0.5
}
