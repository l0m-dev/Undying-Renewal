//=============================================================================
// BloodLightningHitFX. 
//=============================================================================
class BloodLightningHitFX expands LightningHitFX;

defaultproperties
{
     SourceHeight=(Base=0)
     SourceDepth=(Base=8)
     Speed=(Base=100)
     Lifetime=(Rand=1)
     ColorStart=(Base=(G=23,B=23))
     ColorEnd=(Base=(R=151,G=0,B=0))
     SizeWidth=(Rand=4)
     Elasticity=0.25
}
