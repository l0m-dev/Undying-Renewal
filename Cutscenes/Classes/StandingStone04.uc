//=============================================================================
// StandingStone04.
//=============================================================================
class StandingStone04 expands cutscenechar;

//#exec MESH IMPORT MESH=StandingStone04_m SKELFILE=StandingStone04.ngf 

function Explode()
{
	local Actor A;

	ForEach AllActors(class 'Actor', A, 'StandingStone04')
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
     Mesh=SkelMesh'Cutscenes.Meshes.StandingStone04_m'
     CollisionRadius=128
     CollisionHeight=320
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
}
