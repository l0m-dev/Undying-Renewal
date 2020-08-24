//=============================================================================
// ArmChair.
//=============================================================================
class ArmChair expands Furniture;
//#exec MESH IMPORT MESH=ArmChair_m SKELFILE=ArmChair.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.ArmChair_m'
     CollisionRadius=32
     CollisionHeight=46
}
