//=============================================================================
// CutSceneTrigger.
//=============================================================================
class CutSceneTrigger expands Trigger;

//#exec TEXTURE IMPORT NAME=TrigCutScene FILE=TrigCutScene.pcx GROUP=System Mips=Off Flags=2

// var(Cutscene_Animated) name AnimName;
// var(Cutscene_Interp) float CutSceneLength;
// var(Cutscene) bool bHidePlayer;
// var(Cutscene) bool bHoldPlayer;
// var(Cutscene) bool bLetterBoxed;
// var(Cutscene) float LetterBoxTimer;
// var(Cutscene) float LetterBoxAspect;
// var(Cutscene) bool bTeleportPlayer;

var PlayerPawn Player;					// The player
var MasterCameraPoint MasterPoint;		// The Master Point of the cutscene sequence
var CameraProjectile CamProj;			// the Camera Projectile moving through th e scene.
// var AeonsPlayer Player;

function FindPlayer()
{
	ForEach AllActors(class 'PlayerPawn', Player)
	{
		break;
	}
}

function PassThru(actor Other)
{
	local MasterCameraPoint C;
	local Actor A;

	if ( !bPassThru || !bInitiallyActive)
		return;
	
	if ( !CheckConditionalEvent(Condition) )
		return;

	FindPlayer();
	if (Player == none)
	{
		log("Cutscene Trigger PAssThru() -- Can't find the player!",'Misc' );
		return;
	}

	// Player = PlayerPawn(Other);

	if (Event != 'none')
	{
		forEach AllActors(class 'Actor', A, Event)
		{
			if ( A.IsA('MasterCameraPoint') )
			{
				// MasterCameraPoint handling
				C = MasterCameraPoint(A);

				if ( C.bAnimatedCamera )
				{
					if( bTriggerOnceOnly )
						SetCollision(False);
		
					if ( Message != "" && Level.bDebugMessaging)
						Player.ClientMessage(Message);
		
					MasterPoint = C;
					break;
				} else {
					if( bTriggerOnceOnly )
						SetCollision(False);
		
					if ( Message != "" && Level.bDebugMessaging)
						Player.ClientMessage(Message);
		
					MasterPoint = C;
					break;
				}
			} else {
				// normal trigger functionality
				A.trigger(Other, Other.Instigator);
			}
		}
	}

	if ( MasterPoint != none )
	{
		if (MasterPoint.bLetterBoxed)
			MasterPoint.SetLetterBox(Player);
		setupCamera();
	}
}

function Touch( actor Other )
{
	local MasterCameraPoint C;
	local Actor A;
	
	if ( !Other.IsA('PlayerPawn') )
		return;

	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	if ( !bInitiallyActive )
		return;
	
	Player = PlayerPawn(Other);

	if ( Event != 'none' )
	{
		forEach AllActors(class 'Actor', A, Event)
		{
			if ( A.IsA('Trigger') )
			{
				// handle Pass Thru message
				if ( Trigger(A).bPassThru )
				{
					Trigger(A).PassThru(Other);
				}
			}
			A.Trigger( Other, Other.Instigator );

			if ( A.IsA('MasterCameraPoint') )
			{
				// MasterCameraPoint handling
				C = MasterCameraPoint(A);

				if ( C.bAnimatedCamera )
				{
					if( bTriggerOnceOnly )
						SetCollision(False);
		
					if ( Message != "" && Level.bDebugMessaging)
						Player.ClientMessage(Message);
		
					MasterPoint = C;
					break;
				} else {
					if( bTriggerOnceOnly )
						SetCollision(False);
		
					if ( Message != "" )
						Player.ClientMessage(Message);
		
					MasterPoint = C;
					break;
				}
			}
		}
	}
	
	if ( MasterPoint != none )
	{
		if (MasterPoint.bLetterBoxed)
			MasterPoint.SetLetterBox(Player);
		setupCamera();
	}

	if ( Message != "" && Level.bDebugMessaging)
		Other.Instigator.ClientMessage( Message );

	if ( bTriggerOnceOnly )
		SetCollision(False);
}

function setupCamera()
{
	local vector eyeHeight;

	AeonsPlayer(Player).gotoState('PlayerCutScene');
	if ( !MasterPoint.bAnimatedCamera )
	{
		// realtime interpolating camera path
		if ( MasterPoint.CutSceneLength <= 0 )
			MasterPoint.CutSceneLength = 10;

		if ( MasterPoint.bHidePlayer )
		{
			Player.bRenderSelf = false;
			Player.bHidden = true;
		}

		if ( MasterPoint.bHoldPlayer )
			Player.LockPos();			// lock the players location

		EyeHeight.z = Player.Eyeheight;

		if ( MasterPoint.bFromPlayerEyes )
		{
			// startning off in the players head...interpolating to the master point
			CamProj = spawn(class 'CameraProjectile',Player,,Player.Location + EyeHeight,Player.ViewRotation);
			CamProj.ToPoint = MasterPoint;
			CamProj.FromPoint = none;
			CamProj.FromLoc = (Player.Location + EyeHeight);
			CamProj.FromSpeed = 0.15;
		} else {
			// starting at the master point location.. interpolating to the next point
			CamProj = spawn(class 'CameraProjectile',Player,,MasterPoint.Location,Player.ViewRotation);
			MasterPoint.getNextPoint();
			CamProj.ToPoint = MasterPoint.NextPoint;
			CamProj.FromPoint = MasterPoint;
		}
		CamProj.TotalTime = MasterPoint.CutSceneLength;
		CamProj.MasterPoint = MasterPoint;
		Player.ViewTarget = CamProj;
		CamProj.StartSequence();
		AeonsPlayer(Player).MasterCamPoint = MasterPoint;
	} else {
		if (MasterPoint.GetAnimName(0) != 'none')
		{
			CamProj = spawn(class 'CameraProjectile',,,MasterPoint.Location, masterPoint.Rotation);
			// CamProj.AnimName = MasterPoint.AnimName;
			CamProj.MasterPoint = MasterPoint;
	
			if ( MasterPoint.bHidePlayer )
				Player.bRenderSelf = false;
	
			if ( MasterPoint.bHoldPlayer )
				Player.LockPos();			// lock the players location
			Player.ViewTarget = CamProj;
			AeonsPlayer(Player).MasterCamPoint = MasterPoint;
			CamProj.gotoState('PlayCannedAnim');
		}
	}
}

/*
state() CutsceneTrigger
{
	function Trigger(Actor Other, Pawn Instigator)
	{
		if (bInitiallyActive)
			bInitiallyActive = false;
		else
			bInitiallyActive = true;
			
		bHidden = !bInitiallyActive;
	}
}
*/

defaultproperties
{
     bTriggerOnceOnly=True
     InitialState=CutSceneTrigger
     Texture=Texture'Aeons.System.TrigCutScene'
     DrawScale=0.5
}
