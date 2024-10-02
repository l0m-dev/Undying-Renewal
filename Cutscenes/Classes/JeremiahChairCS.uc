//=============================================================================
// JeremiahChairCS.
//=============================================================================
class JeremiahChairCS expands CutsceneChar;

//#exec MESH IMPORT MESH=JeremiahChairCS_m SKELFILE=JeremiahChairCS.ngf 

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
				SetLocation(vect(-3624.45,-2492.65,388.03));
				break;

			// Take 2
			case 1:
				UnHide();
				SetLocation(vect(-3624.45,-2492.65,388.03));
				break;

			// Take 3
			case 2:
				UnHide();
				SetLocation(vect(-3624.45,-2492.65,388.03));
				break;

			// Take 4
			case 3:
				Hide();
				break;
			
			// Take 5
			case 4:
				UnHide();
				SetLocation(vect(-3610.92,-2492.65,388.03));
				break;
			
			// Take 6
			case 5:
				UnHide();
				SetLocation(vect(-3610.92,-2492.65,388.03));
				break;
			
			// Take 7
			case 6:
				UnHide();
				SetLocation(vect(-3610.92,-2512.16,388.03));
				break;
			
			// Take 8
			case 7:
				Hide();
				break;
			
			// Take 9
			case 8:
				UnHide();
				SetLocation(vect(-3610.92,-2492.65,388.03));
				break;
			
			// Take 10
			case 9:
				Hide();
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
				SetLocation(vect(-3610.92,-2492.65,388.03));
				break;
			
			// Take 14
			case 13:
				UnHide();
				SetLocation(vect(-3610.92,-2492.65,388.03));
				break;
			
			// Take 15
			case 14:
				UnHide();
				SetLocation(vect(-3551.87,-2499.25,388.03));
				break;
			
			// Take 16
			case 15:
				UnHide();
				SetLocation(vect(-3551.87,-2499.25,388.03));
				break;
			
			// Take 17
			case 16:
				UnHide();
				SetLocation(vect(-3551.87,-2499.25,388.03));
				break;
			
			// Take 18
			case 17:
				Hide();
				break;
			
			// Take 19
			case 18:
				UnHide();
				SetLocation(vect(-3551.87,-2499.25,388.03));
				break;
			
			// Take 20
			case 19:
				UnHide();
				SetLocation(vect(-3551.87,-2499.25,388.03));
				break;
			
			// Take 21
			case 20:
				UnHide();
				SetLocation(vect(-3551.87,-2499.25,388.03));
				break;

			// Take 22
			case 21:
				UnHide();
				SetLocation(vect(-3382.76,-2499.25,388.03));
				break;
			
			// Take 23
			case 22:
				Hide();
				break;
		}
	}
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.JeremiahChairCS_m'
}
