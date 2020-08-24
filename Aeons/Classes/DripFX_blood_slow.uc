//=============================================================================
// DripFX_blood_slow.
//=============================================================================
class DripFX_blood_slow expands DripFX;

defaultproperties
{
     ParticlesPerSec=(Base=0.1)
     Lifetime=(Base=4)
     ColorStart=(Base=(R=43,B=0),Rand=(R=64,B=0))
     ColorEnd=(Base=(R=85,B=0),Rand=(R=64,B=0))
     AlphaStart=(Base=1,Rand=0)
     DripTime=(Base=2)
     AlphaDelay=1.5
}
