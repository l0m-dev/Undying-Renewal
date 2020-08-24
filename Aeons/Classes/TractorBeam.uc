//=============================================================================
// TractorBeam.
//=============================================================================
class TractorBeam expands PhysicsEffector;


//****************************************************************************
// Member vars.
//****************************************************************************
var() float					InnerRadius;		//
var() float					OuterRadius;		//
var() float					Force;				//
var() float					ForceVariance;		//
var() bool					bNeedLOS;			// Line of sight required.
var() float					TriggerTime;		// How long to remain active when triggered, 0.0 == forever.
var() bool					bInvertMagnitude;	//
var savable float			TriggerDelay;		//


//****************************************************************************
// Inherited functions.
//****************************************************************************
function vector EffectOn( vector ThisLoc )
{
	local vector	DVect;
	local float		DSize;
	local float		DMult;

	if ( bIsActive &&
		 ( !bNeedLOS || FastTrace( Location, ThisLoc ) ) )
	{
		DVect = Location - ThisLoc;
		DSize = VSize(DVect);
		if ( DSize <= InnerRadius )
			DMult = 1.0;
		else if ( DSize >= OuterRadius )
			DMult = 0.0;
		else
			DMult = 1.0 - ( DSize / OuterRadius );
		if ( bInvertMagnitude )
			DMult = 1.0 - DMult;
		return Normal(DVect) * FVariant( Force, ForceVariance ) * DMult;
	}
	else
		return vect(0,0,0);
}

function Trigger( actor Other, pawn EventInstigator )
{
	bIsActive = true;
	TriggerDelay = TriggerTime;
}

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );
	if ( TriggerDelay > 0.0 )
	{
		TriggerDelay -= DeltaTime;
		if ( TriggerDelay <- 0.0 )
		{
			bIsActive = false;
			TriggerDelay = 0.0;
		}
	}
}


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     InnerRadius=32000
     Force=200
}
