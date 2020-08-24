//=============================================================================
// WaterRingSmall.
//=============================================================================
class WaterRingSmall expands Effects;

//#exec MESH IMPORT MESH=WaterRingSmall_m SKELFILE=WaterRingSmall.ngf 


auto state foo
{

	function BeginState()
	{
		Disable('Tick');
	}
	
	function Tick(float DeltaTime)
	{
		DrawScale += 0.1;
		Opacity -= 0.03;
		
		if ( Opacity <= 0 )
			Destroy();

	}
	
	Begin:
		Sleep (0.2 + FRand() * 0.35);
		Enable('Tick');
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.WaterRingSmall_m'
     DrawScale=0.1
}
