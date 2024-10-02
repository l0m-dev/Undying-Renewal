//=============================================================================
// UpholsteredChairCS.
//=============================================================================
class UpholsteredChairCS expands CutsceneChar;

//#exec MESH IMPORT MESH=UpholsteredChairCS_m SKELFILE=UpholsteredChairCS.ngf

function Hide()
{
	bHidden=true;
}

function UnHide()
{
	bHidden=false;
}

function SetupTake(int Cutscene, int Take)
{

	// ====================================================
	// CU_04
	// ====================================================
	if ( Cutscene == 4 )
	{
		log("SetupTake "$Cutscene, 'Misc');
		
		switch( Take )
		{
			// Take 1
			case 0:
				UnHide();
				SetLocation(vect(-3855.15,-2409.37,371.13));
				break;

			// Take 2
			case 1:
				UnHide();
				SetLocation(vect(-3855.15,-2409.37,371.13));
				break;

			// Take 3
			case 2:
				UnHide();
				SetLocation(vect(-3855.15,-2395.57,371.13));
				break;

			// Take 4
			case 3:
				Hide();
				break;
			
			// Take 5
			case 4:
				UnHide();
				SetLocation(vect(-3855.15,-2367.16,371.13));
				break;
			
			// Take 6
			case 5:
				UnHide();
				SetLocation(vect(-3855.15,-2367.16,371.13));
				break;
			
			// Take 7
			case 6:
				Hide();
				break;
			
			// Take 8
			case 7:
				Hide();
				break;
			
			// Take 9
			case 8:
				Hide();
				break;
			
			// Take 10
			case 9:
				UnHide();
				SetLocation(vect(-3855.15,-2367.16,371.13));
				break;
			
			// Take 11
			case 10:
				Hide();
				break;
			
			// Take 12
			case 11:
				Hide();
				break;
			
			// Take 13
			case 12:
				UnHide();
				SetLocation(vect(-3855.15,-2367.16,371.13));
				break;
			
			// Take 14
			case 13:
				UnHide();
				SetLocation(vect(-3864.1,-2353.01,371.13));
				break;
			
			// Take 15
			case 14:
				Hide();
				break;
			
			// Take 16
			case 15:
				UnHide();
				SetLocation(vect(-3864.1,-2353.01,371.13));
				break;
			
			// Take 17
			case 16:
				Hide();
				break;
			
			// Take 18
			case 17:
				Hide();
				break;
			
			// Take 19
			case 18:
				UnHide();
				SetLocation(vect(-3864.1,-2353.01,371.13));
				break;
			
			// Take 20
			case 19:
				UnHide();
				SetLocation(vect(-3864.1,-2353.01,371.13));
				break;
			
			// Take 21
			case 20:
				Hide();
				break;

			// Take 22
			case 21:
				UnHide();
				SetLocation(vect(-3985.75,-2421.28,371.13));
				break;
			
			// Take 23
			case 22:
				UnHide();
				SetLocation(vect(-4047.49,-2592.38,371.13));
				break;
		}
	}
}

defaultproperties
{
     Style=STY_Masked
     Mesh=SkelMesh'Cutscenes.Meshes.UpholsteredChairCS_m'
}
