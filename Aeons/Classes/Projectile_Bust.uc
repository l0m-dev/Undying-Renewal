//=============================================================================
// Projectile_Bust.
//=============================================================================
class Projectile_Bust expands ScriptedProjectile;

defaultproperties
{
     ActivatedHoverAltitude=160
     ProjectileSpeed=1200
     LaunchSound=Sound'CreatureSFX.SharedHuman.C_Whoosh01'
     ExplodeSound=Sound'CreatureSFX.SharedHuman.C_BFallBig_Earth01'
     ContactSound=Sound'Impacts.GoreSpecific.E_Imp_FleshBlunt02'
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
     Mesh=SkelMesh'Aeons.Meshes.Bust_m'
     DrawScale=1
     bProjTarget=False
}
