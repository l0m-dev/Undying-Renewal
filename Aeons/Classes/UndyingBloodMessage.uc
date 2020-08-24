//=============================================================================
// UndyingBloodMessage.
//=============================================================================
class UndyingBloodMessage expands DirectionalDecal;

simulated event PostBeginPlay()
{
	AttachToSurface(Dir);
}

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
	
	log("----------------------------------------------------------------HERE");

	if( AttachDecal(DecalRange, (vect(1,0,0) cross HitNormal)) == none )
		Destroy();
}

defaultproperties
{
     Dir=(Z=1)
     DecalTextures(0)=Texture'Aeons.Decals.BldScry01'
     NumDecals=1
     Texture=Texture'Aeons.Decals.BldScry01'
     bScryeOnly=True
}
