//=============================================================================
// OldPotShatter.
//=============================================================================
class OldPotShatter expands GlassFX;

defaultproperties
{
     bInitiallyOn=False
     ParticlesPerSec=(Base=256)
     SourceWidth=(Base=32)
     SourceHeight=(Base=64)
     SourceDepth=(Base=16)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=150)
     Lifetime=(Base=0.75)
     ColorStart=(Base=(R=255),Max=(R=255,G=255,B=255),Rand=(R=255,G=255,B=255))
     ColorEnd=(Base=(G=0,B=0))
     AlphaStart=(Base=16)
     SizeWidth=(Base=12)
     SizeLength=(Base=12)
     SizeEndScale=(Rand=0.5)
     SpinRate=(Base=0.5)
     AlphaDelay=5
     Elasticity=0
     GravityModifier=0.5
     ParticlesAlive=24
     ParticlesMax=64
     Textures(0)=None
     CollisionRadius=40
     CollisionHeight=40
}
