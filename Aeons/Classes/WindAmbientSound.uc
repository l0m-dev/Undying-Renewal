//=============================================================================
// WindAmbientSound.
//=============================================================================
class WindAmbientSound expands AmbientSound;

/* Force-Recompile */

var(Sound) int PitchVar;
var(Sound) float PitchPeriod;
var(Sound) float PitchPeriodVar;

var(Sound) int VolVar;
var(Sound) float VolPeriod;
var(Sound) float VolPeriodVar;

var int NewPitchTarget, NewVolTarget;
var float Rate, diff, VRate, VDiff;
var float RealPitch, RealVol, InitialVolume, InitialPitch;
var float PitchTimer, PitchLen, VolTimer, VolLen;
var int Dir, VDir;

var transient bool bInitialized;

// here we store the set values for pitch and volume for later use.
// then we set them to Zero so it doesn't actually play at those
// levels while precaching.
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	bInitialized = true;

	InitialPitch = int(SoundPitch);
	InitialVolume = int(SoundVolume);

	SoundPitch=0;
	SoundVolume=0;

	Rate = RandRange((PitchPeriod - PitchPeriodVar), (PitchPeriod + PitchPeriodVar));
	Rate = FClamp(Rate, 1, 9999);
	
	VRate = RandRange((VolPeriod - VolPeriodVar), (VolPeriod + VolPeriodVar));
	VRate = FClamp(VRate, 1, 9999);
	
	RealPitch = RandRange( (InitialPitch-PitchVar), (InitialPitch+PitchVar) );
	RealVol = RandRange( (InitialVolume-VolVar), InitialVolume );

	NewPitchTarget = RandRange( (InitialPitch-PitchVar), (InitialPitch+PitchVar) );
	NewVolTarget = RandRange( (InitialVolume-VolVar), InitialVolume );
}

simulated function Tick(float DeltaTime)
{
	local int p, v;

	PitchLen += DeltaTime;
	VolLen += DeltaTime;

	if (RealPitch < NewPitchTarget)
		Dir = 1.0;
	else
		Dir = -1.0;

	if (RealVol < NewVolTarget)
		VDir = 1.0;
	else
		VDir = -1.0;

	RealPitch += Diff * ((DeltaTime / Rate) * Dir);
	RealVol += VDiff * ((DeltaTime / VRate) * VDir);
	
	RealPitch = FClamp(RealPitch, 0, 255);
	RealVol = FClamp(RealVol, 0, 255);

	SoundPitch = byte(RealPitch) ;
	SoundVolume = byte(RealVol) ;

	//log("Sound Pitch = "$SoundPitch$" Real Pitch = "$RealPitch$" Rate = "$Rate$" Diff = "$Diff, 'Misc');
	// log("Sound Volume = "$SoundVolume$" VRate = "$VRate$" VDiff = "$VDiff, 'Misc');

	if ( PitchLen >= PitchTimer )
	{
		EvalPitch();
		PitchLen = 0;
	}

	if ( VolLen >= VolTimer )
	{
		EvalVol();
		VolLen = 0;
	}
}

simulated function EvalPitch()
{
	local int p;

	p = int(InitialPitch);
	NewPitchTarget = RandRange((p - PitchVar), (p +PitchVar));

	Diff = abs(NewPitchTarget - int(SoundPitch));

	Rate = RandRange((PitchPeriod - PitchPeriodVar), (PitchPeriod + PitchPeriodVar));
	Rate = FClamp(Rate, 1, 9999);
	PitchTimer = Rate;
}

simulated function EvalVol()
{
	local int v;

	v = int(InitialVolume);
	NewVolTarget = RandRange((v - VolVar), v);

	VDiff = abs(NewVolTarget - int(SoundVolume));

	VRate = RandRange((VolPeriod - VolPeriodVar), (VolPeriod + VolPeriodVar));
	VRate = FClamp(VRate, 1, 9999);
	VolTimer = VRate;
}

defaultproperties
{
     PitchVar=16
     PitchPeriod=5
     PitchPeriodVar=3
     VolVar=64
     VolPeriod=5
     VolPeriodVar=3
     bStatic=False
     bSoundLocked=True
     SoundRadius=218
     SoundRadiusInner=16
     SoundFlags=169
}
