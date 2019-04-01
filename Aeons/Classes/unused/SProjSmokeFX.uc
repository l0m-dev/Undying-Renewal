//=============================================================================
// SProjSmokeFX. 
//=============================================================================
class SProjSmokeFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=512)
     SourceWidth=(Base=1)
     SourceHeight=(Base=1)
     SourceDepth=(Base=1)
     AngularSpreadWidth=(Base=90)
     AngularSpreadHeight=(Base=90)
     Speed=(Base=100,Rand=500)
     Lifetime=(Base=0.5,Rand=0.5)
     ColorStart=(Base=(R=90,G=80,B=141))
     ColorEnd=(Base=(R=156,G=156,B=158))
     AlphaStart=(Base=0.25,Rand=0.25)
     SizeWidth=(Base=16)
     SizeLength=(Base=16)
     SizeEndScale=(Base=20)
     SpinRate=(Base=-1,Rand=1)
     Damping=4
     WindModifier=1
     Gravity=(Z=30)
     ParticlesMax=32
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
}
