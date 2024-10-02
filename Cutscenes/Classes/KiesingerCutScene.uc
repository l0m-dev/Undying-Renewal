//=============================================================================
// KiesingerCutScene.
//=============================================================================
class KiesingerCutScene expands CutSceneChar;

//#exec MESH IMPORT MESH=KiesingerCS_m SKELFILE=KiesingerCS.ngf
//#exec MESH JOINTNAME Neck=Head
//#exec MESH MODIFIERS Skirt1:ClothCollide Cape1:ClothingBack LSleeve1:Cloth RSleeve1:Cloth

//#exec MESH NOTIFY SEQ=1113 TIME=0.671 FUNCTION=LightningFingers

//#exec MESH IMPORT MESH=KiesingerCS12_m SKELFILE=KiesingerCS.ngf

function LightningFingers()
{
	local SPLightningFingers lf;

	LogStack();
	lf = spawn( class'SPLightningFingers', self,, JointPlace( 'R_Hand1' ).pos );
	if( lf != none )
		lf.InitFingers( 'R_Hand1', 'L_Hand' );
	else
		LogActor("LightningFingers() couldn't spawn lightning fingers.");
}

function SetupTake(int Cutscene, int Take)
{

	// ====================================================
	// CU_11
	// ====================================================
	if ( Cutscene == 11)
	{
		switch( Take )
		{
			case 0:
				break;
		}
	}
	
	if ( Cutscene == 12)
	{
		switch( Take )
		{
			case 0:
				Mesh = SkelMesh'Cutscenes.KiesingerCS12_m';
				break;
		}
	}

}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.KiesingerCS_m'
}
