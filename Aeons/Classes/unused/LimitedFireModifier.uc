//=============================================================================
// LimitedFireModifier.
//=============================================================================
class LimitedFireModifier expands FireModifier;

function FireJoint( name JName )
{
	local place		P;
	local actor		A, B;

	P = Owner.JointPlace( JName );
	A = Spawn( pawn(Owner).OnFireParticles, Owner,, P.pos );
	A.SetBase( Owner, JName, 'root' );
	if ( pawn(Owner).OnFireSmokeParticles != none )
	{
		B = Spawn( pawn(Owner).OnFireSmokeParticles, Owner,, P.pos );
		B.SetBase( Owner, JName, 'root' );
	}
}

defaultproperties
{
}
