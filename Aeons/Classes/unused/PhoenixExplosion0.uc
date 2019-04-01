//=============================================================================
// PhoenixExplosion0.
//=============================================================================
class PhoenixExplosion0 expands PhoenixExplosions;

function CreateExplosion(Pawn Instigator)
{
	Super.CreateExplosion(Instigator);
	HurtRadius(DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo() );
	spawn (class 'HotExplosionFX'    ,,,Location);
	spawn (class 'SmokyExplosionFX'  ,,,Location);
	spawn (class 'ParticleExplosion' ,,,Location);
	if (!bTriggered)
		Destroy();
	else if (!bTriggerMultiple)
		Destroy();

}

defaultproperties
{
     DamageRadius=512
     Damage=100
     MomentumTransfer=500
     Sounds(0)=Sound'Aeons.Weapons.E_Wpn_DynaExpl01'
     Sounds(1)=Sound'Aeons.Weapons.E_Wpn_DynaExpl02'
     Sounds(2)=Sound'Aeons.Weapons.E_Wpn_DynaExpl03'
}
