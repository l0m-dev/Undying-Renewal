//=============================================================================
// BloodFountainPFX.
//=============================================================================
class BloodFountainPFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=200)
     AngularSpreadWidth=(Base=15)
     AngularSpreadHeight=(Base=15)
     bSteadyState=True
     Speed=(Base=600)
     Lifetime=(Base=2)
     ColorStart=(Base=(R=208,G=15,B=49))
     SizeWidth=(Base=6)
     SizeLength=(Base=6)
     Elasticity=0.1
     Gravity=(Z=-950)
     Textures(0)=Texture'Aeons.Particles.noisy5_pfx'
}
