//=============================================================================
// AmplifierParticleFX.
//=============================================================================
class AmplifierParticleFX expands AeonsParticleFX;

function Tick(float DeltaTime)
{
	if ((Owner == none) || (Owner.Owner != none))
	{
		bShuttingDown = true;
	}
}

defaultproperties
{
     ParticlesPerSec=(Base=16)
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=30,Rand=20)
     ColorStart=(Base=(G=193,B=254))
     ColorEnd=(Base=(B=236))
     Chaos=4
     Attraction=(X=10,Y=10,Z=10)
     Textures(0)=Texture'Aeons.Particles.Flare'
     Tag=AmplifierParticleFX
}
