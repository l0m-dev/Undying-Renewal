//=============================================================================
// ScarrowProjectile.
//=============================================================================
class ScarrowProjectile expands SPThrownProjectile;

#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var ParticleFX				TrailFX;


simulated function PreBeginPlay()
{
	super.PreBeginPlay();
	if (Level.NetMode != NM_DedicatedServer)
	{
		TrailFX = Spawn( class'ScarrowProjectileFX', self,, Location );
		TrailFX.SetBase( self );
	}
}

simulated function Destroyed()
{
	if ( TrailFX != none )
		TrailFX.Destroy();
	super.Destroyed();
}

function HitPlayer( actor Player, vector HitLocation )
{
	if ( Player.IsA('AeonsPlayer') && ( SlimeModifier(AeonsPlayer(Player).SlimeMod) != none ) )
		if ( !CheckPlayerShield(Player, HitLocation) )
			SlimeModifier(AeonsPlayer(Player).SlimeMod).Activate();
}

defaultproperties
{
     TrailClass=None
     Speed=1200
     Damage=10
     bMagical=True
     PawnImpactSound=Sound'CreatureSFX.Shades.C_Shade_SpitHit01'
     DrawType=DT_None
}
