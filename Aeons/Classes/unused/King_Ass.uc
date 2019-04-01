//=============================================================================
// KIng_Ass.
//=============================================================================
class King_Ass expands King_Part;
#exec MESH IMPORT MESH=King_Ass_m SKELFILE=King_Ass.ngf


state AssDoNothing expands AIFrozenState
{
	function BeginState()
	{
		DebugBeginState();
	}

	function EndState()
	{
		DebugEndState();
	}
}

state AIWait
{
	function BeginState()
	{
		super.BeginState();
	
		PlayWait();
		GotoState( 'AssDoNothing' );
	}
}

defaultproperties
{
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.King_Ass_m'
     CollisionRadius=300
     CollisionHeight=150
     bCollideSkeleton=False
}
