//=============================================================================
// SoundEvent.
//=============================================================================
class SoundEvent expands Triggers;

//#exec Texture Import Name=SoundEvent0 File=SoundEvent.pcx Group=System Mips=On

struct SoundInfo
{
	var() float Volume;
	var() float Pitch;
	var() float Radius;
	var() float PercentChanceToFire;
	var() Sound SoundToPlay;
	var() float StopSoundTimer;
};

var(SoundEvent_List) SoundInfo Sounds[8];
var(SoundEvent_List) int NumSoundsInList;
var(SoundEvent_List) bool bUseList;
var(SoundEvent_List) bool bRandom;

var(SoundEvent_Global) float PercentChanceToFire;
var(SoundEvent_Global) float StopSoundTimer;
var(SoundEvent_Global) float Pitch;
var(SoundEvent_Global) float Radius;
var(SoundEvent_Global) float Volume;
var(SoundEvent_Global) Sound SoundToPlay;
var(SoundEvent_Global) bool bFireOnlyOnce;
var(SoundEvent_Global) int SoundFlags;

var() bool bAutoTimerPlay;
var() bool bTrigTimerPlay;
var() float TimerLen;
var() float TimerRandom;
var() float PitchVar;
var() float VolumeVar;

var int SndID;
var int SndIDs[8];
var Actor OtherActor;
var int SndIndex;

var PlayerPawn Player;

function Destroyed()
{
	local int i;

	if ( SndID > 0 )
		StopSound(SndID);
	
	for (i=0; i<8; i++)
	{
		if ( SndIDs[i] > 0 )
			StopSound(SndIDs[i]);
	}
}

state() Play_a_Sound
{
	function BeginState()
	{
		if ( bAutoTimerPlay )
		{
			SetTimer(TimerLen + (FRand() * TimerRandom), true);
		}
	}
	
	function PlaySounds(Actor Other)
	{
		local int i;
		local float rad;

		if (bUseList)
		{
			if (NumSoundsInList > 0)
			{
				if ( bRandom )
					i = Rand(NumSoundsInList);
				else
				{
					SndIndex ++;
					if (SndIndex >= NumSoundsInList)
						SndIndex = 0;
					i = SndIndex;
				}

				if ( Sounds[i].SoundToPlay != none )
					if ( FRand() < Sounds[i].PercentChanceToFire )
					{
						log("SoundEvent "$self.name$" playing sound "$Sounds[i].SoundToPlay, 'Misc');
						SndIDs[i] = PlaySound(Sounds[i].SoundToPlay,,Sounds[i].Volume + RandRange(-VolumeVar, VolumeVar),,Sounds[i].Radius, Sounds[i].Pitch + RandRange(-PitchVar, PitchVar), SoundFlags );
						if ( StopSoundTimer > 0 )
							setTimer(StopSoundTimer, false);
						else if (bFireOnlyOnce)
							GotoState('Idle');
					}
			}
		} else {
			// not using List
			if ( FRand() < PercentChanceToFire )
			{
				log("SoundEvent "$self.name$" playing sound "$SoundToPlay, 'Misc');
				SndID = PlaySound(SoundToPlay,,Volume + RandRange(-VolumeVar, VolumeVar),,Radius, Pitch + RandRange(-PitchVar, PitchVar), SoundFlags );
				if ( (StopSoundTimer > 0) && ( !bAutoTimerPlay && !bTrigTimerPlay ) )
					setTimer(StopSoundTimer, false);
				else if (bFireOnlyOnce)
					GotoState('Idle');
			}
		}
	}

	function Trigger( actor Other, pawn EventInstigator )
	{
		PlaySounds(None);
		if ( bTrigTimerPlay )
			SetTimer(TimerLen + (FRand() * TimerRandom), true);
	}
	
	function Timer()
	{
		if ( bAutoTimerPlay || bTrigTimerPlay )
		{
			PlaySounds(None);
			SetTimer(TimerLen + (FRand() * TimerRandom), true);
		} else {
			StopSound(SndID);
			if (bFireOnlyOnce)
				gotoState('Idle');
		}
	}

	Begin:

}

state() Play_a_Sound_on_the_Player
{
	function BeginState()
	{
		if ( bAutoTimerPlay )
		{
			SetTimer(TimerLen + (FRand() * TimerRandom), true);
		}
	}

	function PlaySounds(Actor Other)
	{
		local int i;
		local float rad;

		OtherActor = Other;

		if (bUseList)
		{
			if (NumSoundsInList > 0)
			{
				if ( bRandom )
					i = Rand(NumSoundsInList);
				else
				{
					SndIndex ++;
					if (SndIndex >= NumSoundsInList)
						SndIndex = 0;
					i = SndIndex;
				}

				if ( Sounds[i].SoundToPlay != none )
					if ( FRand() < Sounds[i].PercentChanceToFire )
					{
						log("SoundEvent "$self.name$" playing sound on the player"$Sounds[i].SoundToPlay, 'Misc');
						SndIDs[i] = OtherActor.PlaySound(Sounds[i].SoundToPlay,,Sounds[i].Volume + RandRange(-VolumeVar, VolumeVar),,Sounds[i].Radius, Sounds[i].Pitch + RandRange(-PitchVar, PitchVar), SoundFlags );
						if ( StopSoundTimer > 0 )
							setTimer(StopSoundTimer, false);
						else if (bFireOnlyOnce)
							GotoState('Idle');
					}
			}
		} else {
			// not using List
			if ( FRand() < PercentChanceToFire )
			{
				log("SoundEvent "$self.name$" playing sound on the player"$SoundToPlay, 'Misc');
				SndID = OtherActor.PlaySound(SoundToPlay,,Volume + RandRange(-VolumeVar, VolumeVar),,Radius, Pitch + RandRange(-PitchVar, PitchVar), SoundFlags );
				if ( StopSoundTimer > 0 )
					setTimer(StopSoundTimer, false);
				else if (bFireOnlyOnce)
					GotoState('Idle');
			}
		}
	}

	function Trigger( actor Other, pawn EventInstigator )
	{
		PlaySounds(Other);
		if ( bTrigTimerPlay )
			SetTimer(TimerLen + (FRand() * TimerRandom), true);
	}
	
	function Timer()
	{
		if ( bAutoTimerPlay || bTrigTimerPlay )
		{
			ForEach AllActors(class 'PlayerPawn', Player)
				PlaySounds(Player);

			SetTimer(TimerLen + (FRand() * TimerRandom), true);
		} else {
			OtherActor.StopSound(SndID);
			if (bFireOnlyOnce)
				gotoState('Idle');
		}
	}

	Begin:
		
}

state() Play_a_Sound_on_the_Players_Camera
{
	function BeginState()
	{
		if ( bAutoTimerPlay )
		{
			SetTimer(TimerLen + (FRand() * TimerRandom), true);
		}
	}

	function PlaySounds(Actor Other)
	{
		local int i;
		local float rad;

		OtherActor = Other;

		if ( Other.IsA('PlayerPawn') )
		{
			if (PlayerPawn(Other).ViewTarget != none)
			{
				OtherActor = PlayerPawn(Other).ViewTarget;
			}
		}

		if (bUseList)
		{
			if (NumSoundsInList > 0)
			{
				if ( bRandom )
					i = Rand(NumSoundsInList);
				else
				{
					SndIndex ++;
					if (SndIndex >= NumSoundsInList)
						SndIndex = 0;
					i = SndIndex;
				}

				if ( Sounds[i].SoundToPlay != none )
					if ( FRand() < Sounds[i].PercentChanceToFire )
					{
						SndIDs[i] = OtherActor.PlaySound(Sounds[i].SoundToPlay,,Sounds[i].Volume + RandRange(-VolumeVar, VolumeVar),,Sounds[i].Radius, Sounds[i].Pitch + RandRange(-PitchVar, PitchVar), SoundFlags );
						if ( StopSoundTimer > 0 )
							setTimer(StopSoundTimer, false);
						else if (bFireOnlyOnce)
							GotoState('Idle');
					}
			}
		} else {
			// not using List
			if ( FRand() < PercentChanceToFire )
			{
				SndID = OtherActor.PlaySound(SoundToPlay,,Volume + RandRange(-VolumeVar, VolumeVar),,Radius, Pitch + RandRange(-PitchVar, PitchVar), SoundFlags );
				if ( StopSoundTimer > 0 )
					setTimer(StopSoundTimer, false);
				else if (bFireOnlyOnce)
					GotoState('Idle');
			}
		}
	}

	function Trigger( actor Other, pawn EventInstigator )
	{
		ForEach AllActors(class 'PlayerPawn', Player)
			PlaySounds(Player);

		if ( bTrigTimerPlay )
			SetTimer(TimerLen + (FRand() * TimerRandom), true);
	}
	
	function Timer()
	{
		if ( bAutoTimerPlay || bTrigTimerPlay )
		{
			ForEach AllActors(class 'PlayerPawn', Player)
				PlaySounds(Player);

			SetTimer(TimerLen + (FRand() * TimerRandom), true);
		} else {
			OtherActor.StopSound(SndID);
			if (bFireOnlyOnce)
				gotoState('Idle');
		}
	}

	Begin:
		
}

state Idle
{
	function PlaySounds( Actor Other ); // Fixes failed to find function

	function Trigger( actor Other, pawn EventInstigator );

	Begin:
}

defaultproperties
{
     Sounds(0)=(Volume=1,Pitch=1,PercentChanceToFire=1)
     Sounds(1)=(Volume=1,Pitch=1,PercentChanceToFire=1)
     Sounds(2)=(Volume=1,Pitch=1,PercentChanceToFire=1)
     Sounds(3)=(Volume=1,Pitch=1,PercentChanceToFire=1)
     Sounds(4)=(Volume=1,Pitch=1,PercentChanceToFire=1)
     Sounds(5)=(Volume=1,Pitch=1,PercentChanceToFire=1)
     Sounds(6)=(Volume=1,Pitch=1,PercentChanceToFire=1)
     Sounds(7)=(Volume=1,Pitch=1,PercentChanceToFire=1)
     PercentChanceToFire=1
     Pitch=1
     Volume=1
     InitialState=Play_a_Sound
     Texture=Texture'Aeons.System.SoundEvent0'
     DrawScale=0.5
     CollisionRadius=384
     bCollideActors=False
     NetUpdateFrequency=1
}
