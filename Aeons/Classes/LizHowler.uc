//=============================================================================
// LizHowler.
//=============================================================================
class LizHowler expands Howler;

// BURT - All exec imports were ripped since it is just an update

defaultproperties
{
     MeleeInfo(0)=(Damage=50)
     MeleeInfo(1)=(Damage=40)
     MeleeInfo(2)=(Damage=35)
     GroundSpeed=650
     AccelRate=2000
     HatedClass=Class'Aeons.Patrick'
     Health=400
     Mesh=SkelMesh'Aeons.Meshes.BossHowler_m'
     DrawScale=1.7
	 DamageRadius=125
	 MeleeRange=100
	 AttitudeToEnemy=ATTITUDE_Ignore
	 AttitudeToPlayer=ATTITUDE_Hate
	 bHasFarAttack=True
}