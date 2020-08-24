//=============================================================================
// Candle_elegant.
//=============================================================================
class Candle_elegant expands Fixtures;

//#exec MESH IMPORT MESH=Candle_elegant01_m SKELFILE=Candle_elegant01.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Candle_elegant01_m'
}
