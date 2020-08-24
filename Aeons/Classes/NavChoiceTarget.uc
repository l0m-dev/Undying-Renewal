//=============================================================================
// NavChoiceTarget.
//=============================================================================
class NavChoiceTarget expands Keypoint;

//#exec TEXTURE IMPORT NAME=NavChoiceTarget FILE=NavChoiceTarget.pcx GROUP="System" FLAGS=2 MIPS=OFF

//****************************************************************************
// This class is used to mark locations of alternate navigation points that
// a creature may use in special cases.
// This class is not derived from the NavigationPoint class and, as such,
// locations marked with these objects are not included in the regular
// navigation network.
// Proper placement of these target points is important, as there is no way
// to use the navigation network to ensure these points can be reached.
// The JumpToTag and MoveToTag properties specify the tags for the respective
// action and, in most cases, should lead to another NavChoiceTarget.
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************

var() name					JumpToTag;			// Tag of the jump target.
var actor					JumpToActor;		// Actor matching the tag.
var() name					MoveToTag;			// Tag of the move target.
var actor					MoveToActor;		// Actor matching the tag.
var vector					LookAtPoint;		// A point directly in front of this location.
var() name					NextState;			// Go to this state after landing, if specified.
var() name					NextTag;			// Use this Tag as OrderTag, if dispatching to another state
var() bool					bJumpDown;			// Set if should force jump down.


//****************************************************************************
// Inherited member funcs.
//****************************************************************************

// Called after creation (or spawning).
function PreBeginPlay()
{
	super.PreBeginPlay();

	LookAtPoint = Location + ( 500 * vector(Rotation) );

	JumpToActor = FindTaggedActor( JumpToTag );
	MoveToActor = FindTaggedActor( MoveToTag );
}


//****************************************************************************
// New member funcs.
//****************************************************************************

// Find the (first) actor whose tag matches the tag passed.
function actor FindTaggedActor( name aTag )
{
	local actor		aActor;

	foreach AllActors( class 'Actor', aActor, aTag )
		return aActor;

	return none;
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     bDirectional=True
     Texture=Texture'Aeons.System.NavChoiceTarget'
     bCollideWhenPlacing=True
     CollisionRadius=40
     CollisionHeight=50
}
