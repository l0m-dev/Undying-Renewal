//=============================================================================
// DirtLightningHitFX. 
//=============================================================================
class DirtLightningHitFX expands LightningHitFX;

defaultproperties
{
     SourceHeight=(Base=0)
     SourceDepth=(Base=8)
     Speed=(Base=100)
     Lifetime=(Rand=1)
     ColorStart=(Base=(R=180,G=137,B=99))
     ColorEnd=(Base=(R=223,G=205,B=179))
     SizeWidth=(Rand=4)
     Elasticity=0.25
}
