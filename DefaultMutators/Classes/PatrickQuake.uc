class PatrickQuake extends Patrick;

var vector StrafeJumpAccel;
var vector StrafeJumpDelta;

//Player Jumped
function DoJump( optional float F )
{
	local vector wishdir;

	if ( CarriedDecoration != None )
		return;
	if ( !InCrouch() && (Physics == PHYS_Walking) )
	{
		wishdir = Normal(StrafeJumpAccel);

		if (Acceleration Dot Normal(StrafeJumpDelta) > 2400) //FIX 2400??? Hard-code?
		{
			Velocity.X += wishdir.X * 100;
			Velocity.Y += wishdir.Y * 100;
		}
	}
	
	Super.DoJump(F);
}


//================================================================================
// Player movement.
// Player Standing, walking, running, falling.
state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;

	exec function FeignDeath()
	{
		if ( Physics == PHYS_Walking )
		{			ServerFeignDeath();
			Acceleration = vect(0,0,0);
			GotoState('FeigningDeath');
		}
	}

	function ZoneChange( ZoneInfo NewZone )
	{
		if (NewZone.bWaterZone)
		{
			SelectMode = SM_None;
			setPhysics(PHYS_Swimming);
			GotoState('PlayerSwimming');
		}
	}
	
	function Timer()
	{
		bPressedJump = false;
	}

	function Landed(vector HitNormal)
	{
//		log( "event Landed()" );
//		ClientMessage( "event Landed()" );
		Global.Landed(HitNormal);
		if ( VSize(Acceleration) < 100 )
			PlayWaiting();
		//bPressedJump = false;
		SetTimer(0.1, false);
	}

	function ProcessMove(float DeltaTime, vector NewAccel, rotator DeltaRot)
	{
		local vector	OldAccel;
		local float		OldVSize;
		local float		NewVSize;
		local rotator	lRot;

		OldAccel = Acceleration;
		OldVSize = VSize(OldAccel);
		NewVSize = VSize(NewAccel);

//		log( "in ProcessMove, OldAccel is <" $ OldAccel $ "> (" $ OldVSize $ "), NewAccel is <" $ NewAccel $ "> (" $ NewVSize $ ")" );

		Acceleration = NewAccel;
		bIsTurning = ( Abs(RawDeltaRotation(DeltaTime).Yaw) > 5000 );
		
		StrafeJumpAccel = Acceleration;
		StrafeJumpDelta = OldAccel;

		if ( bPressedJump )
			DoJump();

		if ( Physics == PHYS_Walking )
		{
			// check crouch
			if ( !bIsCrouching )
			{
				if ( bDuck != 0 )
				{
					// change from standing to crouching
					bIsCrouching = true;
					if ( NewVSize < 0.05 )
						PlayLocomotion( vect(0,0,0) );
				}
			}
			else if ( bDuck == 0 )
			{
				// change from crouching to standing
				bIsCrouching = false;
			}

			if ( ( NewVSize > 0.05 ) )	//&& ( OldVSize < 0.05 ) )
			{
				// movement just started
				lRot = Rotation;
				lRot.Pitch = 0;
				lRot.Roll = 0;

				lRot = rotator(Acceleration) - lRot;
				PlayLocomotion( vector(lRot) );
			}
			else if ( ( NewVSize < 0.05 ) && ( OldVSize > 0.05 ) )
			{
				// movement just stopped
				PlayLocomotion( vect(0,0,0) );
			}
		}
		AdjustCrouch( DeltaTime );
	}
			
	event PlayerTick( float DeltaTime )
	{
		local float DeltaOpacity;

		if ( Health <= 0 )
		{
			GotoState('Dying');
			return;
		}

		DoEyeTrace();
		if (PhaseMod == none)
		{
			//Super.PlayerTick(DeltaTime);
		} 
		else if (!PhaseMod.bActive) 
		{
			// player cutscene fade in/out
			DeltaOpacity = deltaTime * 2.0;
			if ( bRenderSelf )
				Opacity = FClamp(Opacity + DeltaOpacity, 0, 1);
			else
				Opacity = FClamp(Opacity - DeltaOpacity, 0, 1);
		}

		if ( bUpdatePosition )
			ClientUpdatePosition();

		PlayerMove(DeltaTime);
	}

	function PlayerMove( float DeltaTime )
	{
		local vector X,Y,Z, NewAccel;
		local rotator OldRotation;
		local float Speed2D;
		local bool	bSaveJump;
		local rotator MoveRot;

		VelocityBias = GetTotalPhysicalEffect( DeltaTime );

		MoveRot.Yaw = ViewRotation.Yaw;
		GetAxes(MoveRot,X,Y,Z);

		aForward *= 0.4;
		aStrafe  *= 0.4;
		aLookup  *= 0.24;
		aTurn    *= 0.24;

		// Update acceleration.
		NewAccel = aForward*X + aStrafe*Y; 
		NewAccel.Z = 0;
																		//dodge  ?
		if ( (Physics == PHYS_Walking) && (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			//if walking, look up/down stairs - unless player is rotating view
			if ( !bKeyboardLook && (bLook == 0) )
			{
				if ( bLookUpStairs )
					ViewRotation.Pitch = FindStairRotation(deltaTime);
				else if ( bCenterView )
				{
					ViewRotation.Pitch = ViewRotation.Pitch & 65535;
					if (ViewRotation.Pitch > 32768)
						ViewRotation.Pitch -= 65536;
					ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
					if ( Abs(ViewRotation.Pitch) < 1000 )
						ViewRotation.Pitch = 0;	
				}
			}

			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			//add bobbing when walking
			if ( !bShowMenu )
			{
				if ( Speed2D < 10 )
					BobTime += 0.2 * DeltaTime;
				else
					BobTime += DeltaTime * (0.3 + 0.7 * Speed2D/GroundSpeed);
				WalkBob = Y * 0.65 * Bob * Speed2D * sin(6.0 * BobTime);
				if ( Speed2D < 10 )
					WalkBob.Z = Bob * 30 * sin(12 * BobTime);
				else
					WalkBob.Z = Bob * Speed2D * sin(12 * BobTime);
			}
		}	
		else if ( !bShowMenu )
		{ 
			BobTime = 0;
			WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
		}

		OldRotation = Rotation;
		if ( bBehindView && ( bExtra2 > 0 ) )
		{
			// apply rotation delta to behindview offset
			BehindViewOffset = BehindViewOffset + RawDeltaRotation( DeltaTime );
		}
		else
		{
			// Update rotation.
			UpdateRotation(DeltaTime);
		}
														//dodge ?
		if ( False && bPressedJump && ((GetAnimGroup(AnimSequence) == 'Dodge') || (GetAnimGroup(AnimSequence) == 'Landing')) )
		{
			bSaveJump = true;
			bPressedJump = false;
		}
		else
			bSaveJump = false;

		if (!bAllowMove)
		{
			aForward *= 0;
			aStrafe  *= 0;
			aLookup  *= 0;
			aTurn    *= 0;
	
			// Update acceleration.
			NewAccel = vect(0,0,0); 
			Velocity = vect(0,0,0);
		}

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, OldRotation - Rotation);
		//bPressedJump = bSaveJump;
	}

	function BeginState()
	{
		bRenderWeapon = true;
//		WindowConsole(Player.Console).bShellPauses = false;
//		Level.bDontAllowSavegame = false;
		// LetterBox(false);
		UnFreeze(); // just make sure we're unfrozen (in case we're coming from a Dialog Scene)
		WalkBob = vect(0,0,0);
		bIsTurning = false;
		//bPressedJump = false;
		if (Physics != PHYS_Falling) SetPhysics(PHYS_Walking);
		if ( !IsAnimating() )
			PlayLocomotion( vect(0,0,0) );

		bSelectObject = false;
		SelectMode = SM_None;
	}
	
	function EndState()
	{
		WalkBob = vect(0,0,0);
	}
}


defaultproperties
{
	 AirControl=0.2
	 bCanStrafe=True
     GroundSpeed=450
     AirSpeed=450
     AccelRate=2200
     JumpZ=350
}