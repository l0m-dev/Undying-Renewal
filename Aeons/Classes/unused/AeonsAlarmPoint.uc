//=============================================================================
// AeonsAlarmPoint.
//=============================================================================
class AeonsAlarmPoint extends AeonsNavNode;


//****************************************************************************
// Member vars.
//****************************************************************************
var() name					AnimName;			// Name of animation to play at this point.
var() name					NextPointTag;		// Name of the tag of the next alarm point.
var AeonsAlarmPoint			NextPoint;			// Next point in the alarm route.
var int						RingCount;
var() sound					AlarmSound;
var() bool					bWaitForTrigger;	// Wait at point until trigger fires.
var() bool					bWaitForPlayer;		// Wait at point until player nears.
var() bool					bVanishOnContact;	// Destroy pawn when reached.
var() name					PostState;			// State to go to after reaching point.
var() float					WanderRadius;		// Select a point within this radius to wander to.
var() int					AlarmRingCount;		// Number if times to play sound effect.
var() float					AlarmRingFrequency;	// How often the sound is re-triggered.


//****************************************************************************
// Inherited member funcs.
//****************************************************************************

// Called after creation (or spawning).
function PreBeginPlay()
{
	super.PreBeginPlay();
	NextPoint = FindLinkPoint( NextPointTag );

	// If actor is to vanish when reaching point, have to get Touch event.
	if ( bVanishOnContact )
		SetCollision( true );
}

// Called when this point is reached by a creature seeking it.
function Touch( actor Other )
{
	GotoState( 'ALARM_Ring' );

	if ( bVanishOnContact &&
		 Other.IsA('ScriptedPawn') &&
		 ( Other.GetStateName() == 'AIAlarm' ) )
		ScriptedPawn(Other).Vanish();

}


//****************************************************************************
// New member funcs.
//****************************************************************************

// Finds the first AeonsAlarmPoint whose Tag matches the tag passed
// and sets NextPoint to that point.
// If the tag matches no points, NextPoint is set to NONE.
function AeonsAlarmPoint FindLinkPoint( name LinkTag )
{
	local AeonsAlarmPoint	APoint;

	if ( LinkTag != '' )
	{
		foreach AllActors( class'AeonsAlarmPoint', APoint, LinkTag )
			return APoint;
	}
	else
		return none;
}


//****************************************************************************
// State definitions.
//****************************************************************************

auto state ALARM_Wait
{
BEGIN:
}

state ALARM_Ring
{
	function Timer()
	{
		GotoState( , 'RINGIT' );
	}

BEGIN:
	RingCount = AlarmRingCount;

RINGIT:
	PlaySound( AlarmSound,, 2.0 );
	RingCount -= 1;
	if ( RingCount > 0 )
		SetTimer( AlarmRingFrequency, false );
	else
		GotoState( 'ALARM_Wait' );
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     AlarmRingCount=10
     AlarmRingFrequency=2
     bStatic=False
     RemoteRole=ROLE_SimulatedProxy
     Texture=Texture'Aeons.AlarmFlag'
}
