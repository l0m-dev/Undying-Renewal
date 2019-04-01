//=============================================================================
// JileProjectile.
//=============================================================================
class JileProjectile expands SPThrownProjectile;

#exec OBJ LOAD FILE=\Aeons\Sounds\Impacts.uax PACKAGE=Impacts

var ParticleFX				TrailFX;

function PreBeginPlay()
{
	super.PreBeginPlay();
	TrailFX = Spawn( class'JileProjectileFX', self,, Location );
	TrailFX.SetBase( self );
}

function Destroyed()
{
	if ( TrailFX != none )
		TrailFX.Destroy();
	super.Destroyed();
}

function HitPlayer( actor Player, vector HitLocation )
{
	if ( Player.IsA('AeonsPlayer') && ( SlothModifier(AeonsPlayer(Player).SlothMod) != none ) )
		if ( !CheckPlayerShield(Player, HitLocation) )
			SlothModifier(AeonsPlayer(Player).SlothMod).Activate();
}

defaultproperties
{
     TrailClass=None
     Speed=2600
     Damage=5
     bMagical=True
     PawnImpactSound=Sound'Impacts.WpnSplSpecific.C_Plant_SeedImp01'
     DrawType=DT_None
}
