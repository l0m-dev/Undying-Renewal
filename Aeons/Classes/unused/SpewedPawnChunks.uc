//=============================================================================
// SpewedPawnChunks.
//=============================================================================
class SpewedPawnChunks expands FallingProjectile;

#exec MESH IMPORT MESH=SaintChunk0_m SKELFILE=SaintChunk0.ngf 
#exec MESH IMPORT MESH=SaintChunk1_m SKELFILE=SaintChunk1.ngf 

function PreBeginPlay()
{
	super.PreBeginPlay();
	Velocity =  Normal(Vector(Rotation) * 0.25 + vect(0,0,0.75) + VRand() * 0.25) * speed;
	LoopAnim('Spin', randRange(0.5,2.0));
}

defaultproperties
{
     Speed=350
     LifeSpan=3.5
     RotationRate=(Pitch=2005,Yaw=8561,Roll=354)
     bCollideActors=False
     bProjTarget=False
}
