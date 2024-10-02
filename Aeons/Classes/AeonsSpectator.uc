//=============================================================================
// AeonsSpectator.
//=============================================================================
class AeonsSpectator extends Spectator;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	if ( Level.Game != None )
		HUDType = Level.Game.HUDType;		
}

defaultproperties
{
      HUDType=Class'Aeons.AeonsHUD'
      CollisionRadius=17.000000
}
