//=============================================================================
// StandingStone01.
//=============================================================================
class StandingStone01 expands cutscenechar;

//#exec MESH IMPORT MESH=StandingStone01_m SKELFILE=StandingStone01.ngf 
//#exec MESH NOTIFY SEQ=0742 TIME=0.96667 FUNCTION=Explode

function Explode()
{
	local Actor A;

	ForEach AllActors(class 'Actor', A, 'StandingStone01')
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
     Mesh=SkelMesh'Cutscenes.Meshes.StandingStone01_m'
     CollisionRadius=128
     CollisionHeight=320
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
}
