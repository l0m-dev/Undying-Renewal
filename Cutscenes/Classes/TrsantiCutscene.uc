//=============================================================================
// TrsantiCutscene.
//=============================================================================
class TrsantiCutscene expands CutSceneChar;

//#exec MESH IMPORT MESH=TrsantiCS_m SKELFILE=TrsantiCS.ngf

//#exec MESH NOTIFY SEQ=0106a TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0106a TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0106b TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0106b TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0106c TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0106c TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0106d TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0106d TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0106e TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0106e TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0106f TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0106f TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0106g TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0106g TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0106h TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0106h TIME=0.0 FUNCTION=BayonetInHand

//#exec MESH NOTIFY SEQ=0107a TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0107a TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0107b TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0107b TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0107c TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0107c TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0107d TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0107d TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0107e TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0107e TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0107f TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0107f TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0107g TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0107g TIME=0.0 FUNCTION=BayonetInHand
//#exec MESH NOTIFY SEQ=0107h TIME=0.0 FUNCTION=HelmetOnHead
//#exec MESH NOTIFY SEQ=0107h TIME=0.0 FUNCTION=BayonetInHand

//#exec MESH NOTIFY SEQ=0108a TIME=0.0 FUNCTION=SwordInHand
//#exec MESH NOTIFY SEQ=0108b TIME=0.0 FUNCTION=SwordInHand
//#exec MESH NOTIFY SEQ=0108c TIME=0.0 FUNCTION=SwordInHand
//#exec MESH NOTIFY SEQ=0108d TIME=0.0 FUNCTION=SwordInHand
//#exec MESH NOTIFY SEQ=0108e TIME=0.0 FUNCTION=SwordInHand

//#exec MESH NOTIFY SEQ=0109 TIME=0.0 FUNCTION=SwordInHand
//#exec MESH NOTIFY SEQ=0110 TIME=0.0 FUNCTION=SwordInHand
//#exec MESH NOTIFY SEQ=0111 TIME=0.0 FUNCTION=SwordInHand

//#exec MESH NOTIFY SEQ=0916a TIME=1.0 FUNCTION=Play0916a
//#exec MESH NOTIFY SEQ=0916b TIME=1.0 FUNCTION=Play0916b
//#exec MESH NOTIFY SEQ=0916c TIME=1.0 FUNCTION=Play0916c
//#exec MESH NOTIFY SEQ=0916d TIME=1.0 FUNCTION=Play0916d
//#exec MESH NOTIFY SEQ=0916e TIME=1.0 FUNCTION=Play0916e

//=============================================================================

var Actor Helmet, Bayonet, Sword;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Helmet = Spawn(class 'Aeons.TrsantiHelmet',self,,Location);
	Helmet.bHidden = true;
	Sword = Spawn(class 'Aeons.TrsantiSword',self,,Location);
	Sword.bHidden = true;
	Bayonet = Spawn(class 'Aeons.TrsantiBayonet',self,,Location);
	Bayonet.bHidden = true;
}

function Hide()
{
	bHidden = true;
	Helmet.bHidden = true;
	Sword.bHidden = true;
	Bayonet.bHidden = true;
}

function UnHide()
{
	bHidden = false;
	Helmet.bHidden = false;
	Sword.bHidden = false;
	Bayonet.bHidden = false;
}

function Destroyed()
{
	Helmet.Destroy();
	Sword.Destroy();
	Bayonet.Destroy();
}

function Play0916a()
{
	PlayAnim('0916a',,MOVE_AnimAbs,,0.25);
}

function Play0916b()
{
	PlayAnim('0916b',,MOVE_AnimAbs,,0.25);
}

function Play0916c()
{
	PlayAnim('0916c',,MOVE_AnimAbs,,0.25);
}

function Play0916d()
{
	PlayAnim('0916d',,MOVE_AnimAbs,,0.25);
}

function Play0916e()
{
	PlayAnim('0916e',,MOVE_AnimAbs,,0.25);
}

function SwordInHand()
{
	if ( Sword != none )
	{
		Bayonet.bHidden = true;
		Sword.bHidden = false;
		Sword.SetBase(self, 'SwordHand','Sword');
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

function BayonetInHand()
{
	if ( Bayonet != none )
	{
		Sword.bHidden = true;
		Bayonet.bHidden = false;
		Bayonet.SetBase(self, 'R_Index1','bayohandle');
	}
}

function LoseHelmet()
{
	Helmet.Destroy();
}

function SetupTake(int Cutscene, int Take)
{

	// ====================================================
	// CU_01
	// ====================================================
	if ( Cutscene == 1 )
	{
		switch( Take )
		{
			case 7:
				LoseHelmet();
				break;
		}; 
	}
	// ====================================================
	// CU_09
	// ====================================================
	if ( Cutscene == 9 )
	{
		switch( Take )
		{
			case 0:
				Helmet.Destroy();
				Bayonet.Destroy();
				Sword.Destroy();
				break;
		}; 
	}
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.TrsantiCS_m'
}
