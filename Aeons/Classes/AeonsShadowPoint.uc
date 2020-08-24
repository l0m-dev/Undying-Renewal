//=============================================================================
// AeonsShadowPoint.
//=============================================================================
class AeonsShadowPoint extends AeonsNavNode;

//****************************************************************************
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************

var() bool					bRetreatPriority;	// Consider for retreat, if available.
var pawn					PawnUsing;			// The pawn that is using this point.


//****************************************************************************
// Inherited member funcs.
//****************************************************************************


//****************************************************************************
// New member funcs.
//****************************************************************************
// Sets the pawn using this point.
function Using( pawn thisPawn )
{
	PawnUsing = thisPawn;
}

// Check if this point is in use.
function bool IsInUse()
{
	if ( ( PawnUsing != none ) &&
		 ( PawnUsing.Health > 0 ) &&
		 ( Scarrow(PawnUsing) != none ) &&
		 Scarrow(PawnUsing).IsUsing( self ) )
		return true;
	return false;
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     Texture=Texture'Aeons.ShadowFlag'
}
