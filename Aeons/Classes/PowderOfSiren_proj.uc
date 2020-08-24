//=============================================================================
// PowderOfSiren_proj.
//=============================================================================
class PowderOfSiren_proj expands FallingProjectile;

var float effectLen;
var Siren_particles particles;
var int RotRate;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Velocity = speed * Normal(Vector(Pawn(Owner).ViewRotation) + vect(0,0,0.25));
	RotRate = RandRange(16384, 65536);
}

auto state fubar expands FallingState
{
	function Tick(float DeltaTime)
	{
		local rotator r;
		
		r = rotation;
		
		r.pitch += DeltaTime * RotRate;
		r.Roll += DeltaTime * RotRate;
		
		SetRotation(r);
	}
}

function Destroyed()
{
	spawn(class 'Siren_particles',self,,Location + vect(0,0,32));
}

defaultproperties
{
     bDestroyOnHitWall=True
     Speed=600
     LifeSpan=3
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.powderOfSiren_m'
     CollisionRadius=8
     CollisionHeight=16
}
