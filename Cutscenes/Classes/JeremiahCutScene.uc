//=============================================================================
// JeremiahCutScene.
//=============================================================================
class JeremiahCutScene expands CutSceneChar;

//#exec MESH IMPORT MESH=JeremiahCS_m SKELFILE=JeremiahCS.ngf
//#exec MESH JOINTNAME Neck=Head

//#exec MESH NOTIFY SEQ=0733 TIME=0.2666 FUNCTION=DestroyHead
//#exec MESH NOTIFY SEQ=0738 TIME=0.8260 FUNCTION=Explode
//#exec MESH NOTIFY SEQ=0317 TIME=0.2685 FUNCTION=ScrollInHand

var Actor Pipe;
var Actor Glasses;
var Actor Scroll;
var ParticleFX GFX, LiftFX;

function PreBeginPlay()
{
	Pipe = Spawn(Class'Aeons.Pipe',self,,Location);
	Glasses = Spawn(class 'Aeons.Glasses', self,,Location);
	Scroll = Spawn(class 'Aeons.HeldScroll',self,,Location);
	Scroll.bHidden = true;
	Pipe.bHidden = true;
	Glasses.bHidden = true;
	Scroll.ShadowImportance = 0;
	Pipe.ShadowImportance = 0;
	Glasses.ShadowImportance = 0;
}

function DestroyHead()
{
	DestroyLimb('Head');
	ReplicateDestroyLimb(self, 'Head');
}

function Explode()
{
	local Actor A;

	ForEach AllActors(class 'Actor', A, 'JeremiahExplodes')
	{
		A.Trigger(none, none);
	}

	Spawn (class 'SmokyDynamiteExplosionFX'  ,,,Location);
	if ( Glasses != none )
		Glasses.Destroy();
	Destroy();
}

function GlassesOnFace()
{
	if ( Glasses != none )
	{
		Glasses.bHidden = false;
		Glasses.SetBase(self, 'Face_Glasses', 'Attach_Face');
	}
}

function PipeInMouth()
{
	if ( Pipe != none )
	{
		Pipe.bHidden = false;
		Pipe.SetBase(self, 'Face_Pipe', 'Attach_Face');
	}
}

function PipeInHand()
{
	if (Pipe != none)
	{
		Pipe.bHidden = false;
		Pipe.SetBase(self, 'Hand_Pipe', 'Attach_Hand');
	}
}

function Hide()
{
	bHidden = true;
	if (Pipe != none)
		Pipe.bHidden = true;
	if (Glasses != none)
		Glasses.bHidden = true;
	Scroll.bHidden = true;
}
 
function UnHide()
{
	bHidden = false;
	if (Pipe != none)
		Pipe.bHidden = false;
	if (Glasses != none)
		Glasses.bHidden = false;
	Scroll.bHidden = false;
}

function ScrollInHand()
{
	local Scroll s;

	ForEach AllActors(class 'Scroll', s)
	{
		if (s != scroll)
		{
			s.Destroy();
		}
	}	

	if (Scroll != none)
	{
		Scroll.bHidden = false;
		Scroll.SetBase(self, 'Scroll_Att','Scroll_Att');
	}
}

function NoScroll()
{
	if (Scroll != none)
	{
		Scroll.Destroy();
	}
}

function SetupTake(int Cutscene, int Take)
{

	// ====================================================
	// CU_02
	// ====================================================
	if ( Cutscene == 2 )
	{
		log("SetupTake "$Cutscene, 'Misc');
		
		switch( Take )
		{
			// put your glasses on and get your pipe
			case 0:
				GlassesOnFace();
				PipeInMouth();
				UnHide();
				break;

			case 1:
				Hide();
				break;

			// pipe out of the mouth
			case 2:
				PipeInHand();
				UnHide();
				break;
			
			case 3:
				PipeInHand();
				UnHide();
				break;
			
			case 4:
				PipeInHand();
				UnHide();
				break;

			case 5:
				PipeInHand();
				UnHide();
				break;

			case 6:
				Hide();
				break;

			case 7:
				UnHide();
				break;

			case 8:
				Hide();
				break;
			
			case 9:
				Hide();
				break;

			case 10:
				PipeInMouth();
				UnHide();
				break;

			case 11:
				UnHide();
				break;
			
			case 12:
				Hide();
				break;

			case 13:
				UnHide();
				break;
			
			case 14:
				UnHide();
				break;
			
			case 15:
				UnHide();
				break;
			
			case 16:
				UnHide();
				break;
		}
	}

	// ====================================================
	// CU_03
	// ====================================================
	if ( Cutscene == 3 )
	{
		log("SetupTake "$Cutscene, 'Misc');

		switch( Take )
		{
			case 0:
				GlassesOnFace();
				Pipe.Destroy();
				// PipeInMouth();
				break;

			case 2:
				// PipeInHand();
				break;

			case 18:
				// ScrollInHand();
				break;

			case 19:
				Hide();
				break;

			case 20:
				NoScroll();
				UnHide();
				break;
		}
	}

	// ====================================================
	// CU_04
	// ====================================================
	if ( Cutscene == 4 )
	{
		log("SetupTake "$Cutscene, 'Misc');
		
		switch( Take )
		{
			case 0:
				UnHide();
				GlassesOnFace();
				break;

			case 3:
				Hide();
				break;

			case 4:
				UnHide();
				break;

			case 7:
				Hide();
				break;

			case 8:
				UnHide();
				break;

			case 9:
				if ( Glasses != none )
					Glasses.Destroy();
				break;

			case 10:
				Hide();
				break;
			
			case 11:
				UnHide();
				break;
			
			case 12:
				UnHide();
				break;
			
			case 13:
				UnHide();
				break;
			
			case 16:
				UnHide();
				break;
			
			case 17:
				UnHide();
				break;
			
			case 20:
				Hide();
				break;
			
			case 21:
				UnHide();
				break;
			
			case 22:
				Hide();
				break;

		}
	}

	// ====================================================
	// CU_07
	// ====================================================
	if ( Cutscene == 7 )
	{
		GlassesOnFace();
		switch( Take )
		{
			case 0:
				Scroll.Destroy();
				Pipe.Destroy();
				UnHide();
				break;

			case 1:
				Hide();
				break;
			
			case 2:
				UnHide();
				break;
			
			case 9:
				Hide();
				break;
			
			case 10:
				UnHide();
				break;
			
			case 12:
				Hide();
				break;
			
			case 13:
				UnHide();
				break;
			case 14:
				PlayAnim('');
				break;
			
			case 20:
				Hide();
				break;
			
			case 21:
				UnHide();
				break;
			
			case 27:
				Hide();
				break;
			
			case 28:
				UnHide();
				break;
			
			case 31:
				Hide();
				break;
			
			case 32:
				UnHide();
				Glasses.Destroy();
				break;
			
			case 33:
				Hide();
				break;
			
			case 34:
				LiftFX = Spawn(class 'JeremiahLiftFX',Self,,Location);
				UnHide();
				break;
			
			case 35:
				LiftFX.Destroy();
				Hide();
				break;

			case 37:
				GFX = Spawn (class 'LBGGlowFX',Self,,Location); 
				GFX.GotoState('NormalHold');
				UnHide();
				break;
		}
	}
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.JeremiahCS_m'
     CollisionHeight=64
}
