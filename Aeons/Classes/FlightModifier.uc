//=============================================================================
// FlightModifier.
//=============================================================================
class FlightModifier expands PlayerModifier;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

//=============================================================================
var() sound FlyingSound;
var() sound SputterSound;
var() savable travel  float Fuel;

var travel byte InitialVolume;

//=============================================================================
replication
{
	reliable if ( Role == ROLE_Authority )
			Fuel;
}
//=============================================================================

function PreBeginPlay()
{
	super.PreBeginPlay();
	InitialVolume = Owner.SoundVolume;
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
			if ( Owner.GetStateName() == 'PlayerFlying')
			{
				if ( AeonsPlayer(Owner).JumpHeldTime == 0 ) 
				{
						Owner.SetPhysics(PHYS_Falling);
						Owner.GotoState('PlayerWalking');
						GotoState('Idle');
				}				
				else
				{

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
							Owner.AmbientSound = FlyingSound;
						else
							Owner.AmbientSound = SputterSound;
						*/
					}
				}								
			}
			else
			{
				if ( ( AeonsPlayer(Owner).JumpHeldTime >= 0.2 ) &&
					 ( !AeonsPlayer(Owner).InCrouch() ) &&
					 !AeonsPlayer(Owner).Region.Zone.bWaterZone &&
					 (AeonsPlayer(Owner).GetStateName() != 'PlayerCutscene') &&
					 (AeonsPlayer(Owner).GetStateName() != 'DialogScene') &&
					 (AeonsPlayer(Owner).GetStateName() != 'SpecialKill') &&
					 ( Fuel >= 30 ) )
				{
					bActive = true;
					AeonsPlayer(Owner).GotoState('PlayerFlying');//KeebFly();
				} else {
					if ( AeonsPlayer(Owner).JumpHeldTime == 0 ) 
					{
						GotoState('Idle');
					}
				}
			}
		
		}
	}
	
	function Tick( float DeltaTime ) 
	{
	}
	
	function BeginState()
	{
		SetTimer(0.1, True);
		Owner.AmbientSound = FlyingSound;
		Owner.SoundVolume = InitialVolume;
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

			if ( Owner.SoundVolume > 8 ) {
				Owner.SoundVolume -= ( (2*InitialVolume) * DeltaTime );
			} else {
				Owner.AmbientSound = none;
				Owner.SoundVolume = 0;
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
		// Owner.AmbientSound = none;
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
     RemoteRole=ROLE_None
}
