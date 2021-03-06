//=============================================================================
// SnowFootprint.
//=============================================================================
class SnowFootprint expands AeonsDecal;

//#exec OBJ LOAD FILE=\Aeons\Textures\BloodFootprints.utx PACKAGE=BloodFootprints

simulated event PostBeginPlay();
function StartLevel();

simulated function AttachToSurface(optional vector DecalDir)
{
	if( AttachDecal(64, DecalDir) == None )
		Destroy();
}

defaultproperties
{
     Style=STY_AlphaBlend
}
