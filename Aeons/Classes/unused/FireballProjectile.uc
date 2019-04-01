//=============================================================================
// FireballProjectile.
//=============================================================================
class FireballProjectile expands SpellProjectile;

var ParticleFX				MainFX;
var ParticleFX				TrailFX;


function PreBeginPlay()
{
	super.PreBeginPlay();
	MainFX = Spawn( class'FireballParticleFX', self,, Location );
	MainFX.SetBase( self );
	TrailFX = Spawn( class'SkullStorm_Particles', self,, Location );
	TrailFX.SetBase( self );
}

function Destroyed()
{
	if ( MainFX != none )
		MainFX.Destroy();
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
			Spawn( class'FireballExplosion', pawn(Owner),, Location );
		}
		MakeNoise( 3.0 );
		Destroy();
	}

BEGIN:
	Velocity = vector(Rotation) * Speed;
}

defaultproperties
{
     Speed=900
}
