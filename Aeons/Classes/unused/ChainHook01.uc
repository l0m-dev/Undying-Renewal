//=============================================================================
// ChainHook01.
//=============================================================================
class ChainHook01 expands Ornaments;

#exec MESH IMPORT MESH=ChainHook01_m SKELFILE=ChainHook01.ngf 
#exec MESH MODIFIERS Chain01:Chain

defaultproperties
{
     bStatic=False
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.ChainHook01_m'
     ShadowImportance=0
}
