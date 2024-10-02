//=============================================================================
// DarkMonkCutscene.
//=============================================================================
class DarkMonkCutscene expands CutsceneChar;
//#exec MESH IMPORT MESH=DarkMonkCutscene_m SKELFILE=DarkMonkCutscene.ngf 
//#exec MESH JOINTNAME Head=Hood Neck=Head

var Actor Oar;

function PreBeginPlay()
{
	Oar = Spawn(class 'aeons.Oar',self,,Location);
	Oar.BHidden = true;
}

function OarInHands()
{
	if (Oar == none)
		Oar = Spawn(class 'aeons.Oar',self,,Location);

	Oar.SetBase(self, 'R_Index1', 'Oar3');
	Oar.bHidden = false;
}

function GetRidOfOar()
{
	Oar.bHidden = true;
}

function UnHide()
{
	bHidden = false;
	// Oar.bHidden= false;
}

function Hide()
{
	bHidden = true;
	Oar.bHidden= true;
}

function SetupTake(int Cutscene, int Take)
{
	// ====================================================
	// CU_10
	// ====================================================
	if ( Cutscene == 10 )
	{
		log("SetupTake "$Cutscene, 'Misc');
		
		if (Oar != none)
		{
			Oar.Destroy();
		}
		
		switch( Take )
		{
			case 0:
				UnHide();
				break;
			case 1:
				UnHide();
				break;
			case 2:
				UnHide();
				break;
			case 3:
				UnHide();
				break;
			case 4:
				Hide();
				break;
			case 5:
				Hide();
				break;
			case 6:
				Hide();
				break;
		}
	}
	
	// ====================================================
	// CU_13
	// ====================================================
	if ( Cutscene == 13 )
	{
		switch( Take )
		{
			case 0:
				Hide();

			case 8:
				bHidden = false;
				OarInHands();
				break;
			case 9:
				Oar.bHidden = true;
				break;
			case 11:
				Oar.bHidden = false;
				break;
		}
	}
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.DarkMonkCutscene_m'
}
