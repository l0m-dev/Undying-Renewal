//=============================================================================
// AeonsScriptPoint.
//=============================================================================
class AeonsScriptPoint extends AeonsNavNode;

//****************************************************************************
// This class is used to mark points that become part of the basic navigation
// network, but are used to contain information about special alternate
// actions a creature can have at this point.
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************

var() float					AnimPreDelay;		// Delay before running animation.
var() name					AnimName;			// Name of animation to play.
var() name					ScriptState;		// Name of state to enter.
var() name					ScriptTag;			// Value to place in OrderTag prior to changing states.
var() name					JumpToTag;			// Tag of NavChoiceTarget.
var actor					JumpToActor;		// Actor obtained from JumpToTag.
var() enum EScriptPointAction
{
	SCRIPTACTION_Animate,
	SCRIPTACTION_GotoState,
	SCRIPTACTION_NavChoice,
	SCRIPTACTION_AnimateThenGotoState,
}							Action;				// Scripted action for this point.
var() name					DelayedState;		// Delayed state change state.
var() name					DelayedTag;			// Delayed state change tag.
var() float					DelayedTime;		// Delayed state change timer.

//****************************************************************************
// Inherited member funcs.
//****************************************************************************

// Called after creation (or spawning).
function PreBeginPlay()
{
	super.PreBeginPlay();
	JumpToActor = FindTaggedActor( JumpToTag );
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
// Def props.
//****************************************************************************

defaultproperties
{
     Texture=Texture'Aeons.ScriptFlag'
}
