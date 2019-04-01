//=============================================================================
// PhoenixFireModifier.
//=============================================================================
class PhoenixFireModifier expands LimitedFireModifier;

function Activate()
{
	if ( ( Owner != none ) &&
		 ( pawn(Owner).OnFireParticles != none ) &&
		 !bActive &&
		 ( !Owner.IsA('PlayerPawn' ) ) )
	{
		bActive = true;
		FireJoint( 'tail' );
		FireJoint( 'tail2' );
		FireJoint( 'r_ankle' );
		FireJoint( 'l_ankle' );
		FireJoint( 'l_shoulder1' );
		FireJoint( 'l_elbow' );
		FireJoint( 'l_wrist' );
		FireJoint( 'r_shoulder1' );
		FireJoint( 'r_elbow' );
		FireJoint( 'r_wrist' );
		FireJoint( 'head' );
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
