//=============================================================================
// LizHowler.
//=============================================================================
class LizHowler expands Howler;

defaultproperties
{
     MeleeInfo(0)=(Damage=50,EffectStrength=0.1,Method=Bite)
     MeleeInfo(1)=(Damage=35,EffectStrength=0.25,Method=RipSlice)
     MeleeInfo(2)=(Damage=40,EffectStrength=0.5,Method=RipSlice)
     GroundSpeed=600
     AccelRate=2000
     HatedClass=Class'Aeons.Patrick'
     Health=400
     Mesh=SkelMesh'Aeons.Meshes.BossHowler_m'
     DrawScale=1.7
     DamageRadius=125
     MeleeRange=100
     AttitudeToEnemy=ATTITUDE_Ignore
     AttitudeToPlayer=ATTITUDE_Hate
     bBlockPlayers=True
     bBlockActors=False
     CollisionRadius=40
     CollisionHeight=57
}