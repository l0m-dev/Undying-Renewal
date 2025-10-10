//=============================================================================
// SphereOfCold_proj.
//=============================================================================
class SphereOfCold_proj expands SpellProjectile;

var PlayerStateTrigger 		attachedTrigger;
var PlayerPawn 				ViewOwner;
var TibetianWarCannon 		owner;
var Pawn					SeekPawn;
var Vector					SeekLoc;
var SoCIce_particles		IceTrail;

simulated function PreBeginPlay()
{
	PlaySound(SpawnSound);
 	IceTrail = spawn(class 'SoCIce_particles',,,Location);
 	IceTrail.setBase(self);
}

simulated function Destroyed()
{
	if (IceTrail != none)
		IceTrail.Shutdown();
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Instigator != Other) || (bCanHitInstigator) )
	{
		if ( Role == ROLE_Authority )
		{
			log("SphereOf Cold Applying Damage to "$Other, 'Misc');
			if ( Other.IsA('Pawn') && (HitLocation.Z - Other.Location.Z > 0.62 * Other.CollisionHeight)
				&& (instigator.IsA('PlayerPawn') || (instigator.skill > 1))
				&& (!Other.IsA('ScriptedPawn') || !ScriptedPawn(Other).bIsBoss) 
				&& Other.AcceptDamage(GetDamageInfo('SphereOfCold')) )
				Other.TakeDamage(instigator,HitLocation, (MomentumTransfer * Normal(Velocity)), GetDamageInfo('SphereOfCold'));
			else if ( Other.AcceptDamage(GetDamageInfo()) )
				Other.TakeDamage(instigator,HitLocation, (MomentumTransfer * Normal(Velocity)), GetDamageInfo('SphereOfCold'));
		}
		PlaySound(MiscSound, SLOT_Misc, 2.0);
		Destroy();
	}
}

auto state Flying
{
	simulated function ParticleHitFX(vector HitLocation, vector HitNormal)
	{
		Spawn(class'SoCHitFX', , , HitLocation, rotator(HitNormal));
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		ParticleHitFX(HitLocation, HitNormal);
		PlaySound(ProjImpactSound);
		Destroy();
	}

	Begin:
		Velocity = Vector(Rotation) * Speed;
}

function Landed(vector HitNormal)
{
	Explode(Location, HitNormal);
}

defaultproperties
{
     damagePerLevel(0)=30
     damagePerLevel(1)=30
     damagePerLevel(2)=30
     damagePerLevel(3)=30
     damagePerLevel(4)=30
     Speed=1000
     Damage=25
     Physics=PHYS_Falling
     DrawType=DT_Sprite
     Style=STY_Modulated
     Texture=Texture'Aeons.Trails.sphereOfCold_projTex'
     DrawScale=0.35
}
