//=============================================================================
// Candleabra_table.
//=============================================================================
class Candleabra_table expands Fixtures;

#exec MESH IMPORT MESH=Candleabra_table01_m SKELFILE=Candleabra_table01.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Candleabra_table01_m'
}
