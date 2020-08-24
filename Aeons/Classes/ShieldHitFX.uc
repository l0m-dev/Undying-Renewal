//=============================================================================
// ShieldHitFX. 
//=============================================================================
class ShieldHitFX expands HitFX;

defaultproperties
{
     ParticlesPerSec=(Base=2000)
     SourceWidth=(Base=50)
     SourceHeight=(Base=50)
     SourceDepth=(Base=50)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=300)
     Lifetime=(Base=1.5,Rand=0.5)
     ColorStart=(Base=(R=0,G=0,B=204))
     ColorEnd=(Base=(R=125,G=125,B=255))
     AlphaStart=(Base=0.5)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=0.5)
     Elasticity=0.05
     Damping=0.5
     WindModifier=1
     GravityModifier=0.75
     ParticlesMax=100
     Textures(0)=Texture'UWindow.WhiteTexture'
     RenderPrimitive=PPRIM_Shard
     CollisionRadius=200
     CollisionHeight=200
}
