//=============================================================================
// King_L_Arm.
//=============================================================================
class King_L_Arm expands King_Part;
//#exec MESH IMPORT MESH=King_L_Arm_m SKELFILE=King_L_Arm.ngf


//#exec MESH NOTIFY SEQ=Attack TIME=0.170 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack TIME=0.189 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack TIME=0.245 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack TIME=0.792 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack TIME=0.830 FUNCTION=DoNearDamage

//#exec MESH NOTIFY SEQ=Attack TIME=0.037 FUNCTION=PlaySound_N ARG="WhooshHvy PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack TIME=0.148 FUNCTION=PlaySound_N ARG="HeavyHit PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Multi_Brainshot TIME=0.739 FUNCTION=PlaySound_N ARG="WhooshHvy PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Multi_Brainshot TIME=0.791 FUNCTION=PlaySound_N ARG="HeavyHit PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Start TIME=0.079 FUNCTION=C_BfallBig

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	if( JointStrikeValid( Victim, 'BIGCLAW_L_Elbow', DamageRadius ) ||
		JointStrikeValid( Victim, 'BIGCLAW_L_Wrist', DamageRadius ) ||
		JointStrikeValid( Victim, 'BIGCLAW_L_Pincerbase', DamageRadius ) ||
		JointStrikeValid( Victim, 'BIGCLAW_L_RPincer', DamageRadius ) ||
		JointStrikeValid( Victim, 'BIGCLAW_L_LPincer', DamageRadius ) )
		return true;
	else
		return false;
}

defaultproperties
{
     MaxTanYaw=0.1
     RootJointName=BIGCLAW_L_ROOT
     MeleeInfo(0)=(Damage=40,EffectStrength=0.25,Method=RipSlice)
     DamageRadius=150
     MeleeRange=1500
     SoundSet=Class'Aeons.KingSoundSet'
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.King_L_Arm_m'
}
