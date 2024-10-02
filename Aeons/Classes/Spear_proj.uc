//=============================================================================
// Spear_proj.
//=============================================================================
class Spear_proj expands WeaponProjectile;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Impacts.uax PACKAGE=Impacts

var() float WindStrMult;
var() float FadeDelay;
var() sound WhooshSound;

var AeonsPlayer Player;
var bool bCharged;
var pawn PawnOwner;
var actor a;
var name HitJointName;
var wind wind;
var PersistentWound Wound;
var bool bPlayedWhoosh;

var float StickTime;

replication
{
	reliable if (Role == ROLE_Authority)
		bCharged;
}

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

function AttachBloodySpear(name JointName)
{
	local Actor BloodySpear;

	BloodySpear = spawn(class 'Spear_Bloody',Owner,,Owner.JointPlace(JointName).pos,Rotation);
	BloodySpear.SetBase(Owner, JointName, 'none');
	bHidden = true;
}

function DamageInfo getDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;

	if ( DamageType == 'none' )
		DamageType = MyDamageType;

	if ( bCharged && (DamageType == 'LightningBoltOfGods'))
	{
		DInfo.Damage = 500;
		DInfo.bMagical = true;
	} else	{
		DInfo.Damage = Damage;
		DInfo.bMagical = false;
	}
	
	DInfo.DamageString = MyDamageString;
	DInfo.DamageType = DamageType;
	DInfo.Deliverer = self;
	DInfo.ImpactForce = Velocity;
//	DInfo.JointName = CheckJoint();
	DInfo.JointName = HitJointName;
	DInfo.DamageMultiplier = 1.0;

	return DInfo;
}

function Electrify()
{
	bCharged = true;
	Damage = 60;
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
			ParticleFX(a).Shutdown();
	}

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		local vector HitLoc, HitNormal, Start, End;
		local int HitJoint;
		local bool bGenBlood;

		
		//logactorstate("processtouch");
//		if ( Role == ROLE_Authority )
//		{
			if (Other != Owner)
			{
				if ( Pawn(Other) != none )
				{
					// ScriptedPawn
					if (Other.IsA('ScriptedPawn'))
						if (!ScriptedPawn(Other).bNoBloodPool)
							 bGenBlood = true;
					
					// Player
					if (Other.IsA('PlayerPawn'))
						bGenBlood = true;

					// Gneerate Blood?
					if (bGenBlood)
						Spawn(class'BloodHitFX', , , HitLocation, rotator(-Velocity));
					
//					Start = Location + -Normal(Velocity) * 512;
//					End = start + Normal(Velocity) * 512;
					Start = Location;
					End = OldLocation;
					Trace(HitLoc, HitNormal, HitJoint,end, start, true);
					HitJointName = Other.JointName(HitJoint);
					SetOwner(Other);
					PawnOwner = Pawn(Owner);
					bOwnerNoSee = true;
					if (HitJointName != 'none') 
					{
						//rb this isn't simulated so they can't be called by clients, right ?
						Pawn(Other).PlayDamageMethodImpact('Stab', HitLocation, Normal(Location-HitLocation), HitJointName);
						
						// Generate Blood?
						if (bGenBlood)
						{
							Wound = Spawn(class 'SpearWound',Other,,HitLocation, Rotator(Normal(OldLocation-Location)));
							Wound.AttachJoint = HitJointName;
							Wound.setup();
						}
					} 
					else 
					{
						//rb this isn't simulated so they can't be called by clients, right ?
						Pawn(Other).PlayDamageMethodImpact('Stab', HitLocation, Normal(Location-HitLocation));
					}
				}

				if ( Role >= ROLE_Authority )
					if (Other.AcceptDamage(getDamageInfo()))
						if( Other.IsA('King_Part') && bCharged )
							DoLightningBoltOfGodsOnKing( King_Part(Other) );
						else {
							if ( Other.IsA('AeonsPlayer') ) {
								HitLocation = Other.Location - Normal(Velocity);
								Other.TakeDamage(instigator,HitLocation, (MomentumTransfer * Normal(Velocity)), getDamageInfo() );
							} else
								Other.TakeDamage(instigator,HitLocation, (MomentumTransfer * Normal(Velocity)), getDamageInfo() );
						}

				PlaySound(MiscSound, SLOT_Misc, 2.0);
				gotoState('stuck');
			}
//		}
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
/*
				case TID_Metal:
				case TID_Stone:
					Impact(HitNormal);
					if ( FRand() > 0.5 )
					{
						Velocity = -Velocity * 0.25;
						setPhysics(PHYS_Falling);
					} 
					else
					{
						Impact(HitNormal);
						GotoState('Stuck');
					}
					break;
	*/			
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

function DoLightningBoltOfGodsOnKing( King_Part Other )
{
	local vector HitLocation, HitNormal, End, Start;
	local int HitJoint, Flags;
	local SkyZoneInfo A;
	local LightningBoltOfTheGods lbg;
	local texture HitTexture;
	local float bestDist;
	local int i;

	Start = Location;
			
	if ( Other.Health <= 0 )
		return;

	End = Start + vect(0,0,65536);
			
	HitTexture = TraceTexture(End, start, Flags);

	if( HitJointName == 'none' )
	{
		bestDist = VSize( start - Other.JointPlace( Other.JointName( 0 ) ).pos );
		HitJointName = Other.JointName( 0 );

		for(i = 1; i < Other.NumJoints(); ++i)
		{
			if( VSize( start - Other.JointPlace( Other.JointName( i ) ).pos ) < bestDist )
			{
				bestDist = VSize( start - Other.JointPlace( Other.JointName( i ) ).pos );
				HitJointName = Other.JointName( i );
			}
		}
	}

	if ( (HitTexture.name == 'S_SkyZone') && 
		 ((Other.IsA('King_Body') && King_Body(Other).IsBrainJoint(HitJointName)) ||
		  Other.IsA('King_Mouth') ||
		  Other.IsA('King_L_Mandible') ||
		  Other.IsA('King_R_Mandible')) )
	{
		Trace(HitLocation, HitNormal, HitJoint, End, Start, false);
				
		if ( VSize(HitLocation-start) > 8192)
			HitLocation = Start + vect(0,0,8192);

		Lbg = Spawn(class 'LightningBoltOfTheGods',,,start);
		Lbg.Strike(HitLocation, Start);
		Other.TakeDamage(instigator, Start, (MomentumTransfer * Normal(Velocity)), getDamageInfo('LightningBoltOfGods') );
	}		
	else
		Other.TakeDamage(instigator, Start, (MomentumTransfer * Normal(Velocity)), getDamageInfo() );
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


singular event BaseChange()
{
	log("BaseChange: Base = " $ Base );
	if ( Base == None ) 
		gotoState('FadeAway');
}

// stuck in something - an actor or a wall
state stuck
{
	ignores ProcessTouch, Touch, HitWall;

	simulated function Tick( float DeltaTime ) 
	{
		/*
		if (( Owner != None ) && (Pawn(Owner).Health <= 0))
		{
			// log("Spear_Proj: state Stuck: Tick:  Owner health depleted, detaching");
			SetOwner(None);
			// SetPhysics(PHYS_Falling);
			gotoState('FadeAway');
		}
		*/
	}

	simulated function Timer()
	{
		local vector HitLocation, HitNormal, End, Start;
		local int HitJoint, Flags;
		local SkyZoneInfo A;
		local LightningBoltOfTheGods lbg;
		local texture HitTexture;

		LightType = LT_None;
		if ( bCharged && (Owner == None || !Owner.IsA('King_Part')) )
		{
			if (Owner != None && Owner.IsA('Patrick'))
				SetOwner(none);

			if ( (Owner != none) )
				Start = Owner.Location + Owner.CollisionHeight * vect(0,0,1.0);
			else
				Start = Location;
			
			// make sure we're not hitting a dead guy.
			//if (Owner.IsA('Pawn'))
			//	if ( Pawn(Owner).Health <= 0 )
			//		return;

			End = Start + vect(0,0,65536);
			
			HitTexture = TraceTexture(End, start, Flags);

			// try 4 more times
			// RGC()? this just makes lbg more consistent
			if ( HitTexture.name != 'S_SkyZone' )
			{
				End = Start + vect(-64,0,65536);
				HitTexture = TraceTexture(End, start + vect(-64,0,0), Flags);
			}
			if ( HitTexture.name != 'S_SkyZone' )
			{
				End = Start + vect(64,0,65536);
				HitTexture = TraceTexture(End, start + vect(64,0,0), Flags);
			}
			if ( HitTexture.name != 'S_SkyZone' )
			{
				End = Start + vect(0,-64,65536);
				HitTexture = TraceTexture(End, start + vect(0,-64,0), Flags);
			}
			if ( HitTexture.name != 'S_SkyZone' )
			{
				End = Start + vect(0,64,65536);
				HitTexture = TraceTexture(End, start + vect(0,64,0), Flags);
			}

			if ( HitTexture.name == 'S_SkyZone' )
			{
				Trace(HitLocation, HitNormal, HitJoint, End, Start, false);
				
				//if ( VSize(HitLocation-start) > 8192 )
					HitLocation = Start + vect(0,0,8192);

				Lbg = Spawn(class 'LightningBoltOfTheGods',,,start);
				Lbg.Strike(HitLocation, Start + vect(0,0,-128));
				if ( Owner != none )
				{
					if ( Owner.IsA('AeonsPlayer') )
					{
						if ( !AeonsPlayer(Owner).ShalasMod.bActive )
						{
							Spawn (class 'LBGGlowFX',Owner,,Location); 
							Owner.Velocity = vect(0,0,0);
							Owner.SetPhysics(PHYS_None);
						}
					} else if( Owner.IsA('Bethany') ) {
						Spawn (class 'LightningGlowFX',Owner,,Location); 
						Owner.Velocity = vect(0,0,0);
						Owner.SetPhysics(PHYS_None);
					} else {
						Spawn (class 'LBGGlowFX',Owner,,Location); 
						Owner.Velocity = vect(0,0,0);
						Owner.SetPhysics(PHYS_None);
					}
				}
				
				if (Owner != None)
				{
					ScriptedPawn(Owner).StopMovement();
					Pawn(Owner).LoopAnim('Death_PowerWord_Cycle',2,,,0);
				}
				Spawn (class 'Aeons.LBGExplosion',,,start + vect(0,0,32));
				if ( Owner != None && Owner.AcceptDamage(GetDamageInfo()) )
					Pawn(Owner).TakeDamage( none, Owner.Location, vect(0,0,0), GetDamageInfo('LightningBoltOfGods'));
				Destroy();
			} else if ( Wound != none ) {
				GotoState('Shatter');
			} else {
				GotoState('FadeAway');
			}
		} 
		else if ( Wound != none ) {
			GotoState('Shatter');
		}
		else
		{
			GotoState('FadeAway');
		}
	}

	simulated function BeginState()
	{
		if ( Wind != None )
			Wind.Destroy();
		if ( a!=None )
			ParticleFX(a).Shutdown();
		SetCollision(false, false, false);
		MaxSpeed = 0;
		SetTimer(0.15,false);
	}

	Begin:
		

}

state FadeAway
{
	simulated function BeginState()
	{
		disable('Tick');
		SetTimer((StickTime), false);
	}

	simulated function Timer()
	{
		Enable('Tick');
//		bCollideWorld=false;
//		bCollideActors=false;
		// SetPhysics(PHYS_Falling);
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
     StickTime=5
     Speed=6000
     MaxSpeed=10000
     Damage=60
     MomentumTransfer=100
     MyDamageType=spear
     MyDamageString="skewered"
     PawnImpactSound=Sound'Impacts.WpnSplSpecific.E_Wpn_SpearHit01'
     ImpactSound(0)=Sound'Impacts.WpnSplSpecific.E_Wpn_SpearHit01'
     ImpactSound(1)=Sound'Impacts.WpnSplSpecific.E_Wpn_SpearHit01'
     ImpactSound(2)=Sound'Impacts.WpnSplSpecific.E_Wpn_SpearHit01'
     ImpactSoundClass=Class'Aeons.SpearImpact'
     Mesh=SkelMesh'Aeons.Meshes.Spear_proj_m'
     LightEffect=LE_FireWaver
     LightBrightness=255
     LightHue=152
     LightSaturation=126
     LightRadius=32
     LightRadiusInner=8
}
