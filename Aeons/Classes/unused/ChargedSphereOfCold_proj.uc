//=============================================================================
// ChargedSphereOfCold_proj.
//=============================================================================
class ChargedSphereOfCold_proj expands SpellProjectile;

#exec MESH IMPORT MESH=IceChunk_proj_m SKELFILE=IceChunk_proj.ngf 

var PlayerStateTrigger 		attachedTrigger;
var PlayerPawn 				ViewOwner;
var TibetianWarCannon 		owner;
var Pawn					SeekPawn;
var Vector					SeekLoc;
var SphereOfCold_particles	trail;
var SoCIce_particles		IceTrail;

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
	if ( (Instigator != Other) || (bCanHitInstigator) )
	{
		if ( Role == ROLE_Authority )
		{
			if ( Other.IsA('AeonsPlayer') )
			{
				AeonsPlayer(Other).SPhereOfColdMod.gotoState('Activated');
				Pawn(Other).OnFire(false);
			}

			if ( Other.IsA('ScriptedPawn') )
				if ( !ScriptedPawn(Other).SPhereOfColdMod.bActive )
				{
					ScriptedPawn(Other).SPhereOfColdMod.gotoState('Activated');
					Pawn(Other).OnFire(false);
				}
		}
		PlaySound(PawnImpactSound);
		Explode(HitLocation, Normal(Velocity) );
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
	if ( NewZone.bWaterZone )
	{
		spawn(class 'FrozenWater',,,Location,rot(0,0,0));
		Destroy();
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
	HurtRadius( 128, 'cold', 50, HitLocation, GetDamageInfo() );
	ParticleHitFX(HitLocation, HitNormal);
	Destroy();
}

defaultproperties
{
     damagePerLevel(0)=30
     damagePerLevel(1)=30
     damagePerLevel(2)=30
     damagePerLevel(3)=30
     damagePerLevel(4)=30
     AltDamagePerLevel(0)=30
     AltDamagePerLevel(1)=30
     AltDamagePerLevel(2)=30
     AltDamagePerLevel(3)=30
     AltDamagePerLevel(4)=30
     Speed=1200
     Damage=40
     ProjImpactSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_TWCMiss01'
     PawnImpactSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_TWCHit01'
     ExplosionDecal=Class'Aeons.ChargedSoCDecal'
     Physics=PHYS_Falling
     RotationRate=(Pitch=512,Yaw=654,Roll=256)
     Style=STY_Translucent
     Texture=None
     Mesh=SkelMesh'Aeons.Meshes.IceChunk_proj_m'
     DrawScale=0.5
     CollisionRadius=16
     CollisionHeight=16
}
