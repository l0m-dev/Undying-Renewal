//=============================================================================
// HealthModifier.
//=============================================================================
class HealthModifier expands PlayerModifier;

var travel int HealthSurplus, NumHealths, SuperHealthSurplus, ProjectedHealthTarget;
var float t;

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
				if (Pawn(Owner).Health < 200.0)
				{
					if (Pawn(Owner).Health > 199.0) {
						Pawn(Owner).Health = 200;
					} else {
						Pawn(Owner).Health += 1.0;
					}
					HealthSurplus --;
				} else {
					HealthSurplus = 0;
				}
			} else if ( SuperHealthSurplus > 0 ) {
				if (Pawn(Owner).Health < 200)
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

		ProjectedHealthTarget = Pawn(Owner).Health + HealthSurplus + SuperHealthSurplus;
		
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
	 ProjectedHealthTarget=100 // fixes picking up health before we tick (custom maps that give us health packs on start)
     bTimedTick=True
     MinTickTime=0.15
     RemoteRole=ROLE_None
}
