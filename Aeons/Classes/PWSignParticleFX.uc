//=============================================================================
// PWSignParticleFX. 
//=============================================================================
class PWSignParticleFX expands ScriptedFX;

function Tick(float DeltaTime)
{
	if (Owner == None)
		Destroy();
}

defaultproperties
{
     Lifetime=(Base=0.25)
     ColorStart=(Base=(R=255,G=255,B=255))
     AlphaEnd=(Base=0)
     SizeWidth=(Base=1)
     SizeLength=(Base=1)
     SizeEndScale=(Base=1.25)
     Textures(0)=Texture'Aeons.Particles.pw_trail'
     Style=STY_AlphaBlend
}
