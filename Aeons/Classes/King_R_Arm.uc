//=============================================================================
// King_R_Arm.
//=============================================================================
class King_R_Arm expands King_Part;
//#exec MESH IMPORT MESH=King_R_Arm_m SKELFILE=King_R_Arm.ngf

//#exec MESH NOTIFY SEQ=Attack TIME=0.241 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack TIME=0.259 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack TIME=0.296 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack TIME=0.741 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack TIME=0.778 FUNCTION=DoNearDamage

//#exec MESH NOTIFY SEQ=Attack TIME=0.185 FUNCTION=PlaySound_N ARG="WhooshHvy PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack TIME=0.222 FUNCTION=PlaySound_N ARG="HeavyHit PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack TIME=0.703 FUNCTION=PlaySound_N ARG="WhooshHvy PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack TIME=0.777 FUNCTION=PlaySound_N ARG="HeavyHit PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Multi_Brainshot TIME=0.687 FUNCTION=PlaySound_N ARG="WhooshHvy PVar=0.25 VVar=0.1"


function bool NearStrikeValid( actor Victim, int DamageNum )
{
	if( JointStrikeValid( Victim, 'BIGCLAW_R_Elbow', DamageRadius ) ||
		JointStrikeValid( Victim, 'BIGCLAW_R_Wrist', DamageRadius ) ||
		JointStrikeValid( Victim, 'BIGCLAW_R_Pincerbase', DamageRadius ) ||
		JointStrikeValid( Victim, 'BIGCLAW_R_R_Pincer', DamageRadius ) ||
		JointStrikeValid( Victim, 'BIGCLAW_R_LPincer', DamageRadius ) )
		return true;
	else
		return false;
}

defaultproperties
{
     MinTanYaw=-0.1
     RootJointName=BIGCLAW_R_Root
     MeleeInfo(0)=(Damage=40,EffectStrength=0.25,Method=RipSlice)
     DamageRadius=150
     MeleeRange=1500
     SoundSet=Class'Aeons.KingSoundSet'
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.King_R_Arm_m'
}
