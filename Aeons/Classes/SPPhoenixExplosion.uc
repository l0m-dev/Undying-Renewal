//=============================================================================
// SPPhoenixExplosion.
//=============================================================================
class SPPhoenixExplosion expands Explosion;

simulated function CreateExplosion( pawn Inst )
{
	local SPPhoenixQuake	PQ;
	local int				lp;
	local MolotovFire_proj	MF;

	Instigator = Inst;
	super.CreateExplosion( Instigator );

	// Damage
	if ( bCausesDamage )
		HurtRadius( DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo( DamageType ) );

	// Visual Effects
	Spawn( class'DefaultParticleExplosionFX',,, Location );

	/*
	for ( lp=0; lp<6; lp++)
	{
		MF = Spawn( class'MolotovFire_proj', self,, Location );
		if ( MF != none )
		{
			MF.bMakesSound = false;
			MF.Dir = VRand();
			MF.GotoState( 'Flying' );
		}
	}
	*/

	// Effects
	PQ = Spawn( class'SPPhoenixQuake',,, Location );
	if ( PQ != none )
		PQ.Trigger( none, none );

	// Decals
	GenerateDecal();
	
	// Wind
	Spawn( class'ExplosionWind',,, Location );

	// Sound
	PlayEffectSound();
}

defaultproperties
{
     DamageRadius=384
     Damage=40
     DamageType=gen_concussive
     MomentumTransfer=5000
     Sounds(0)=Sound'Aeons.Weapons.E_Wpn_DynaExpl01'
     Sounds(1)=Sound'Aeons.Weapons.E_Wpn_DynaExpl02'
     Sounds(2)=Sound'Aeons.Weapons.E_Wpn_DynaExpl03'
     DecalClass=Class'Aeons.ExplosionDecal'
}
