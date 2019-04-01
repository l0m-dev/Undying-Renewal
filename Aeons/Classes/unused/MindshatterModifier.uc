//=============================================================================
// MindshatterModifier.
//=============================================================================
class MindshatterModifier expands PlayerModifier;

var travel bool bModCrosshair;			// Mindshatter effect modifies players crosshair
var travel bool bRollCamera;			// Mindshatter effect modifies players camera roll
var travel bool bChangeFOV;			// Mindshatter effect modifies players FOV
var travel bool bModGroundSpeed;		// Mindshatter effect modifies players GroundSpeed

var int SndID;
var float ModCrosshairStr[6];	// casting level strengths
var float ModRollCameraStr[6];	// casting level strengths
var float ModChangeFOVStr[6];	// casting level strengths
var float ModPitchStrength[6];	// casting level strengths
var float ModFriction[6];		// casting level strengths
var float EffectLen[6];		// casting level strengths

var float fovMax;					// maximum fov
var travel float crossX, crossY;			// crosshair offsets in screen space
var float v;						// velocity
var travel float inc, inc2, inc3, inc4, inc5;	// counters
var float vMin, vMax;				// min/max velocity
var float fCrosshairMod;			// max distance in screen space the crosshair is allowed to move
var float fCrossHairScale;			// max scale factor for the crosshair
var float fDeltaFOV;
var travel float effectDuration;
var float pitch;
var travel float effectTimer;
var float targetFOV;
var float DefaultFOV;

function SetupValues()
{
	EffectLen[0] = 15;
	EffectLen[1] = 15;
	EffectLen[2] = 15;
	EffectLen[3] = 30;
	EffectLen[4] = 30;
	EffectLen[5] = 30;

	ModCrosshairStr[0] = 0.35;
	ModCrosshairStr[1] = 0.35;
	ModCrosshairStr[2] = 0.75;
	ModCrosshairStr[3] = 0.75;
	ModCrosshairStr[4] = 1.5;
	ModCrosshairStr[5] = 1.75;

	ModRollCameraStr[0] = 0.3;
	ModRollCameraStr[1] = 0.3;
	ModRollCameraStr[2] = 0.75;
	ModRollCameraStr[3] = 0.75;
	ModRollCameraStr[4] = 1.2;
	ModRollCameraStr[5] = 1.5;

	ModChangeFOVStr[0] = 0.3;
	ModChangeFOVStr[1] = 0.3;
	ModChangeFOVStr[2] = 0.5;
	ModChangeFOVStr[3] = 0.5;
	ModChangeFOVStr[4] = 1.0;
	ModChangeFOVStr[5] = 1.2;

	ModPitchStrength[0] = 0;
	ModPitchStrength[1] = 0.353;
	ModPitchStrength[2] = 0.55;
	ModPitchStrength[3] = 1.0;
	ModPitchStrength[4] = 1.0;
	ModPitchStrength[5] = 1.2;

	ModFriction[0] = 0.0;
	ModFriction[1] = 0.35;
	ModFriction[2] = 0.35;
	ModFriction[3] = 0.65;
	ModFriction[4] = 0.65;
	ModFriction[5] = 0.85;
	
	bModCrosshair = true;
	bRollCamera = true;
	bChangeFOV = true;
	bModGroundSpeed = true;

	vMin = 16;				// min velocity
	vMax = 360;				// max velocity range
	fovMax = 150;			// max fov
	fCrosshairMod = 128; 	// crosshair offset
	fCrossHairScale = 4;

	fDeltaFOV = 15;
	

}

function PreBeginPlay()
{
	super.PreBeginPlay();

	SetupValues();
	if ( PlayerPawn(Owner) != none )
		DefaultFOV = PlayerPawn(Owner).DefaultFOV;
}

// ===================================================================================
// AeonsPlayer Deactivated state
// ===================================================================================
state Deactivated
{
	simulated function BeginState()
	{
		TargetFOV = PlayerPawn(Owner).DefaultFOV;
		// PlayerPawn(Owner).DefaultFOV = DefaultFOV;
		PlayerPawn(Owner).DesiredFOV = DefaultFOV;
		// log ("BeginState: PlayerPawn(Owner).DefaultFov = "$PlayerPawn(Owner).DefaultFov, 'Misc');
	}
	
	simulated function EndState()
	{
		// PlayerPawn(Owner).DefaultFOV = DefaultFOV;
		PlayerPawn(Owner).DesiredFOV = DefaultFOV;
		// log ("EndState : PlayerPawn(Owner).DefaultFov = "$PlayerPawn(Owner).DefaultFov, 'Misc');
	}

	simulated function Tick( float deltaTime )
	{
		local bool bFov, bRoll, bcrossX, bCrossY, bCrossScale;
		local vector shake;
		local float x, scale;
		
		// Fov
		/*
		if ( !bFOV )
		{
			if (abs (PlayerPawn(Owner).desiredFOV - DefaultFOV) < 2.0)
			{
				PlayerPawn(Owner).DefaultFOV = DefaultFOV;
				PlayerPawn(Owner).DesiredFOV = DefaultFOV;
				// PlayerPawn(Owner).desiredFov = PlayerPawn(Owner).DefaultFov;
				bFOV = true;
			} else {
				if ( PlayerPawn(Owner).desiredFOV < DefaultFOV )
					PlayerPawn(Owner).desiredFOV += 0.5;
				else
					PlayerPawn(Owner).desiredFOV -= 0.5;
			}
		}
*/
		// View rotation Roll
		if ( !bRoll )
		{
			if ( (abs(AeonsPlayer(Owner).ViewRotation.Roll) < 128) || (abs(AeonsPlayer(Owner).ViewRotation.Roll) > (65536-128)) )
			{
				AeonsPlayer(Owner).ViewRotation.Roll = 0;
				bRoll = true;
			} else {
				if ( AeonsPlayer(Owner).ViewRotation.Roll > 0 )
					AeonsPlayer(Owner).ViewRotation.Roll -= 1;
				else
					AeonsPlayer(Owner).ViewRotation.Roll += 1;
			}
		}

		// CrossHair X
		if ( !bCrossX )
		{
			if (abs(AeonsPlayer(Owner).crosshairOffsetX) < 3)
			{
				AeonsPlayer(Owner).crosshairOffsetX = 0;
				bCrossX = true;
			} else {
				if (AeonsPlayer(Owner).crosshairOffsetX > 0)
					AeonsPlayer(Owner).crosshairOffsetX -= 3;
				else
					AeonsPlayer(Owner).crosshairOffsetX += 3;
			}
		}

		// CrossHair Y
		if ( !bCrossY )
		{
			if (abs (AeonsPlayer(Owner).crosshairOffsetY) < 3)
			{
				AeonsPlayer(Owner).crosshairOffsetY = 0;
				bCrossY = true;
			} else {
				if (AeonsPlayer(Owner).crosshairOffsetY > 0)
					AeonsPlayer(Owner).crosshairOffsetY -= 3;
				else
					AeonsPlayer(Owner).crosshairOffsetY += 3;
			}
		}

		// CrossHair Scale
		if ( !bCrossScale )
		{
			if (abs(AeonsPlayer(Owner).crosshairScale - 1) < 0.5)
			{
				AeonsPlayer(Owner).crosshairScale = 1;
				bCrossScale = true;
			} else {
				if (AeonsPlayer(Owner).crosshairScale > 1)
					AeonsPlayer(Owner).crosshairScale -= 0.1;
				else
					AeonsPlayer(Owner).crosshairScale += 0.1;
			}
		}
		
		if ( bCrossX && bCrossY && bCrossScale && bRoll )
		{
			// PlayerPawn(Owner).DesiredFov = DefaultFOV;
			AeonsPlayer(Owner).CrosshairOffsetX = 0;
			AeonsPlayer(Owner).CrosshairOffsetY = 0;
			AeonsPlayer(Owner).CrosshairScale = 1;
			PlayerPawn(Owner).GroundSpeed = PlayerPawn(Owner).Default.groundSpeed;
			AeonsPlayer(Owner).ViewRotation.Roll = 0;
			gotoState('Idle');
		}
	}

	Begin:
		AeonsPlayer(Owner).bRenderWeapon = true;
		bActive = false;
		effectTimer = 0;
}


// ===================================================================================
// ScriptedPawn Deactivated state
// ===================================================================================
state SPDeactivated
{

	Begin:
		bActive = false;
}

// ===================================================================================
// ScriptedPawn Activated state
// ===================================================================================
state SPActivated
{


	Begin:
		bActive = true;
		sleep(30);
		gotoState('SPDeactivated');
}

// ===================================================================================
// AeonsPlayer Activated state
// ===================================================================================
state Activated
{
	function BeginState()
	{
		log("Mindshatter Modifier being activated - casting level = "$castingLevel, 'Misc');
		if (Owner.IsA('ScriptedPawn'))
			gotoState('SPActivated');
		SetLocation(Owner.Location);
		PlaySound(ActivateSound,,1);
	}

	simulated function Timer()
	{
// 		owner.playOwnedSound(EffectSound,,1,,,pitch);
	}

	simulated function Tick( float deltaTime )
	{
		local vector shake;
		local float x, scale;
		local float targetFOV;
		local float fovMod;

		if (PlayerPawn(Owner).Health <= 0)
		{
			PlayerPawn(Owner).DesiredFOV = PlayerPawn(Owner).DefaultFOV;
			return;
		}
		effectTimer += deltaTime;
		if ( effectTimer > EffectLen[CastingLevel] )
		{
			gotoState('Deactivated');
			return;
		}
			
		v = vSize(owner.velocity);		// get the velocity of the character
		inc += 0.02;
		inc2 += 0.05;
		inc3 += 0.065;
		inc4 += 0.125;
		inc5 += 0.025;

		pitch = ModPitchStrength[castingLevel]; // * abs(cos(inc));
		// FOV /////////////////////////////////////////////////////////////////////////////////////////////////
		if ( bChangeFOV )
		{
			fovMod = ((fDeltaFOV *2) * ModChangeFOVStr[castingLevel]) + (cos(inc) * (fDeltaFOV * ModChangeFOVStr[castingLevel])) + (cos(inc2) * ((fDeltaFOV * 2) * ModChangeFOVStr[castingLevel]));
			TargetFOV = DefaultFOV + fovMod;
		} else
			TargetFOV = DefaultFOV;

		if ( PlayerPawn(Owner).DesiredFOV < TargetFOV )
			TargetFOV = PlayerPawn(Owner).DesiredFOV + 0.5;
		else
			TargetFOV = PlayerPawn(Owner).DesiredFOV - 0.5;

		PlayerPawn(Owner).DesiredFOV = TargetFOV;

		// Roll Camera /////////////////////////////////////////////////////////////////////////////////////////////////
		if ( bRollCamera )
			AeonsPlayer(Owner).ViewRotation.Roll = (cos(inc2) * (4096 * ModRollCameraStr[castingLevel])) + (cos(inc3) * (4096 * ModRollCameraStr[castingLevel]));
			//AeonsPlayer(Owner).ViewRotation.Roll = (cos(inc5) * (65536)) + (cos(inc2) * (2048 * ModRollCameraStr[castingLevel])) + (cos(inc3) * (2048 * ModRollCameraStr[castingLevel]));

		// GroundSpeed /////////////////////////////////////////////////////////////////////////////////////////////////
		/*
		if ( bModGroundSpeed )
			PlayerPawn(Owner).GroundFriction = PlayerPawn(Owner).default.groundSpeed + (cos(inc) * 120);
		else
			PlayerPawn(Owner).groundSpeed = PlayerPawn(Owner).default.groundSpeed;
		*/
		// CrossHair /////////////////////////////////////////////////////////////////////////////////////////////////
		if ( bModCrosshair )
		{
			scale = abs(cos(inc * 0.3) * (fCrossHairScale * 0.5) + cos(inc2 * 0.5) * (fCrossHairScale * 0.5));
			crossX = cos(inc) * (fCrosshairMod * ModCrosshairStr[castingLevel]);
			crossY = cos(inc2) * (fCrosshairMod * ModCrosshairStr[castingLevel]);
			AeonsPlayer(Owner).crosshairOffsetX = -crossX;
			AeonsPlayer(Owner).crosshairOffsetY = -crossY;

			//AeonsPlayer(Owner).crosshairOffsetX = cos(inc) * crossX;
			//AeonsPlayer(Owner).crosshairOffsetY = cos(inc2) * crossY;
			AeonsPlayer(Owner).crosshairScale = fClamp(scale, 1, fCrossHairScale);
		} else {
			AeonsPlayer(Owner).crosshairOffsetX = 0;
			AeonsPlayer(Owner).crosshairOffsetY = 0;
			AeonsPlayer(Owner).crosshairScale = 1;
		}
	}

	Begin:
		bActive = true;
		AeonsPlayer(Owner).bRenderWeapon = false;
		// log("Mindshatter activated... my owner is " $Owner.name);
		if (SndID == -1)
			SndID = Owner.PlaySound(EffectSound,,1,,,Pitch);
		log ("Starting Mindshatter Sound: " $ SndID);
		// setTimer(GetSoundDuration(EffectSound), true);
		inc = 0; inc2 = 0; inc3 = 0; inc4 = 0; inc5 = 0;
		EffectTimer = 0;
}

auto state Idle
{
	Begin:
		if ( !Level.bIsCutsceneLevel )
			if ( PlayerPawn(Owner) != none )
			{
				PlayerPawn(Owner).DesiredFOV = PlayerPawn(Owner).DefaultFOV;
				bActive = false;
			}
		AeonsPlayer(Owner).bRenderWeapon = true;
		log ("Stopping Mindshatter Sound: " $ SndID);
		Owner.StopSound(SndID);
		SndID = -1;
}

defaultproperties
{
     SndID=-1
     ActivateSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_MindHitHead01'
     EffectSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_MindLoop01'
     bNetTemporary=True
}
