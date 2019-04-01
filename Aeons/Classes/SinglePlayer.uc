//=============================================================================
// SinglePlayer.
//=============================================================================
class SinglePlayer extends AeonsGameInfo;

var string StartMap;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	bClassicDeathmessages = True;
}

function Killed(pawn Killer,pawn Other,name DamageType)
{
    Super.Killed(Killer,Other,DamageType);
}   

function DiscardInventory(Pawn Other)
{
    if (Other.Weapon != None) {
        Other.Weapon.PickupViewScale*=0.7;
    }
    Super.DiscardInventory(Other);
}

function PlayTeleportEffect(actor Incoming,bool bOut,bool bSound)
{
}

function StartCutScene(PlayerPawn Player)
{
	local MasterCameraPoint C, MasterPoint;

	// log("..............................................Starting CutScene");

	forEach AllActors(class 'MasterCameraPoint', C, Event)
	{
		MasterPoint = C;
		break;
	}
	
	if ( MasterPoint != none )
		setupCamera(MasterPoint, Player);
	else
		log("Aeons.SinglePlayer: Cutscene FAILED to start - no master Point class found!");

}

function setupCamera(MasterCameraPoint MasterPoint, PlayerPawn Player)
{
	local vector eyeHeight;
	local CameraProjectile CamProj;

	if ( !MasterPoint.bAnimatedCamera )
	{
		// realtime interpolating camera path
		if ( MasterPoint.CutSceneLength <= 0 )
			MasterPoint.CutSceneLength = 10;

		// Hide Player
		if ( MasterPoint.bHidePlayer )
			Player.bRenderSelf = false;

		// Lock Player Location
		if ( MasterPoint.bHoldPlayer )
			Player.LockPos();
		
		Player.LetterBox(true);

		// starting at the master point location.. interpolating to the next point
		CamProj = spawn(class 'CameraProjectile',Player,,MasterPoint.Location,Player.ViewRotation);
		MasterPoint.getNextPoint();
		CamProj.ToPoint = MasterPoint.NextPoint;
		CamProj.FromPoint = MasterPoint;
		CamProj.MasterPoint = MasterPoint;
		CamProj.TotalTime = MasterPoint.CutSceneLength;
		Player.ViewTarget = CamProj;
		CamProj.StartSequence();
		//MasterPoint.SetLetterBox(Player);
	} else {
		// PreAnimated camera path

		// log("...............................Generating camera projectile");
		AeonsPlayer(Player).SetFOV(36);
		CamProj = spawn(class 'CameraProjectile');//,,,MasterPoint.Location, masterPoint.Rotation);
		CamProj.MasterPoint = MasterPoint;
		CamProj.SetOwner(Player);
		Player.DesiredFOV = MasterPoint.GetCamFOVs(0);
		Player.ViewTarget = CamProj;
		CamProj.gotoState('PlayCannedAnim');
	}
}

defaultproperties
{
     bHumansOnly=True
     bClassicDeathMessages=True
}
