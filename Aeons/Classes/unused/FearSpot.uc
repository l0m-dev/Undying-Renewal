//=============================================================================
// FearSpot.
// Creatures will tend to back away when entering this spot
// To be effective, there should also not be any paths going through the area
//=============================================================================
class FearSpot extends Triggers;


//****************************************************************************
// Member vars.
//****************************************************************************
var() bool					bInitiallyActive;	//
var() float					TouchFrequency;		//
var float					TouchTimer;			//
var() class<actor>			ExcludeClass;		//
var() class<actor>			AffectOnlyClass;	//


//****************************************************************************
// Inherited functions.
//****************************************************************************
function Tick( float DeltaTime )
{
	local int	lp;

	super.Tick( DeltaTime );

	if ( bInitiallyActive )
	{
		if ( TouchTimer <= DeltaTime )
		{
			TouchTimer = TouchFrequency;
			CheckTouchList();
		}
		else
			TouchTimer -= DeltaTime;
	}
}

function Touch( actor Other )
{
	if ( bInitiallyActive && Other.bIsPawn )
	{
//		log( name $ ".Touched " $ Other.name );
		if ( ( AffectOnlyClass != none ) && ( Other.class != AffectOnlyClass ) )
			return;
		if ( ( ExcludeClass != none ) && ( Other.class == ExcludeClass ) )
			return;
		pawn(Other).FearThisSpot( self );
	}
}

function Trigger( actor Other, pawn EventInstigator )
{
	bInitiallyActive = !bInitiallyActive;
	if ( bInitiallyActive )
	{
//		log( name $ ".Trigger(), now ACTIVE" );
		CheckTouchList();
	}
//	else
//		log( name $ ".Trigger(), now INACTIVE" );
}

//****************************************************************************
// New class functions.
//****************************************************************************
function CheckTouchList()
{
	local ScriptedPawn	SP;

	foreach TouchingActors( class'ScriptedPawn', SP )
		Touch( SP );
	/*
	local int	i;

	for ( i=0; i<ArrayCount(Touching); i++ )
		if ( Touching[i] != none )
			Touch( Touching[i] );
	*/
}

//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     TouchFrequency=0.2
}
