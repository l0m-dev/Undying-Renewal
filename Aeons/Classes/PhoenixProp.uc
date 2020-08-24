//=============================================================================
// PhoenixProp.
//=============================================================================
class PhoenixProp expands Decoration;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	PlayAnim ('Pickup_Pose');
}

function Tick(float DeltaTime)
{
	local rotator r;

	r = rotation;
	r.yaw += 8192 * DeltaTime;
	SetRotation(r);
}

defaultproperties
{
     bStatic=False
     bStasis=False
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Phoenix_m'
     Opacity=0.5
}
