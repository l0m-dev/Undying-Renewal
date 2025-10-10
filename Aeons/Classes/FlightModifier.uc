//=============================================================================
// FlightModifier.
//=============================================================================
class FlightModifier expands PlayerModifier;

#exec OBJ LOAD FILE=..\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

//=============================================================================
var() sound FlyingSound;
var() sound SputterSound;
var() travel  float Fuel;

var travel byte InitialVolume;

//=============================================================================
replication
{
	reliable if ( Role == ROLE_Authority && bNetOwner )
		Fuel;
}
//=============================================================================

function PreBeginPlay()
{
	super.PreBeginPlay();
	InitialVolume = SoundVolume;
}

//=============================================================================
state Active
{
	function Timer()
	{
		local float FuelNeeded;
		
		if ( Owner != None ) 
		{
			// Die while flying?
			if ( Pawn(Owner).Health <= 0 )
			{
				Owner.SetPhysics(PHYS_Falling);
				Owner.GotoState('PlayerWalking');
				GotoState('Idle');
				return;
			}
			
			// this part needs to go in FlightModifier
			if ( Owner.GetStateName() != 'PlayerFlying')
			{
				if ( ( AeonsPlayer(Owner).JumpHeldTime >= 0.2 ) &&
					 ( !AeonsPlayer(Owner).InCrouch() ) &&
					 !AeonsPlayer(Owner).Region.Zone.bWaterZone &&
					 !AeonsPlayer(Owner).IsInCutsceneState() &&
					 ( Fuel >= 30 ) )
				{
					bActive = true;
					AeonsPlayer(Owner).GotoState('PlayerFlying');//KeebFly();
				} else
				{
					if ( AeonsPlayer(Owner).JumpHeldTime == 0 ) 
					{
						GotoState('Idle');
						return;
					}
				}
			}

			if ( AeonsPlayer(Owner).JumpHeldTime == 0 ) 
			{
				Owner.SetPhysics(PHYS_Falling);
				Owner.GotoState('PlayerWalking');
				Fuel = FMax(0, Fuel-1.5); // prevents spamming to fly further
				GotoState('Idle');
				return;
			}				
			
			if ( Pawn(Owner).Acceleration.Z > 0 )
			{						
				FuelNeeded = 1.5 + 1.5*Pawn(Owner).Acceleration.Z/Pawn(Owner).AirSpeed;
			}	
			else
			{
				FuelNeeded = 1.5;
			}
			
			if ( FuelNeeded > Fuel )
			{
				// sorry but you are all out of mana
				Owner.SetPhysics(PHYS_Falling);
				Owner.GotoState('PlayerWalking');
				Fuel = 0;
				GotoState('Idle');
			}
			else
			{
				Fuel -= FuelNeeded;					
				
				/*
				if ( Fuel >= 30 )
					AmbientSound = FlyingSound;
				else
					AmbientSound = SputterSound;
				*/
			}						
		}
	}
	
	function Tick( float DeltaTime ) 
	{
	}
	
	function BeginState()
	{
		Timer(); // removes 0.1s delay
		SetTimer(0.1, True);
		AmbientSound = FlyingSound;
		
		SoundVolume = InitialVolume;
	}
	
	function EndState()
	{
	}
}

//=============================================================================
auto state Idle
{

	function Tick(float DeltaTime)
	{
		local int Flags;
		local bool bNoPass;
		
		if (Owner != none)
		{
			TraceTexture(Owner.Location + vect(0,0,-192), Owner.Location , Flags );
			if ( (131072 & Flags) != 0 )
				bNoPass = true;

			if ( SoundVolume > 8 ) {
				SoundVolume -= ( (8*InitialVolume) * DeltaTime );
			} else {
				AmbientSound = none;
				SoundVolume = 0;
			}
		} else {
			Destroy();
		}

		// Refresh fuel
		// no refresh when guiding phoenix
		if ( Owner != None && (AeonsPlayer(Owner).GetStateName() != 'GuidingPhoenix') && !bNoPass)
		{
			if ( Fuel < 60 ) 
			{
				// another form of balancing flight with no delay
				if (Owner.Physics == PHYS_Falling)
					Fuel += 15.0 * DeltaTime;
				else
					Fuel += 25.0 * DeltaTime;

				Fuel = FClamp( Fuel, 0.0, 60.0 );
			}
		}
				
		if ( (Owner != None) && (AeonsPlayer(Owner) != None) && !AeonsPlayer(Owner).bSelectObject && (Pawn(Owner).Health > 0))
		{
			// if Player had held down jump for a while and there is enough fuel and we can fly in this level and we're not in the wheel
			if ( AeonsPlayer(Owner).GetStateName() != 'FallingDeath' )
				if ( (AeonsPlayer(Owner).JumpHeldTime >= 0.2 ) && (Fuel >= 30) && Level.bAllowFlight )
					GotoState('Active');
		}
	}

	function BeginState()
	{
		// we are not flying
		bActive = false;
		//AmbientSound = none;
	}
	
	function EndState()
	{
	}

}

//=============================================================================
//=============================================================================

defaultproperties
{
     FlyingSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_Fly01'
     SputterSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_FlyLoopEnd01'
     Fuel=60
     RemoteRole=ROLE_SimulatedProxy
	 SoundRadius=30
     SoundVolume=96
}
