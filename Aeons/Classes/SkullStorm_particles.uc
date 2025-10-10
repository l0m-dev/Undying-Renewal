//=============================================================================
// SkullStorm_particles. 
//=============================================================================
class SkullStorm_particles expands SpellParticleFX;

//     BaseParams=(ParticlesPerSec=50.000000,AngularSpreadWidth=10.000000,AngularSpreadHeight=10.000000,Speed=0.000000,Lifetime=3.000000,ColorStart=(R=50,G=50,B=50),ColorEnd=(R=0),AlphaStart=0.300000,SizeWidth=16.000000,SizeLength=16.000000,SizeEndScale=16.000000)

simulated function Tick(float DeltaTime)
{
	if ( Owner == none )
		Shutdown();
}

state Kill
{
	function Timer()
	{
		Destroy();
	}

	Begin:
		ParticlesPerSec.Base = 0;
		setTimer(4 ,false);
}

defaultproperties
{
     ParticlesPerSec=(Base=48)
     SourceWidth=(Base=8)
     SourceHeight=(Base=8)
     SourceDepth=(Base=8)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=0)
     Lifetime=(Base=0.75,Rand=0.5)
     ColorStart=(Base=(R=96,G=96,B=96))
     ColorEnd=(Base=(R=0))
     AlphaStart=(Base=0.75,Rand=0.25)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=3)
     WindModifier=1
     Gravity=(Z=10)
     Textures(0)=Texture'Aeons.Particles.Smoke32_01'
     LODBias=101
     Style=STY_AlphaBlend
}
