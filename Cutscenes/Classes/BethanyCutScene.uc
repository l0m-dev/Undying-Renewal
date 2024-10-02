//=============================================================================
// BethanyCutScene.
//=============================================================================
class BethanyCutScene expands CutSceneChar;

//#exec MESH IMPORT MESH=BethanyCS_m SKELFILE=BethanyCS.ngf

//#exec MESH IMPORT MESH=BethanyChange_m SKELFILE=Change\BethanyChange.ngf

//#exec MESH IMPORT MESH=BethanyCS_LA_m SKELFILE=LongArms\BethanyCS_LA.ngf
//#exec MESH MODIFIERS Sac1:Jello

var Actor Shawl;

function PreBeginPlay()
{
	Shawl = Spawn(class 'Aeons.BethanyShawl',self,,Location);
	Shawl.bHidden = true;
}

function Hide()
{
	bHidden = true;
	Shawl.bHidden = true;
}

function UnHide()
{
	bHidden = false;
	Shawl.bHidden = false;
}

function ShawlOnHead()
{
	Shawl.SetBase(self, 'head', 'shawl');
}

function Change()
{
	Mesh=SkelMesh'Cutscenes.Meshes.BethanyChange_m';
}

function ChangeToLongArms()
{
	Mesh=SkelMesh'Cutscenes.Meshes.BethanyCS_LA_m';
}

function SetupTake(int Cutscene, int Take)
{

	// ====================================================
	// CU_08
	// ====================================================
	if ( Cutscene == 8 )
	{
		switch (Take)
		{
			case 0:
				ShawlOnHead();
				Hide();
				break;
			
			case 1:
				UnHide();
				break;

			case 6:
				Hide();
				break;

			case 7:
				UnHide();
				break;
			
			case 8:
				Change();
				break;
			
			case 9:
				Hide();
				Shawl.Destroy();
				break;
			
			case 10:
				UnHide();
				break;
			
			case 16:
				Hide();
				break;
			
			case 17:
				UnHide();
				break;

			case 18:
				ChangeToLongArms();
				break;
			
		};
	}
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.BethanyCS_m'
}
