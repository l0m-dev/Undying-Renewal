//=============================================================================
// GhelzStone.
//=============================================================================
class GhelzStone expands CutsceneChar;
//#exec MESH IMPORT MESH=GhelzStone_m SKELFILE=GhelzStone.ngf 

//#exec MESH NOTIFY SEQ=0414a TIME=1.0 FUNCTION=Play14b
//#exec MESH NOTIFY SEQ=0414b TIME=1.0 FUNCTION=Play14c
//#exec MESH NOTIFY SEQ=0420 TIME=0.772 FUNCTION=DestroyStone
//#exec MESH NOTIFY SEQ=1310 TIME=0.950 FUNCTION=Play10a

var AmbroseCutscene Amb;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetBase(Owner,'Stone_Attach_Neck','Stone_Att');

	// if it's spawned (not placed in a level) don't replicate it
	if (Owner != None)
	{
		RemoteRole = ROLE_None;
	}
	else
	{
		// temp hack to avoid replication
		// only needed because this class is spawned
		// so we can't use bNoDelete
		// instead make a subclass and set bNoDelete=False there
		// and use that class for spawning instead
		if (string(Level.Outer) ~= "CU_04")
		{
			AnimName[13] = '0414a';
			AnimName[19] = '0420';
			CutsceneID = 4;
		}
	}
}

function DestroyStone()
{
	Destroy();
}

function Play10a()
{
	PlayAnim('1310a',,MOVE_AnimAbs,,0);
}

function Play14b()
{
	PlayAnim('0414b',,MOVE_AnimAbs,,0);
	// PlayAnim('0416b')
}

function Play14c()
{
	PlayAnim('0414c',,MOVE_AnimAbs,,0);
	// PlayAnim('0416b')
}


function Tick(float DeltaTime)
{
	bHidden = false;
}

/*
function FindAmbrose()
{
	ForEach AllActors(class 'AmbroseCutscene', Amb)
	{
		break;
	}
}
*/

function SetupTake(int Cutscene, int Take)
{
	// ====================================================
	// CU_04
	// ====================================================
	if ( Cutscene == 4 )
	{
		switch( Take )
		{
			case 20:
				SetBase(Amb,'RWrist','root');
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
			case 10:
				Unhide();
				break;
		}
	}
}

defaultproperties
{
     Style=STY_Masked
     Mesh=SkelMesh'Cutscenes.Meshes.GhelzStone_m'
     bNoDelete=False
}
