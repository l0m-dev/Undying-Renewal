//=============================================================================
// PlayerDeathProjectile.
//=============================================================================
class PlayerDeathProjectile expands Projectile;

var float DistToGround, Inc;
var float FallToKneesTime;
var vector x, y, z;

function HitWall( vector HitNormal, actor HitWall, byte TextureID )
{
	Velocity = HitNormal * (0.5 * VSize(Velocity));
}

auto state ControlledFall
{
	function vector CheckForKing()
	{
		local King_Ass A;
		local vector Loc;

		ForEach AllActors(class 'King_Ass', A)
		{
			Loc = A.Location;
		}
		return Loc;
	}

	function BeginState()
	{
		local vector v;
		
		v = CheckForKing();
		if (  v != vect(0,0,0) )
		{
			SetPhysics(PHYS_Falling);
			Velocity = Normal(Location - v) * 1024;
		}
		else if ( VSize(Pawn(Owner).Velocity) > 200)
		{
			SetPhysics(PHYS_Falling);
			Velocity = Pawn(Owner).Velocity;
		}
		setTimer(2, false);
	}

	function Tick(float DeltaTime)
	{
		local vector Start, End, HitLocation, HitNOrmal;
		local int HitJoint;
		
		start = Location;
		End = Location + vect(0,0,-1024);

		Trace(HitLocation, HitNormal, HitJoint, End, Start);
		DistToGround = VSize(HitLocation-Location);
		
		if (DistToGround >= 64) {
			Inc += DeltaTime + RandRange(0,DeltaTime);
			AeonsPlayer(Owner).ViewRotation.Roll = cos(inc) * 8192;
			SetLocation(Location + vect(0,0,-0.07));
		} else {
			GotoState('FallForward');
		}
		SetRotation(Pawn(Owner).ViewRotation);
	}

	function Timer()
	{
		GotoState('FallForward');
	}

	Begin:
		
}

state FallForward
{
	function Tick(float DeltaTime)
	{
		SetRotation(PlayerPawn(Owner).ViewRotation);
	}

	Begin:
		GetAxes(Pawn(Owner).Rotation, x,y,z);
		SetPhysics(PHYS_Falling);
		Velocity = X * 128;
		Sleep(3);
		PlayerPawn(Owner).ClientAdjustGlow(-1.0,vect(0,0,0));
		Sleep(2);
		PlayerPawn(Owner).SetPhysics(PHYS_None);
		PlayerPawn(Owner).ServerRestartPlayer();
}

defaultproperties
{
     Physics=PHYS_Falling
     CollisionRadius=8
     CollisionHeight=16
     bCollideActors=False
     bBounce=True
     Mass=10
}
