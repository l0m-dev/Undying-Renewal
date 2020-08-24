//=============================================================================
// Crossbow_Bolt.
//=============================================================================
class Crossbow_Bolt expands Weaponprojectile;

//#exec MESH IMPORT MESH=Crossbow_Bolt_m SKELFILE=Crossbow_Bolt.ngf 
//#exec OBJ LOAD FILE=\Aeons\Sounds\Impacts.uax PACKAGE=Impacts

var() float WindStrMult;
var() float FadeDelay;
var() sound WhooshSound;

var pawn PawnOwner;
var actor a;
var name HitJointName;
var wind wind;
var PersistentWound Wound;
var AeonsPlayer Player;
var bool bPlayedWhoosh;

simulated function PostBeginPlay()
{
	local ScriptedPawn		GPawn;

	Super.PostBeginPlay();

	//Note: SpearTrailFX has RemoteRole already set to ROLE_None
	//		so the server will not try and replicate it to the Client
	if ( Level.NetMode != NM_DedicatedServer )
	{
		a = spawn(class 'SpearTrailFX',self,,Location);
		a.SetBase(self);
	}

	foreach RadiusActors( class'ScriptedPawn', GPawn, 4096 )
		GPawn.LookTargetNotify( self, 2.0 );
}

function Electrify()
{
	Damage = 0;
	LightType = LT_Flicker;
}

auto state Flying
{
	function FindPlayer()
	{
		ForEach AllActors(class 'AeonsPlayer', Player)
			break;
	}

	function Tick(float DeltaTime)
	{
		if ( !Owner.IsA('AeonsPlayer') )
		{
			if ( !bPlayedWhoosh )
			{
				if ( Player == none )
					FindPlayer();
				if (Player != none)
				{
					if ( VSize(Location - Player.Location) <= 256 )
					{
						Player.PlaySound(WhooshSound);
						bPlayedWhoosh = true;
					}
				}
			}
		}
	}

	simulated function ZoneChange(ZoneInfo NewZone)
	{
		if (NewZone.bWaterZone)
			ParticleFX(a).bShuttingDown = true;
	}

	function ProcessTouch (Actor Other, Vector HitLocation)
	{
		local vector HitLoc, HitNormal, Start, End;
		local int HitJoint;
		local DamageInfo DInfo;
		
		if ( Role == ROLE_Authority )
		{
			if (Other != Owner)
			{
				if ( Pawn(Other) != none )
				{
					Start = Location + -Normal(Velocity) * 128;
					End = start + Normal(Velocity) * 128;
					Trace(HitLoc, HitNormal, HitJoint,end, start, true);//,,vect(10,10,10));
					HitJointName = Other.JointName(HitJoint);
					SetOwner(Other);
					PawnOwner = Pawn(Owner);
					bOwnerNoSee = true;
					if (HitJointName != 'none') {
						SetLocation( HitLocation );
						SetBase(Owner, HitJointName, 'none');
						Pawn(Other).PlayDamageMethodImpact('Stab', HitLocation, Normal(Location-HitLocation), HitJointName);
						//Wound = Spawn(class 'SpearWound',Other,,HitLocation, Rotator(HitNormal));
						//Wound.AttachJoint = HitJointName;
						//Wound.setup();
					} else {
						Pawn(Other).PlayDamageMethodImpact('Stab', HitLocation, Normal(Location-HitLocation));
						SetBase(Owner, 'root', 'none');
					}
				}

				DInfo = GetDamageInfo();
				if ( Other.AcceptDamage(DInfo) )
				{
					Other.TakeDamage(instigator,HitLocation, (MomentumTransfer * Normal(Velocity)), DInfo );
					PlaySound(MiscSound, SLOT_Misc, 2.0);
					GotoState('stuck');
				}
			}
		}
	}

	simulated function SetRoll(vector NewVelocity) 
	{
		local rotator newRot;
	
		newRot = rotator(NewVelocity);
		SetRotation(newRot);
	}

	simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
	{
		local int Flags;
		local Texture HitTexture;
		local float decision;

		CheckGenBubbles();

		HitTexture = TraceTexture(location - HitNormal * 128, Location , flags );
		
		SetOwner(none);
		if (HitTexture != none)
		{
			Dust(Location, HitNormal, HitTexture, 1.0);
			switch(HitTexture.ImpactID)
			{
				case TID_Metal:
				case TID_Stone:
					Impact(HitNormal);
					if ( FRand() > 0.5 )
					{
						Velocity = -Velocity * 0.25;
						setPhysics(PHYS_Falling);
					} 
					else
						gotoState('Shatter');
					break;
				
				default:
					Impact(HitNormal);
					gotoState('Stuck');
					break;
			}
		}
		else
			gotoState('Stuck');
	}

	simulated function BeginState()
	{
		wind = spawn(class 'SpearWind',,,Location);
		wind.setBase(self);

		Velocity = Vector(Rotation) * Speed;
		if ( Level.NetMode != NM_DedicatedServer )
		{
			// LoopAnim('Spin',1.0);
			if ( Level.NetMode == NM_Standalone )
				SoundPitch = 200 + 50 * FRand();
		}			
		PawnOwner = none;

	}
}

simulated function Impact(vector HitNormal)
{
	local int Flags;
	local Texture HitTexture;
	
	if ( ImpactSoundClass != None )
	{
		HitTexture = TraceTexture(location - HitNormal * 128, Location , flags );

		if ( HitTexture != None ) 
			PlayImpactSound( 1, HitTexture, 0, Location, 5.0, 1024, 1.0 );
	}

	//PlaySound(ProjImpactSound, SLOT_Misc, 2.0);
	// spawn(class 'BulletSpang',,,Location,Rotator(HitNormal));
	// Explode(Location + ExploWallOut * HitNormal, HitNormal);
	// WallDecal(Location, HitNormal);
}

// stuck in something - an actor or a wall
state stuck
{
	ignores ProcessTouch, Touch, HitWall;

	simulated function Timer()
	{
		local vector HitLocation, HitNormal, End, Start;
		local int HitJoint, Flags;
		local SkyZoneInfo A;
		local LightningBoltOfTheGods lbg;
		local texture tex;

		gotoState('FadeAway');
	}

	simulated function BeginState()
	{
		Wind.Destroy();
		ParticleFX(a).bShuttingDown = true;
		SetCollision(false);
		//PlaySound(StuckSound[Rand(3)]);
		//if ( PawnOwner != none )
		//{
		//	SetPhysics(PHYS_None);
		//}
		SetTimer(2,false);

	}

	Begin:
	

}

state FadeAway
{
	simulated function BeginState()
	{
		disable('Tick');
		SetTimer((LifeSpan - 3), false);
	}

	simulated function Timer()
	{
		Enable('Tick');
	}

	simulated function Tick(float deltaTime)
	{
		if ( FadeDelay > 0.0 ) 
			FadeDelay -= deltaTime;
		else
		{
			Opacity -= (deltaTime / 2.0);
		
			if ( Opacity <= 0.01 )
				Destroy();
		}

	}


}

state Shatter
{

	simulated function BeginState()
	{
		Destroy();
	}
	
	/* //rb net
	Begin:
		Destroy();
	*/
}

simulated function Destroyed()
{
	if (wind != none)
		wind.Destroy();
}

defaultproperties
{
     WindStrMult=0.05
     FadeDelay=10
     WhooshSound=Sound'Impacts.WpnSplSpecific.E_Wpn_GenericWhooshby'
     Speed=2000
     MaxSpeed=3000
     Damage=15
     MomentumTransfer=100
     MyDamageType=spear
     MyDamageString="impaled"
     PawnImpactSound=Sound'Impacts.WpnSplSpecific.E_Wpn_SpearHit01'
     ImpactSound(0)=Sound'Impacts.WpnSplSpecific.E_Wpn_SpearHit01'
     ImpactSound(1)=Sound'Impacts.WpnSplSpecific.E_Wpn_SpearHit01'
     ImpactSound(2)=Sound'Impacts.WpnSplSpecific.E_Wpn_SpearHit01'
     ImpactSoundClass=Class'Aeons.SpearImpact'
     LifeSpan=0
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Crossbow_Bolt_m'
     CollisionRadius=1
     CollisionHeight=2
     LightEffect=LE_FireWaver
     LightBrightness=255
     LightHue=152
     LightSaturation=126
     LightRadius=32
     LightRadiusInner=8
}
