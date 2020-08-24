//=============================================================================
// KeisingerHalo.
//=============================================================================
class KeisingerHalo expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=4096)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=400)
     Lifetime=(Base=500)
     ColorStart=(Base=(R=129,G=44,B=186))
     ColorEnd=(Base=(R=15,G=19,B=187),Rand=(R=6,G=81,B=2))
     SizeWidth=(Base=16,Rand=4)
     SizeLength=(Base=16,Rand=4)
     SizeEndScale=(Rand=6)
     bSystemRelative=True
     Damping=5
     ParticlesMax=512
     Textures(0)=Texture'Aeons.Particles.Star7_pfx'
}
