//=============================================================================
// LightningScriptedFX. 
//=============================================================================
class LightningScriptedFX expands ScriptedFX;

simulated function Tick(float DeltaTime)
{
	if ( Pawn(Owner) != none )
	{
		setRotation(Pawn(Owner).ViewRotation);
	}
	else
	{
		//setRotation(Owner.Rotation);
          Disable('Tick');
	}
}

defaultproperties
{
     ColorStart=(Base=(R=255,G=255,B=255))
     ColorEnd=(Base=(R=255,G=255,B=255))
     SizeWidth=(Base=0)
     SizeLength=(Base=0)
     bSystemRelative=True
     Textures(0)=Texture'Aeons.Particles.LtngFX03'
     LODBias=100
     CollisionRadius=1000
     CollisionHeight=1000
}
