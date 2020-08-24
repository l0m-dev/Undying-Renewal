//=============================================================================
// Projectile_Candle1.
//=============================================================================
class Projectile_Candle1 expands ScriptedProjectile;

defaultproperties
{
     ActivatedHoverAltitude=160
     ProjectileSpeed=1200
     LaunchSound=Sound'CreatureSFX.SharedHuman.C_Whoosh01'
     ExplodeSound=Sound'CreatureSFX.SharedHuman.C_BFallSmall_Wood01'
     ContactSound=Sound'Impacts.GoreSpecific.E_Imp_FleshBlunt01'
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
     Mesh=SkelMesh'Aeons.Meshes.Candle_elegant01_m'
     DrawScale=1
     bProjTarget=False
}
