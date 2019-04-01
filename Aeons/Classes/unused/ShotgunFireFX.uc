//=============================================================================
// ShotgunFireFX. 
//=============================================================================
class ShotgunFireFX expands ShotgunSmokeFX;

defaultproperties
{
     Speed=(Base=500,Rand=1000)
     Lifetime=(Base=0.1,Rand=0.4)
     ColorStart=(Base=(R=243,G=255,B=21))
     ColorEnd=(Base=(R=255,G=60,B=60))
     AlphaStart=(Base=1,Rand=0)
     SizeEndScale=(Base=2,Rand=2)
     Damping=20
     ParticlesMax=16
     RenderPrimitive=PPRIM_Liquid
}
