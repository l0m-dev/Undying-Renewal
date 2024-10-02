//=============================================================================
// PhoenixProp.
//=============================================================================
class PhoenixProp expands Decoration;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	PlayAnim ('Pickup_Pose');

	if (Level.NetMode == NM_DedicatedServer)
		Disable('Tick');
}

simulated function Tick(float DeltaTime)
{
	local rotator r;

	// left for compatibility with broken PHYS_Rotating
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
     RemoteRole=ROLE_SimulatedProxy
     bClientAnim=True
}
