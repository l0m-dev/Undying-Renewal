//=============================================================================
// BloodTrailFX. 
//=============================================================================
class BloodTrailFX expands ParticleTrailFX;

defaultproperties
{
     ParticlesPerSec=(Base=128)
     SourceWidth=(Base=8)
     SourceHeight=(Base=8)
     SourceDepth=(Base=8)
     AngularSpreadWidth=(Base=30)
     AngularSpreadHeight=(Base=30)
     Speed=(Base=50)
     Lifetime=(Rand=2)
     ColorStart=(Base=(R=128,G=0,B=0))
     ColorEnd=(Base=(R=128,G=0,B=0))
     SizeWidth=(Base=4)
     SizeLength=(Base=0.5)
     GravityModifier=0.4
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
     RenderPrimitive=PPRIM_Liquid
}
