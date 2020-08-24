//=============================================================================
// BoneTorch01.
//=============================================================================
class BoneTorch01 expands Fixtures;
//#exec MESH IMPORT MESH=BoneTorch01_m SKELFILE=BoneTorch01.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.BoneTorch01_m'
}
