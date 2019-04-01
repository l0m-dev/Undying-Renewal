//=============================================================================
// AeonsSearchPoint.
//=============================================================================
class AeonsSearchPoint extends AeonsNavNode;

//****************************************************************************
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************

var bool					bInSearchList;		// Flag when the point is included in list.
var() name					NextPointTag;		// Name of the tag of the next patrol point.
var AeonsSearchPoint		NextPoint;			// Next point in the patrol.


//****************************************************************************
// Inherited member funcs.
//****************************************************************************

// Called after creation (or spawning).
function PreBeginPlay()
{
	super.PreBeginPlay();
	if ( ( Tag != '' ) && ( NextPointTag != '' ) )
	{
		// This point wants to force a link to another.
		FindLinkPoint( NextPointTag );
	}
	else
	{
		FindNearestPoint();
	}
	if ( NextPoint != none )
	{
//		log( name $ " chose " $ NextPoint.name $ " as NextPoint" );
		bInSearchList = true;
		NextPoint.bInSearchList = true;
	}
}


//****************************************************************************
// New member funcs.
//****************************************************************************

// Finds the first AeonsSearchPoint whose Tag matches the tag passed
// and sets NextPoint to that point.
// If the tag matches no points, NextPoint is set to NONE.
function FindLinkPoint( name LinkTag )
{
	if ( LinkTag != '' )
	{
		foreach AllActors( class 'AeonsSearchPoint', NextPoint, LinkTag )
			return;
	}
	else
	{
		NextPoint = none;
	}
}

//
function FindNearestPoint()
{
	local AeonsSearchPoint	aPoint;
	local AeonsSearchPoint	bPoint;
	local float				distance;

	bPoint = none;
	foreach AllActors( class 'AeonsSearchPoint', aPoint )
	{
		if ( ( aPoint != self ) && !aPoint.bInSearchList && ( aPoint.Tag == '' ) && ( aPoint.NextPointTag == '' ) )
		{
			if ( ( bPoint == none ) || ( VSize(Location - aPoint.Location) < distance ) )
			{
				bPoint = aPoint;
				distance = VSize(Location - aPoint.Location);
			}
		}
	}
	if ( bPoint != none )
	{
		NextPoint = bPoint;
	}
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     Texture=Texture'Aeons.SearchFlag'
}
