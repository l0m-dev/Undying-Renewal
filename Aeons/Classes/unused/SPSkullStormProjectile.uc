//=============================================================================
// SPSkullStormProjectile.
//=============================================================================
class SPSkullStormProjectile expands SpellProjectile;

#exec MESH IMPORT MESH=SPSkullStormProj_m SKELFILE=SPSkullStormProj.ngf

var ParticleFX				TrailFX;


function PreBeginPlay()
{
	super.PreBeginPlay();
	TrailFX = Spawn( class'SkullStorm_Particles', self,, Location );
	TrailFX.SetBase( self );
}

function Destroyed()
{
	if ( TrailFX != none )
		TrailFX.Destroy();
	super.Destroyed();
}


auto state Flying
{
	simulated function ProcessTouch( actor Other, vector HitLocation )
	{
		if ( pawn(Other) != pawn(Owner) )
		{
			BlowUp( HitLocation, Normal(Location - HitLocation) );
		}
	}

	simulated function HitWall( vector HitNormal, actor Wall, byte TextureID )
	{
		local DamageInfo DInfo;

		DInfo = GetDamageInfo();
		if ( Role == ROLE_Authority )
		{
			if (Wall.AcceptDamage(DInfo))
			{
				if ( ( Mover(Wall) != none ) && Mover(Wall).bDamageTriggered )
					Wall.TakeDamage( Instigator, Location, MomentumTransfer * Normal(Velocity), DInfo );
			}
			MakeNoise( 1.0 );
		}
		BlowUp( Location, HitNormal );
	}

	simulated function BlowUp( vector HitLocation, vector HitNormal )
	{
		if ( Region.Zone.bWaterZone )
		{
			Spawn( class'UnderwaterExplosionFX',,, Location + HitNormal * 32 );
//			PlaySound( UnderWaterExplosionSound );
//UnderWaterExplosionSound=Sound'Aeons.Weapons.E_Wpn_DynaExplUnderwater01'
		}
		else
		{
			Spawn( class'SPSkullStormExplosion', pawn(Owner),, Location );
		}
		MakeNoise( 3.0 );
		Destroy();
	}

BEGIN:
	Velocity = vector(Rotation) * Speed;
}

defaultproperties
{
     Speed=1800
     Mesh=SkelMesh'Aeons.Meshes.SPSkullStormProj_m'
     DrawScale=0.225
     CollisionRadius=6
     CollisionHeight=6
}
