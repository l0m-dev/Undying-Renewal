//=============================================================================
// PlayerStateTrigger.
//=============================================================================
class PlayerStateTrigger expands DynamicTrigger;

var float PawnSpeedMult, ProjSpeedMult;

var float projectileSpeed;

function Touch( actor Other )
{
	local actor A;
	local float rs, ar;
	
	if( IsRelevant( Other ) )
	{
		if ( Other.IsA('Pawn')) {
			rs = Pawn(Other).Default.GroundSpeed * PawnSpeedMult;
			ar = Pawn(Other).Default.AccelRate * PawnSpeedMult;
			Pawn(Other).PlayerStateTrigger(rs, ar);
		}
		if ( Other.IsA('Projectile'))
		{
			Projectile(Other).speed = ( Projectile(Other).default.speed * ProjSpeedMult );
			// log ("Projectile entering"$Projectile(Other).speed);
		}
	}
}

function UnTouch( actor Other )
{
	local actor A;
	if( IsRelevant( Other ) )
	{
		if ( Other.IsA('Pawn'))
			Pawn(Other).PlayerStateTrigger(400, 2048);
		if ( Other.IsA('Projectile'))
		{
			// log ("Projectile leaving"$Projectile(Other).default.speed);
			Projectile(Other).speed = Projectile(Other).default.speed;
		}
	}
}

defaultproperties
{
     TriggerType=TT_AnyProximity
     CollisionRadius=80
     CollisionHeight=64
     LightType=LT_Steady
     LightBrightness=128
     LightHue=150
     LightSaturation=100
     LightRadius=15
}
