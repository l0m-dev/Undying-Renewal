//=============================================================================
// MolotovSplash_particles. 
//=============================================================================
class MolotovSplash_particles expands MolotovFire_particles;

//#exec AUDIO IMPORT FILE="..\Molotov_proj\E_Wpn_MoltFireLoop01vL.wav" NAME="E_Wpn_MoltFireLoop01" GROUP="Weapons"

function ZoneChange(ZoneInfo NewZone)
{
	if (NewZone.bWaterZone)
		Shutdown();
}

state() startup
{

	Begin:
		//log("...............MolotovSplash_particles: startup State begin");
		if (Region.Zone.bWaterZone)
			gotoState('Extinguish');

		sleep(0.5);
		gotoState('Spreading');
}

// ===============================================================================================
// Spreading state - big
// ===============================================================================================
state Spreading
{
	function Touch( actor Other )
	{
		if (Other.AcceptDamage(GetDamageInfo()))
			Other.TakeDamage(Instigator, Location, vect(0,0,0), getDamageInfo());
	}
	
	function Timer()
	{
		local int i;
		
		if (damping > 0)
			damping -= 5;
		for (i=0;i<8;i++)
			if ( Touching[i] != None )
				Touch(Touching[i]);
	}

	function BeginState()
	{
		setPhysics(PHYS_None);
		setRotation(Rotator(vect(0,0,1)));

		AngularSpreadHeight.Base = 15;
		AngularSpreadWidth.Base = 15;
		
		SetCollisionSize( 64, 32 );
		SourceHeight.Base = 4;
		SourceDepth.Base = 64;
		SourceWidth.Base = 64;

		Gravity = vect(0,0,100);
		Speed.Base = 0;
		Speed.Rand = 0;

		SizeLength.Base = 64;
		SizeLength.Rand = 64;

		SizeWidth.Base = 64;
		SizeWidth.Rand = 64;
		
		DripTime.Base = 0.1;

		Lifetime.Base = 0.25;
		Lifetime.Rand = 3;

		ParticlesPerSec.Base = 32;

	}

	Begin:
		//log("...............MolotovSplash_particles: Spreading State begin");
		if (Region.Zone.bWaterZone)
			gotoState('Extinguish');

		setTimer(0.2,true);
		sleep((FRand() * 4) + 3);
		Shutdown();
		// gotoState('Extinguish');
}

defaultproperties
{
     SourceWidth=(Base=1)
     SourceHeight=(Base=1)
     SourceDepth=(Base=1)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=5)
     Speed=(Base=100,Rand=800)
     Lifetime=(Base=0.5,Rand=0)
     SizeWidth=(Rand=32)
     SizeLength=(Rand=32)
     SizeEndScale=(Base=2,Rand=4)
     DripTime=(Rand=0)
     Damping=0.5
     GravityModifier=0
     InitialState=Startup
     SoundVolume=64
     bProjTarget=True
     LightBrightness=200
     LightSaturation=64
}
