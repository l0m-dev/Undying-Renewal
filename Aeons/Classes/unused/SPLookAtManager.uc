//=============================================================================
// SPLookAtManager.
//=============================================================================
class SPLookAtManager expands SPEffector;

//****************************************************************************
// Looking manager (preliminary).
// Will replace all looking behavior currently handled by ScriptedPawn.
// Will enhance current ScriptedPawn behavior by adding the following:
// -- ability to specify a location (world vector) as a target
// -- ability to specify whether to aim at the target
// -- ability to specify a timeout duration for the target
// -- ??
//****************************************************************************


//****************************************************************************
// Structure defs.
//****************************************************************************
struct LookTargetInfo
{
	var actor			TargetActor;			// Actor to track, or...
	var vector			TargetLocation;			// Location to track
	var float			Duration;				// How long to track target
	var bool			bAimTarget;				// Aiming plus looking
	var bool			bLocation;				// Target is a location.
};


//****************************************************************************
// Member vars.
//****************************************************************************
var LookTargetInfo		KeyTarget;				// Key target.
var LookTargetInfo		Targets[20];			// Stacked targets.
var int					TargetIndex;			// Index to current target.
var bool				bActive;				// Set when looking is active.


//****************************************************************************
// Inherited member funcs.
//****************************************************************************
function Tick( float DeltaTime )
{
	local int	lp;

	super.Tick( DeltaTime );
	for ( lp=0; lp<TargetIndex; lp++ )
		if ( Targets[lp].Duration > 0.0 )
		{
			Targets[lp].Duration -= DeltaTime;
			if ( Targets[lp].Duration <= 0.0 )
				Targets[lp].Duration = -1.0;
		}
	CleanStack();
}


//****************************************************************************
// New member funcs.
//****************************************************************************
function SetTarget( actor NewTarget, optional bool Aim )
{
//	log( self.name $ ".SetTarget() " $ NewTarget.name );
	KeyTarget.TargetActor = NewTarget;
	KeyTarget.Duration = -1.0;
	KeyTarget.bAimTarget = Aim;
	KeyTarget.bLocation = false;
	bActive = true;
}

function actor KeyTargetActor()
{
	if ( KeyTarget.bLocation )
		return none;
	else
		return KeyTarget.TargetActor;
}

function bool IsTracking()
{
	if ( bActive )
	{
		if ( TargetIndex > 0 )
		{
			if ( Targets[TargetIndex - 1].bLocation )
				return true;
			else
			{
				return ( Targets[TargetIndex - 1].TargetActor != none ) && ( Targets[TargetIndex - 1].TargetActor.Owner != self );
			}
		}
		else
			return KeyTarget.bLocation || ( KeyTarget.TargetActor != none );
	}
	else
		return false;
}

function vector GetTargetLocation()
{
	if ( TargetIndex > 0 )
	{
		if ( Targets[TargetIndex - 1].bLocation )
			return Targets[TargetIndex - 1].TargetLocation;
		else
			return Targets[TargetIndex - 1].TargetActor.JointPlace('head').Pos;
	}
	if ( KeyTarget.bLocation )
		return KeyTarget.TargetLocation;
	else if (PlayerPawn(KeyTarget.TargetActor) != none)
		return KeyTarget.TargetActor.Location + vect(0,0,1)*PlayerPawn(KeyTarget.TargetActor).EyeHeight;
	else
		return KeyTarget.TargetActor.JointPlace('head').Pos;

}

function PushTarget( actor NewTarget, float Duration, optional bool Aim )
{
	/*
	if ( NewTarget != none )
		log( self.name $ ".PushTarget() # " $ TargetIndex + 1 $ ", " $ NewTarget.name );
	else
		log( self.name $ ".PushTarget() # " $ TargetIndex + 1 $ ", NONE" );
	*/
	if ( TargetIndex < ArrayCount(Targets) )
	{
		Targets[TargetIndex].TargetActor = NewTarget;
		Targets[TargetIndex].Duration = Duration;
		Targets[TargetIndex].bAimTarget = Aim;
		Targets[TargetIndex].bLocation = false;
		TargetIndex += 1;
		bActive = true;
	}
	else
		Warn( "LookAtManager: **** REACHED STACK LIMIT ****" );
}

function PopTarget()
{
//	log( self.name $ ".PopTarget()" );
	if ( TargetIndex > 0 )
		TargetIndex -= 1;
	CleanStack();
}

function CleanStack()
{
	while ( ( TargetIndex > 0 ) &&
			( ( Targets[TargetIndex - 1].Duration < 0.0 ) || ( !Targets[TargetIndex - 1].bLocation && ( Targets[TargetIndex - 1].TargetActor != none ) && Targets[TargetIndex - 1].TargetActor.bDeleteMe ) ) )
	{
//		log( self.name $ ".CleanStack() removed target# " $ TargetIndex );
		TargetIndex -= 1;
	}
}

function SetActive( bool B )
{
	bActive = B;
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
}
