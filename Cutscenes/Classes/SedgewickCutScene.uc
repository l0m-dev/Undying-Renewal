//=============================================================================
// SedgewickCutScene.
//=============================================================================
class SedgewickCutScene expands CutSceneChar;

//#exec MESH IMPORT MESH=Sedgewick_cs_m SKELFILE=Sedgewick_cs.ngf

var Actor Hat;

function PreBeginPlay()
{
	Hat = Spawn(Class'Aeons.Sedgewick_Hat',self,,Location);
// 	SetOwner(Hat);
	Hat.bHidden = true;
	Hat.bMRM = false;
}

function Tick(float DeltaTime)
{
	if (Hat != none)
		Hat.bHidden = self.bHidden;
}

function HatOnHead()
{
	if ( Hat != none )
	{
		Hat.bHidden = false;
		Hat.SetBase(self, 'HatBone', 'Hat1');
	}
}


function SetupTake(int Cutscene, int Take)
{
	// ====================================================
	// CU_09
	// ====================================================
	if ( Cutscene == 9 )
	{
		log("SetupTake "$Cutscene, 'Misc');
		
		switch( Take )
		{
			// put your hat on
			case 0:
				HatOnHead();
				break;
		}
	}

}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.Sedgewick_cs_m'
}
