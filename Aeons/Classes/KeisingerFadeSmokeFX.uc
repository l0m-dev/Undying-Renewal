//=============================================================================
// KeisingerFadeSmokeFX.
//=============================================================================
class KeisingerFadeSmokeFX expands SigilSmokyExplosionFX;

defaultproperties
{
     Lifetime=(Rand=1)
     ColorStart=(Base=(R=31,G=112,B=7),Rand=(R=1,G=139,B=108))
     ColorEnd=(Base=(R=2,G=149,B=61),Rand=(R=2,G=164,B=112))
     SizeEndScale=(Base=3)
     ParticlesMax=48
}
