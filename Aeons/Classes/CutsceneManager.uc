//=============================================================================
// CutsceneManager.
// handles cutscenes
//=============================================================================
class CutsceneManager expands Invisible;

/*
	Handles:
	- Starting a cutscene mid game for all players present
	- Starting a cutscene when a player joins while a cutscene is active
	- Stopping cutscenes if a player exits the cutscene state
	- Skipping cutscenes

	Todo:
	- Vote to skip cutscene
*/

var MasterCameraPoint MasterCamPoint;
var name MasterPointTag;
var bool bFromPlayerStart;
var CameraProjectile CamProj;
var PlayerPawn LocalPlayer;
var float LastPlayerStateCheckTime;
var float CutsceneRecheckDelay;

var float CutsceneTime;
var float TakeTime;
var float CameraHoldTime;

const PLAYER_STATE_CHECK_TIME = 0.5; // server side
const ACTIVE_CUTSCENE_CHECK_DELAY = 0.2; // client side

replication
{
	reliable if (Role == ROLE_Authority)
		bFromPlayerStart, MasterCamPoint, CamProj;
	reliable if (Role == ROLE_Authority && bNetInitial)
		CutsceneTime, TakeTime, CameraHoldTime;
}

simulated function PostNetBeginPlay()
{
	GotoState('ClientCutsceneQueued');
}

// state for clients only, ensures CamProj was replicated
// but not that it's NetReady
simulated state ClientCutsceneQueued
{
	simulated function Timer()
	{
		CutsceneRecheckDelay = ACTIVE_CUTSCENE_CHECK_DELAY;
	}

	Begin:
		// recheck as fast as possible for the first second
		CutsceneRecheckDelay = 0.0;
		SetTimer(Level.TimeDilation, false);

		while (!IsCutsceneActive())
			Sleep(CutsceneRecheckDelay);

		FindLocalPlayer();
		SetupCutsceneForPlayer(LocalPlayer);
}

function Tick(float DeltaTime)
{
	local PlayerPawn Player;

	if (!IsCutsceneActive())
	{
		CutsceneTime = 0.0;
		TakeTime = 0.0;
		CameraHoldTime = 0.0;
		NetUpdateFrequency = 1;
		return;
	}

	CutsceneTime += DeltaTime;
	TakeTime += DeltaTime;
	CameraHoldTime += DeltaTime;
	NetUpdateFrequency = default.NetUpdateFrequency;
	
	// couldn't use bTimedTick for CutsceneTime because it was inaccurate
	LastPlayerStateCheckTime += DeltaTime;
	if (LastPlayerStateCheckTime > PLAYER_STATE_CHECK_TIME)
	{
		LastPlayerStateCheckTime = 0.0;
		foreach AllActors(class'PlayerPawn', Player)
		{
			if (Player.getStateName() != 'PlayerCutScene')
			{
				log ("Player State is "$Player.getStateName(), 'Misc');
				if (Level.NetMode == NM_Standalone)
				{
					CamProj.EndIt();
					break;
				}
				else
				{
					// keep the cutscene playing in multiplayer and setup the cutscene again for that player
					SetupCutsceneForPlayer(Player);
				}
			}
		}
	}
}

function PlayerLogin(PlayerPawn Player, bool bCutSceneStartSpot)
{
	// player logged in (server side)
	if (bCutSceneStartSpot && !IsCutsceneActive())
		StartCutscene(Player, true);

	if (IsCutsceneActive())
	{
		SetupCutsceneForPlayer(Player);
	}
}

function PlayerLogout(PlayerPawn Player)
{
	log("PlayerLogout"@Player);
}

function StartCutscene(PlayerPawn Player, bool bNewFromPlayerStart, optional name NewMasterPointTag)
{
	local PlayerPawn P;

	bFromPlayerStart = bNewFromPlayerStart;
	MasterPointTag = NewMasterPointTag;

	if (MasterCamPoint == None)
	{
		forEach AllActors(class 'MasterCameraPoint', MasterCamPoint, MasterPointTag)
			break;
	}

	if (MasterCamPoint == None)
	{
		log("MasterCameraPoint not found"@MasterPointTag);
		return;
	}

	if (CamProj != None && Role == ROLE_Authority)
	{
		// happens in Manor_EntranceHall_Intro, cutscene is started twice (at LevelBegin and PostLogin)
		log("Warning: CameraProjectile already exists"@CamProj);
	}

	if (CamProj == None)
		SetupCameraProjectile(Player);

	foreach AllActors(class'PlayerPawn', P)
	{
		SetupCutsceneForPlayer(P);
	}
}

// can be safely called from a client or the server at any time
// client calls this from CutsceneManager's ClientCutsceneQueued state and from player's PlayerCutScene state
simulated function SetupCutsceneForPlayer(optional PlayerPawn Player)
{
	if (MasterCamPoint == None)
	{
		log("MasterCameraPoint not found"@MasterPointTag);
		return;
	}

	if (CamProj == None)
	{
		log("CameraProjectile not found");
		return;
	}

	if (Level.NetMode != NM_Client)
	{
		// bIsCutsceneLevel check is needed because undying developers didn't set bHidePlayer everywhere (ex. CU_06)
		if ( MasterCamPoint.bHidePlayer || Level.bIsCutsceneLevel )
		{
			Player.bRenderSelf = false;
			Player.bHidden = true;
		}

		if ( MasterCamPoint.bHoldPlayer ) // && !bFromPlayerStart
		{
			Player.LockPos(); // mostly deprecated, it now just sets velocity and acceleration to 0
			Player.Freeze(); // freeze the players location
		}
	}

	if ( MasterCamPoint.bAnimatedCamera )
	{
		// PreAnimated camera path
		if (bFromPlayerStart && CamProj.Take == 0 && Level.NetMode != NM_DedicatedServer)
		{
			Player.FOVAngle = 36;
			Player.DesiredFOV = MasterCamPoint.GetCamFOVs(0);
		}
		if ( Level.NetMode == NM_Client && CamProj.GetStateName() != 'PlayCannedAnim' )
			CamProj.gotoState('PlayCannedAnim');
	}
	else
	{
		// realtime interpolating camera path
		if ( Level.NetMode == NM_Client && CamProj.GetStateName() != 'PathInterpolation')
			CamProj.StartSequence();
	}

	if ( MasterCamPoint.bLetterBoxed && Level.NetMode != NM_DedicatedServer ) // || bFromPlayerStart
		MasterCamPoint.SetLetterBox(Player);

	if (CamProj != None)
	{
		// cutscene started
		if (Player != None)
		{
			CamProj.Player = Player;
			Player.gotoState('PlayerCutScene');
			Player.ViewTarget = CamProj; // has to be set serverside so relevancy works
		}
	}
}

function SkipCutscene()
{
	local CameraProjectile Cam;
	local ScriptedPawn SP;
	//local Dispatcher DP;

	if ( MasterCamPoint != none && (MasterCamPoint.bEscapable || MasterCamPoint.URL != "") )
	{
		CamProj.EndIt();
	}
	else if (GetRenewalConfig().bMoreSkippableCutscenes)
	{
		ForEach AllActors(class 'CameraProjectile', Cam)
		{
			Cam.SkipIt();
		}

		/*
		ForEach AllActors(class 'Dispatcher', DP)
		{
			if (DP.Instigator == None)
				continue;

			for( DP.i=0; DP.i<ArrayCount(DP.OutEvents); DP.i++ )
			{
				if( DP.OutEvents[DP.i] != '' )
				{
					foreach AllActors( class 'Actor', Target, DP.OutEvents[DP.i] )
					{
						if ( Target.IsA('Trigger') )
						{
							// handle Pass Thru message
							if ( Trigger(Target).bPassThru )
							{
								Trigger(Target).PassThru(DP.Other);
							}
						}
						Target.Trigger( DP, DP.Instigator );
					}
				}
			}

			DP.GotoState('');
			DP.bDisabled = true;
		}
		*/

		foreach AllActors( class'ScriptedPawn', SP )
		{
			if (SP.Script != None)
				SP.Script.bClickThrough = true;
			SP.FastScript( true );
		}
		
		// todo
		//AeonsHud(myHud).RemoveSubtitle();
	}
}

function CutsceneCompleted()
{
	local PlayerPawn Player;

	foreach AllActors(class'PlayerPawn', Player)
	{
		if ( MasterCamPoint != None && MasterCamPoint.URL != "" )
		{
			// log("URL is "$URL$" PlayerPawn(Owner) is "$PlayerPawn(Owner), 'Cutscenes');
			MasterCamPoint.Teleport(Player);
		}

		AeonsPlayer(Player).resetFOV();
		Player.bRenderSelf = true;
		Player.bHidden = false;	
		Player.StopCutScene();
	}
}

function TeleportPlayer(PlayerPawn aPlayer, vector Loc, rotator Rot)
{
	local PlayerPawn Player;

	// teleport all players
	foreach AllActors(class'PlayerPawn', Player)
	{
		Player.SetCollision( false, false, false );
		Player.SetLocation( Loc );
		Player.SetRotation( Rot );
		Player.ClientSetRotation( Player.Rotation );
		Player.SetCollision( true, true, true );
	}
}

function SetupCameraProjectile(PlayerPawn Player)
{
	local vector vecEyeHeight;

	if ( !MasterCamPoint.bAnimatedCamera )
	{
		// realtime interpolating camera path
		if ( MasterCamPoint.CutSceneLength <= 0 )
			MasterCamPoint.CutSceneLength = 10;

		// always false for gameinfo, needs a bFromPlayerStart check?
		if ( MasterCamPoint.bFromPlayerEyes )
		{
			// startning off in the players head...interpolating to the master point
			vecEyeHeight.z = Player.Eyeheight;
			CamProj = spawn(class 'CameraProjectile',,,Location + vecEyeHeight,Player.ViewRotation);
			CamProj.ToPoint = MasterCamPoint;
			CamProj.FromPoint = none;
			CamProj.FromLoc = (Location + vecEyeHeight);
			CamProj.FromSpeed = 0.15;
		} else {
			// starting at the master point location.. interpolating to the next point
			CamProj = spawn(class 'CameraProjectile',,,MasterCamPoint.Location,Player.ViewRotation);
			MasterCamPoint.getNextPoint();
			CamProj.ToPoint = MasterCamPoint.NextPoint;
			CamProj.FromPoint = MasterCamPoint;
		}
		CamProj.TotalTime = MasterCamPoint.CutSceneLength;
		CamProj.MasterPoint = MasterCamPoint;
		CamProj.StartSequence();
	} else if (bFromPlayerStart) {
		// PreAnimated camera path

		// log("...............................Generating camera projectile");
		CamProj = spawn(class 'CameraProjectile');//,,,MasterPoint.Location, masterPoint.Rotation);
		CamProj.MasterPoint = MasterCamPoint;
		CamProj.MasterPoint.StartCutscene();
		CamProj.gotoState('PlayCannedAnim');
	} else {
		if (MasterCamPoint.GetAnimName(0) != 'none')
		{
			CamProj = spawn(class 'CameraProjectile',self,,MasterCamPoint.Location, MasterCamPoint.Rotation);
			CamProj.MasterPoint = MasterCamPoint;
			CamProj.MasterPoint.StartCutscene();
			CamProj.gotoState('PlayCannedAnim');
		}
	}
}

simulated function bool IsCutsceneActive()
{
	return CamProj != None && !CamProj.bDeleteMe;
}

function SetMasterCamPoint(MasterCameraPoint NewMasterCamPoint)
{
	MasterCamPoint = NewMasterCamPoint;
}

function TakeChanged(int NewTake)
{
	TakeTime = 0.0;
}

function CameraHoldStarted()
{
	CameraHoldTime = 0.0;
}

simulated function FindLocalPlayer()
{
	local PlayerPawn P;

	foreach AllActors(class'PlayerPawn', P)
	{
		if(Viewport(P.Player) != None)
		{
			LocalPlayer = P;
			break;
		}
	}
}

// Ensures that there are no duplicates and helps with backwards compatibility by spawning CutsceneManager when needed
simulated static final function CutsceneManager GetCutsceneManager(LevelInfo Level)
{
	local CutsceneManager CutsceneManager;

	foreach Level.AllActors(class'CutsceneManager', CutsceneManager)
		break;

	if (CutsceneManager == None)
		CutsceneManager = Level.Spawn(class'CutsceneManager');
	
	return CutsceneManager;
} 

defaultproperties
{
     bHidden=True
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
     NetPriority=3
}
