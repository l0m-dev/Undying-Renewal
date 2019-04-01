//=============================================================================
// Pellet_proj.
//=============================================================================
// used by the Shotgun
class Pellet_proj expands WeaponProjectile;

var bool bCanRicochet, bMakeImpactSound;
var BulletScriptFX trail;

simulated function PreBeginPlay()
{
	// bCanRicochet = true;
	super.PreBeginPlay();
}

simulated function ZoneChange( Zoneinfo NewZone )
{
	// log("ZONE CHANGE");
	if ( NewZone.bWaterZone )
	{
		Velocity = Normal(Velocity) * default.speed * 0.5;

		EnterWaterLocation = Location;
		if (bMakeImpactSound)
			spawn(class 'WaterHitFX',,,Location, rotator(vect(0,0,1)));
	}
}

function HitPawn(vector HitLocation)
{
	PlaySound(PawnImpactSound, SLOT_Misc, 2.0);
	ParticleHitFX(HitLocation, -Normal(Velocity), 'Blood');
}

simulated function ParticleHitFX(vector HitLocation, vector HitNormal, optional name type)
{
	if ( type == 'Blood' )
	{
		// Spawn(class'BloodHitFX', , , HitLocation, rotator(HitNormal));
		// Spawn(class 'BloodSplatDecal',,,HitLocation, rotator((HitNormal + (VRand() * 0.15))));
	}
	//else
	//	Spawn(class'RevolverHitFX', , , HitLocation, rotator(HitNormal));
}

auto state Flying
{
	simulated function BeginState()
	{
		SetTimer(0.2, false);
		Velocity = Vector(Rotation) * (speed + (RandRange(-1.0, 1.0) * (0.25 * speed)));

		if ( Level.NetMode != NM_DedicatedServer )
		{
			// LoopAnim('Spin',1.0);
			if ( Level.NetMode == NM_Standalone )
				SoundPitch = 200 + 50 * FRand();
		}			
	}

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		local DamageInfo DInfo;

		if ( (Other != instigator) || (bCanHitInstigator) )
		{
			if ( Role == ROLE_Authority )
			{
				DInfo = GetDamageInfo();
				DInfo.ImpactForce *= 0.25;
				Other.ProjectileHit(Instigator, HitLocation, MomentumTransfer * Normal(Velocity), self, DInfo);
			}

			PlaySound(PawnImpactSound,,4.0,,1024,1.0);
			if ( Other.IsA('Pawn') )
			{
				if (FRand() < 0.5)
					Pawn(Other).PlayDamageMethodImpact('Bullet', HitLocation, -Normal(Velocity)); //Normal(Location-HitLocation));
				// ParticleHitFX(Location, -Normal(Velocity), 'Blood');
			}
		}

		/*
			if ( Role == ROLE_Authority )
			{
				Other.ProjectileHit(Pawn(Owner), HitLocation, momentumTransfer * Normal(Velocity), self, getDamageInfo());
				Pawn(Other).PlayDamageMethodImpact('Bullet', HitLocation, -Normal(Velocity)); // Normal(Location-HitLocation));
				HitPawn(HitLocation);
			}
		*/
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		CheckGenBubbles();
		ParticleHitFX(HitLocation, HitNormal);
		Destroy();
	}
	
	// ricochetting off a surface
	simulated function ricochet(vector HitNormal)
	{
		local vector rndDir;
		
		rndDir = Normal(reflect(-Normal(Velocity), HitNormal) + (VRand() * 0.35));
		if ( !CheckGenBubbles() )
		{
			trail = spawn(class 'BulletScriptFX',,,Location);
			trail.inVec = Normal(Velocity);
			if ( VSize(Location - spawnLoc) < 200 )
				trail.trailLen = VSize(Location - spawnLoc) * 0.5;
			else
				trail.trailLen = 200;

			trail.scaleFactor = 1.0;
			trail.outVec = rndDir * speed;
			trail.genEffect();
		}

		Velocity = rndDir * speed;
		setRotation(Rotator(Velocity));

		damage *= 0.5;

		spawnLoc = Location;
		bCanRicochet = false;
		bCanHitInstigator = true;
		PlaySound(MiscSound, SLOT_Misc, 2.0);
	}
	
	// impacting a surface
	simulated function Impact(vector HitNormal, optional Texture Tex)
	{
		local int Flags;
		local Texture HitTexture;
		local bool bGlassStrike;

		if ( ImpactSoundClass != None )
		{
			if (Tex != none)
			{
				HitTexture = Tex;
				TraceTexture(Location + (HitNormal * -32), location + (HitNormal * 32) , Flags );
			} else {
				HitTexture = TraceTexture(Location + (HitNormal * -32), location + (HitNormal * 32) , Flags );
			}
			
			//log("Bullet - Strike surface Flags = "$Flags, 'Misc');
			if ( (134217728 & Flags) != 0)
			{
				bGlassStrike = true;
				//log("Bullet - GlassStrike = TRUE", 'Misc');
			}

			if ( bGlassStrike )
			{
				GlassDecal(Location, HitNormal);
			} else {
				if ( HitTexture != none )
				{
					switch (HitTexture.ImpactID)
					{
						// Don't create anything for water impacts.... handled by the texture hit effect.
						case TID_Water:
							Spawn(class 'WaterHitFX',,,Location, rotator(vect(0,0,1)));
							break;
		
						case TID_Glass:
							GlassDecal(Location, HitNormal);
							break;

						default:
							if ( bMakeImpactSound )
								PlayImpactSound( 1, HitTexture, 0, Location, 5.0, 1024, 1.0 );
							WallDecal(Location, HitNormal);
							spawn(class 'BulletSpang',,,Location,Rotator(HitNormal));
					};

					MakeNoise(1.0, 512);
					Dust(Location, HitNormal, HitTexture, 1.0);
				}
			}
	
		}
		Explode(Location + ExploWallOut * HitNormal, HitNormal);
	}
	/*
	simulated function Impact(vector HitNormal)
	{
		local int Flags;
		local Texture HitTexture;
	
		if ( ImpactSoundClass != None )
		{
			// t = TraceTexture(End, Start, Flags);
			HitTexture = TraceTexture(location - HitNormal * 8, location , flags );
	
			if ( HitTexture != None ) 
			{
				if ( Frand() > 0.5 )
					Dust(Location, HitNormal, HitTexture, 0.5);
				if ( bMakeImpactSound )
					PlayImpactSound( 1, HitTexture, 0, Location, 5.0, 1024, 1.0 );
			}
		}

		// PlaySound(ProjImpactSound, SLOT_Misc, 2.0);
		spawn(class 'BulletSpang',,,Location,Rotator(HitNormal));
		Explode(Location + ExploWallOut * HitNormal, HitNormal);
		WallDecal(Location, HitNormal);
	}*/

	simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
	{
		if ( Role == ROLE_Authority )
		{
			if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
				if (Wall.AcceptDamage(GetDamageInfo()))
					Wall.TakeDamage(instigator, Location, MomentumTransfer * Normal(Velocity), getDamageInfo());
	
			MakeNoise(1.0);
		}

		if ( bCanRicochet )
		{
			switch(textureID)
			{
				case 12:					// Stone
				case 13:					// Metal
					ricochet(HitNormal);
					break;
	
				default:					// default
					Impact(HitNormal);
					break;
			}
		} else {
			Impact(HitNormal);
		}
	}

}

defaultproperties
{
     bMakeImpactSound=True
     HeadShotMult=2
     Speed=10000
     MaxSpeed=50000
     Damage=6
     MomentumTransfer=500
     MyDamageType=pellet
     MyDamageString="shot"
     PawnImpactSound=Sound'Impacts.WpnSplSpecific.E_Wpn_ShotHit01'
     ExplosionDecal=Class'Aeons.BulletDecal'
     ImpactSound(0)=Sound'Impacts.SurfaceSpecific.E_Wpn_ShotHitGen01'
     ImpactSound(1)=Sound'Impacts.SurfaceSpecific.E_Wpn_ShotHitGen02'
     ImpactSound(2)=Sound'Impacts.SurfaceSpecific.E_Wpn_ShotHitGen03'
     ImpactSoundClass=Class'Aeons.ShotImpact'
     LifeSpan=1
     DrawScale=0.1
     bBounce=True
}
