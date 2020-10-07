//=============================================================================
// MiniBoss.
//=============================================================================
class MiniBoss expands Howler;

//#exec MESH IMPORT MESH=MiniBoss_m SKELFILE=MiniBoss.ngf INHERIT=Howler_m
//#exec MESH JOINTNAME R_Shoulder=R_Collar R_Shoulder_Rot=R_Shoulder R_Hand=R_Hand1 R_Claw_A1=R_ClawA1 R_Claw_B1=R_ClawB1
//#exec MESH JOINTNAME L_Shoulder=L_Collar L_Shoulder_Rot=L_Shoulder L_Hand=L_Hand1 L_Claw_A1=L_ClawA1 L_Claw_B1=L_ClawB1

defaultproperties
{
     MeleeInfo(0)=(Damage=35)
     MeleeInfo(1)=(Damage=15)
     MeleeInfo(2)=(Damage=20)
     JumpZ=480
     Health=100
     Mesh=SkelMesh'Aeons.Meshes.MiniBoss_m'
     DrawScale=1.15
}
