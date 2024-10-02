//=============================================================================
// WaterRing.
//=============================================================================
class WaterRing expands RingExplosion;

//#exec MESH IMPORT MESH=WaterRing_m SKELFILE=WaterRing.ngf

var float Rate, ORate;


simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	Rate = RandRange(0.02, 0.2);
	ORate = RandRange(0.5, 1.5);
}

simulated function Tick(float DeltaTime)
{
	DrawScale += Rate;
	Opacity -= DeltaTime * ORate;

	if ( Opacity <= 0 )
		Destroy();
}

defaultproperties
{
     bNetOptional=True
     LifeSpan=0
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.WaterRing_m'
     DrawScale=0.1
}
