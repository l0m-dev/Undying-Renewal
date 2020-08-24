//=============================================================================
// DispelFX.
//=============================================================================
class DispelFX expands Effects;
//#exec MESH IMPORT MESH=DispelFX_m SKELFILE=DispelFX.ngf 

var vector InitialLocation;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	DrawScale = 0.25;
}

function Tick(float DeltaTime)
{
	DrawScale += ( DeltaTime * 16.0 );

	// SetLocation( InitialLocation + vect(0,0,1) * (DrawScale * 128.0) );
	if ( DrawScale > 4.0 )
		GotoState('FadeAway');
}


state FadeAway
{
	
	function Tick(float DeltaTime)
	{
		DrawScale += ( DeltaTime * 16.0 );
		Opacity -= DeltaTime * 2;
		
		if ( Opacity <= 0 )
			Destroy();
	}

}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.DispelFX_m'
     bUnlit=True
}
