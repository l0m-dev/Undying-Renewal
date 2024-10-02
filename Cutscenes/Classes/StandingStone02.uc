//=============================================================================
// StandingStone02.
//=============================================================================
class StandingStone02 expands cutscenechar;

//#exec MESH IMPORT MESH=StandingStone02_m SKELFILE=StandingStone02.ngf 
//#exec MESH NOTIFY SEQ=0742 TIME=0.3000 FUNCTION=Explode

function Explode()
{
	local Actor A;

	ForEach AllActors(class 'Actor', A, 'StandingStone02')
	{
		A.Trigger(self, none);
	}
}
function Hide()
{
	bHidden = true;
}

function SetupTake(int Cutscene, int Take)
{
	// ====================================================
	// CU_07
	// ====================================================
	if ( Cutscene == 7 )
	{
		switch( Take )
		{
			case 42:
				Hide();
				break;

		}
	}	// 07
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.StandingStone02_m'
     CollisionRadius=128
     CollisionHeight=320
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
}
