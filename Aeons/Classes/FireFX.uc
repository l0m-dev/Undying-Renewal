//=============================================================================
// FireFX.
//=============================================================================
class FireFX expands AeonsParticleFX;

var() bool bCausesDamage;
var() bool bDynamic;
var() float DynamicLifetime;
var Actor A;

function ZoneChange(ZoneInfo NewZone)
{
	if (NewZone.bWaterZone)
		Shutdown();
}

simulated function BeginPlay()
{
	Super.BeginPlay();
	if ( bDynamic )
		GotoState('DynamicState');
	
	if ( bCausesDamage )
	{
		A = spawn(class 'FireTrigger', Pawn(Owner),,Location, Rotator(vect(0,0,1)));
		if ( A != None )
			A.SetBase(self);
	}
}

simulated function MakeDynamic()
{
	bDynamic = true;
	GotoState('DynamicState');
}

state DynamicState
{
	simulated function Timer()
	{
		local Texture HitTexture;
		local vector Start, End;
		local int Flags;
		
		Start = Location;
		End = Location + vect(0,0,-1) * 64;

		HitTexture = TraceTexture(End, Start, Flags);
		
		if (HitTexture != none)
			DynamicLifetime = HitTexture.Flammability * DynamicLifetime;
		else
			DynamicLifetime = 0.5f * DynamicLifetime;

		if (DynamicLifetime == 0)
			DynamicLifetime = 0.01;

		GotoState('DynamicHold');
		
	
	}

	simulated function BeginState()
	{
		SetTimer(0.25, true);
		
	}
}

state DynamicHold
{
	simulated function Timer()
	{
		GotoState('SlowShutDown');
	}

	simulated function BeginState()
	{
		SetTimer(DynamicLifetime, false);
	}
/*
	Begin:
		SetTimer(DynamicLifetime, false);
*/
}

state SlowShutDown
{
	simulated function Timer()
	{
		local ParticleFX A;

		Lifetime.Base *= 0.75;
		if (Lifetime.Base < 0.2)
		{
			ForEach AllActors(class 'ParticleFX',A)
			{
				if (A.Owner == self)
					A.Shutdown();
			}
	
			Shutdown();
		}
	}

	simulated function BeginState()
	{
		SetTimer(0.1, true);
	}
/*
	Begin:
		SetTimer(0.1, true);
*/
}

simulated function Destroyed()
{
	A.Destroy();
}

defaultproperties
{
     bCausesDamage=True
     DynamicLifetime=7
     ParticlesPerSec=(Base=32,Rand=32)
     SourceWidth=(Base=16)
     SourceHeight=(Base=16)
     SourceDepth=(Base=16)
     Speed=(Base=0)
     Lifetime=(Base=0.25,Rand=0.5)
     ColorStart=(Base=(R=250,G=166,B=90))
     SizeWidth=(Base=16)
     SizeLength=(Base=16)
     SizeEndScale=(Base=0,Rand=8)
     SpinRate=(Base=-8,Rand=16)
     AlphaDelay=0.25
     Chaos=16
     Damping=2
     WindModifier=1
     Gravity=(Z=300)
     Textures(0)=Texture'Aeons.Particles.PotFire08'
     LODBias=20
     AmbientSound=Sound'Aeons.Weapons.E_Wpn_MoltFireLoop01'
     CollisionRadius=64
     CollisionHeight=64
     bCollideActors=True
}
