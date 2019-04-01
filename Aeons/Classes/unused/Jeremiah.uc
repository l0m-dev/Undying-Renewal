//=============================================================================
// Jeremiah.
//=============================================================================
class Jeremiah expands ScriptedNarrator;

#exec MESH IMPORT MESH=Jeremiah_m SKELFILE=Jeremiah.ngf INHERIT=ScriptedBiped_m
#exec MESH JOINTNAME Neck=Head

defaultproperties
{
     MyPropInfo(0)=(Prop=Class'Aeons.Pipe',PawnAttachJointName=Face_Pipe,AttachJointName=Attach_Face)
     MyPropInfo(1)=(Prop=Class'Aeons.Glasses',PawnAttachJointName=Face_Glasses,AttachJointName=Attach_Face)
     SoundSet=Class'Aeons.JeremiahSoundSet'
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Jeremiah_m'
}
