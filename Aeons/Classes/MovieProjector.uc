//=============================================================================
// MovieProjector.
//=============================================================================
class MovieProjector expands Ornaments;
//#exec MESH IMPORT MESH=MovieProjector_m SKELFILE=MovieProjector.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.MovieProjector_m'
}
