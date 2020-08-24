//=============================================================================
// WaterLightningHitFX. 
//=============================================================================
class WaterLightningHitFX expands LightningHitFX;

defaultproperties
{
     ParticlesPerSec=(Base=16,Rand=16)
     SourceHeight=(Base=0)
     SourceDepth=(Base=8)
     Lifetime=(Rand=1)
     ColorStart=(Base=(R=149,G=149))
     ColorEnd=(Base=(R=255,G=255,B=255))
     AlphaStart=(Base=0.25,Rand=0.75)
     SizeWidth=(Rand=4)
     SizeEndScale=(Base=0.25,Rand=0.75)
     Elasticity=0
}
