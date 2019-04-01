//=============================================================================
// SilverBullet_proj.
//=============================================================================
class SilverBullet_proj expands SpellProjectile;

//----------------------------------------------------------------------------

var bool bInWater;				// Projectile is in the water
var int maxWallHits, numWallHits;
var BulletScriptFX trail;

//----------------------------------------------------------------------------

simulated function PreBeginPlay()
{
	// log("..................................PreBeginPlay");
	if (Region.Zone.bWaterZone)
	{
		log("PreBeginPlay - in Water");
		bInWater = true;
	}
	maxWallHits	= 2;
	super.PreBeginPlay();
}

//----------------------------------------------------------------------------

simulated function ZoneChange( Zoneinfo NewZone )
{
	// log("..................................Zone Change");
	// log("ZONE CHANGE");
	if ( NewZone.bWaterZone)
	{
		if (!bInWater )
		{
			bInWater = true;
			Velocity = Normal(Velocity) * default.speed * 0.5;
	
			EnterWaterLocation = Location;
			spawn(class 'WaterHitFX',,,Location, rotator(vect(0,0,1)));
		}
	} else
		bInWater = false;
}

//----------------------------------------------------------------------------

simulated function ParticleHitFX(vector HitLocation, vector HitNormal, optional name type)
{
	/*
	if ( type == 'Blood' )
	{
		Spawn(class'BloodPuffFX', , , HitLocation, rotator(HitNormal));
		Spawn(class 'BloodSplatDecal',,,HitLocation, rotator(HitNormal));
	}
	else
		Spawn(class'RevolverHitFX', , , HitLocation, rotator(HitNormal));
	*/
}

//=============================================================================
// Flying State
//=============================================================================

auto state Flying
{
	simulated function BeginState()
	{
		SetTimer(0.2, false);
		Velocity = Vector(Rotation) * speed;
		if ( Level.NetMode != NM_DedicatedServer )
		{
			// LoopAnim('Spin',1.0);
			if ( Level.NetMode == NM_Standalone )
				SoundPitch = 200 + 50 * FRand();
		}			
	}


	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		
		if ( (Other != instigator) || (bCanHitInstigator) )
		{
			if ( Role == ROLE_Authority )
				Other.ProjectileHit(Instigator, HitLocation, MomentumTransfer * Normal(Velocity), self, GetDamageInfo());

			PlaySound(PawnImpactSound,,4.0,,1024,1.0);
			if ( Other.IsA('Pawn') )
			{
				Pawn(Other).PlayDamageMethodImpact('Bullet', HitLocation, -Normal(Velocity)); //Normal(Location-HitLocation));
				ParticleHitFX(HitLocation, -Normal(Velocity), 'Blood');
			}
		}
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
		Damage = default.Damage * 0.5;
		if (!CheckGenBubbles())
		{
			trail = spawn(class 'BulletScriptFX',,,Location);
			trail.inVec = Normal(Velocity);
			if ( VSize(Location - spawnLoc) < 128 )
				trail.trailLen = VSize(Location - spawnLoc) * 0.75;
			else
				trail.trailLen = 128;

			trail.scaleFactor = 1.0;
			trail.outVec = reflect(-Normal(Velocity), HitNormal) * speed;
			trail.genEffect();
		}

		Velocity = reflect(-Normal(Velocity), HitNormal) * speed;
		setRotation(Rotator(Velocity));

		spawnLoc = Location;
		numWallHits ++;
		bCanHitInstigator = true;
		MakeNoise(1.0, 512);
		PlaySound(RicochetSounds[Rand(3)], SLOT_Misc, 2.0);
	}
	
	// impacting a surface
	simulated function Impact(vector HitNormal, optional Texture Tex)
	{
		local int Flags;
		local Texture HitTexture;
		
		if ( ImpactSoundClass != None )
		{
			if (Tex != none)
				HitTexture = Tex;
			else
				HitTexture = TraceTexture(location - HitNormal * 8, location , flags );
			
			if (HitTexture != none)
			{
				switch (HitTexture.ImpactID)
				{
					// Don't create anything for water impacts.... handled by the texture hit effect.
					case TID_Water:
						break;
	
					default:
						WallDecal(Location, HitNormal);
						spawn(class 'BulletSpang',,,Location,Rotator(HitNormal));
				};

				MakeNoise(1.0, 512);
				PlayImpactSound( 1, HitTexture, 0, Location, 5.0, 1024, 1.0 );
				Dust(Location, HitNormal, HitTexture, 1.0);
			}
	
		}
		Explode(Location + ExploWallOut * HitNormal, HitNormal);
	}

	simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
	{
		local int Flags;
		local Texture HitTexture;

		if ( Role == ROLE_Authority )
		{
			if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
				if ( Wall.AcceptDamage(GetDamageInfo()) )
					Wall.TakeDamage(instigator, Location, MomentumTransfer * Normal(Velocity), getDamageInfo());
			MakeNoise(1.0);
		}

		HitTexture = TraceTexture(location - HitNormal * 64, location + HitNormal * 64 , flags );
		
		if ( numWallHits < maxWallHits )
		{
			if (HitTexture != none)
			{
				switch (HitTexture.ImpactID)
				{
						case TID_Stone:					// Stone
						case TID_Metal:					// Metal
							ricochet(HitNormal);
							break;
			
						default:					// default
							Impact(HitNormal, HitTexture);
							break;
				};
			} else {
				Impact(HitNormal);
			}
		} else {
			Impact(HitNormal);
		}
	}

	Begin:
		
}

defaultproperties
{
     damagePerLevel(0)=30
     damagePerLevel(1)=30
     damagePerLevel(2)=30
     damagePerLevel(3)=30
     damagePerLevel(4)=30
     Speed=5000
     MaxSpeed=50000
     Damage=30
     MomentumTransfer=10
     MyDamageType=SilverBullet
     MyDamageString="shot"
     bMagical=True
     PawnImpactSound=Sound'Impacts.WpnSplSpecific.E_Wpn_RevHit01'
     ExplosionDecal=Class'Aeons.BulletDecal'
     RicochetSounds(0)=Sound'Impacts.SurfaceSpecific.E_Wpn_RevHitRico01'
     RicochetSounds(1)=Sound'Impacts.SurfaceSpecific.E_Wpn_RevHitRico02'
     RicochetSounds(2)=Sound'Impacts.SurfaceSpecific.E_Wpn_RevHitRico03'
     ImpactSound(0)=Sound'Impacts.SurfaceSpecific.E_Wpn_RevHitGen01'
     ImpactSound(1)=Sound'Impacts.SurfaceSpecific.E_Wpn_RevHitGen02'
     ImpactSound(2)=Sound'Impacts.SurfaceSpecific.E_Wpn_RevHitGen03'
     ImpactSoundClass=Class'Aeons.RevImpact'
     LifeSpan=5
     DrawType=DT_None
     DrawScale=0.1
     bProjTarget=True
     bBounce=True
     Mass=1
}
