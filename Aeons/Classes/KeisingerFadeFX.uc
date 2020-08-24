//=============================================================================
// KeisingerFadeFX.
//=============================================================================
class KeisingerFadeFX expands SigilExplosionFX;

defaultproperties
{
     Speed=(Base=400,Rand=400)
     Lifetime=(Base=1,Rand=0.75)
     ColorStart=(Base=(R=23,G=94,B=6),Rand=(R=7,G=143,B=99))
     ColorEnd=(Base=(R=20,G=151,B=13),Rand=(R=4,G=128,B=69))
     SizeWidth=(Base=24)
     SizeLength=(Base=24)
     SizeEndScale=(Base=2,Rand=2)
     Gravity=(Z=0)
}
