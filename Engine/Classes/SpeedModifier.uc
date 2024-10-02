//=============================================================================
// SpeedModifier.
//=============================================================================
class SpeedModifier expands PlayerModifier;

var float defaultSpeed;

function PreBeginPlay()
{
	super.PreBeginPlay();

	if (Owner == none)
		Destroy();

	if (Level.NetMode == NM_Standalone)
		Disable('Tick');
}

function Tick(float DeltaTime)
{
	local PlayerPawn Player;
	local DamageInfo DInfo;

	Player = PlayerPawn(Owner);

	if (Owner == none)
	{
		Destroy();
		return;
	}

	if (Player == none)
	{
		return;
	}
	
	// PlayerTick is not called on the server so we need this to calculate VelocityBias
	// it should only be calculated in walking and flying state
	Player.VelocityBias = Player.GetTotalPhysicalEffect(DeltaTime);

	// hack to stop player from falling from other clients' perspectives
	// needs to be fixed in native code
	if (Role == ROLE_Authority && (Player.Physics == PHYS_Walking || Player.Physics == PHYS_Swimming))
	{
		// bIsClimbing is replicated but bCanFly isn't
		Player.bCanFly = Player.bIsClimbing;
	}

	// another hack to call a function on tick for the player server side
	// make a new ticker actor?
	Player.DoEyeTrace();

	// another hack to enter dying state
	// make a new ticker actor?
	if (Player.Health <= 0 && Player.GetStateName() == 'PlayerWalking')
	{
		Player.PlayerDied('Dying', '', None, '', Location, DInfo);
	}
}

function LockPosition()
{
	if ( (Owner != None) && (PlayerPawn(Owner) != None) )
	{
		bActive = true;
		Owner.Velocity = vect(0,0,0);
		Visible(Owner).Acceleration = vect(0,0,0);
	}
}

function ReleasePosition()
{
	if ( (Owner != None) && (PlayerPawn(Owner) != None) )
	{
		bActive = false;
	}
}

defaultproperties
{
}
