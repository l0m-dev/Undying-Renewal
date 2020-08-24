//=============================================================================
// ShotgunMuzzleFlash.
//=============================================================================
class ShotgunMuzzleFlash expands MuzzleFlash;

//#exec MESH IMPORT MESH=ShotgunMuzzleFlash_m SKELFILE=ShotgunMuzzleFlash_m.ngf

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
     Mesh=SkelMesh'Aeons.Meshes.ShotgunMuzzleFlash_m'
     bUnlit=True
}
