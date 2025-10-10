//=============================================================================
// BloodFootprint.
//=============================================================================
class BloodFootprint expands AeonsDecal
	abstract;

#exec OBJ LOAD FILE=..\Textures\BloodFootprints.utx PACKAGE=BloodFootprints


simulated event PostBeginPlay();
function StartLevel();

simulated function AttachToSurface(optional vector DecalDir)
{
	if (Level.NetMode == NM_DedicatedServer)
		return;

	if (Level.NetMode == NM_Client && Role < ROLE_Authority && Rotation == rot(0,0,0))
	{
		// since rotation isn't replicated, try downwards direction
		DecalDir = vect(0,0,1);
		SetRotation(Rotator(DecalDir));
	}
	
	if( AttachDecal(64, DecalDir) == None )
		Destroy();
}

simulated function PostNetBeginPlay()
{
	AttachToSurface();
}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
}
