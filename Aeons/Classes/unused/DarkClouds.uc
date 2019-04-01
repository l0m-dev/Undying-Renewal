//=============================================================================
// DarkClouds.
//=============================================================================
class DarkClouds expands SmokeParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=1280)
     SourceWidth=(Base=128)
     SourceHeight=(Base=32)
     SourceDepth=(Base=128)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=10)
     Speed=(Rand=256)
     Lifetime=(Base=8,Rand=0)
     ColorStart=(Rand=(R=64,B=64))
     ColorEnd=(Base=(R=0,G=0,B=64),Rand=(G=64,B=64))
     AlphaStart=(Base=0.75)
     SizeWidth=(Base=128,Rand=128)
     SizeLength=(Base=128,Rand=128)
     SizeEndScale=(Base=1,Rand=1)
     SpinRate=(Base=-4,Rand=8)
     AlphaDelay=1.5
     Gravity=(Z=0)
     ParticlesAlive=256
     Textures(0)=Texture'Aeons.MuzzleFlashes.Ghelz_Glow'
     Style=STY_AlphaBlend
}
