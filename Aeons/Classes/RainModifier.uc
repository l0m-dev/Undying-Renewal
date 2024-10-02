//=============================================================================
// RainModifier.
//=============================================================================
class RainModifier expands PlayerModifier;

var ParticleFX RainFX;
var ParticleFX SplashFX;
var ParticleFX SnowFX;

var() float Strength;						// how strong is the rain?....pretty strong I'd say!
var int SplashMax, SplashMin;			// number of splashes per second
var int SplashParticlesMin, SplashParticlesMax, SplashParticles;
var float FallOffTimer;


function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	// log("PostBeginPlay() ", 'Misc');
	if ( Owner == none )
		Destroy();
	
	SetTimer(0.5, true);
	UpdateForecast();
}

function Timer()
{
	UpdateForecast();
}

function UpdateForecast()
{
	if ( Owner == none )
	{
		Destroy();
		return;
	}

	switch ( Owner.Region.Zone.Weather )
	{
		case Weather_Clear:
			if (GetStateName() != 'NoWeather')
			{
				if (GetStateName() == 'Raining' && Level.bSoftWeatherTransitions)
				{
					GotoState('FallOffRain');
				} else
				{
					StopRaining();
					StopSnowing();
					GotoState('NoWeather');
				}
			}
			break;

		case Weather_Rain:
			if (GetStateName() != 'Raining')
			{
				StopSnowing();
				StartRaining();
				GotoState('Raining');
			}
			break;

		case Weather_Snow:
			if (GetStateName() != 'Snowing')
			{
				StopRaining();
				StartSnowing();
				GotoState('Snowing');
			}
			break;
		
		default:
			GotoState('NoWeather');
	}
}

// Create & setup the particle systems
function StartSnowing()
{
	if ( SnowFX == none )
	{
		// log("Starting to snow...", 'Misc');
		SnowFX = spawn( class 'SnowFX',Owner, ,Owner.Location + vect(0,0,64),Rotator(vect(0,0,-1)) );
	} else {
		// log("Tried to Start Snowing, but the SnowFX particle system is already defined...", 'Misc');
	}
}

// Shutdown and clean up the particle fx
function StopSnowing()
{
	if ( SnowFX != none )
	{
		SnowFX.Shutdown();
		SnowFX = none;
	}
}

// Create & setup the particle systems
function StartRaining()
{
	// log("StartRaining()", 'Misc');
	
	if ( RainFX == none )
	{
		// log("Creating Rain", 'Misc');		
		RainFX = spawn( class 'RainFX',Owner, ,Owner.Location + vect(0,0,128),Rotator(vect(0,0,-1)) );
		// RainFX.SetBase(Owner, 'root', 'root');
	}
	
	if ( SplashFX == none )
	{
		// log("Creating Rain Splash efx", 'Misc');		
		SplashFX = spawn( class 'RainSplashFX',,,Owner.Location, Rotator(vect(0,0,1)) );
		// SplashFX.SetBase( Owner );
	}
	
}

// Shutdown and clean up the particle fx
function StopRaining()
{
	if (RainFX != none)
	{
		RainFX.Shutdown();
		RainFX = none;
	}
	
	if (SplashFX != none)
	{
		SplashFX.Shutdown();
		SplashFX = none;
	}
}

// Generates a small splash of particles.
function GenSplash(vector Loc)
{
	local int Np;		// Num particles
	local int i;

	if ( SplashFX != none )
	{
		Np = SplashFX.NumParticles();
		
		for (i=1; i<(SplashParticles+1); i++)
		{
			SplashFX.AddParticle(Np+i, Loc);
		}
	}
}

function UpdateStrength(float NewStr)
{
	Strength = NewStr;
}

// ================================================================
// raining cats and dogs
// ================================================================
state Raining
{
	function BeginState()
	{
		// log("Raining State BeginState()", 'Misc');
		Enable('Tick');
		SetTimer(0.5 / ((SplashMax-SplashMin) * Strength + SplashMin), true);
	}

	function UpdateStrength(float NewStr)
	{
		Strength = NewStr;
		SetTimer((SplashMax-SplashMin) * Strength + SplashMin, true);
	}

	function Tick(float DeltaTime)
	{
		local vector x, y, z;
		local float foo;

		if (PlayerPawn(Owner).ViewTarget == none)
		{
			GetAxes(Pawn(Owner).ViewRotation, x, y, z);
			
			foo = ((1.0 - abs(x.z)) * 64.0) + 64.0;
			
			x.z = 0;
			x = Normal(x);

			RainFX.SetLocation( (Owner.Location + ( x * foo )) + vect(0,0,256) );
			SplashFX.SetLocation(Owner.Location + vect(0,0,-48));
		} else {
			GetAxes(PlayerPawn(Owner).ViewTarget.Rotation, x, y, z);
			
			foo = ((1.0 - abs(x.z)) * 64.0) + 64.0;
			
			x.z = 0;
			x = Normal(x);

			RainFX.SetLocation( (PlayerPawn(Owner).ViewTarget.Location + ( x * foo )) + vect(0,0,64) );
			SplashFX.SetLocation(PlayerPawn(Owner).ViewTarget.Location + vect(0,0,-48));
		}
	}
	
	function Timer()
	{
		local vector HitLocation, HitNormal, End, Start;
		local int HitJoint;
		local vector Dir;

		if ( Owner.Region.Zone.Weather != WEATHER_Rain )
			UpdateForecast();

		if (RainFX == None)
			return;

		// Random location within the particle system extents
		Start = RainFX.Location;
		Start.x += RandRange(-RainFX.SourceWidth.Base, RainFX.SourceWidth.Base);
		Start.y += RandRange(-RainFX.SourceHeight.Base, RainFX.SourceHeight.Base);
		
		// trace direction takes into account wind at the start location 
		Dir = Normal( Level.GetTotalWind( RainFX.Location ) + Vect(0, 0, -950.00) );

		End = Start + (Dir * 2048);
	
		// trace down and see if we hit something
		Trace(HitLocation, HitNormal, HitJoint, End, Start, false );
		
		if ( HitLocation != vect(0,0,0) )
		{
			// splash!
			GenSplash( HitLocation );
		}
	}
}

state FallOffRain expands Raining
{
	function UpdateForecast()
	{
		// log("UpdateForecast() called within FallOffRain", 'Misc');
	}

	function BeginState()
	{
		FallOffTimer = 10;
		if ( SplashFX != none )
		{
			SplashFX.Shutdown();
			SplashFX = none;
		}
	}
	
	function Tick(float DeltaTime)
	{
		local vector x, y, z;
		local float foo;

		FallOffTimer -= DeltaTime;
		
		if ( FallOffTimer <= 0 )
		{
			Region.Zone.Weather = Weather_Clear;
			UpdateForecast();
		} else {
			if (PlayerPawn(Owner).ViewTarget == none)
			{
				GetAxes(Pawn(Owner).ViewRotation, x, y, z);
				
				foo = ((1.0 - abs(x.z)) * 64.0) + 64.0;
				
				x.z = 0;
				x = Normal(x);

				if (RainFX != None)
					RainFX.SetLocation( (Owner.Location + ( x * foo )) + vect(0,0,256) );
				SplashFX.SetLocation(Owner.Location + vect(0,0,-48));
				if (RainFX != None)
					RainFX.ParticlesPerSec.Base = RainFX.default.ParticlesPerSec.Base * (FallOffTimer * 0.1);
				// log("FallOffRain -- setting particles per sec to "$(RainFX.default.ParticlesPerSec.Base * (FallOffTimer * 0.1)), 'Misc');
			} else {
				GetAxes(PlayerPawn(Owner).ViewTarget.Rotation, x, y, z);
				
				foo = ((1.0 - abs(x.z)) * 64.0) + 64.0;
				
				x.z = 0;
				x = Normal(x);

				if (RainFX != None)
					RainFX.SetLocation( (PlayerPawn(Owner).ViewTarget.Location + ( x * foo )) + vect(0,0,64) );
				SplashFX.SetLocation(PlayerPawn(Owner).ViewTarget.Location + vect(0,0,-48));
			}
		}
	}
}

// ==============================================================
// snowing little snow men
// ==============================================================
state Snowing
{
	function BeginState()
	{
		// log("Raining State BeginState()", 'Misc');
		Enable('Tick');
	}

	function UpdateStrength(float NewStr)
	{
		Strength = NewStr;
		SetTimer((SplashMax-SplashMin) * Strength + SplashMin, true);
	}

	function Tick(float DeltaTime)
	{
		local vector x, y, z;
		local float foo;

		GetAxes(Pawn(Owner).ViewRotation, x, y, z);
		
		foo = ((1.0 - abs(x.z)) * 64.0) + 64.0;
		
		x.z = 0;
		x = Normal(x);

		SnowFX.SetLocation( (Owner.Location + ( x * foo )) + vect(0,0,256) );
	}
	
	function Timer()
	{
		if ( Owner.Region.Zone.Weather != WEATHER_Snow )
			UpdateForecast();
	}

	Begin:
		SetTimer(0.5, true);
}

// ==============================================================
// Not raining right now
// ==============================================================
state NoWeather
{
	function BeginState()
	{
		// log("NoWeather State BeginState()", 'Misc');
		SetTimer(0.5, true);
	}

	function Timer()
	{
		UpdateForecast();
	}
}

// ==============================================================

defaultproperties
{
     Strength=1
     SplashMax=60
     SplashMin=6
     SplashParticlesMin=2
     SplashParticlesMax=20
     SplashParticles=2
}
