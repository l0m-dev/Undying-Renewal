//=============================================================================
// SmokyDynamiteExplosionFX.
//=============================================================================
class SmokyDynamiteExplosionFX expands SmokyExplosionFX;

defaultproperties
{
     SourceWidth=(Base=160)
     SourceHeight=(Base=160)
     SourceDepth=(Base=160)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=192,Rand=0)
     Lifetime=(Base=1.5,Rand=1)
     ColorStart=(Base=(R=85,G=85,B=85))
     ColorEnd=(Base=(R=128,G=128,B=128),Rand=(R=192,G=192,B=192))
     SpinRate=(Base=-2,Rand=4)
     Damping=1.5
     GravityModifier=-0.05
     Gravity=(Z=0)
}
