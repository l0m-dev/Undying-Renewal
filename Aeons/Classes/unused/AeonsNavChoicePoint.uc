//=============================================================================
// AeonsNavChoicePoint.
//=============================================================================
class AeonsNavChoicePoint extends AeonsNavNode;

//****************************************************************************
// This class is used to mark points that become part of the basic navigation
// network, but are used to contain information about special alternate
// navigation choices a creature can make at this point.
// The JumpToTag and MoveToTag properties specify the tags for the respective
// action and, in most cases, should lead to an object of the NavChoiceTarget
// class.
//****************************************************************************


//****************************************************************************
// member vars
//****************************************************************************

var() name					JumpToTag;			// tag of the jump target
var actor					JumpToActor;		// 
var() name					MoveToTag;			// tag of the move target
var actor					MoveToActor;		//


//****************************************************************************
// inherited member funcs
//****************************************************************************

// called after creation (or spawning)
function PreBeginPlay()
{
	super.PreBeginPlay();
	
	JumpToActor = FindTaggedActor( JumpToTag );
	MoveToActor = FindTaggedActor( MoveToTag );
}


//****************************************************************************
// new member funcs
//****************************************************************************

// find the (first) actor whose tag matches the tag passed
function actor FindTaggedActor( name aTag )
{
	local actor		aActor;

	if ( aTag != '' )
	{
		foreach AllActors( class 'Actor', aActor, aTag )
			return aActor;
	}

	return none;
}


//****************************************************************************
// def props
//****************************************************************************

defaultproperties
{
     Texture=Texture'Aeons.NavChoice'
}
