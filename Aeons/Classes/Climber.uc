//=============================================================================
// Climber.
//=============================================================================
class Climber expands Info;

//#exec TEXTURE IMPORT FILE=Climber.pcx GROUP=System Mips=On

var() bool bActive;

function Trigger(Actor Other, Pawn Instigator)
{
	bActive = !bActive;
}

function Touch(Actor Other)
{
	if ( bActive )
	{
		if ( Other.IsA('PlayerPawn') )
		{
			PlayerPawn(Other).bForceClimb = true;
		}
	}
}

function UnTouch(Actor Other)
{
	local int i;
	local bool bTouchingAnotherClimber;
	if (bActive)
	{
		if ( Other.IsA('PlayerPawn') )
		{
			for (i=0; i<8; i++)
			{
				if ( (PlayerPawn(Other).Touching[i].IsA('Climber')) && (PlayerPawn(Other).Touching[i] != self) )
					bTouchingAnotherClimber = true;
			}
			if ( !bTouchingAnotherClimber )
				PlayerPawn(Other).bForceClimb = false;
		}
	}
}

defaultproperties
{
     bActive=True
     Texture=Texture'Aeons.System.Climber'
     DrawScale=0.5
     CollisionRadius=32
     CollisionHeight=128
     bCollideActors=True
}
