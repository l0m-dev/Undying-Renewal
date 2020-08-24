//=============================================================================
// Projectile_KitchenKnife.
//=============================================================================
class Projectile_KitchenKnife expands ScriptedProjectile;

defaultproperties
{
     ActivatedHoverAltitude=160
     ProjectileSpeed=1200
     LaunchSound=Sound'Impacts.WpnSplSpecific.E_Wpn_DaggerHit01'
     ExplodeSound=Sound'Impacts.SurfaceSpecific.E_Wpn_SpearHitGen01'
     ContactSound=Sound'Impacts.GoreSpecific.E_Imp_FleshStab02'
     MeleeInfo(0)=(Damage=10)
     DamageRadius=64
     OrderState=AIWaitForTrigger
     HearingEffectorThreshold=0
     VisionEffectorThreshold=0
     TriggerDelay=2
     TriggerState=AIEncounter
     AirSpeed=1600
     AccelRate=800
     Alertness=1
     SightRadius=0
     HearingThreshold=10
     Tag=DiningRoomKnives
     Mesh=SkelMesh'Aeons.Meshes.KitchenKnife_m'
     DrawScale=1
     bProjTarget=False
}
