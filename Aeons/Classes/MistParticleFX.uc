//=============================================================================
// MistParticleFX.
//=============================================================================
class MistParticleFX expands AeonsParticleFX;

//	SourceWidth=(Base=50.000000,Rand=50.000000)
//	SourceHeight=(Base=50.000000,Rand=50.000000)
//	SizeWidth=(Base=4.000000,Rand=4.000000)
//	SizeLength=(Base=4.000000,Rand=4.000000)
//	Lifetime=(Base=4.000000,Rand=2.000000)
//	ColorStart=(Base=(R=64,G=128,B=255))
//	ColorEnd=(Base=(R=0,G=0,B=255))
//	Attraction=(X=13.000000,Y=17.000000,Z=19.000000)

defaultproperties
{
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     bSteadyState=True
     Speed=(Rand=100)
     Lifetime=(Base=0.5,Rand=0.5)
     ColorStart=(Base=(R=64,B=255))
     ColorEnd=(Base=(R=0,B=255))
     AlphaStart=(Base=0.5,Rand=0.25)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=4,Rand=6)
     SpinRate=(Base=-8,Rand=8)
     Attraction=(X=20,Y=20,Z=20)
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
}
