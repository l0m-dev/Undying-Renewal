//=============================================================================
// SPEffector.
//=============================================================================
class SPEffector expands Info
	abstract;

//****************************************************************************
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************

var SPEffector				nextEffector;		// Next in linked list.
var float					EffectDuration;		// How long the effect lasts.
var float					EffectFrequency;	// How often the effect is "applied" to the host.
var float					EffectTimer;		// Time until next effect.


//****************************************************************************
// Inherited member funcs.
//****************************************************************************

// Called when spawned.
function Spawned()
{
	Lifespan = EffectDuration;
	EffectTimer = EffectFrequency;
}

// Called when Lifespan expires.
function Expired()
{
	RemoveFromHost();
	super.Expired();
}

// Handle per-frame tick.
function Tick( float DeltaTime )
{
	local int	iCount;

	super.Tick( DeltaTime );

	if ( EffectFrequency > 0.0 )
	{
		EffectTimer -= DeltaTime;

		iCount = 0;
		while ( EffectTimer < 0.0 )
		{
			EffectTimer += EffectFrequency;
			iCount++;
		}
		if ( iCount > 0 )
			AffectHost( iCount );
	}
}


//****************************************************************************
// New member funcs.
//****************************************************************************

// Called when EffectTimer cycles, count indicates # of cycles.
function AffectHost( int count )
{
}

// Called immediately after attaching to the host.
function Attached( pawn host )
{
}

// Called immediately before removing from host.
function Removing( pawn host )
{
}

// Attach the effector to the pawn passed.
function AttachToHost( pawn thisPawn )
{
	local ScriptedPawn		sPawn;

	sPawn = ScriptedPawn(thisPawn);
	if ( sPawn != none )
	{
		SetOwner( sPawn );
		sPawn.AddEffector( self );
		Attached( sPawn );
	}
}

// Remove the effector from the owner.
function RemoveFromHost()
{
	local ScriptedPawn		sPawn;

	sPawn = ScriptedPawn(Owner);
	if ( sPawn != none )
	{
		Removing( sPawn );
		sPawn.LosingEffector( self );
		sPawn.RemoveEffector( self );
		SetOwner( none );
	}
}

// Change the Lifespan.
function SetDuration( float newDuration )
{
	Lifespan = newDuration;
}

// Get the remaining Lifespan.
function float GetDuration()
{
	return Lifespan;
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     DrawType=DT_None
}
