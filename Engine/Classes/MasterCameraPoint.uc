//=============================================================================
// MasterCameraPoint.
//=============================================================================
class MasterCameraPoint expands CameraNavigation;

var() enum RotationMethod
{
	ROT_Absolute,		// Rotates to look exactly the direction it is moving.
	ROT_NextPoint,		// Look at the point you're moving towards.
	ROT_SecondPoint		// Look at the point after the one you're moving towards
} RotMethod;

// Debug
var() string CutsceneName;
var float TotalTime, StartTime, TempTime;
var int CurrentTake;
var float TakeTime, StartTakeTime, LastTakeTime, CumTime;
var bool bDebugMode;
var() bool		bAutoClearAnims;
var() bool		bEndGame;
var() bool 		bHidePlayer;
var() bool 		bHoldPlayer;
var() bool 		bLetterboxed;
var() bool		bFromPlayerEyes;		// camera starts from the players eye location?
var() bool 		bTeleportPlayer;
var() float 	CutSceneLength;
var() name 		AnimName[64];
var() vector	CamLocations[64];
var() vector	CamDirs[64];
var() float		CamTimes[64];
var() int		CamFOVs[64];
var() name	CamEvents[64];
var() bool		bEscapable;
var() float		WaitTimer[64];
var() float 	LetterBoxTimer;
var() float 	LetterBoxAspect;
var() bool		bAnimatedCamera;		// camera is pre-animated.

var() vector 	StartLocation;
var() vector 	StartDirection;
var() int 		NumTakes;
var() name		EndEvent;

var() name PlayerTeleportTag;

// ============================================================================

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	if ( StartLocation != vect(0,0,0) )
		SetLocation(StartLocation);

	if ( StartDirection != vect(0,0,0) )
		SetRotation(Rotator(StartDirection));
}

simulated function Tick(float DeltaTime)
{
	//log("Level.TimeSeconds = "$Level.TimeSeconds, 'Misc');
	//log("Dt = "$DeltaTime, 'Misc');
	TotalTime += DeltaTime;
	TakeTime += DeltaTime;
}

simulated function name GetAnimName(int i)
{
	return AnimName[i];
}

simulated function int GetCamFOVs(int i)
{
	local Actor A;

	CurrentTake = i;
	LastTakeTime = TakeTime;
	CumTime += LastTakeTime;
	TempTime = TotalTime;
	log("", 'Misc');
	log ("Take "$(i-1)$" time = "$LastTakeTime, 'Misc');
	log("Change at "$Level.TimeSeconds, 'Misc');
	log("", 'Misc');
	TakeTime = 0;

	if ( CamEvents[i] != 'none' )
	{
		ForEach AllActors(class 'Actor', A, CamEvents[i])
		{
			log("Sending Event "$CamEvents[i]$" to "$A.name, 'Misc');
			A.Trigger(self, none);
		}
	}

	return CamFOVs[i];
}

simulated function float GetWaitTimer(int i)
{
	return WaitTimer[i];
}

simulated function vector GetCamLoc(int i)
{
	if (i < 64)
		return CamLocations[i];
	else
		return vect(0,0,0);
}

simulated function float GetCamTime(int i)
{
	return CamTimes[i];
}

simulated function rotator GetCamRot(int i)
{
	return Rotator(CamDirs[i]);
}

simulated function SetLetterBox(PlayerPawn Player)
{
	log("SetLetterBox", 'Misc');
	Player.LetterboxAspect(FClamp(LetterBoxAspect, 0.0, 0.2));
	Player.LetterboxRate(LetterBoxTimer);
	Player.Letterbox(true);
}

simulated function StartCutscene()
{
	TotalTime = 0;
	TakeTime = 0;
}

simulated function CompleteCutscene(PlayerPawn Player)
{
	local Actor A;
	local pawn OtherPlayer;

	log ("Completing Cutscene - Level.TimeSeconds = "$Level.TimeSeconds, 'Misc');

	if ( EndEvent != '' )
	{
		ForEach AllActors(class 'Actor', A, EndEvent)
		{
			if ( A.IsA('Trigger') )
			{
				if ( Trigger(A).bPassThru )
					Trigger(A).PassThru(Player);
			}
			A.Trigger(none, none);
		}
	}

	//if ( bEndGame )
	//	Player.ShowMenu();
	//else
}

defaultproperties
{
     bDebugMode=True
     bAutoClearAnims=True
     LetterBoxTimer=1.5
     LetterboxAspect=0.12
     FOV_Target=110
     bActive=True
     bHidden=True
     Texture=Texture'Engine.System.CamNav_m'
     DrawScale=1
     RemoteRole=ROLE_None
     bNoDelete=True
     bAlwaysRelevant=True
     bStatic=False
}
