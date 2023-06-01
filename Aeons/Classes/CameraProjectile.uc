//=============================================================================
// CameraProjectile.
//=============================================================================
class CameraProjectile expands Projectile;

//#exec MESH IMPORT MESH=camera_m SKELFILE=camera.ngf

var byte 	RotMethod;
var name 	AnimName;
var bool 	bFirstTick, bHolding;
var int 	nextDir, i;
var name 	Events[4];
var float 	EventTimes[4], LookWt[2], TScale, TotalPathLen, TotalTime, LenToNextPoint, pDist, LastpDist, FOVs[2], FromSpeed, HoldLen, LastTick;
var vector 	LookAt[2], T1, T2, P0, P1, P2, P3, FromLoc, LastLoc, LookAtOffset[2];
var CameraNavigation ToPoint, FromPoint, NextPoint, LastPoint;
var ParticleFX dFX;
var MasterCameraPoint MasterPoint;
var int LastYaw;
var ScriptedPawn GPawn;
var CutSceneChar C;
var float dt[60];
var int iDt;
var bool bSkipped;

function PreBeginPlay()
{
	super.PreBeginPlay();
	// log("..............CameraProjectile : PreBeginPlay()", 'Misc');
	bFirstTick = true;
	TScale = 1.0;
}

function Destroyed()
{
	// log("Camera Destroyed ... ", 'Misc');
}

// Start sequence stuff
simulated function startSequence()
{
	TotalPathLen = GetTotalPathLen(MasterPoint);		// length of the path
	Speed = TotalPathLen/TotalTime;						// speed derived from length
	
	
	log("...........................................................................", 'Cutscenes');
	log("...............................................TotalPathLen: "$TotalPathLen, 'Cutscenes');
	log("...............................................Speed: "$Speed, 'Cutscenes');
	log("...............................................New Time:"$(TotalPathLen/Speed), 'Cutscenes');
	log("...........................................................................", 'Cutscenes');

	// AeonsPlayer(Owner).bHidden = true;
	FromLoc = Location;
	NextPoint = ToPoint.NextPoint;
	LastLoc = FromLoc + Normal(FromLoc-ToPoint.Location) * 256;
	ComputeSegmentData();
	GotoState('PathInterpolation');		// go
}

// get the total length of the path that camera will traverse.
function float GetTotalPathLen(MasterCameraPoint P)
{
	local bool bFoundEnd;
	local CameraNavigation CP0, CP1, CP2, CP3;
	local Vector P0, P1, P2, P3, v0, v1, v2, v3, v4, v5, v6, v7, v8, EyeHeight;
	local float PathLen, d1, d2;
	local Actor A;

	AeonsPlayer(Owner).MasterCamPoint = P;
	// CP1 is the master point
	CP1 = P;
	CP1.getNextPoint(true);
	CP1.getPrevPoint(true);

	// previous point
	CP0 = CP1.PrevPoint;

	// Next Point
	CP2 = CP1.NextPoint;
	CP2.GetNextPoint(true);
	CP2.PrevPoint = CP1;

	CP3 = CP2.NextPoint;
	CP3.GetNextPoint(true);
	CP3.PrevPoint = CP2;

	P0 = CP1.Location;
	P1 = CP1.Location;
	P2 = CP2.Location;
	P3 = CP3.Location;

	/*
	log("...CP0 = "$CP0, 'Cutscenes');
	log("...CP1 = "$CP1, 'Cutscenes');
	log("...CP2 = "$CP2, 'Cutscenes');
	log("...CP3 = "$CP3, 'Cutscenes');
*/
	while ( !bFoundEnd )
	{
		if ( CP2 != none )
		{
			if ( !CP2.bEndCutscene && CP2 != P ) {
				if (!CP1.bCutToNextPoint)
				{ 
					d1 = ((VSize(P1-P0) + VSize(P1-P2)) * 0.5) * TScale;
					d2 = ((VSize(P3-P2) + VSize(P1-P2)) * 0.5) * TScale;
				
					T1 = Normal(P2-P0) * d1;
					T2 = Normal(P3-P1) * d2;
	
					v0 = GetHermitePoint(P1, T1, P2, T2, 0.1);
					v1 = GetHermitePoint(P1, T1, P2, T2, 0.2);
					v2 = GetHermitePoint(P1, T1, P2, T2, 0.3);
					v3 = GetHermitePoint(P1, T1, P2, T2, 0.4);
					v4 = GetHermitePoint(P1, T1, P2, T2, 0.5);
					v5 = GetHermitePoint(P1, T1, P2, T2, 0.6);
					v6 = GetHermitePoint(P1, T1, P2, T2, 0.7);
					v7 = GetHermitePoint(P1, T1, P2, T2, 0.8);
					v8 = GetHermitePoint(P1, T1, P2, T2, 0.9);
					
					// log("Calculating the length of the path...", 'Cutscenes');
					PathLen += VSize(P1-v0);
					PathLen += VSize(v1-v0);
					PathLen += VSize(v2-v1);
					PathLen += VSize(v3-v2);
					PathLen += VSize(v4-v3);
					PathLen += VSize(v5-v4);
					PathLen += VSize(v6-v5);
					PathLen += VSize(v7-v6);
					PathLen += VSize(v8-v7);
					PathLen += VSize(P2-v8);
				}
			} else {
				// log("CP2.bEndCutscene = "$CP2.bEndCutscene, 'Cutscenes');
				// log("CP2 != P = "$(CP2 != P), 'Cutscenes');
				if ( P.bTeleportPlayer )
				{
					if ( P.PlayerTeleportTag != 'none' )
					{
						ForEach AllActors(class 'Actor', A, P.PlayerTeleportTag)
						{
							// log("Found Actor to move player to : "$A.name, 'Cutscenes');
							//EyeHeight.z = PlayerPawn(Owner).EyeHeight;
							PlayerPawn(Owner).SetCollision( false, false, false );
							PlayerPawn(Owner).SetLocation(A.Location); //-Eyeheight);
							PlayerPawn(Owner).SetRotation(A.Rotation);
							PlayerPawn(Owner).ViewRotation = PlayerPawn(Owner).Rotation;
							PlayerPawn(Owner).SetCollision( true, true, true );
							break;
						}
					} else {
						EyeHeight.z = PlayerPawn(Owner).EyeHeight;
						PlayerPawn(Owner).SetCollision( false, false, false );
						PlayerPawn(Owner).SetLocation(CP2.Location-Eyeheight);
						PlayerPawn(Owner).SetRotation(Rotator(CP2.Location-CP2.PrevPoint.Location));
						PlayerPawn(Owner).ViewRotation = PlayerPawn(Owner).Rotation;
						PlayerPawn(Owner).SetCollision( true, true, true );
					}
				}

				bFoundEnd = true;
				break;
			}
		} else {
			// log("CP2 = none", 'Cutscenes');
			bFoundEnd = true;
			break;
		}
		CP0 = CP1;
		CP1 = CP2;
		CP2 = CP3;
		CP2.GetNextPoint(true);
		CP3 = CP2.NextPoint;
		P0 = CP0.Location;
		P1 = CP1.Location;
		P2 = CP2.Location;
		P3 = CP3.Location;

		/*
		log("CP0 = "$CP0, 'Cutscenes');
		log("CP1 = "$CP1, 'Cutscenes');
		log("CP2 = "$CP2, 'Cutscenes');
		log("CP3 = "$CP3, 'Cutscenes');
		*/
	}

	return PathLen;
}

// This function is called before ComputeSegmentData()
function ResolvePathPoints()
{
	//log("",'Misc');
	
	if ( (ToPoint.bEndCutscene && !ToPoint.bHold) || FromPoint.bEndCutscene ) {
		//log("ResolvePathPoints Ending Cutscene", 'Misc');
		EndIt();
	} else {
		if ( FromPoint.bHold && !FromPoint.bCutToNextPoint )
		{
			FromPoint.bHold = false;
		} else {
			//log("ResolvePathPoints shifting points", 'Misc');
			LastPoint = FromPoint;
			FromPoint = ToPoint;
			ToPoint = NextPoint;
			NextPoint = ToPoint.NextPoint;
		}

		if ( FromPoint.bCutToNextPoint && !FromPoint.bHold )
		{
			//log("ResolvePathPoints shifting points a second time", 'Misc');
			LastPoint = FromPoint;
			FromPoint = ToPoint;
			ToPoint = NextPoint;
			NextPoint = ToPoint.NextPoint;
		}
		
		if ( FromPoint.bHold )
		{
			//log("ResolvePathPoints FromPoint is holding", 'Misc');
			bHolding = true;
		}
	}
}

// recompute the segment data - this is done only when we cross over to a new segment.
function ComputeSegmentData()
{
	local float d1, d2;
	local vector v0, v1, v2, v3, v4, v5, v6 ,v7, v8;
	local int i;
	local Actor A;
	
	if (FromPoint != none)
		P1 = FromPoint.Location;
	else
		P1 = FromLoc;

	P2 = ToPoint.Location;

	if (ToPoint.bCutToNextPoint)
		P3 = (P2-P1) + P2;		// If we are cutting to the next point, we derive its tangent from
	else
		P3 = NextPoint.Location;

	if ( LastPoint != none )
	{
		if ( LastPoint.bCutToNextPoint )
		{
			SetLocation(FromPoint.Location);
			P0 = P1 + (P1-P2);
			if ( FromPoint.bDirectional ) {
				// Set the cameras initial rotation to the rotation of the point we are now coming from (after the cut)
				SetRotation(FromPoint.Rotation);
			} else if ( FromPoint.LookAt != 'none' ) {
				// Set the camera rotation to look at the actor we  need to be looking at.
				ForEach AllActors(class 'Actor', A, FromPoint.LookAt)
				{
					SetRotation(Rotator(A.Location - Location));
					break;	
				}
			} else {
				// we're not looking at anything in particular - start out looking at the next point.
				SetRotation(Rotator(ToPoint.Location - FromPoint.Location));
			}

		} else {
			P0 = LastPoint.Location;
		}
	} else {
		P0 = LastLoc;
	}

	d1 = ((VSize(P1-P0) + VSize(P1-P2)) * 0.5) * TScale;
	d2 = ((VSize(P3-P2) + VSize(P1-P2)) * 0.5) * TScale;

	T1 = Normal(P2-P0) * d1;
	T2 = Normal(P3-P1) * d2;

	LenToNextPoint = 0;
	
	v0 = GetHermitePoint(P1, T1, P2, T2, 0.1);
	v1 = GetHermitePoint(P1, T1, P2, T2, 0.2);
	v2 = GetHermitePoint(P1, T1, P2, T2, 0.3);
	v3 = GetHermitePoint(P1, T1, P2, T2, 0.4);
	v4 = GetHermitePoint(P1, T1, P2, T2, 0.5);
	v5 = GetHermitePoint(P1, T1, P2, T2, 0.6);
	v6 = GetHermitePoint(P1, T1, P2, T2, 0.7);
	v7 = GetHermitePoint(P1, T1, P2, T2, 0.8);
	v8 = GetHermitePoint(P1, T1, P2, T2, 0.9);

	LenToNextPoint += VSize(P1-v0);
	LenToNextPoint += VSize(v1-v0);
	LenToNextPoint += VSize(v2-v1);
	LenToNextPoint += VSize(v3-v2);
	LenToNextPoint += VSize(v4-v3);
	LenToNextPoint += VSize(v5-v4);
	LenToNextPoint += VSize(v6-v5);
	LenToNextPoint += VSize(v7-v6);
	LenToNextPoint += VSize(v8-v7);
	LenToNextPoint += VSize(P2-v8);

	LookAt[0] = vect(0,0,0);
	LookAt[1] = vect(0,0,0);
	LookWt[0] = 1.0;
	LookWt[1] = 1.0;
	LookAtOffset[0] = vect(0,0,0);
	LookAtOffset[1] = vect(0,0,0);

	FOVs[0] = 0;
	FOVs[1] = 0;
	
	if (FromPoint != none)
		FOVs[0] = FromPoint.FOV_Target;

	if (FOVs[0] == 0)
		FOVs[0] = 90;

	if (ToPoint != none)
		FOVs[1] = ToPoint.FOV_Target;

	if (FOVs[1] == 0)
		FOVs[1] = 90;
	
	if ( ToPoint.LookAt != 'none' )
		ForEach AllActors(class 'Actor', A, ToPoint.LookAt)
		{
			LookAt[1] = A.Location;
			LookWt[1] = ToPoint.LookWeight;
			break;
		}
	if ( FromPoint.bHold )
	{
		HoldLen = FromPoint.HoldLen;
		bHolding = true;
	}

	// =========================================================
	// calculate all the necessary events and their time offsets

	// clear the events
	for (i=0; i<4; i++)
		Events[i] = 'none';

	// From Point Event 1
	if (FromPoint.Event1 != 'none')
	{
		if (FromPoint.Event1Time >= 0)
		{
			Events[0] = FromPoint.Event1;
			EventTimes[0] = FClamp(FromPoint.Event1Time, 0, 1.0);
		}
	}

	// From Point Event 2
	if (FromPoint.Event2 != 'none')
	{
		if (FromPoint.Event2Time >= 0)
		{
			Events[1] = FromPoint.Event2;
			EventTimes[1] = FClamp(FromPoint.Event2Time, 0, 1.0);
		}
	}

	// To Point Event 1
	if (ToPoint.Event1 != 'none')
	{
		if (ToPoint.Event1Time < 0)
		{
			Events[2] = ToPoint.Event1;
			EventTimes[2] = FClamp((ToPoint.Event1Time + 1.0), 0, 1.0);
		}
	}

	// To Point Event 2
	if (ToPoint.Event2 != 'none')
	{
		if (ToPoint.Event2Time < 0)
		{
			Events[2] = ToPoint.Event2;
			EventTimes[2] = FClamp((ToPoint.Event2Time + 1.0), 0, 1.0);
		}
	}
}

function vector GetHermitePoint(vector P1, vector T1, vector P2, vector T2, float u)
{
	local float h1, h2, h3, h4, t;

	t = fClamp(u,0,1);

	h1 = (2 * (t*t*t)) - (3 * square(t)) + 1;
	h2 = -(2 * (t*t*t)) + (3 * square(t));
	h3 = (t*t*t) - (2 * square(t)) + t;
	h4 = (t*t*t) - square(t);
	return (h1*P1 + h2*P2 + h3*T1 + h4*T2);
}

// Camera is interpolating a sequence of points in the level.
simulated state PathInterpolation
{
	simulated function Tick(float DeltaTime)
	{
		local vector 	NextFrameLoc, LookDir, LastDir;
		local float 	MoveAmt, SpeedModifier, FromSpeed, ToSpeed;
		local int i, CurrentYaw, YawDiff;
		local Actor A;
		local rotator LookRot;

		if ( !bHolding )
		{
			if ( FromPoint.bDirectional )
			{
				LookAt[0] = FromPoint.Location + (Vector(FromPoint.Rotation) * 1024);
				LookWt[0] = FromPoint.LookWeight;
			} else {
				if ( FromPoint.LookAt != 'none' )
				{
					ForEach AllActors(class 'Actor', A, FromPoint.LookAt)
					{
						LookAt[0] = A.Location;
						LookWt[0] = FromPoint.LookWeight;
						LookAtOffset[0] = FromPoint.LookAtOffset;
						break;
					}
				} else {
					LookAt[0] = ToPoint.Location;
					LookWt[0] = FromPoint.LookWeight;
				}
			}

			if ( ToPoint.bDirectional )
			{
				LookAt[1] = ToPoint.Location + (Vector(ToPoint.Rotation) * 1024);
				LookWt[1] = ToPoint.LookWeight;
			} else {
				if ( ToPoint.LookAt != 'none' )
				{
					ForEach AllActors(class 'Actor', A, ToPoint.LookAt)
					{
						LookAt[1] = A.Location;
						LookWt[1] = ToPoint.LookWeight;
						LookAtOffset[0] = ToPoint.LookAtOffset;
						break;
					}
				} else {
					LookAt[1] = NextPoint.Location;
					LookWt[1] = ToPoint.LookWeight;
				}
			}

			LastDir = Vector(Rotation);

			// Move this amount this frame.
			if (FromPoint != none)
				FromSpeed = FromPoint.SpeedModifier;
			else
				FromSpeed = 1.0;

			if (ToPoint != none)
				ToSpeed = ToPoint.SpeedModifier;
			else
				ToSpeed = 1.0;

			SpeedModifier = ((FromSpeed * (1-pDist)) + (ToSpeed * pDist));

			MoveAmt = (Speed * DeltaTime) * SpeedModifier;

			// Calculate the parametric distance between the points.

			pDist += (MoveAmt / LenToNextPoint);
			pDist = FClamp(pDist, 0, 1);

			// Events
			for ( i=0; i<4; i++ )
			{
				if (Events[i] != 'none')
					if (pDist >= EventTimes[i] || bSkipped)
					{
						foreach AllActors( class 'Actor', A, Events[i] )
						{
							if ( A.IsA('Trigger') )
							{
								Trigger(A).PassThru(self);
							}
							A.Trigger( Self, Self.Instigator );
						}
						// just fired the event... remove it from the list.
						Events[i] = 'none';
					}
			}

			// The next frame, I'll be in this location...
			NextFrameLoc = GetHermitePoint(P1, T1, P2, T2, pDist);
	
			// where am I Looking???
			LookDir = vect(0,0,0);

			if ( LookAt[0] != vect(0,0,0) )
				LookDir += Normal((LookAt[0] + LookAtOffset[0]) - Location) * (1 - pDist) * LookWt[0];
			else
				LookDir += Normal(NextFrameLoc - Location) * (1 - pDist) * LookWt[0];
	
			if ( LookAt[1] != vect(0,0,0) )
				LookDir += Normal((LookAt[1] + LookAtOffset[0]) - Location) * pDist * LookWt[1];
			else
				LookDir += Normal(NextFrameLoc - Location) * pDist * LookWt[1];

			/*
			switch ( RotMethod )
			{
				// ===========================================================
				// Absolute rotation - look in the direction we are moving.
				case 0:
					if (LookAt[0] != vect(0,0,0))
						LookDir += Normal((LookAt[0] + LookAtOffset[0]) - Location) * (1 - pDist) * LookWt[0];
					else
						LookDir += Normal(NextFrameLoc - Location) * (1 - pDist) * LookWt[0];
			
					if (LookAt[1] != vect(0,0,0))
						LookDir += Normal((LookAt[1] + LookAtOffset[0]) - Location) * pDist * LookWt[1];
					else
						LookDir += Normal(NextFrameLoc - Location) * pDist * LookWt[1];
					break;
					
				// ===========================================================
				// look at the next point ahead.
				case 1:
	
					if (LookAt[0] != vect(0,0,0))
						LookAt[0] = ToPoint.Location;
						
					if (LookAt[1] != vect(0,0,0))
						LookAt[1] = NextPoint.Location;
	
					LookDir += Normal((LookAt[0]) - Location) * (1 - pDist);
					LookDir += Normal((LookAt[1]) - Location) * pDist;
	
					// LookDir = (ToPoint.Location + (NextPoint.Location-ToPoint.Location) * pDist) - Location;
					break;
	
				// ===========================================================
				// look at the second point ahead
				case 2:
					if (LookAt[0] != vect(0,0,0))
						LookDir += Normal((LookAt[0] + LookAtOffset[0]) - Location) * (1 - pDist) * LookWt[0];
					else
						LookDir += Normal(NextPoint.Location - Location) * (1 - pDist) * LookWt[0];
			
					if (LookAt[1] != vect(0,0,0))
						LookDir += Normal((LookAt[1] + LookAtOffset[0]) - Location) * pDist * LookWt[1];
					else
						LookDir += Normal(NextPoint.Location - Location) * pDist * LookWt[1];
		
					break;
			};
			*/
			
			LookDir = Normal(LookDir);

			LookRot = Rotator(LookDir);
			// CurrentYaw = LookRot.yaw;
			// YawDiff = CurrentYaw - LastYaw;
			// LookRot.Roll = YawDiff * 4;
			// DesiredRotation = LookRot;
			// LookRot = Rotator(NextFrameLoc - Location);
			
			AeonsPlayer(Owner).CamDebugRotDiff = (LookRot-Rotation);
			AeonsPlayer(Owner).CamDebugPosDiff = (NextFrameLoc - Location);
			AeonsPlayer(Owner).LookAt1 = LookAt[0];
			AeonsPlayer(Owner).LookAt2 = LookAt[1];
			AeonsPlayer(Owner).LookDir = LookDir;
			AeonsPlayer(Owner).pDist = pDist;
			AeonsPlayer(Owner).DesiredFOV = (FOVs[0] * (1-pDist) + FOVs[1] * pDist);

			SetRotation(LookRot);

			PlayerPawn(Owner).SetFOVAngle(FOVs[0] * (1-pDist) + FOVs[1] * pDist);
			
			// log(""$pDist$" "$(pDist-LastpDist)$" "$(NextFrameLoc - Location)$" "$LookDir$" "$Rotation,'CameraDebug');

			// LastYaw = LookRot.yaw;

			// Move me, and make sure we're in the level.
			if (Level.GetZone(NextFrameLoc) > 0)
			{
				SetLocation( NextFrameLoc);
			} else {
				PlayerPawn(Owner).ClientMessage("Out of Level");
			}

			if ( !bFirstTick )
				if (PlayerPawn(Owner).getStateName() != 'PlayerCutScene')
				{
					log ("Player State is "$PlayerPawn(Owner).getStateName(), 'Misc');
					log("CameraProjectile -- path interpolation ... forcing cutscene to end", 'Misc');
					Destroy();
					MasterPoint.CompleteCutscene(PlayerPawn(Owner));
					MasterPoint.Teleport(PlayerPawn(Owner));
				}

			if ( pDist >= 1.0 || bSkipped )
			{
				log ("pDist reached .... ", 'Misc');
				bHolding = false;
				pDist = 0;
				ResolvePathPoints();
				ComputeSegmentData();
			}
		} else {
			// FromPoint.bHold = false;
			HoldLen -= DeltaTime;
			
			if ( HoldLen <= 0 || bSkipped )
			{
				// log ("Hold Timer reached .... ", 'Misc');
				pDist = 0;
				bHolding = false;
				for ( i=0; i<4; i++ )
				{
					if ( Events[i] != 'none' )
						foreach AllActors( class 'Actor', A, Events[i] )
						{
							if ( A.IsA('Trigger') )
							{
								Trigger(A).PassThru(self);
							}
							A.Trigger( Self, Self.Instigator );
						}
					Events[i] = 'none';
				}

				ResolvePathPoints();
				ComputeSegmentData();
			}
		
			SetLocation( FromPoint.Location );

			if ( FromPoint.bDirectional )
			{
				SetRotation(FromPoint.Rotation);
			} else if ( FromPoint.LookAt != 'none' ) {
				ForEach AllActors(class 'Actor', A, FromPoint.LookAt)
				{
					SetRotation(Rotator(A.Location - Location));
					break;
				}
			} else {
				SetRotation( Rotator(FromPoint.Location - ToPoint.Location) );
			}

		}
	}

	function EndState()
	{
		PlayerPawn(Owner).bRenderSelf = true;
		PlayerPawn(Owner).bHidden = false;

		if (MasterPoint.bHoldPlayer)
			PlayerPawn(Owner).UnFreeze();

		if (ToPoint.bEndCutScene && (pDist > 0.5 || bSkipped))
			PlayerPawn(Owner).bRenderSelf = true;
	}

	Begin:
		// foreach AllActors( class'ScriptedPawn', GPawn,)
		// 	GPawn.LookTargetNotify( self, 20 );

		if ( !MasterPoint.bFromPlayerEyes && MasterPoint.bDirectional )
			SetRotation(MasterPoint.Rotation);

		LastYaw = rotation.yaw;
		// get the rotation method to use for the projectile.
		if ( MasterPoint.bHidePlayer )
		{
			PlayerPawn(Owner).bRenderSelf = false;
			PlayerPawn(Owner).bHidden = true;
		}

		if (MasterPoint.bHoldPlayer)
			PlayerPawn(Owner).Freeze();
	
		if ( MasterPoint.bLetterBoxed )
			MasterPoint.SetLetterBox(PlayerPawn(Owner));

		switch ( MasterPoint.RotMethod )
		{
			case ROT_Absolute:
				RotMethod = 0;
				break;
	
			case ROT_NextPoint:
				RotMethod = 1;
				break;
	
			case ROT_SecondPoint:
				RotMethod = 2;
				break;
		};
		PlayerPawn(Owner).GotoState('PlayerCutScene');
		PlayerPawn(Owner).ViewTarget = self;

		bFirstTick = false;
}

function SkipIt()
{
	bSkipped = true;
}
function EndIt()
{
	// log ("Attempting to End the Cutscene", 'Misc');
	log("CameraProjectile -- EndIT ... forcing cutscene to end", 'Misc');
	MasterPoint.CompleteCutscene(PlayerPawn(Owner));
	MasterPoint.Teleport(PlayerPawn(Owner));
	Destroy();
}
function SetTake(int t);
function NextTake();
function PrevTake();

// Play a preanimated sequence
simulated state PlayCannedAnim
{
	function SetTake(int t)
	{
		i = t;
	}
	
	function NextTake()
	{
		i ++;
	}

	function PrevTake()
	{
		i --;
	}

	Begin:
		SetTimer(0.5, true) ;
		SetPhysics(PHYS_None);
		PlayerPawn(Owner).GotoState('PlayerCutScene');

		PlayerPawn(Owner).bHidden = true;

		AeonsPlayer(Owner).MasterCamPoint = MasterPoint;
		MasterPoint.StartCutscene();
		// LetterBox
		if ( MasterPoint.bLetterBoxed ) {
			MasterPoint.SetLetterBox(PlayerPawn(Owner));
			log("LB", 'Misc');
		} else
			log("NO LB", 'Misc');
		
		for ( i=0;i<MasterPoint.NumTakes;i++ )
		{
			
			if ( MasterPoint.GetWaitTimer(i) > 0 )
				Sleep(MasterPoint.GetWaitTimer(i));

			// set the FOV
			
			/*
			if ( AeonsPlayer(Owner).ViewTarget == self )
			{
			*/
			AeonsPlayer(Owner).EyeHeight = 0;
			AeonsPlayer(Owner).SetFOV(MasterPoint.GetCamFOVs(i));
			/*
			} else {
				AeonsPlayer(Owner).EyeHeight = AeonsPlayer(Owner).default.EyeHeight;
				AeonsPlayer(Owner).SetFOV(AeonsPlayer(Owner).DefaultFOV);
			}
			*/
			
			// cause the Cutscene character to play his take
			ForEach AllActors(class 'CutSceneChar', C)
			{
				C.SceneCamera = self;
				//if ( MasterPoint.bAutoClearAnims )
				//	C.PlayAnim('');
				C.PlayTake(i);
			}

			// either play an animation for the camera or set the camera
			// location and orientation for a period of time.
			if (MasterPoint.GetAnimName(i) != 'none')
			{
				// log("Camera Projectile playing anim : "$MasterPoint.GetAnimName(i)$" for Take: "$i, 'Cutscenes');
				PlayAnim(MasterPoint.GetAnimName(i),1.0, MOVE_AnimAbs,,0);
				FinishAnim();
			} else {
				if (MasterPoint.GetCamTime(i) > 0)
				{
					// log("Camera Projectile static position : for Take: "$i, 'Cutscenes');
					// Camera Projectile Going to static position
			
					// Clear Anims
					PlayAnim('',,,,0);
					
					// New Location
					SetLocation(MasterPoint.GetCamLoc(i));
					
					// New Rotation
					SetRotation(MasterPoint.GetCamRot(i));
					
					/*
					log ("Cutscene Camera Debug: Take "$i, 'Cutscenes');
					log ("Cutscene Camera Desired Location = "$MasterPoint.GetCamLoc(i), 'Cutscenes');
					log ("Cutscene Camera Location = "$Location, 'Cutscenes');
					log ("Cutscene Camera Desired Dir = "$vector(MasterPoint.GetCamRot(i)), 'Cutscenes');
					log ("Cutscene Camera Dir = "$vector(Rotation), 'Cutscenes');
					*/
					// Hold for the duration of the shot
					Sleep(MasterPoint.GetCamTime(i));
					
				}
			}
		}

		log("CameraProjectile -- end of a play canned anim cutscene", 'Misc');
		MasterPoint.CompleteCutscene(PlayerPawn(Owner));
		MasterPoint.Teleport(PlayerPawn(Owner));
		// Destroy();
}

defaultproperties
{
     bHidden=True
     Physics=PHYS_None
     LifeSpan=0
     Mesh=SkelMesh'Aeons.Meshes.camera_m'
     bCollideActors=False
     bCollideWorld=False
	 RemoteRole=ROLE_None
}
