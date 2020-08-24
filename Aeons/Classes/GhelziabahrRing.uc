//=============================================================================
// GhelziabahrRing.
//=============================================================================
class GhelziabahrRing expands Effects;

//#exec MESH IMPORT MESH=GhelziabahrRing_m SKELFILE=GhelziabahrRing.ngf

function PreBeginPlay()
{
	super.PreBeginPlay();
}

function Tick(float DeltaTime)
{
	DrawScale += 32 * DeltaTime;
	
	if (DrawScale > 16)
		Destroy();
}

defaultproperties
{
	 RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.GhelziabahrRing_m'
     bUnlit=True
}
