//=============================================================================
// PhoenixEggFX.
//=============================================================================
class PhoenixEggFX expands HotExplosionFX;

function Tick(float DeltaTime)
{
	local vector Loc;

	Loc = Pawn(Owner).Location + (vect(0,0,1) * Pawn(Owner).EyeHeight) + vector(Pawn(Owner).ViewRotation) * 24;
	SetLocation(Loc);
}

defaultproperties
{
     Speed=(Base=30,Rand=200)
     SizeWidth=(Base=8)
     SizeLength=(Base=8)
     bSystemRelative=True
     Gravity=(Z=0)
}
