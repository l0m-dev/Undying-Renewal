//=============================================================================
// AeonsPatrolPoint.
//=============================================================================
class AeonsPatrolPoint extends AeonsNavNode;


//****************************************************************************
// Member vars.
//****************************************************************************
var() bool					bDontTurn;			// if true, no turning will be done
var() bool					bTurnFirst;			// if true, will turn before animation
var() name					NextPointTag;		// name of the tag of the next patrol point
var() float					NextDelay;			// delay until leaving for next point
var() float					AnimPreDelay;		// delay before running animation
var() name					AnimName;			// animation to run
var() byte					AnimCount;			// number of animations to play
var() float					AnimFrequency;		// chance that animation will play [0,1]
var int						AnimLoop;			// internal count of animations
var() Sound					AnimSound;			// sound to play at start of animation
var() float					TurnPreDelay;		// delay before turning
var AeonsPatrolPoint		NextPoint;			// next point in the patrol
var() bool					bHasteToMe;			// Use run to reach this point.
var() bool					bVanishOnContact;	// Destroy pawn when point reached.


//****************************************************************************
// Inherited member funcs.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();
	NextPoint = FindLinkPoint( NextPointTag );
	if ( NextPoint == self )
		NextPoint = none;		// fix designer-able-to-recurse-infinitely bug
	if ( AnimName == '' )
		AnimCount = 0;
}


//****************************************************************************
// New member funcs.
//****************************************************************************
// finds the first AeonsPatrolPoint whose Tag matches the tag passed
// and sets NextPoint to that point
// if the tag matches no points, NextPoint is set to NONE
function AeonsPatrolPoint FindLinkPoint( name LinkTag )
{
	local AeonsPatrolPoint	PPoint;

	if ( LinkTag != '' )
	{
		foreach AllActors( class 'AeonsPatrolPoint', PPoint, LinkTag )
			return PPoint;
	}
	else
	{
		return none;
	}
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     bDontTurn=True
     AnimCount=1
     AnimFrequency=1
     Texture=Texture'Aeons.PatrolFlag'
}
