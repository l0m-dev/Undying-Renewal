//=============================================================================
// CeltCutscene.
//=============================================================================
class CeltCutscene expands CutsceneChar;

// #exec MESH IMPORT MESH=Celt_m SKELFILE=Celt.ngf INHERIT=ScriptedBiped_m

// Celt ============================================
//#exec MESH IMPORT MESH=Celt_m SKELFILE=Celt.ngf
//#exec MESH NOTIFY SEQ=0745 TIME=0.283 FUNCTION=Explode

// Shield ============================================
//#exec MESH IMPORT MESH=Celt_Shield SKELFILE=CeltShield\Celt_Shield.ngf

var Actor Mask;
var Actor Shield;

function Hide()
{
	bHidden = true;
	if ( Mask != none )
		Mask.bHidden = true;
	if ( Shield != none )
		Shield.bHidden = true;
}

function UnHide()
{
	bHidden = false;
	if ( Mask != none )
		Mask.bHidden = false;
	if ( Shield != none )
		Shield.bHidden = false;
}

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Mask = Spawn(class 'Aeons.CeltMask',self,,Location);
	Mask.bHidden = true;
}

function MaskOnFace()
{
	if ( Mask != none )
	{
		// Mask.SetLocation( self.(GetJointPlace('Head')).pos );
		Mask.SetBase( self, 'Head', 'Mask' );
		Mask.bHidden = false;
	}
}

function Explode()
{
	Spawn (class 'SmokyDynamiteExplosionFX'  ,,,Location);
	Hide(); // Destroy();
}

function SetupTake(int Cutscene, int Take)
{
	// ====================================================
	// CU_07
	// ====================================================
	if ( Cutscene == 7 )
	{
		switch( Take )
		{
			case 0:
				Mask.Destroy();
				Hide();
				break;

			case 42:
				ShadowImportance = 0;
				UnHide();
				break;

			case 43:
				Hide();
				break;
			
			case 44:
				ShadowImportance = 1;
				UnHide();
				break;
		}
	}	// 07
	
	// ====================================================
	// CU_10
	// ====================================================
	if ( Cutscene == 10 )
	{
		switch( Take )
		{
			case 0:
				UnHide();
				MaskOnFace();
				break;

			case 3:
				Hide();
				break;

			case 4:
				UnHide();
				break;
		}
	}	// 07

}

defaultproperties
{
     Style=STY_Masked
     Mesh=SkelMesh'Cutscenes.Meshes.Celt_m'
}
