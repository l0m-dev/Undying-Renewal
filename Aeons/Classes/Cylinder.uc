//=============================================================================
// Cylinder.
//=============================================================================
class Cylinder expands Decoration;

//#exec MESH IMPORT MESH=Cylinder SKELFILE=Cyl.ngf
//#exec MESH NOTIFY SEQ=cyl_skel TIME=0.5 FUNCTION=cyl_morph
	function Morph() { PlayAnim('cyl_morph'); }

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Cylinder'
}
