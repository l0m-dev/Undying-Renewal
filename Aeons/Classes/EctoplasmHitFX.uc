//=============================================================================
// EctoplasmHitFX. 
//=============================================================================
class EctoplasmHitFX expands HitFX;

//BaseParams=(ParticlesPerSec=2048.000000,SourceWidth=4.000000,SourceHeight=4.000000,AngularSpreadWidth=30.000000,AngularSpreadHeight=30.000000,
//Speed=50.000000,ColorStart=(X=1.000000,Y=1.000000,Z=1.000000),ColorEnd=(X=0.000000,Z=1.000000),AlphaStart=1.000000,SizeEndScale=0.300000)

/*
var bool bSpewed;

function PreBeginPlay()
{
	super.PreBeginPlay();
	// setTimer(2,true);
}


auto state Spew
{
	function Tick(float deltaTime)
	{
		if (bSpewed)
			gotoState('Idle');
		bSpewed = true;
	}
	
	function BeginState()
	{
		ParticlesPerSec.Base = 2048;
		bSpewed = false;
	}

	Begin:
}

state Idle
{
	function Timer()
	{
		Destroy();
	}

	function BeginState()
	{
		ParticlesPerSec.Base = 0;
		strength = 0;
		setTimer(Lifetime.Base,false);
	}

	Begin:
}

*/

defaultproperties
{
     ParticlesPerSec=(Base=2048)
     SourceWidth=(Base=4)
     SourceHeight=(Base=4)
     AngularSpreadWidth=(Base=30)
     AngularSpreadHeight=(Base=30)
     Speed=(Base=0,Rand=75)
     Lifetime=(Base=0,Rand=1.5)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(R=4,G=30,B=255))
     AlphaEnd=(Base=0.3)
     SizeWidth=(Base=16)
     SizeLength=(Base=16)
     SizeEndScale=(Base=0.5,Rand=1)
     Damping=0.1
     GravityModifier=0.1
     Gravity=(Z=50)
     ParticlesMax=8
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
     LightEffect=LE_FastWave
     LightBrightness=103
     LightHue=156
     LightSaturation=123
     LightRadius=32
     LightRadiusInner=16
}
