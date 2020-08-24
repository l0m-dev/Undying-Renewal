//=============================================================================
// BloodStreamPFX.
//=============================================================================
class BloodStreamPFX expands AeonsParticleFX;


var() vector	SprayOffset;


/*
function BeginPlay()
{
	local vector	X, Y, Z;
	local vector	SLoc;

	super.BeginPlay();

	GetAxes( Rotation, X, Y, Z );
	SLoc = Location + ( X * SprayOffset.X ) + ( Y * SprayOffset.Y ) + ( Z * SprayOffset.Z );
	Spawn( class'BloodFountainPFX', self,, SLoc, Rotation );
}
*/

defaultproperties
{
     SprayOffset=(X=80,Z=-10)
     ParticlesPerSec=(Base=200)
     AngularSpreadWidth=(Base=2)
     AngularSpreadHeight=(Base=2)
     bSteadyState=True
     Speed=(Base=600)
     Lifetime=(Base=0.5)
     ColorStart=(Base=(R=208,G=15,B=49))
     SizeWidth=(Base=7)
     SizeLength=(Base=11)
     Elasticity=0.1
     Gravity=(Z=-950)
     Textures(0)=Texture'Aeons.Particles.noisy5_pfx'
}
