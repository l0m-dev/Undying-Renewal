//=============================================================================
// SmokyBloodFX. 
//=============================================================================
class SmokyBloodFX expands SmokyExplosionFX;

defaultproperties
{
     SourceWidth=(Base=32)
     SourceHeight=(Base=128)
     SourceDepth=(Base=32)
     Speed=(Base=100,Rand=100)
     Lifetime=(Base=0.5,Rand=1)
     SizeEndScale=(Rand=1)
     Gravity=(Z=-200)
     ParticlesMax=8
     Textures(0)=Texture'Aeons.Particles.BloodSmoke1'
     Style=STY_AlphaBlend
}
