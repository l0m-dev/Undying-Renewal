//=============================================================================
// DragonSpout.
//=============================================================================
class DragonSpout expands Decoration;
#exec MESH IMPORT MESH=DragonSpout_m SKELFILE=DragonSpout.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.DragonSpout_m'
}
