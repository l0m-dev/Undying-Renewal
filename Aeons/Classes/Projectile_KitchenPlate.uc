//=============================================================================
// Projectile_KitchenPlate.
//=============================================================================
class Projectile_KitchenPlate expands ScriptedProjectile;

defaultproperties
{
     ActivatedHoverAltitude=160
     ProjectileSpeed=1600
     LaunchSound=Sound'Impacts.WpnSplSpecific.E_Wpn_GenericWhooshby'
     ExplodeSound=Sound'LevelMechanics.Manor.A04_DishBreak1'
     ContactSound=Sound'Impacts.GoreSpecific.E_Imp_FleshStab01'
     MeleeInfo(0)=(Damage=15)
     DamageRadius=64
     OrderState=AIWaitForTrigger
     HearingEffectorThreshold=0
     VisionEffectorThreshold=0
     TriggerState=AIEncounter
     Alertness=1
     SightRadius=0
     HearingThreshold=10
     BaseEyeHeight=2
     Tag=KitchenTrouble
     Mesh=SkelMesh'Aeons.Meshes.KitchenPlate_m'
     DrawScale=2
}
