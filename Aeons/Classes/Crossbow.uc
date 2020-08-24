//=============================================================================
// Crossbow.
//=============================================================================
class Crossbow expands Heldprop;
//#exec MESH IMPORT MESH=Crossbow_m SKELFILE=Crossbow.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Crossbow_m'
}
