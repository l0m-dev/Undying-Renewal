//=============================================================================
// FireFlyTrail_particles. 
//=============================================================================
class FireFlyTrail_particles expands SpellParticleFX;

/* Force-Recompile */

state dissipate
{


	Begin:
		Elasticity = 0;
		ParticlesPerSec.Base = 0;
		Lifetime.Base = 0.25;
		lifeSpan = 1;
}

defaultproperties
{
     AmpColors(0)=(R=0,G=0,B=0)
     AmpColors(1)=(R=0,G=0,B=0)
     AmpColors(2)=(R=0,G=0,B=0)
     AmpColors(3)=(R=0,G=0,B=0)
     AmpColors(4)=(R=0,G=0,B=0)
     ParticlesPerSec=(Base=64)
     SourceWidth=(Base=12)
     SourceHeight=(Base=12)
     SourceDepth=(Base=12)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=100)
     Lifetime=(Base=0.33,Rand=0.25)
     ColorStart=(Base=(R=126,G=113,B=255))
     ColorEnd=(Base=(G=255,B=255))
     AlphaEnd=(Base=1,Rand=0.5)
     SizeWidth=(Base=20)
     SizeLength=(Base=20)
     SizeEndScale=(Base=0)
     Elasticity=22
     Textures(0)=Texture'Aeons.Particles.FireFly01'
     LODBias=10
     RemoteRole=ROLE_SimulatedProxy
}
