//=============================================================================
// SpectralWindFX.
//=============================================================================
class SpectralWindFX expands WindFX;

defaultproperties
{
     ParticlesPerSec=(Base=128)
     Lifetime=(Base=2)
     AlphaStart=(Base=0.25,Rand=0.5)
     SizeWidth=(Base=8,Rand=8)
     SizeLength=(Base=8)
     AlphaDelay=1
     Chaos=64
     ChaosDelay=0.2
     Damping=0.5
     Textures(0)=Texture'Aeons.MuzzleFlashes.Ghelz_Glow'
     LODBias=10
     Tag=SpectralWindFX
}
