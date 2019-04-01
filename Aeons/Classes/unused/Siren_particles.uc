//=============================================================================
// Siren_particles. 
//=============================================================================
class Siren_particles expands AeonsParticleFX;

var int		PingCount;

function NotifySPs()
{
	local ScriptedPawn SP;
	
	ForEach RadiusActors(class 'ScriptedPawn', SP, 1024)
	{
		SP.PowderOfSirenNotify(self);
	}
}

auto state expand
{

	Begin:
		NotifySPs();
		sleep(1);
		gotoState('Rising');
		
}

state Rising
{
	function Timer()
	{
		NotifySPs();
		PingCount += 1;
		if ( PingCount >= 6 )
			SetTimer( 0.0, false );
	}

	Begin:
		PingCount = 0;
		SetTimer( 0.5, true );
		Damping = 0;
}

defaultproperties
{
     ParticlesPerSec=(Base=1024)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Speed=(Base=700,Rand=800)
     Lifetime=(Base=25,Rand=5)
     ColorStart=(Base=(R=89,G=89,B=89))
     ColorEnd=(Base=(R=82,G=82,B=82))
     SizeWidth=(Base=256)
     SizeLength=(Base=256)
     SizeEndScale=(Rand=2)
     SpinRate=(Base=-1,Rand=2)
     Elasticity=0.5
     Damping=10
     ParticlesMax=32
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
     InitialState=expand
     LODBias=10
}
