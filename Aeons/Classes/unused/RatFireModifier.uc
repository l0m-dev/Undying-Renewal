//=============================================================================
// RatFireModifier.
//=============================================================================
class RatFireModifier expands LimitedFireModifier;

function Activate()
{
	if ( ( Owner != none ) &&
		 ( pawn(Owner).OnFireParticles != none ) &&
		 !bActive &&
		 ( !Owner.IsA('PlayerPawn' ) ) )
	{
		bActive = true;
		FireJoint( 'spine3' );
		FireJoint( 'neck' );
		if ( Owner.AcceptDamage(GetDamageInfo()) )
		{
			Pawn(Owner).TakeDamage( pawn(Owner), Location, vect(0,0,0), getDamageInfo() );
			SetTimer( TimerLen, true );
			Burnout = 0.0;
			GotoState( 'Damaging' );
		}
	}
}

defaultproperties
{
}
