//=============================================================================
// Groundskeeper_Hat.
//=============================================================================
class Groundskeeper_Hat expands HeldProp;

#exec MESH IMPORT MESH=Groundskeeper_Hat_m SKELFILE=Groundskeeper_Hat.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Groundskeeper_Hat_m'
     DrawScale=1.15
     CollisionRadius=11
     CollisionHeight=7
}
