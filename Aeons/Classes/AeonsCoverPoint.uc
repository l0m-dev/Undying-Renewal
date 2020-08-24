//=============================================================================
// AeonsCoverPoint.
//=============================================================================
class AeonsCoverPoint extends AeonsNavNode;


//****************************************************************************
// Member vars.
//****************************************************************************

var() bool					bCanLeanLeft;		// Set if can attack by leaning out left.
var() bool					bCanLeanRight;		// Set if can attack by leaning out right.
var() float					LeanDistance;		// Distance to lean out, to clear level geometry.
var() bool					bMoveToCover;		// Set if creature should move toward the cover.
var() bool					bVanishOnContact;	// Destroy pawn when reached.
var() float					CrouchChance;		// Crouch weighting.
var() name					NextPointTag;		// Name of the tag of the next point.
var AeonsCoverPoint			NextPoint;			// Next point in the list.
var pawn					PawnCovering;		// The pawn that is covering this point.
var() name					CoCoverPointTag;	// Tag of the co-cover point.
var AeonsCoverPoint			CoCoverPoint;		// Co-cover point.


//****************************************************************************
// Inherited member funcs.
//****************************************************************************

// Called after creation (or spawning)
function PreBeginPlay()
{
	super.PreBeginPlay();
	NextPoint = FindLinkPoint( NextPointTag );
	if ( ( CoCoverPoint == none ) && ( CoCoverPointTag != '' ) )
		CoCoverPoint = FindLinkPoint( CoCoverPointTag );
	if ( CoCoverPoint != none )
	{
		CoCoverPoint.CoCoverPoint = self;
//		log( "CoverPoint " $ name $ " found " $ CoCoverPoint.name $ " as co-CoverPoint" );
	}
	// If actor is to vanish when reaching point, have to get Touch event.
	if ( bVanishOnContact )
		SetCollision( true );
}

//
function Touch( actor Other )
{
	super.Touch( Other );
//	log( "CoverPoint " $ name $ " got Touch() from " $ Other.name );
	if ( Other.IsA('ScriptedPawn') && ( Other.GetStateName() == 'AIRetreat' ) )
		ScriptedPawn(Other).Vanish();
}


//****************************************************************************
// New member funcs.
//****************************************************************************

// Finds the first AeonsCoverPoint whose Tag matches the tag passed
// and sets NextPoint to that point.
// If the tag matches no points, NextPoint is set to NONE.
function AeonsCoverPoint FindLinkPoint( name LinkTag )
{
	local AeonsCoverPoint	cPoint;

	if ( LinkTag != '' )
	{
		foreach AllActors( class'AeonsCoverPoint', cPoint, LinkTag )
			return cPoint;
	}
	else
		return none;
}

// Sets the pawn covering this point.
function SetCovering( pawn thisPawn )
{
	PawnCovering = thisPawn;
}

// Check if this point is still being covered.
function bool IsCovered()
{
	if ( ( PawnCovering != none ) &&
		 ( PawnCovering.Health > 0 ) &&
		 ( ScriptedPawn(PawnCovering) != none ) &&
		 ScriptedPawn(PawnCovering).IsCovering( self ) )
		return true;
	return false;
}


//****************************************************************************
// def props
//****************************************************************************

defaultproperties
{
     Texture=Texture'Aeons.CoverFlag'
}
