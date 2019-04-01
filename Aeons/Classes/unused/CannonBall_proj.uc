//=============================================================================
// CannonBall_proj.
//=============================================================================
class CannonBall_proj expands WeaponProjectile;
#exec MESH IMPORT MESH=CannonBall_proj_m SKELFILE=CannonBall_proj.ngf 


function PreBeginPlay()
{
	Super.PreBeginPlay();
	Velocity = Vector(Rotation) * speed;
}

simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
{
	local int Flags;
	local Texture HitTexture;
	local DamageInfo DInfo;

	if ( Role == ROLE_Authority )
	{
		DInfo = GetDamageInfo();
		if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
			if ( Wall.AcceptDamage(DInfo) )
				Wall.TakeDamage(instigator, Location, MomentumTransfer * Normal(Velocity), DInfo);

		MakeNoise(1.0);
	}
	
	Destroy();
	// SetPhysics(PHYS_Falling);

}

defaultproperties
{
     Speed=2000
     Damage=100
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.CannonBall_proj_m'
     CollisionRadius=40
     CollisionHeight=16
     LightBrightness=100
     bBounce=True
}
