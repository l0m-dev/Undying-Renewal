//=============================================================================
// HeldProp.
//=============================================================================
class HeldProp expands Actor
	abstract;

var pawn					PawnOwner;			// Pawn I am attached to
var() float					DroppedLifespan;	//


//=============================================================================
function Setup(name PawnAttachJointName, name AttachJointName)
{
	PawnOwner = Pawn(Owner);
	if (PawnOwner != none)
	{
		setBase(PawnOwner, PawnAttachJointName, AttachJointName);
	}
}

//=============================================================================
// Called by a Pawn when this prop is Dropped
function Dropped()
{
	setPhysics(PHYS_Falling);
	RemoteRole = ROLE_DumbProxy;
	bCollideWorld = true;
	Lifespan = DroppedLifespan;
}

//=============================================================================
// Called by a Pawn when this prop is Thrown
function Thrown(vector Dir, float Speed, optional bool bRandSpin)
{
	Velocity = Dir * speed;
	Dropped();
}

//=============================================================================
// Called by a Pawn when this prop is picked up
function PickedUp()
{
	RemoteRole = ROLE_SimulatedProxy;
}

function SwitchLocation()
{
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bSimFall=True
}
