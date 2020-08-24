//=============================================================================
// AeonsGuardPoint.
//=============================================================================
class AeonsGuardPoint extends AeonsNavNode;

//****************************************************************************
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************

var() bool					bUseAsShield;		// If true, use point as shield instead of guarding it.
var() float					InnerRadius;		// Distance to begin any traces leaving the point location.
var() float					GuardRadius;		// Distance to keep from point.


//****************************************************************************
// Inherited member funcs.
//****************************************************************************


//****************************************************************************
// New member funcs.
//****************************************************************************

//
function vector GetGuardPoint( actor theGuard, actor theEnemy )
{
	local vector		sPoint;
	local vector		ePoint;
	local vector		dVect;
	local rotator		rot;
	local actor			HitActor;
	local vector		HitLocation, HitNormal;
	local int			HitJoint;

	if ( bUseAsShield )
	{
		// Place guard point between location and actor.
		sPoint = Location + vect(0,0,1) * ( theGuard.CollisionHeight - CollisionHeight );
		rot = rotator(sPoint - theEnemy.Location);
		rot.Pitch = 0;
		rot.Roll = 0;

		dVect = Normal(vector(rot));
		ePoint = sPoint + dVect * GuardRadius;
		sPoint = sPoint + dVect * InnerRadius;
		HitActor = Trace( HitLocation, HitNormal, HitJoint, ePoint, sPoint, false );

		if ( HitActor == none )
			return ePoint;
		else
			return HitLocation - ( dVect * theGuard.CollisionRadius );
	}
	else
	{
		// Place location between guard point and actor.
		sPoint = Location + vect(0,0,1) * ( theGuard.CollisionHeight - CollisionHeight );
		rot = rotator(theEnemy.Location - sPoint);
		rot.Pitch = 0;
		rot.Roll = 0;

		dVect = Normal(vector(rot));
		ePoint = sPoint + dVect * GuardRadius;
		sPoint = sPoint + dVect * InnerRadius;
		HitActor = Trace( HitLocation, HitNormal, HitJoint, ePoint, sPoint, false );

		if ( HitActor == none )
			return ePoint;
		else
			return HitLocation  - ( dVect * theGuard.CollisionRadius );
	}
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     Texture=Texture'Aeons.GuardFlag'
}
