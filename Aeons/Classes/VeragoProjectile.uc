//=============================================================================
// VeragoProjectile.
//=============================================================================
class VeragoProjectile expands SpellProjectile;

//#exec MESH IMPORT MESH=VeragoProj_m SKELFILE=Verago_proj.ngf

var float					ZSeek;				//
var float					ZDelta;				//
var float					DDelta;				//
var ParticleFX				TrailFX;

/*
function PreBeginPlay()
{
	super.PreBeginPlay();
	TrailFX = Spawn( class'SkullStorm_Particles', self,, Location );
	TrailFX.SetBase( self );
}
*/

simulated function Destroyed()
{
	if ( TrailFX != none )
		TrailFX.Destroy();
	super.Destroyed();
}

function Setup( float ZHeight, float DeltaTime )
{
	ZSeek = ZHeight;
	ZDelta = ( ZSeek - Location.Z ) / DeltaTime;
	DDelta = default.DrawScale / DeltaTime;
	DrawScale = 0.01;
}


auto state RisingState
{
	function BeginState()
	{
		super.BeginState();
		Enable( 'Tick' );
	}

	function Tick( float DeltaTime )
	{
		local vector	CLoc;

		super.Tick( DeltaTime );
		CLoc = Location;
		CLoc.Z += ZDelta * DeltaTime;
		SetLocation( CLoc );
		DrawScale += DDelta * DeltaTime;
	}
}


state Flying
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
	DrawScale = default.DrawScale;
	SetPhysics( PHYS_Projectile );
	TrailFX = Spawn( class'SkullStorm_Particles', self,, Location );
	TrailFX.SetBase( self );
	TrailFX.RemoteRole = ROLE_SimulatedProxy;
	Velocity = vector(Rotation) * Speed;
}

defaultproperties
{
     Speed=1800
     LifeSpan=10
     Mesh=SkelMesh'Aeons.Meshes.VeragoProj_m'
     DrawScale=0.225
     CollisionRadius=6
     CollisionHeight=6
     bNetTemporary=False
}
