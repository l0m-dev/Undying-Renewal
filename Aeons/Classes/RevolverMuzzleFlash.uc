//=============================================================================
// RevolverMuzzleFlash.
//=============================================================================
class RevolverMuzzleFlash expands MuzzleFlash;

//#exec MESH IMPORT MESH=RevolverMuzzleFlash_m SKELFILE=RevolverMuzzleFlash.ngf

var bool b;


simulated function Tick(float deltaTime)
{
	if (b)
		Destroy();
	else
		b = true;
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.RevolverMuzzleFlash_m'
     DrawScale=2.5
     bUnlit=True
}
