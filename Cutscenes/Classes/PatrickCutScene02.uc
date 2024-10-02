//=============================================================================
// PatrickCutScene02.
//=============================================================================
class PatrickCutScene02 expands CutSceneChar;

//#exec MESH IMPORT MESH=PatrickCS02_m SKELFILE=PatrickCS02.ngf
//#exec MESH MODIFIERS Head:PatrickHair
//#exec MESH NOTIFY SEQ=0212 TIME=0.142 FUNCTION=GunInHand

var Actor Revolver;
var Actor Scroll;
var Actor Helmet;
var Actor Stone;
var AeonsPlayer Player;

function FindPlayer()
{
	ForEach AllActors (class 'AeonsPlayer', Player)
	{
		break;
	}
}

function PreBeginPlay()
{
	Revolver = Spawn(Class'Aeons.HeldRevolver',self,,Location);
	Revolver.bHidden = true;
	Scroll = Spawn(class 'Aeons.HeldScroll',self,,Location);
	Scroll.bHidden = true;
	Helmet = Spawn(class 'Aeons.WWIHelmet',self,,Location);
	Helmet.bHidden = true;
	Stone = Spawn(class 'Cutscenes.GhelzStone',self,,Location);
	Stone.bHidden = true;
	Revolver.ShadowImportance = 0;
	Scroll.ShadowImportance = 0;
	Helmet.ShadowImportance = 0;
	Stone.ShadowImportance = 0;
}

function Tick(float DeltaTime)
{
	if ( Scroll != none )
		Scroll.bHidden = self.bHidden;
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

function ScrollInHand()
{
	if ( Scroll != none )
	{
		Scroll.bHidden = false;
		Scroll.SetBase(self, 'R_Wrist','Scroll_Att');
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

function Hide()
{
	bHidden = true;
	Revolver.bHidden = true;
	Stone.bHidden = true;
	Scroll.bHidden = true;
	Helmet.bHidden = true;
}

function UnHide()
{
	bHidden = false;
	Revolver.bHidden = false;
	Stone.bHidden = false;
	Scroll.bHidden = false;
	Helmet.bHidden = false;
}

function LoseStone()
{
	Stone.bHidden = true;
}

function PlayerHoldsRevoler()
{
	local weapon NewWeapon;

	if ( (Player.Weapon != None) && (Player.Weapon.Inventory != None) )
		newWeapon = Weapon(Player.Weapon.Inventory.FindItemInGroup(1));
	else
		newWeapon = None;	
	if ( newWeapon == None )
		newWeapon = Weapon(Player.Inventory.FindItemInGroup(1));
	if ( newWeapon == None )
		return;

	if ( Player.Weapon == None )
	{
		Player.PendingWeapon = newWeapon;
		Player.ChangedWeapon();
	} else {
		Player.Weapon = newWeapon;
		Player.PendingWeapon = newWeapon;
	}
}


function SetupTake(int Cutscene, int Take)
{
	if ( Cutscene == 2 )
	{
		// log("Patrick02 SetupTake "$Cutscene, 'Misc');

		// PlayAnim( Sequence, Rate, move, combine, TweenTime, JointName, AboveJoint, OverrideTarget );

		// Reset the mouth
		PlayAnim('ResetMouth_Morph',10,,,0);
		switch( Take )
		{
			case 0:
				StoneAroundNeck();
				GunInHolster();
				FindPlayer();
				PlayerHoldsRevoler();
				break;

			case 1:
				StoneAroundNeck();
				GunInHolster();
				break;

			case 2:
				StoneAroundNeck();
				GunInHolster();
				break;
			
			case 3:
				StoneAroundNeck();
				GunInHolster();
				break;
			
			case 4:
				StoneAroundNeck();
				GunInHolster();
				break;
			
			case 5:
				GunInHolster();
				break;
			
			case 6:
				GunInHolster();
				break;
			
			case 7:
				Hide();
				break;
			
			case 8:
				Hide();
				break;
			
			case 9:
				UnHide();
				GunInHolster();
				break;
			
			case 10:
				GunInHolster();
				break;
			
			case 11:
				GunInHolster();
				break;
			 
			case 12:
				GunInHand();
				break;
			
			case 13:
				GunInHand();
				break;
			
			case 14:
				GunInHand();
				break;
			
			case 15:
				GunInHand();
				break;

			case 16:
				GunInHand();
				break;
		}
	}
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.PatrickCS02_m'
}
