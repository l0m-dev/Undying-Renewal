//=============================================================================
// HealthModifier.
//=============================================================================
class HealthModifier expands PlayerModifier;

var travel int HealthSurplus, NumHealths, SuperHealthSurplus, ProjectedHealthTarget;
var float t, MaxHealthSurplus, MaxSuperHealthSurplus;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// fixes picking up health before we tick (on custom maps that give us health packs on start)
	if ( Owner != None ) 
		UpdateProjectedHealthTarget();

	if ( RGC() )
		MaxHealthSurplus = 200.0;
}

simulated function UpdateProjectedHealthTarget()
{
	ProjectedHealthTarget = Pawn(Owner).Health + HealthSurplus + SuperHealthSurplus;
}

function int Dispel(optional bool bCheck)
{
	return -1;
}

auto state Activated
{
	function Tick(float DeltaTime)
	{
		local name PlayerState;
		local Inventory Inv;
		local int tempHealth;

		if ( Owner == None ) 
			return;

		PlayerState = Pawn(Owner).GetStateName();

		switch ( PlayerState )
		{
			// Player is dead - make sure we do not add any health surplus...
			case 'Dying':
			case 'SpecialKill':
			case 'FallingDeath':
			case 'FadingDeath':
				HealthSurplus = 0;
				NumHealths = 0;
				if ( Pawn(Owner).Health > 0 )
					Pawn(Owner).Health = 0;
				break;

			default:
				break;
		}

		t += DeltaTime;
		if (t >= 0.2)
		{
			t -= 0.2;
			if (HealthSurplus > 0)
			{
				if (Pawn(Owner).Health < MaxHealthSurplus)
				{
					if (Pawn(Owner).Health > (MaxHealthSurplus - 1.0)) {
						Pawn(Owner).Health = MaxHealthSurplus;
					} else {
						Pawn(Owner).Health += 1.0;
					}
					HealthSurplus --;
				} else {
					HealthSurplus = 0;
				}
			} else if ( SuperHealthSurplus > 0 ) {
				if (Pawn(Owner).Health < MaxSuperHealthSurplus)
				{
					Pawn(Owner).Health += 1.0;
					SuperHealthSurplus --;
				} else {
					SuperHealthSurplus = 0;
				}
			} else {
				t = 0;
			}
		}

		UpdateProjectedHealthTarget();
		
		if (Level.Game.Difficulty == 0)
		{
			if ( ProjectedHealthTarget <= 65 )
			{
				if (NumHealths > 0)
				{
					Inv = AeonsPlayer(Owner).FindInventoryType(class 'Aeons.Health');
					if (Inv != none)
					{
						Inv.Activate();
					}
				}
			}
		}

	}

	function Timer()
	{
		if ( Pawn(Owner) != none )
		{
			if (HealthSurplus == 0)
				if ( int(Pawn(Owner).Health) > int(Pawn(Owner).default.Health) )
					Pawn(Owner).Health -= 1;
		} else {
			Destroy();
		}
	}

	Begin:
		setTimer(1, true);
}

defaultproperties
{
     bTimedTick=True
     MinTickTime=0.15
     RemoteRole=ROLE_None
     MaxHealthSurplus=100
     MaxSuperHealthSurplus=100
}
