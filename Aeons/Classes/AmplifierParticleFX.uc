//=============================================================================
// AmplifierParticleFX.
//=============================================================================
class AmplifierParticleFX expands AeonsParticleFX;

simulated function PreBeginPlay()
{
     // here bStartup will only be true on the client if it's placed in the level
     // only if we don't delete ParticleFX client side
     if (Level.NetMode != NM_Client || Level.bStartup)
     {
          // give some time for the particle to be visible, this was done on Tick before
          SetTimer(MinTickTime, false);
     }
     Super.PreBeginPlay();
}

simulated function Timer()
{
     CheckShutdown();
}

simulated function CheckShutdown()
{
     // this is needed because there are some of these particles just placed in a level,
     // that are meant to disappear, like in Oneiros_City1 
     if (Owner == None)
          Shutdown();
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
