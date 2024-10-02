//=============================================================================
// TrsantiLtCutscene.
//=============================================================================
class TrsantiLtCutscene expands CutSceneChar;

//#exec MESH IMPORT MESH=Trsanti_LtCS_m SKELFILE=Trsanti_LtCS.ngf

//#exec MESH NOTIFY SEQ=0916a TIME=1.0 FUNCTION=Play0916a
//#exec MESH NOTIFY SEQ=0916b TIME=1.0 FUNCTION=Play0916b

var Actor Dagger1, Dagger2;

function PostBeginPlay()
{
	super.PostBeginPlay();
	DaggersInHands();
}

function Play0916a()
{
	PlayAnim('0916a',,MOVE_AnimAbs,,0.25);
}

function Play0916b()
{
	PlayAnim('0916b',,MOVE_AnimAbs,,0.25);
}

function DaggersInHands()
{
	Dagger1 = spawn(class 'TrsantiDagger1',,,Location);
	Dagger1.SetBase(self, 'ShotgunAtt', 'Knife1Att');

	Dagger2 = spawn(class 'TrsantiDagger2',,,Location);
	Dagger1.SetBase(self, 'Knife2Att', 'Knife2Att');
}

function SetupTake(int Cutscene, int Take)
{

	// ====================================================
	// CU_09
	// ====================================================
	if ( Cutscene == 9 )
	{
		switch( Take )
		{
			case 0:
				Dagger1.Destroy();
				Dagger2.Destroy();
				break;
		}; 
	}
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.Trsanti_LtCS_m'
}
