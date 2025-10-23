//=============================================================================
// Servant.
//=============================================================================
class Servant expands ScriptedNarrator
	abstract;


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function bool IsAlert()
{
	return false;
}


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
// Animation/audio notification handlers [SFX].
//****************************************************************************


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AIBumpAvoid
// Bumped into BumpedPawn, try to avoid or move around, return via state stack.
//****************************************************************************
state AIBumpAvoid
{
	// *** ignored functions ***

	// *** overridden functions ***
	function float ScatterDistance()
	{
		return default.CollisionRadius * FVariant( 6.0, 1.5 );
	}

	function Dispatch()
	{
		local vector	X, Y, Z, EX;
		local vector	DVect;
		local float		ESpeed;
		local float		MySpeed;

		GetAxes( BumpedPawn.Rotation, EX, Y, Z );
		GetAxes( Rotation, X, Y, Z );
		ESpeed = VSize(BumpedPawn.Velocity);
		MySpeed = VSize(Velocity);
		DVect = BumpedPawn.Location - Location;
		DVect.Z = 0.0;
		DVect = Normal(DVect);

		// Check for different priorities first.
		if ( ScriptedPawn(BumpedPawn) != none )
		{
			if ( ScriptedPawn(BumpedPawn).bBumpPriority && !bBumpPriority )
			{
				BumpPoint = GetBumpPoint( Y, DVect );
				GotoState( , 'GOAROUND' );
				return;
			}
			else if ( !ScriptedPawn(BumpedPawn).bBumpPriority && bBumpPriority )
			{
				PopState();
				return;
			}
		}

		if ( BumpedPawn.Health <= 0 )
		{
			BumpPoint = GetBumpPoint( Y, DVect );
			GotoState( , 'GOAROUND' );
			return;
		}

		// Priorities are the same.
		if ( ScriptedPawn(BumpedPawn) == none )
			GotoState( , 'STOPWAIT' );
		else if ( ( X dot EX ) > 0.0 )
		{
			// Headed in similar directions.
			if ( ( X dot DVect ) > 0.0 )
			{
				// I'm "behind" the BumpedPawn, so I'll stop or go around
				if ( ( ESpeed < 10.0 ) || ( ( ESpeed < MySpeed ) && ( FRand() < 0.90 ) ) )
				{
					BumpPoint = GetBumpPoint( Y, DVect );
					GotoState( , 'GOAROUND' );
				}
				else
					GotoState( , 'STOPWAIT' );
			}
			else
			{
				// Headed similar direction, I'm in front.
				if ( MySpeed < 10.0 )
				{
					BumpPoint = GetPointAhead( -DVect );
					GotoState( , 'GOAROUND' );	// I'm blocking, better move.
				}
				else
					PopState();		// I'm moving, just continue
			}
		}
		else
		{
			// Headed in opposite directions.
			BumpPoint = GetBumpPoint( Y, DVect );
			GotoState( , 'GOAROUND' );
		}
	}

	// *** new (state only) functions ***
	function bool ClearAhead()
	{
		local vector	X, Y, Z;
		local vector	SVect, EVect;
		local vector	HitLocation, HitNormal;
		local int		HitJoint;
		local actor		A;

		GetAxes( Rotation, X, Y, Z );
		SVect = Location + X * CollisionRadius;
		EVect = Location + X * CollisionRadius * 3.0;
		A = Trace( HitLocation, HitNormal, HitJoint, EVect, SVect, true );
		if ( A != None )
			DebugInfoMessage( ".ClearAhead() hit " $ A.name );
		return ( PlayerPawn(A) == none );
	}


STOPWAIT:
	SetMarker( Location );		// TEMP
	DebugInfoMessage( ".AIBumpAvoid, STOPWAIT" );
	StopMovement();
	PlayWait();

PLAYERBLOCKING:
	Sleep( FVariant( 1.5, 0.5 ) );
	if ( !ClearAhead() )
		goto 'PLAYERBLOCKING';
	PopState();

} // state AIBumpAvoid


//****************************************************************************
// AIRunScript
// Follow the actions of the script.
//****************************************************************************
state AIRunScript
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Bump( actor Other )
	{
		local vector	X, Y, Z;

		GetAxes( Rotation, X, Y, Z );
		if ( ( ( Normal(Other.Location - Location) dot X ) > 0.0 ) && ( VSize(Velocity) > 10.0 ) )
			CreatureBump( pawn(Other) );
	}

	// *** new (state only) functions ***


} // state AIRunScript


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	// *** overridden functions ***
	function bool CanBeInvoked()
	{
		return false;
	}

} // state Dying


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     JumpScalar=0.75
     FireScalar=1.5
     ConcussiveScalar=1.5
     AccelRate=1600
     Health=60
     TransientSoundRadius=1500
}
