//=============================================================================
// MolotovFire_particles. 
//=============================================================================
class MolotovFire_particles expands AeonsParticleFX;

var float inc, inc2;
var float timeOffset;
var float spreadMax;
var int Damage;

simulated function PreBeginPlay()
{
	super.PreBeginPlay();
	// Texture = Texture'fX.Fire.fire_1';
	inc = FRand();
	inc2 = FRand();
	timeOffset = FRand() * 0.5;
	spreadMax = 128;
	Damage = 3;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if (Region.Zone.bWaterZone)
		gotoState('Extinguish');
}

simulated function ZoneChange(ZoneInfo NewZone)
{
	if (NewZone.bWaterZone)
		Shutdown();
}

auto state Idle
{

	Begin:
		if (Region.Zone.bWaterZone)
			gotoState('Extinguish');
}

function DamageInfo getDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;
	
	DInfo.Damage = Damage;
	if (DamageType == 'none')
		DInfo.DamageType = 'Fire';

	return DInfo;
}


// ===============================================================================================
// Spreading state - big
// ===============================================================================================
state Spreading
{

	function Touch( actor Other )
	{
		if ( Other.AcceptDamage(getDamageInfo()) )
			Other.TakeDamage(Instigator, Location, vect(0,0,0), getDamageInfo());
	}
	
	function Timer()
	{
		local int i;
		
		for (i=0;i<8;i++)
			if ( Touching[i] != None )
				Touch(Touching[i]);
	}

	function Tick(float DeltaTime)
	{
		local int i;
		inc += 0.01;
		inc += 0.07;
		if (SourceWidth.Base < spreadMax)
			SourceWidth.Base += 3;

		if (SourceHeight.Base < spreadMax)
			SourceHeight.Base += 3;

		SetCollisionSize(SourceWidth.Base * 0.5, 32);

		if (ParticlesPerSec.Base < 16)
			ParticlesPerSec.Base += 1;
	}

	function BeginState()
	{
		setPhysics(PHYS_None);
		setRotation(Rotator(vect(0,0,1)));

		SetCollisionSize( 64, 32 );
		SourceDepth.Base = 64;
		SourceHeight.Base = 8;
		SourceWidth.Base = 64;
		Lifetime.Base = 0.2 + FRand();
		ParticlesPerSec.Base = 16 + Rand(16);
	}

	Begin:
		if (Region.Zone.bWaterZone)
			gotoState('Extinguish');
		setTimer(0.2,true);
		sleep((FRand() * 4) + 2);
		gotoState('Extinguish');
	

}


// ===============================================================================================
// Spreading state - small
// ===============================================================================================
state SmallSpread
{
	function Touch( actor Other )
	{
		if (Other.AcceptDamage(GetDamageInfo()))
			Other.TakeDamage(Instigator, Location, vect(0,0,0), getDamageInfo());
		gotoState('Extinguish');
	}
	
	function Timer()
	{
		local int i;
		
		for (i=0;i<8;i++)
			if ( Touching[i] != None )
				Touch(Touching[i]);
	}
	
	function BeginState()
	{
		setPhysics(PHYS_None);
		setRotation(Rotator(vect(0,0,1)));

		Speed.Base = 15;

		// Emitter dimensions.
		SetCollisionSize( 64, 32 );
		SourceHeight.Base = 4;
		SourceWidth.Base = 16;
		SourceDepth.Base = 16;
		
		// Alpha
		AlphaStart.Base = 1;
		AlphaStart.Rand = 0;

		// Drip
		DripTime.Base = 0.25;
		DripTime.Rand = 0.333;

		// Particle Scale
		SizeLength.Base = 32;
		SizeWidth.Base = 32;
		SizeLength.Rand = 32;
		SizeWidth.Rand = 32;

		SizeEndScale.Base = 16;

		AngularSpreadWidth.Base = 15;
		AngularSpreadHeight.Base = 15;
		Lifetime.Base = 0.5;
		Lifetime.Rand = 1;
		ParticlesPerSec.Base = 16;

	}

	Begin:
		if (Region.Zone.bWaterZone)
			gotoState('Extinguish');
		setTimer(0.2,false);
		sleep(4);
		gotoState('Extinguish');

}

state Extinguish
{
	function Timer()
	{
		SoundVolume *= 0.95;
	}

	Begin:
		Shutdown();
		setTimer(0.1,true);
}

defaultproperties
{
     ParticlesPerSec=(Base=32)
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     AngularSpreadWidth=(Base=15)
     AngularSpreadHeight=(Base=15)
     Speed=(Base=10,Rand=100)
     Lifetime=(Base=0.25,Rand=3)
     ColorStart=(Base=(G=247,B=84))
     ColorEnd=(Base=(R=204))
     AlphaStart=(Base=0.25,Rand=0.25)
     SizeWidth=(Base=16)
     SizeLength=(Base=16)
     SizeEndScale=(Base=6,Rand=8)
     SpinRate=(Base=-3,Rand=6)
     DripTime=(Rand=0.5)
     Damping=1
     WindModifier=1
     GravityModifier=0.35
     Textures(0)=Texture'Aeons.Particles.PotFire08'
     Physics=PHYS_Falling
     LODBias=5
     CollisionRadius=16
     CollisionHeight=16
     bCollideActors=True
     bCollideWorld=True
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=198
     LightHue=28
     LightSaturation=65
     LightRadius=12
     LightRadiusInner=8
}
