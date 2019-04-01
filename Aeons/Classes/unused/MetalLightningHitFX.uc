//=============================================================================
// MetalLightningHitFX.
//=============================================================================
class MetalLightningHitFX expands LightningHitFX;

defaultproperties
{
     AngularSpreadWidth=(Base=5)
     AngularSpreadHeight=(Base=5)
     Speed=(Base=0,Rand=400)
     Lifetime=(Base=0.25,Rand=1)
     ColorStart=(Base=(G=243,B=21),Rand=(R=73,G=73,B=73))
     ColorEnd=(Base=(R=19,G=0,B=255))
     SizeWidth=(Base=1,Rand=1)
     Chaos=8
     Elasticity=0.5
}
