//=============================================================================
// Ambient sound, sits there and emits its sound.  This class is no different 
// than placing any other actor in a level and setting its ambient sound.
//=============================================================================
class AmbientSound extends Keypoint;

// Import the sprite.
#exec Texture Import File=Textures\Ambient.pcx Name=S_Ambient Mips=On Flags=2

var Sound StoredSound;
var() bool bInitiallyOn;
var() bool bFadeOut;
var() float FadeLen;
var name SavedState;
var int SavedSoundVolume;
var PlayerPawn Player;
var float RealVolume, FadeTimer;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	StoredSound = AmbientSound;
	if ( !bInitiallyOn )
		AmbientSound = none;
}

function UnTrigger(Actor Other, Pawn Instigator)
{	
	if ( AmbientSound != none )
	{
		AmbientSound = none;
	}
}

state() ToggleSound
{
	function Trigger(Actor Other, Pawn Instigator)
	{	
		if (AmbientSound == none)
		{
			AmbientSound = StoredSound;		
		} else {
			AmbientSound = none;
		}
	}
}

state() TurnOffSound
{
	function Trigger(Actor Other, Pawn Instigator)
	{	
		if ( bFadeOut && (FadeLen > 0) )
		{
			RealVolume = SoundVolume;
			SavedSoundVolume = SoundVolume;
			SavedState = 'TurnOffSound';
			GotoState('Eh');
		} else {
			AmbientSound = none;
		}
	}
}

state Eh
{
	function Trigger(Actor Other, Pawn Instigator){}

	function BeginState()
	{
		FadeTimer = 0;
	}
	
	function Timer()
	{
		AmbientSound = none;
		if (SavedState != 'none')
			GotoState(SavedState);
	}
	
	function Tick(float DeltaTime)
	{
		FadeTimer += DeltaTime;
		RealVolume = (1 - (FadeTimer / FadeLen)) * SavedSoundVolume;
		SoundVolume = byte(RealVolume);
	}
	
	Begin:
		SetTimer(FadeLen, false);
}

state() TurnOnSound
{
	function BeginState()
	{
		AmbientSound = none;
	}

	function Trigger(Actor Other, Pawn Instigator)
	{	
		AmbientSound = StoredSound;
	}
}

state() PlayerZoneControl
{
	function FindPlayer()
	{
		ForEach AllActors(class 'PlayerPawn', Player)
		{
			break;
		}
	}
	
	function Timer()
	{
		// Get the player
		if ( Player == none )
			FindPlayer();

		if ( Player != none )
		{
			// turn the sound on
			if ( (Player.Region.Zone == Region.Zone) && (AmbientSound == none) )
				AmbientSound = StoredSound;

			// turn off the sound
			if ( (Player.Region.Zone != Region.Zone) && (AmbientSound != none) )
				AmbientSound = none;
		}
	}

	Begin:
		SetTimer(0.1, true);
}

state() NormalAmbientSound
{
}

defaultproperties
{
     bInitiallyOn=True
     InitialState=NormalAmbientSound
     Texture=Texture'Engine.S_Ambient'
     SoundRadius=40
     SoundVolume=190
}
