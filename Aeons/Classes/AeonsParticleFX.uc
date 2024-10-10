//=============================================================================
// AeonsParticleFX. 
//=============================================================================
class AeonsParticleFX expands ParticleFX;

// removed bNetTemporary=True
// no longer need to tick: EnergyKey, Amplifier, HealthVial
// no longer dumbproxy: SpellParticleFX
// doesn't need bNetTemporary=False anymore: GiveSpellParticleFX, ScytheWoundFX

//#exec OBJ LOAD FILE=\Aeons\Textures\fxB.utx PACKAGE=fxB

//----------------------------------------------------------------------------
//	Import
//----------------------------------------------------------------------------
//#exec Texture Import Name=Glow00 File=Glow00.pcx Group=Particles Mips=Off
//#exec Texture Import Name=Glow01 File=Glow01.pcx Group=Particles Mips=Off
//#exec Texture Import Name=DarkGlow00 File=DarkGlow00.bmp Group=Particles Mips=Off

//#exec Texture Import Name=EctoFX01 File=EctoFX01.pcx Group=Particles Mips=Off
//#exec Texture Import Name=EctoFX02 File=EctoFX02.pcx Group=Particles Mips=Off
//#exec Texture Import Name=EctoFX03 File=EctoFX03.pcx Group=Particles Mips=Off

//#exec Texture Import Name=FireFlyB File=FireFlyB.pcx Group=Particles Mips=Off

//#exec Texture Import Name=SparkB File=SparkB.pcx Group=Particles Mips=Off
//#exec Texture Import Name=SparkB01 File=SparkB01.pcx Group=Particles Mips=Off
//#exec Texture Import Name=SparkB02 File=SparkB02.pcx Group=Particles Mips=Off

//#exec Texture Import Name=BoneChunk0 File=BoneChunk0.pcx Group=Particles Mips=Off

//#exec Texture Import Name=Bubble File=Bubble.bmp Group=Particles Mips=On
//#exec Texture Import Name=BubbleTrans File=Bubble.pcx Group=Particles Mips=On

//#exec Texture Import Name=noisy1_pfx File=noisy1_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=noisy2_pfx File=noisy2_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=noisy3_pfx File=noisy3_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=noisy4_pfx File=noisy4_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=noisy5_pfx File=noisy5_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=noisy6_pfx File=noisy6_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=noisy7_pfx File=noisy7_pfx.pcx Group=Particles Mips=OFF

//#exec Texture Import Name=Pinwheel_pfx File=Pinwheel_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Ring_pfx File=Ring_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Ring2_pfx File=Ring2_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Ring3_pfx File=Ring3_pfx.pcx Group=Particles Mips=OFF

//#exec Texture Import Name=SoftShaft01 File=SoftShaft01.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=SoftShaft02 File=SoftShaft02.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Soft_pfx File=Soft_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Square_pfx File=Square_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Square1_pfx File=Square1_pfx.pcx Group=Particles Mips=OFF

//#exec Texture Import Name=Star1_pfx File=Star1_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Star2_pfx File=Star2_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Star3_pfx File=Star3_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Star4_pfx File=Star4_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Star5_pfx File=Star5_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Star6_pfx File=Star6_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Star7_pfx File=Star7_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Star8_pfx File=Star8_pfx.pcx Group=Particles Mips=OFF

//#exec Texture Import Name=Smoke_mpfx File=Smoke_mpfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Smoke2_mpfx File=Smoke2_mpfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Smoke3_mpfx File=Smoke3_mpfx.pcx Group=Particles Mips=OFF

//#exec Texture Import Name=BallLightning File=BallLightning.pcx Group=Particles Mips=On
//#exec Texture Import Name=Lightning File=Lightning.pcx Group=Particles Mips=Off
//#exec Texture Import Name=Shaft File=Shaft.pcx Group=Particles Mips=Off
//#exec Texture Import Name=Shaft2 File=Shaft2.pcx Group=Particles Mips=On
//#exec Texture Import Name=Flare File=Flare.pcx Group=Particles Mips=Off

//#exec Texture Import Name=PotFire00 File=PotFire00.pcx Group=Particles Mips=Off
//#exec Texture Import Name=PotFire01 File=PotFire01.pcx Group=Particles Mips=Off
//#exec Texture Import Name=PotFire02 File=PotFire02.pcx Group=Particles Mips=Off
//#exec Texture Import Name=PotFire03 File=PotFire03.pcx Group=Particles Mips=Off
//#exec Texture Import Name=PotFire04 File=PotFire04.pcx Group=Particles Mips=Off
//#exec Texture Import Name=PotFire05 File=PotFire05.pcx Group=Particles Mips=Off
//#exec Texture Import Name=PotFire06 File=PotFire06.pcx Group=Particles Mips=Off
//#exec Texture Import Name=PotFire07 File=PotFire07.pcx Group=Particles Mips=Off
//#exec Texture Import Name=PotFire08 File=PotFire08.pcx Group=Particles Mips=Off
//#exec Texture Import Name=PotFire09 File=PotFire09.pcx Group=Particles Mips=Off

//#exec Texture Import Name=SpiderWeb File=SpiderWeb.pcx Group=Particles Mips=On

//#exec Texture Import Name=LtngFX01 File=LtngFX01.pcx Group=Particles Mips=On
//#exec Texture Import Name=LtngFX02 File=LtngFX02.pcx Group=Particles Mips=On
//#exec Texture Import Name=LtngFX03 File=LtngFX03.pcx Group=Particles Mips=On
//#exec Texture Import Name=LtngFX04 File=LtngFX04.pcx Group=Particles Mips=On
//#exec Texture Import Name=LtngFX05 File=LtngFX05.pcx Group=Particles Mips=On

//#exec Texture Import Name=FireFly01 File=FireFly01.pcx Group=Particles Mips=On

//#exec Texture Import Name=Rain0 File=Rain0.pcx Group=Particles Mips=On
//#exec Texture Import Name=Rain1 File=Rain1.pcx Group=Particles Mips=On

//#exec Texture Import Name=Ember00 File=Ember00.pcx Group=Particles Mips=On

//#exec Texture Import Name=BloodDrip0 File=BloodDrip0.bmp Group=Particles Mips=Off
 
//#exec Texture Import Name=BloodSmoke0 File=BloodSmoke0.bmp Group=Particles Mips=Off
//#exec Texture Import Name=BloodSmoke1 File=BloodSmoke1.bmp Group=Particles Mips=Off

//#exec Texture Import Name=Fire00 File=Fire00.bmp Group=Particles Mips=Off
//#exec Texture Import Name=Smoke32_00 File=Smoke32_00.bmp Group=Particles Mips=Off
//#exec Texture Import Name=Smoke32_01 File=Smoke32_01.bmp Group=Particles Mips=Off

//#exec Texture Import Name=pw_trail File=pw_trail.bmp Group=Particles Mips=Off
//#exec Texture Import Name=pw_bit File=pw_bit.bmp Group=Particles Mips=Off

//----------------------------------------------------------------------------
//	Variables
//----------------------------------------------------------------------------
var() float ChangeTime;
var() bool bInitiallyOn;
var() bool  bDelayFullOn;      // Delay then go full-on.
var() class<ParticleFX> EndFX;
var() sound TurnOnSound;
var() sound TurnOffSound;

var		float PPSBase, PPSRand;
var		float Alpha, Direction;
var		float InitialBrightness;
var		int	  DefaultParticlesPerSecBase, DefaultParticlesPerSecRand;

var bool bAlreadyStarted;

//----------------------------------------------------------------------------

replication
{
	unreliable if (Role == ROLE_Authority)
		bInitiallyOn, Direction;
}

//----------------------------------------------------------------------------

simulated function PreBeginPlay()
{
	bSavable = true;
}

simulated function BeginPlay()
{
	DefaultParticlesPerSecBase = ParticlesPerSec.Base;
	DefaultParticlesPerSecRand = ParticlesPerSec.Rand;

	// Remember initial light type and set new one.
	InitialBrightness = LightBrightness;
	if (Level.NetMode != NM_Client || GetStateName() == 'NormalParticles')
		Disable( 'Tick' );
	
	if( bInitiallyOn )
	{
		Alpha     = 1.0;
		Direction = 1.0;
	} else {
		Strength = 0;
		Alpha     = 0.0;
		Direction = -1.0;
	}
}

simulated function PostNetBeginPlay()
{
	if( bInitiallyOn )
	{
		Alpha     = 1.0;
		Direction = 1.0;
	} else {
		Strength = 0;
		Alpha     = 0.0;
		Direction = -1.0;
	}
}

function PostLoadGame()
{
	DefaultParticlesPerSecBase = ParticlesPerSec.Base;
	DefaultParticlesPerSecRand = ParticlesPerSec.Rand;

	// Remember initial light type and set new one.
	InitialBrightness = LightBrightness;
	Enable( 'Tick' );
	
	log("PostLoadGame - - - - - - bInitiallyOn is: "$bInitiallyOn, 'Misc');
	if( bInitiallyOn )
	{
		Alpha     = 1.0;
		Direction = 1.0;
	} else {
		ParticlesPerSec.Base = 0;
		ParticlesPerSec.Rand = 0;
		Strength = 0;
		Alpha     = 0.0;
		Direction = -1.0;
	}
}

simulated function StartLevel()
{
}

//----------------------------------------------------------------------------

// Called whenever time passes.
simulated function Tick( float DeltaTime )
{
	Alpha += Direction * DeltaTime / ChangeTime;

	if( Alpha > 1.0 )
	{
		Alpha = 1.0;
		if (Level.NetMode != NM_Client || GetStateName() == 'NormalParticles')
			Disable( 'Tick' );
	} 
	else if( Alpha < 0.0 ) 
	{
		Alpha = 0.0;
		if (Level.NetMode != NM_Client || GetStateName() == 'NormalParticles')
			Disable( 'Tick' );
	}

	if( !bDelayFullOn )
	{
		LightBrightness = Alpha * InitialBrightness;
		ParticlesPerSec.Base = Alpha * DefaultParticlesPerSecBase;
		ParticlesPerSec.Rand = Alpha * DefaultParticlesPerSecRand;
	} 
	else if( (Direction>0 && Alpha!=1) || Alpha==0 ) 
	{
		LightBrightness = 0;
		ParticlesPerSec.Base = 0;
		ParticlesPerSec.Rand = 0;
	}
	else 
	{
		LightBrightness = InitialBrightness;
		ParticlesPerSec.Base = DefaultParticlesPerSecBase;
		ParticlesPerSec.Rand = DefaultParticlesPerSecRand;
	}
}

//----------------------------------------------------------------------------

simulated function TurnOnEffect()
{
	bSavable = true;
	PlaySound(TurnOnSound);
}

//----------------------------------------------------------------------------

simulated function TurnOffEffect()
{
	PlaySound(TurnOffSound);
	if (EndFX != none)
		spawn(EndFX,,,Location, Rotation);
}


//----------------------------------------------------------------------------
//	State TriggerTurnsOn
//----------------------------------------------------------------------------
state() TriggerTurnsOn
{

	simulated function Trigger(Actor Other, Pawn EventInstigator)
	{
		bSavable = true;
		bInitiallyOn = true;
		TurnOnEffect();
		Direction = 1.0;
		Enable( 'Tick' );
	}

	Begin:

}


//----------------------------------------------------------------------------
//	State TriggerTurnsOff
//----------------------------------------------------------------------------
state() TriggerTurnsOff
{
	simulated function Trigger(Actor Other, Pawn EventInstigator)
	{
		bSavable = true;
		bInitiallyOn = false;
		Direction = -1.0;
		Enable( 'Tick' );
		TurnOffEffect();
	}
	
	Begin:
}

//----------------------------------------------------------------------------
//	State TriggerToggles
//----------------------------------------------------------------------------
state() TriggerToggles
{
	simulated function Trigger(Actor Other, Pawn EventInstigator)
	{
		Direction *= -1;
		Enable( 'Tick' );
		
		if (Direction == -1)
		{
			bSavable = true;
			bInitiallyOn = false;
			TurnOffEffect();
		} else {
			bSavable = true;
			bInitiallyOn = true;
			TurnOnEffect();
		}
	}
	
	Begin:
}

//----------------------------------------------------------------------------
//	State TriggerControl - Trigger controls the light.
//----------------------------------------------------------------------------
state() TriggerControl
{
	simulated function Trigger( actor Other, pawn EventInstigator )
	{
		if( bInitiallyOn )
		{
			bSavable = true;
			bInitiallyOn = true;
			Direction = -1.0;
			TurnOffEffect();
		}
		else 
		{
			bSavable = true;
			bInitiallyOn = false;
			Direction = 1.0;
			TurnOnEffect();
		}
		Enable( 'Tick' );
	}

	simulated function UnTrigger( actor Other, pawn EventInstigator )
	{
		if( bInitiallyOn )
		{
			bSavable = true;
			bInitiallyOn = true;
			Direction = 1.0;
			TurnOnEffect();
		}
		else 
		{
			bSavable = true;
			bInitiallyOn = false;
			Direction = -1.0;
			TurnOffEffect();
		}
		Enable( 'Tick' );
	}
}

//----------------------------------------------------------------------------
//	State NormalParticles
//----------------------------------------------------------------------------
state() NormalParticles
{
	simulated function StartLevel()
	{
		// StartLevel can be called twice if an actor that's initially in the level spawns an actor before its StartLevel is called
		// it can be called during SpawnActor and then right after the level has started
		if (!bSpawned && !bAlreadyStarted)
		{
			RemoteRole = ROLE_None;
		}
		bAlreadyStarted = true;
	}
}


//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     bInitiallyOn=True
     bTimedTick=True
     MinTickTime=0.15
     InitialState=NormalParticles
     NetUpdateFrequency=4
}
