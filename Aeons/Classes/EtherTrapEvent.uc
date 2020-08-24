//=============================================================================
// EtherTrapEvent.
//=============================================================================
class EtherTrapEvent expands Info;

//#exec TEXTURE IMPORT NAME=ETrapEvent FILE=ETrapEvent.pcx GROUP=System Mips=Off Flags=2

var() bool bRequireSameZone;

function Trigger(Actor Other, Pawn Instigator)
{
	local Actor A;
	
	// log("EtherTrapEvent: being triggered", 'Misc');
	if ( Event != 'none' )
	{
		
		// check for same zone
		if ( bRequireSameZone )
			if (Other.Region.Zone != Region.Zone)
				return;

		ForEach AllActors(class 'Actor', A, Event)
		{
			if (A.IsA('Trigger'))
			{
				if (Trigger(A).bPassThru)
				{
					Trigger(A).PassThru(Other);
				}
				else
					A.Trigger(Other, Other.Instigator);
			}
			else 
				A.Trigger(Other, Other.Instigator);
		}
	}
}

defaultproperties
{
     Texture=Texture'Aeons.System.ETrapEvent'
}
