//=============================================================================
// FireFlyTrailFX. 
//=============================================================================
class FireFlyTrailFX expands ParticleTrailFX;

defaultproperties
{
     ParticlesPerSec=(Base=8)
     SourceWidth=(Base=16)
     SourceHeight=(Base=16)
     SourceDepth=(Base=16)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=100,Rand=75)
     Lifetime=(Base=0.25,Rand=0.5)
     ColorStart=(Base=(R=255,G=251,B=64))
     ColorEnd=(Base=(R=232,G=156,B=0))
     AlphaStart=(Base=0.25,Rand=0.25)
     SizeWidth=(Base=24)
     SizeLength=(Base=24)
     SizeEndScale=(Base=3,Rand=5)
     SpinRate=(Base=-8,Rand=8)
     Attraction=(X=20,Y=20,Z=20)
     Distribution=DIST_Random
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
     RenderPrimitive=PPRIM_Billboard
     LODBias=10
}
