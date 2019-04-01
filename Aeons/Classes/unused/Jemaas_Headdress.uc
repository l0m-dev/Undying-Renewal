//=============================================================================
// Jemaas_Headdress.
//=============================================================================
class Jemaas_Headdress expands HeldProp;

#exec MESH IMPORT MESH=Jemaas_Headdress_m SKELFILE=Jemaas_Headdress.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.Jemaas_Headdress_m'
     CollisionRadius=10
     CollisionHeight=6
}
