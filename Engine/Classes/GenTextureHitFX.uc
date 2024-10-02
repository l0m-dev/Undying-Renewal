//=============================================================================
// GenTextureHitFX. 
//=============================================================================
class GenTextureHitFX expands ParticleFX;

/* Force-Recompile */

//#exec Texture Import Name=noisy1pfx File=Textures\noisy1pfx.pcx Group=Particles Mips=OFF

defaultproperties
{
     ParticlesPerSec=(Base=1024)
     SourceWidth=(Base=8)
     SourceHeight=(Base=32)
     SourceDepth=(Base=32)
     AngularSpreadWidth=(Base=60)
     AngularSpreadHeight=(Base=60)
     Speed=(Base=0,Rand=50)
     Lifetime=(Base=0.25,Rand=0.5)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(G=255,B=255))
     AlphaStart=(Base=0,Rand=0.5)
     SizeEndScale=(Rand=4)
     Damping=2
     WindModifier=1
     ParticlesMax=16
     Textures(0)=Texture'Engine.Particles.noisy1pfx'
     bNetTemporary=True
}
