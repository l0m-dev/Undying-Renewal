//=============================================================================
// PhoenixCameraProjectile.
//=============================================================================
class PhoenixCameraProjectile expands Projectile;

var PlayerPawn Player;
var bool bTimerSet;
var int Roll;
var rotator LastRot, NewRot;
var float Dist, len;

auto state Hover 
{
	function Tick(float DeltaTime)	
	{
		if ( Owner != none ) {
			SetRotation(Rotator(Owner.Location - Location));
			LastRot = Rotation;
			Dist = VSize(Owner.Location - Location);
		} else {
			len += deltaTime;
			if (!bTimerSet)
			{
				SetTimer(1.5, false);
				bTimerSet = true;
			} else {
				if (Dist < 1024)
				{
					NewRot = LastRot;
					NewRot.Roll += (RandRange(-4096, 4096)) * (Dist/1024.0) * abs((len/1.5)-1);
					SetRotation(NewRot);
				}
			}
		}
	}

	function Timer()
	{
		ForEach AllActors(class 'PlayerPawn', Player)
		{
			break;
		}
		if (Player.ViewTarget == self)
			Player.ViewTarget = none;
		Destroy();
	}
}

defaultproperties
{
}
