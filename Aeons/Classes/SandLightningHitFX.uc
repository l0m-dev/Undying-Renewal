//=============================================================================
// SandLightningHitFX. 
//=============================================================================
class SandLightningHitFX expands LightningHitFX;

defaultproperties
{
     SourceHeight=(Base=0)
     SourceDepth=(Base=8)
     Speed=(Base=100)
     Lifetime=(Rand=1)
     ColorStart=(Base=(R=180,G=151,B=99))
     ColorEnd=(Base=(R=163,G=137,B=118))
     SizeWidth=(Rand=4)
     SizeLength=(Base=3)
     Elasticity=0.25
}
