//=============================================================================
// Projectile_DeadFish.
//=============================================================================
class Projectile_DeadFish expands ScriptedProjectile;

defaultproperties
{
     ActivatedHoverAltitude=160
     ProjectileSpeed=1200
     LaunchSound=Sound'Impacts.WpnSplSpecific.E_Wpn_GenericWhooshby'
     ExplodeSound=Sound'Footsteps.BareFS.C_BareFS_StoneL01'
     ContactSound=Sound'Impacts.GoreSpecific.E_Imp_FleshSlice02'
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
     Mesh=SkelMesh'Aeons.Meshes.deadfish_m'
     DrawScale=1
     bProjTarget=False
}
