//=============================================================================
// RevolverHitFX. 
//=============================================================================
class RevolverHitFX expands HitFX;

defaultproperties
{
     ParticlesPerSec=(Base=2048)
     SourceWidth=(Base=2)
     SourceHeight=(Base=2)
     SourceDepth=(Base=2)
     AngularSpreadWidth=(Base=30)
     AngularSpreadHeight=(Base=30)
     Speed=(Base=0,Rand=300)
     Lifetime=(Base=0.33,Rand=1)
     ColorStart=(Base=(R=167,G=158,B=131))
     ColorEnd=(Base=(R=102,G=84,B=68))
     AlphaStart=(Base=0.5,Rand=0.5)
     SizeWidth=(Rand=8)
     SizeLength=(Rand=8)
     SizeEndScale=(Base=0,Rand=1)
     Elasticity=0.01
     Damping=0.2
     WindModifier=1
     Gravity=(Z=-600)
     ParticlesMax=8
     Textures(0)=Texture'Aeons.Particles.BoneChunk0'
     RenderPrimitive=PPRIM_Shard
}
