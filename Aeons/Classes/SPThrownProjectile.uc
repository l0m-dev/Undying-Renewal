//=============================================================================
// SPThrownProjectile.
//=============================================================================
class SPThrownProjectile expands FallingProjectile;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Impacts.uax PACKAGE=Impacts



// return TRUE if player's shield protects them, FALSE if not.
function bool CheckPlayerShield( actor Player, vector HitLocation )
{
	local vector vd, playerCoord1, playerCoord2, PlayerLocation;
	local AeonsPlayer AP;
	local float dp;

	if ( Player.IsA('AeonsPlayer') )
	{
		log(" .... Player", 'Misc');
		AP = AeonsPlayer(Player);

		if (AP.ShieldMod.bActive)
		{
			log(" Shield Is Active", 'Misc');
			PlayerLocation = AP.Location;
			PlayerLocation.z = 0;
			vd = vector(AP.ViewRotation);
			vd.z = 0;
			playerCoord1 = ( Normal(HitLocation - PlayerLocation) ) - vd;
			playerCoord2 = ( Normal(HitLocation - PlayerLocation) ) + vd;

			dp = Normal(HitLocation - PlayerLocation) dot vd;
			
			if ( dp < 0 )
			{
				// Player takes damage
				log(" Shield does not protect", 'Misc');
				return false;
			} else {
				// Shield Absorbs damage
				log(" Shield does protect", 'Misc');
				return true;
			}
		} else {
			log(" Shield not on", 'Misc');
			return false;
		}
	}
}

function HitPlayer( actor Player, vector HitLocation )
{
}

function PreBeginPlay()
{
	Disable( 'Tick' );
}

function DamageInfo getDamageInfo( optional name DamageType )
{
	local DamageInfo DInfo;

	if ( DamageType == '' )
		DamageType = MyDamageType;
	DInfo.Damage = Damage;
	DInfo.DamageType = DamageType;
	DInfo.DamageString = MyDamageString;
	DInfo.bMagical = bMagical;
	DInfo.Deliverer = self;
	if ( ScriptedPawn(Owner) != none )
		DInfo.DamageMultiplier = ScriptedPawn(Owner).OutDamageScalar;
	else
		DInfo.DamageMultiplier = 1;
	DInfo.bBounceProjectile = false;

	return DInfo;
}

function Explode( vector HitLocation, vector HitNormal )
{
	// spawn effect
	if ( Trail != none )
		Trail.bShuttingDown = true;
	Destroy();
}


auto state HeldState
{
}

state FallingState
{
	function Tick( float DeltaTime )
	{
		if ( VSize(Velocity) < 4 )
		{
			SetCollision( false );
			if ( Trail != none )
			{
				Trail.bShuttingDown = true;
				Trail = none;
			}
			SetPhysics( PHYS_Falling );
		}
	}

	simulated function ProcessTouch( actor Other, vector HitLocation )
	{
		if ( Other == Owner )
			return;

		if ( Other.IsA('Pawn') )
		{
			Other.PlaySound( PawnImpactSound );
			Other.ProjectileHit( Instigator, HitLocation, MomentumTransfer * Normal(Velocity), self, getDamageInfo() );
			Pawn(Other).PlayDamageMethodImpact( MyDamageType, HitLocation, -Normal(Velocity) );
			Explode( Location, Normal(Location - HitLocation) );
			ProcessBounce( Normal(Location - HitLocation) );
		}

		if ( Other.IsA('PlayerPawn') )
			HitPlayer( Other, HitLocation );
	}

	simulated function HitWall ( vector HitNormal, actor Wall, byte TextureID )
	{
		local DamageInfo	DInfo;

		if ( Wall.AcceptDamage( GetDamageInfo() ) )
			Wall.TakeDamage( Instigator, Location, MomentumTransfer * Normal(Velocity), getDamageInfo() );
		ProcessBounce( HitNormal );
	}
}

state Stopped
{
	simulated function BeginState()
	{
		ClearAnims();
		if ( Trail != none )
			Trail.bShuttingDown = true;
		SetPhysics( PHYS_None );
		SetCollision( false, false, false );
		Velocity = vect(0,0,0);
		SetTimer( 3, false );
	}
}

defaultproperties
{
     CollisionMethod=COL_Method_4
     Elasticity=0.15
     TrailClass=Class'Aeons.SaintSkullTrailFX'
     Speed=2000
     Damage=20
     MomentumTransfer=600
     LifeSpan=10
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Skull_proj'
     DrawScale=0.125
     CollisionRadius=6
     CollisionHeight=6
}
