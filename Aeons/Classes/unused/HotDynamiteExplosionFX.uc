//=============================================================================
// HotDynamiteExplosionFX.
//=============================================================================
class HotDynamiteExplosionFX expands HotExplosionFX;

defaultproperties
{
     SourceWidth=(Base=32)
     SourceHeight=(Base=32)
     SourceDepth=(Base=32)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=128,Rand=512)
     Lifetime=(Base=0.5,Rand=0)
     ColorStart=(Base=(R=128,G=0,B=0),Rand=(R=170,G=85))
     ColorEnd=(Base=(G=128,B=64),Rand=(R=255,G=255))
     AlphaStart=(Base=0.75)
     SizeWidth=(Base=48,Rand=16)
     SizeLength=(Base=48,Rand=16)
     SizeEndScale=(Base=1)
     SpinRate=(Base=-2,Rand=4)
     Damping=3
     Gravity=(Z=0)
     ParticlesMax=192
}
