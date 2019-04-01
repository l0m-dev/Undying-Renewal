//=============================================================================
// GhelziabahrRing.
//=============================================================================
class GhelziabahrRing expands PlayerEffects;

#exec MESH IMPORT MESH=GhelziabahrRing_m SKELFILE=GhelziabahrRing.ngf

simulated function PreBeginPlay()
{
	setTimer(0.05,true);
	super.PreBeginPlay();
}

simulated function Timer()
{
	if ((8.0 - DrawScale) > 0.1)
		DrawScale += (0.5 * (8.0 - DrawScale));
	else
		Destroy();
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.GhelziabahrRing_m'
     bUnlit=True
}
