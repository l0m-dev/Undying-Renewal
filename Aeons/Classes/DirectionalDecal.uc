//=============================================================================
// DirectionalDecal.
//=============================================================================
class DirectionalDecal expands AeonsDecal;

var() vector Dir;

simulated event PostBeginPlay()
{
	AttachToSurface(Dir);
}

function StartLevel();

simulated function AttachToSurface(optional vector DecalDir)
{
	local int Flags, HitJoint;
	local vector Start, End, HitLocation, HitNormal;
	local Texture t;

	start = Location;
	end = start + (Vector(Rotation) * 128);
	t = TraceTexture(End, Start, Flags);
	
	if (t!= none)
		if (t.ImpactID == TID_Water)
			return;

	Trace(HitLocation, HitNormal, HitJoint, end, start);

	if( AttachDecal(DecalRange, (Dir cross HitNormal)) == none )	// trace 100 units ahead in direction of current rotation
		Destroy();
}

defaultproperties
{
     DrawScale=1
}
