//=============================================================================
// FogCS.
//=============================================================================
class FogCS expands CutsceneChar;
//#exec MESH IMPORT MESH=FogCS_m SKELFILE=FogCS.ngf

defaultproperties
{
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Cutscenes.Meshes.FogCS_m'
     bUnlit=True
}
