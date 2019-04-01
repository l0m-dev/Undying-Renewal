//=============================================================================
// Pipe.
//=============================================================================
class Pipe expands Heldprop;
#exec MESH IMPORT MESH=Pipe_m SKELFILE=Pipe.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Pipe_m'
}
