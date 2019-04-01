//=============================================================================
// WeakGibBits.
//=============================================================================
class WeakGibBits expands GibBits;

function GenWallHitDecal( vector HitLocation, vector HitNormal )
{
	Spawn( class'SmallBloodDripDecal',,, HitLocation, rotator(HitNormal) );
}

function DripBlood()
{
	local vector	HitLocation, HitNormal;
	local int		HitJoint;
	local Actor		A;
	
	A = Trace( HitLocation, HitNormal, HitJoint, Location + vect(0,0,256), Location, true );
	if ( A == none )
		Spawn( class'SmallBloodDripDecal',,, HitLocation, rotator(HitNormal) );
}

function PreBeginPlay()
{
	Velocity = vector(Rotation) * ( 30 + FRand() * 150 );
	SetTimer( 1 + FRand(), true );
}

//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
}
