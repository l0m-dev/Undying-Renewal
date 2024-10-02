//=============================================================================
// Fragment.
//=============================================================================
class Fragment extends Projectile;

var() MESH Fragments[11];
var int numFragmentTypes;
var bool bFirstHit;

simulated function PostBeginPlay()
{
	if ( Region.Zone.bDestructive )
		Destroy();
	else
		Super.PostBeginPlay();
}

simulated function CalcVelocity(vector Momentum, float ExplosionSize)
{
	Velocity = VRand()*(ExplosionSize+FRand()*150.0+100.0 + VSize(Momentum)/80); 
}

simulated function HitWall (vector HitNormal, actor HitWall, byte TextureID)
{
	Velocity = 0.5*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	Speed = VSize(Velocity);	
	if (bFirstHit && Speed<400) 
	{
		bFirstHit=False;
		bRotatetoDesired=True;
		bFixedRotationDir=False;
		DesiredRotation.Pitch=0;	
		DesiredRotation.Yaw=FRand()*65536;
		DesiredRotation.roll=0;
	}
	RotationRate.Yaw = RotationRate.Yaw*0.75;
	RotationRate.Roll = RotationRate.Roll*0.75;
	RotationRate.Pitch = RotationRate.Pitch*0.75;
	if ( (Speed < 60) && (HitNormal.Z > 0.7) )
	{
		SetPhysics(PHYS_none);
		bBounce = false;
		GoToState('Dying');
	}
	else If (Speed > 50) 
	{
		//rb impact if (FRand()<0.5) PlaySound(ImpactSound, SLOT_None, 0.5+FRand()*0.5,, 300, 0.85+FRand()*0.3);
		//rb impact else PlaySound(MiscSound, SLOT_None, 0.5+FRand()*0.5,, 300, 0.85+FRand()*0.3);
	}
}

auto state Flying
{
	simulated function timer()
	{
		GoToState('Dying');
	}


	simulated function Touch(actor Other)
	{
		if (Pawn(Other)==None) Return;
		if (!Pawn(Other).bIsPlayer) Destroy();
	}


	simulated singular function ZoneChange( ZoneInfo NewZone )
	{
		local float splashsize;
		local actor splash;

		if ( NewZone.bWaterZone )
		{
			Velocity = 0.2 * Velocity;
			splashSize = 0.0005 * (250 - 0.5 * Velocity.Z);
			if ( Level.NetMode != NM_DedicatedServer )
			{
				if ( NewZone.EntrySound != None )
					PlaySound(NewZone.EntrySound, SLOT_Interact, splashSize);
				if ( NewZone.EntryActor != None )
				{
					splash = Spawn(NewZone.EntryActor); 
					if ( splash != None )
						splash.DrawScale = 4 * splashSize;
				}
			}
			if (bFirstHit) 
			{
				bFirstHit=False;
				bRotatetoDesired=True;
				bFixedRotationDir=False;
				DesiredRotation.Pitch=0;	
				DesiredRotation.Yaw=FRand()*65536;
				DesiredRotation.roll=0;
			}
			
			RotationRate = 0.2 * RotationRate;
			GotoState('Dying');
		}
		if ( NewZone.bPainZone && (NewZone.DamagePerSec > 0) )
			Destroy();
	}

	simulated function BeginState()
	{
		RandSpin(125000);
		if (RotationRate.Pitch>-10000&&RotationRate.Pitch<10000) 
			RotationRate.Pitch=10000;
		if (RotationRate.Roll>-10000&&RotationRate.Roll<10000) 
			RotationRate.Roll=10000;			
		Mesh = Fragments[int(FRand()*numFragmentTypes)];
		if ( Level.NetMode == NM_Standalone )
			LifeSpan = 20 + 40 * FRand();
		SetTimer(5.0,True);			
	}
}

state Dying
{
	simulated function HitWall (vector HitNormal, actor HitWall, byte TextureID)
	{
		Velocity = 0.5*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
		Speed = VSize(Velocity);	
		if (bFirstHit && Speed<400) 
		{
			bFirstHit=False;
			bRotatetoDesired=True;
			bFixedRotationDir=False;
			DesiredRotation.Pitch=0;	
			DesiredRotation.Yaw=FRand()*65536;
			DesiredRotation.roll=0;
		}
		RotationRate.Yaw = RotationRate.Yaw*0.75;
		RotationRate.Roll = RotationRate.Roll*0.75;
		RotationRate.Pitch = RotationRate.Pitch*0.75;
		if ( (Velocity.Z < 50) && (HitNormal.Z > 0.7) )
		{
			SetPhysics(PHYS_none);
			bBounce = false;
		}
		else If (Speed > 80)  
		{
			//rb impact if (FRand()<0.5) PlaySound(ImpactSound, SLOT_None, 0.5+FRand()*0.5,, 300, 0.85+FRand()*0.3);
			//rb impact else PlaySound(MiscSound, SLOT_None, 0.5+FRand()*0.5,, 300, 0.85+FRand()*0.3);
		}
	}

	function TakeDamage( Pawn instigatedBy, Vector hitlocation, Vector momentum, DamageInfo DInfo)
	{
		Destroy();
	}

	simulated function timer()
	{
		if (!PlayerCanSeeMe()) 
			Destroy();
	}

	simulated function BeginState()
	{
		SetTimer(1.5,True);
		SetCollision(true, false, false);
	}
}

defaultproperties
{
     bFirstHit=True
     bNetOptional=True
     Physics=PHYS_Falling
     LifeSpan=20
     CollisionRadius=18
     CollisionHeight=4
     bCollideActors=False
     bBounce=True
     bFixedRotationDir=True
     NetPriority=1.4
}
