//=============================================================================
// WitchDaggers.
//=============================================================================
class WitchDaggers expands HeldProp;

//#exec MESH IMPORT MESH=WitchDaggers_m SKELFILE=WitchDaggers.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.WitchDaggers_m'
     bMRM=False
     CollisionRadius=2
     CollisionHeight=2
}
