//=============================================================================
// ShellFX. 
//=============================================================================
class ShellFX expands ParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=2)
     SourceWidth=(Base=2)
     SourceHeight=(Base=2)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     bSteadyState=True
     Speed=(Base=0,Rand=10)
     Lifetime=(Base=2,Rand=1)
     ColorStart=(Base=(B=0))
     AlphaStart=(Base=0.5)
     SizeWidth=(Base=24)
     SizeLength=(Base=24)
     SizeEndScale=(Base=0,Rand=4)
     Chaos=8
     ChaosDelay=0.25
     Gravity=(Y=-8)
     Textures(0)=Texture'Aeons.Particles.Flare'
     Tag=ShellFX
     Rotation=(Pitch=16400)
     CollisionRadius=1000
     CollisionHeight=1000
}
