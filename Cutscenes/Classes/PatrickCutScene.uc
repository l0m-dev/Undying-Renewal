//=============================================================================
// PatrickCutScene.
//=============================================================================
class PatrickCutScene expands CutSceneChar;

//#exec MESH IMPORT MESH=PatrickCS_m SKELFILE=PatrickCS.ngf
//#exec MESH MODIFIERS Head:PatrickHair

//#exec MESH NOTIFY SEQ=0111 TIME=0.40 FUNCTION=FireGun
//#exec MESH NOTIFY SEQ=0737 TIME=0.24 FUNCTION=LightFlash

//=============================================================================
var Actor Revolver;
var Actor Scroll;
var Actor Helmet;
var Actor Stone;
var Patrick Player;

function PreBeginPlay()
{
	Revolver = Spawn(Class'Aeons.HeldRevolver',self,,Location);
	Revolver.bHidden = true;
	Revolver.ShadowImportance = 0;
	Scroll = Spawn(class 'Aeons.HeldScroll',self,,Location);
	Scroll.bHidden = true;
	Scroll.ShadowImportance = 0;
	Helmet = Spawn(class 'Aeons.WWIHelmet',self,,Location);
	Helmet.bHidden = true;
	Helmet.ShadowImportance = 0;
	Stone = Spawn(class 'Cutscenes.GhelzStone',self,,Location);
	Stone.bHidden = true;
	Stone.ShadowImportance = 0;
}

function LightFlash()
{
	local Actor A;

	ForEach AllActors(class 'Actor', A, 'LightFlash')
	{
		A.Trigger(none, none);
	}
}

function FindPlayer()
{
	ForEach AllActors(class 'Patrick', Player)
	{
		break;
	}
}

function FireGun()
{
	local vector Loc;

	if ( Revolver != none )
	{
		Loc = Revolver.JointPlace('Rev0').pos;
		Spawn(class'Aeons.ShotgunSmokeFX',,, Loc);
	}
}

function GunInHolster()
{
	if ( Revolver != none )
	{
		Revolver.bHidden = false;
		Revolver.SetBase(self, 'Revolver_Attach_Belt','Root');
		Revolver.Mesh = Mesh'Aeons.Revolver_Half_m';
	}
}

function GunInHand()
{
	if ( Revolver != none )
	{
		Revolver.bHidden = false;
		Revolver.SetBase(self, 'Revolver_Attach_Hand','Root');
		Revolver.Mesh = SkelMesh'Aeons.Revolver3rd_m';
	}
}

function Hide()
{
	bHidden = true;
	
	if (Revolver != none)
		Revolver.bHidden = true;
	
	if (Scroll != none)
		Scroll.bHidden = true;
	
	if (Helmet != none)
		Helmet.bHidden = true;

	if (Stone != none)
		Stone.bHidden = true;
}

function UnHide()
{
	bHidden = false;
	
	if (Revolver != none)
		Revolver.bHidden = false;
	
	if (Scroll != none)
		Scroll.bHidden = false;
	
	if (Helmet != none)
		Helmet.bHidden = false;
	
	if (Stone != none)
		Stone.bHidden = false;
}

function ScrollInHand()
{
	if ( Scroll != none )
	{
		Scroll.bHidden = false;
		Scroll.SetBase(self, 'Scroll_Att','Scroll_Att');
	}
}

function HelmetOnHead()
{
	if ( Helmet != none )
	{
		Helmet.bHidden = false;
		Helmet.SetBase(self, 'Head','Helmet');
	}
}

function StoneAroundNeck()
{
	if ( Stone != none )
	{
		Stone.SetBase(self, 'Stone_Attach_Neck', 'StoneAtt');
		Stone.bHidden = false;
	}
}

function LoseStone()
{
	// Stone.SetBase(self, '', '');
	Stone.bHidden = true;
}

function SetupTake(int Cutscene, int Take)
{

	if ( Take == 0 )
		switch( Cutscene )
		{
			case 4:
				Scroll.Destroy();
				Helmet.Destroy();
				break;
				
			case 5:
			case 6:
			case 7:
			case 11:
			case 13:
			case 12:
				Revolver.Destroy();
				Scroll.Destroy();
				Helmet.Destroy();
				break;

			case 8:
				Scroll.Destroy();
				Helmet.Destroy();
				break;
		};

	// ====================================================
	// CU_01
	// ====================================================
	if ( Cutscene == 1 )
	{
		switch( Take )
		{
			case 5:
				Stone.Destroy();
				break;

			case 9:
				UnHide();
				GunInHand();
				HelmetOnHead();
				break;
			
			case 19:
				Revolver.Destroy();
				Helmet.Destroy();
				PlayAnim('');
				break;
			
			case 20:
				Stone = Spawn(class 'Cutscenes.GhelzStone',self,,Location);
				StoneAroundNeck();
				break;
		}
	}	// 01

	// ====================================================
	// CU_02
	// ====================================================
	if ( Cutscene == 2 )
	{
		switch( Take )
		{
			// put your glasses on and get your pipe
			case 0:
				GunInHand();
				break;
		}
	}	// 02

	// ====================================================
	// CU_03
	// ====================================================
	if ( Cutscene == 3 )
	{
		
		switch( Take )
		{
			// put scroll in your hand
			case 20:
				ScrollInHand();
				break;
		}
	}	// 03

	// ====================================================
	// CU_04
	// ====================================================
	if ( Cutscene == 4 )
	{

		switch( Take )
		{
			// put scroll in your hand
			case 0:
				StoneAroundNeck();
				break;
			case 13:
				Stone.Destroy();
				break;
		}
	}	// 04

	// ====================================================
	// CU_05
	// ====================================================
	if ( Cutscene == 5 )
	{
		switch( Take )
		{
			// put scroll in your hand
			case 0:
				StoneAroundNeck();
				GunInHolster();
				break;
		}
	} // 05

	// ====================================================
	// CU_07
	// ====================================================
	if ( Cutscene == 7 )
	{
		switch( Take )
		{
			case 0:
				StoneAroundNeck();
				Hide();
				break;
			
			case 1:
				UnHide();
				break;

			case 3:
				Hide();
				break;
			
			case 6:
				UnHide();
				break;

			case 10:
				Hide();
				break;
			
			case 16:
				UnHide();
				break;
			
			case 30:
				SetLocation(vect(0,0,0));
				Hide();
				break;

			case 31:
				UnHide();
				break;
			
			case 33:
				Hide();
				break;
			
			case 34:
				UnHide();
				break;
			
			case 39:
				Hide();
				break;
			
			case 40:
				Hide();
				break;
		}
	}	// 07


	// ====================================================
	// CU_08
	// ====================================================
	if ( Cutscene == 8 )
	{
		switch( Take )
		{
			// put scroll in your hand
			case 0:
				UnHide();
				GunInHolster();
				StoneAroundNeck();
				break;
			case 2:
				Hide();
				break;
			case 3:
				UnHide();
				break;
			case 5:
				Hide();
				break;
			case 6:
				UnHide();
				break;
			case 8:
				Hide();
				break;
			case 9:
				UnHide();
				break;
			case 10:
				Hide();
				break;
			case 11:
				UnHide();
				break;
			case 12:
				Hide();
				break;
			case 14:
				UnHide();
				break;
			case 15:
				Hide();
				break;
			case 16:
				UnHide();
				break;
			case 17:
				Hide();
				break;
			case 19:
				UnHide();
				break;
		}
	}	// 08
	
	// ====================================================
	// CU_09
	// ====================================================
	if ( Cutscene == 9 )
	{
		UnHide();
		switch( Take )
		{
			// put scroll in your hand
			case 0:
				StoneAroundNeck();
				GunInHolster();
				break;
		}
		Scroll.bHidden = true;
		Helmet.bHidden = true;
	}	// 09

	// ====================================================
	// CU_12
	// ====================================================
	if ( Cutscene == 12 )
	{
		PlayAnim('');
		switch( Take )
		{
		}
	}	// 12

	// ====================================================
	// CU_13
	// ====================================================
	if ( Cutscene == 13 )
	{
		PlayAnim('');
		switch( Take )
		{
			case 0:
				UnHide();
				StoneAroundNeck();
				break;

			case 2:
				Hide();
				break;

			case 3:
				UnHide();
				break;

			case 7:
				Hide();
				break;
			case 8:
				UnHide();
				break;
			
			case 10:
				Stone.Destroy();
				break;

			case 12:
				Hide();
				break;
			
			case 15:
				FindPlayer();
				Player.RainDance();
				break;
			
			case 16:
				Player.ClearWeather();
				break;
		}
	}	// 13

}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.PatrickCS_m'
     CollisionHeight=64
}
