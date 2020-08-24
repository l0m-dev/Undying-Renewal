//=============================================================================
// LightningTreeTop.
//=============================================================================
class LightningTreeTop expands Decoration;
//#exec MESH IMPORT MESH=LightningTreeTop_m SKELFILE=LightningTreeTop.ngf

defaultproperties
{
     bStatic=False
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.LightningTreeTop_m'
}
