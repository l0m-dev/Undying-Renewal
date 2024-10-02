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
//var CameraProjectile CamProj;			// the Camera Projectile moving through th e scene.
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
	
	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	setupCutscene(Other, true);
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
	
	setupCutscene(Other, false);
}

function setupCutscene(actor Other, bool bFromPassThru)
{
	local MasterCameraPoint C;
	local Actor A;

	if (Other == None)
		FindPlayer();
	else
		Player = PlayerPawn(Other);
	
	if (Player == none)
	{
		log("Cutscene Trigger PAssThru() -- Can't find the player!",'Custom' );
		return;
	}

	// Player = PlayerPawn(Other);

	if (Event != 'none')
	{
		forEach AllActors(class 'Actor', A, Event)
		{
			if ( !bFromPassThru )
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
			}
			
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
			} else if (bFromPassThru) {
				// normal trigger functionality
				A.trigger(Other, Other.Instigator);
			}
		}
	}

	// this just ensures there is one on the server, it's not actually used
	if ( MasterPoint != none )
	{
		if (Level.NetMode == NM_Standalone)
		{
			if (MasterPoint.bLetterBoxed)
				MasterPoint.SetLetterBox(Player);
		}
		setupCamera();
	}

	if ( !bFromPassThru )
	{
		if ( Message != "" && Level.bDebugMessaging)
			Other.Instigator.ClientMessage( Message );

		if ( bTriggerOnceOnly )
			SetCollision(False);
	}
}

function setupCamera()
{
	local CutsceneManager CutsceneManager;
	
	CutsceneManager = class'CutsceneManager'.static.GetCutsceneManager(Level);
	CutsceneManager.SetMasterCamPoint(MasterPoint);
	CutsceneManager.StartCutscene(Player, false, Event);
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
     RemoteRole=ROLE_None
}
