//=============================================================================
// DamageProxy.
//=============================================================================
class DamageProxy expands Actor;

var name Joint;

event TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	if( Owner != none )
	{
		DInfo.JointName = Joint;
		Owner.TakeDamage( EventInstigator, HitLocation, Momentum, DInfo );
	}
}

defaultproperties
{
     DrawType=DT_None
}
