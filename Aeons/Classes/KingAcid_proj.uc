//=============================================================================
// KingAcid_proj.
//=============================================================================
class KingAcid_proj expands SpellProjectile;

var KingAcidProj_particles	Trail;

simulated function PreBeginPlay()
{
	PlaySound(SpawnSound);
 	Trail = spawn(class 'KingAcidProj_particles',self,,Location);
 	Trail.setBase(self);
}

simulated function Destroyed()
{
	if (Trail != none)
		Trail.Shutdown();
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	local DamageInfo DInfo;

	log( "" $ name $ ".ProcessTouch( " $ Other.name $ " ) called." );
	
	DInfo = GetDamageInfo();
	
	if ( (Instigator != Other) || (bCanHitInstigator) )
	{
		if ( Role == ROLE_Authority )
		{
			if ( Other.IsA('Pawn') && (HitLocation.Z - Other.Location.Z > 0.62 * Other.CollisionHeight)
				&& (instigator.IsA('PlayerPawn') || (instigator.skill > 1))
				&& (!Other.IsA('ScriptedPawn') || !ScriptedPawn(Other).bIsBoss)
				&& Other.AcceptDamage(DInfo) )
				Other.TakeDamage(instigator,HitLocation, (MomentumTransfer * Normal(Velocity)), DInfo);
			else if (Other.AcceptDamage(DInfo) )
				Other.TakeDamage(instigator,HitLocation, (MomentumTransfer * Normal(Velocity)), DInfo);
		}
		PlaySound(MiscSound, SLOT_Misc, 2.0);
		destroy();
	}
}

auto state Flying
{
	function Tick( float deltaTime )
	{
		super.Tick( deltaTime );
		Velocity = Vector(Rotation) * Speed;
	}

	simulated function ParticleHitFX(vector HitLocation, vector HitNormal)
	{
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
	log( "" $ name $ ".Landed() called." );
	Explode(Location, HitNormal);
}

defaultproperties
{
     damagePerLevel(0)=25
     damagePerLevel(1)=25
     damagePerLevel(2)=25
     damagePerLevel(3)=25
     damagePerLevel(4)=25
     Speed=1000
     Damage=25
     Style=STY_Modulated
     Texture=Texture'Aeons.Trails.sphereOfCold_projTex'
     DrawScale=0.35
     CollisionRadius=10
     CollisionHeight=10
}
