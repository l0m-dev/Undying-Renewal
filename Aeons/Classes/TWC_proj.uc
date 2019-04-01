//=============================================================================
// TWC_proj.
//=============================================================================
class TWC_proj expands SpellProjectile
	abstract;

#exec MESH IMPORT MESH=IceChunk_proj_m SKELFILE=IceChunk_proj.ngf 

var PlayerStateTrigger 		attachedTrigger;
var PlayerPawn 				ViewOwner;
var TibetianWarCannon 		owner;
var Pawn					SeekPawn;
var Vector					SeekLoc;
var SphereOfCold_particles	trail;
var SoCIce_particles		IceTrail;
var() float Radius;
var() float EffectLen;
var bool bHitActor;
var float age;

function Tick(float DeltaTime)
{
	age += DeltaTime;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	PlaySound(SpawnSound);

 	IceTrail = spawn(class 'SoCIce_particles',,,Location);
 	IceTrail.setBase(self);
	IceTrail.RemoteRole = ROLE_None;

 	trail = spawn(class 'SphereOfCold_particles',,,Location);
 	trail.setBase(self);
	trail.RemoteRole = ROLE_None;
}


simulated function Destroyed()
{
	if ( IceTrail != None )
		IceTrail.bshuttingDown = true;

	if ( trail != None ) 
		trail.bShuttingDown = true;
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	local DamageInfo DInfo;

	if ( (Instigator != Other) || (bCanHitInstigator) )
	{
		if ( Role == ROLE_Authority )
		{
			if ( Other.IsA('AeonsPlayer') )
			{
				Other.TakeDamage( Instigator, Location, vect(0,0,0), GetDamageInfo('SphereOfCold'));
				SphereOfColdModifier(AeonsPlayer(Other).SPhereOfColdMod).EffectLen = EffectLen;
				AeonsPlayer(Other).SPhereOfColdMod.gotoState('Activated');
				Pawn(Other).OnFire(false);
				PlaySound(PawnImpactSound);
			} else  if ( Other.IsA('ScriptedPawn') ) {
				DInfo = GetDamageInfo('SphereOfCold');
				// log("Hit "$other.name$" delivering damage = "$Dinfo.Damage, 'Misc');
				Other.TakeDamage( Instigator, Location, vect(0,0,0), GetDamageInfo('SphereOfCold'));
				if ( !ScriptedPawn(Other).SPhereOfColdMod.bActive )
				{
					SphereOfColdModifier(ScriptedPawn(Other).SPhereOfColdMod).EffectLen = EffectLen;
					ScriptedPawn(Other).SPhereOfColdMod.gotoState('Activated');
					Pawn(Other).OnFire(false);
				}
				PlaySound(PawnImpactSound);
			} else {
				Other.TakeDamage( Instigator, Location, vect(0,0,0), GetDamageInfo('SphereOfCold'));
			}
		}
		bHitActor = true;
		if ( !Other.IsA('Pawn') )
		{
			Explode(HitLocation, Normal(Velocity) );
			PlaySound(ProjImpactSound);
		}
	}
}

auto state Flying
{

	Begin:
		Velocity = Vector(Rotation) * Speed;
		setTimer(0.1, true);
}

simulated function Landed(vector HitNormal)
{
	PlaySound(ProjImpactSound);
	Explode(Location, HitNormal);
}

simulated function ZoneChange( ZoneInfo NewZone )
{
	if (age > 0.1)
	{
		if ( NewZone.bWaterZone )
			Explode(Location, vect(0,0,1));
	}
}

simulated function ParticleHitFX(vector HitLocation, vector HitNormal)
{
	local actor a;

	Spawn(class'ChargedSoCHitFX', , , HitLocation, rotator(HitNormal));
	// Server running this code. Don't replicate to clients
	a.RemoteRole = ROLE_None;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( !bHitActor )
		HurtRadius( Radius, 'cold', 50, HitLocation, GetDamageInfo('SphereOfCold') );
	
	ParticleHitFX(HitLocation, HitNormal);
	Destroy();
}

defaultproperties
{
     damagePerLevel(0)=20
     damagePerLevel(1)=30
     damagePerLevel(2)=40
     damagePerLevel(3)=50
     damagePerLevel(4)=60
     damagePerLevel(5)=70
     AltDamagePerLevel(0)=20
     AltDamagePerLevel(1)=30
     AltDamagePerLevel(2)=40
     AltDamagePerLevel(3)=50
     AltDamagePerLevel(4)=60
     AltDamagePerLevel(5)=70
     Damage=30
     ProjImpactSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_TWCMiss01'
     PawnImpactSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_TWCHit01'
     Physics=PHYS_Falling
     RotationRate=(Pitch=512,Yaw=654,Roll=256)
     Style=STY_Translucent
     Texture=None
     Mesh=SkelMesh'Aeons.Meshes.IceChunk_proj_m'
     DrawScale=0.5
     CollisionRadius=16
     CollisionHeight=16
}
