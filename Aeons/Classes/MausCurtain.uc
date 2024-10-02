//=============================================================================
// MausCurtain.
//=============================================================================
class MausCurtain expands Decoration;
//#exec MESH IMPORT MESH=MausCurtain_m SKELFILE=MausCurtain.ngf 
//#exec MESH MODIFIERS Cloth:Cloth

/* Force-Recompile */

defaultproperties
{
     bNoDelete=True
     bClientAnim=True
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.MausCurtain_m'
}
