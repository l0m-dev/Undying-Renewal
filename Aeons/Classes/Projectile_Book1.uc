//=============================================================================
// Projectile_Book1.
//=============================================================================
class Projectile_Book1 expands ScriptedProjectile;

defaultproperties
{
     ActivatedHoverAltitude=160
     ProjectileSpeed=1200
     LaunchSound=Sound'LevelMechanics.Manor.A04_BookThrow1'
     ExplodeSound=Sound'LevelMechanics.Manor.A04_BookLand1'
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
     Mesh=SkelMesh'Aeons.Meshes.Book01_m'
     DrawScale=1
     bProjTarget=False
}
