//=============================================================================
// FallingProjectile. 
//=============================================================================
class FallingProjectile expands Projectile;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Impacts.uax PACKAGE=Impacts

var() const enum ECollision
{
	COL_None,
	COL_Method_1,
	COL_Method_2,
	COL_Method_3,
	COL_Method_4
} CollisionMethod;

var() float WindStrMult;
var() float Elasticity;
var() class <ParticleFX> TrailClass;
var() bool bDestroyInWater;
var() bool bScaleDownWhenStopped;
var() bool bDestroyOnHitWall;

var ParticleFX Trail;
var int cnt;
var bool bAvg;

simulated function PreBeginPlay()
{
	super.PreBeginPlay();
	Velocity = Vector(rotation) * (200 + FRand() * 400);
}


simulated function ZoneChange(zoneInfo NewZone)
{	
	if (bDestroyInWater)
		if ( NewZone.BWaterZone )
		{
			spawn(class 'SmallShotgunSmokeFX',,,Location, rotator(vect(0,0,1)));
			Destroy();
		}
}

simulated function Destroyed()
{
	if (ExplosionDecal != none)
		WallDecal(Location, vect(0,0,1));

	if (trail != none)
		trail.Shutdown();
}

simulated function ProcessBounce(vector HitNormal, optional vector vel)
{
	local vector refDir;

	refDir = reflect(-Normal(Velocity), HitNormal);

	switch (CollisionMethod)
	{
		case COL_None:
			gotoState('Stopped');
			break;

		case COL_Method_1:
			Velocity = Velocity - HitNormal * (Velocity dot HitNormal) * (1+Elasticity);
			break;

		case COL_Method_2:
			Velocity = (refDir - (HitNormal * (1.0 - Elasticity))) * VSize(Velocity);
			break;

		case COL_Method_3:
			Velocity =  refDir * speed * Elasticity;
			break;

		case COL_Method_4:
			refDir = reflect(-Normal(Velocity), HitNormal);
			refDir = Normal(refDir + (VRand() * 0.25));
			Velocity = refDir * ( Elasticity * VSize(Velocity));
			Velocity.z *= 0.75;
			break;
	};

	if (VSize(Velocity) < 8)
		gotoState('Stopped');
}

auto state FallingState
{
	simulated function Tick(float DeltaTime)
	{
		local vector w;
		
		// wind
		if (WindStrMult > 0)
		{
			w = Level.GetTotalWind(self.Location);
			Velocity += (w * WindStrMult);
		}
	}

	simulated function ProcessTouch(Actor Other, Vector HitLocation)
	{
		if (Other == Owner)
			return;

		if ( Other.IsA('Pawn') )
		{
			PlaySound(PawnImpactSound);
			Other.ProjectileHit(Instigator, HitLocation, (MomentumTransfer * Normal(Velocity)), self, getDamageInfo());
			if ( !bDestroyOnHitWall )
				ProcessBounce(Normal(Location-HitLocation));
			else
				Destroy();
		} else if ( Other.IsA('FallingProjectile') ) {
			ProcessBounce(Normal(Location-HitLocation));
		}
	}

	simulated function Landed (vector HitNormal)
	{
		if (!bDestroyOnHitWall)
			ProcessBounce(HitNormal);
		else
			Destroy();
	}

	simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
	{
		local DamageInfo DInfo;
		DInfo = GetDamageInfo();
		if ( Wall.AcceptDamage(DInfo) )
			Wall.TakeDamage( instigator, Location, MomentumTransfer * Normal(Velocity), GetDamageInfo());
		GenWallHitDecal(Location, HitNormal);
		if (!bDestroyOnHitWall)
			ProcessBounce(HitNormal);
		else
			Destroy();
	}

	simulated function BeginState()
	{
		if (TrailClass != None)
		{
//			Warn("TrailClass is valid");
			Trail = spawn(TrailClass,self,,Location);
			Trail.setBase(self);
		}
		else
			warn(" TrailClass == None ");

	}

/*
	Begin:
		if (TrailClass != None)
		{
			Warn("TrailClass is valid");
			Trail = spawn(TrailClass,self,,Location);
			Trail.setBase(self);
		}
		else
			warn(" TrailClass == None ");
*/
}

function GenWallHitDecal(vector HitLocation, vector HitNormal);

simulated function DamageInfo getDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;

	if (DamageType == 'none')
		DamageType = MyDamageType;
	DInfo.DamageMultiplier = 1;
	DInfo.Damage = Damage * (VSize(Velocity) / Speed);
	DInfo.DamageType = DamageType;
	DInfo.DamageString = MyDamageString;
	DInfo.bMagical = bMagical;
	DInfo.Deliverer = self;
	DInfo.bBounceProjectile = true;
	return DInfo;
}

state Stopped
{
	simulated function Tick(float DeltaTime)
	{
		if (bScaleDownWhenStopped)
		{
			if (Trail != none)
			{
				Trail.SizeEndScale.Base *= 0.9;
				Trail.SizeWidth.Base *= 0.9;
				Trail.SizeLength.Base *= 0.9;
			}
			DrawScale *= 0.99;
		}
	}
	
	simulated function Timer()
	{
		Destroy();
	}

	simulated function BeginState()
	{
		//ClearAnims();
		if (Trail != none)
			Trail.Shutdown();
		setPhysics(PHYS_None);
		Velocity = vect(0,0,0);
		setTimer(3,false);
	}
/*
	Begin:
		ClearAnims();
		if (Trail != none)
			Trail.Shutdown();
		setPhysics(PHYS_None);
		Velocity = vect(0,0,0);
		setTimer(3,false);
*/
}

defaultproperties
{
     Elasticity=0.1
     Speed=100
     Physics=PHYS_Falling
     LifeSpan=15
     DrawType=DT_Sprite
     Style=STY_Masked
     Texture=Texture'Engine.S_Corpse'
     CollisionRadius=16
     CollisionHeight=32
     bProjTarget=True
     bBounce=True
}
