//=============================================================================
// WaterGlobeParticleFX.
//=============================================================================
class WaterGlobeParticleFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=48)
     SourceWidth=(Base=6)
     SourceHeight=(Base=6)
     SourceDepth=(Base=2)
     Speed=(Base=20)
     Lifetime=(Rand=0.75)
     ColorStart=(Base=(G=193))
     ColorEnd=(Base=(R=254,G=65,B=1))
     SizeWidth=(Base=12)
     SizeLength=(Base=12)
     SpinRate=(Base=8,Rand=-8)
     DripTime=(Base=0.5)
     Textures(0)=Texture'Aeons.Particles.PotFire08'
}
