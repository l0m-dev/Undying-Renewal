//=============================================================================
// CameraNavigation.
//=============================================================================
class CameraNavigation expands Actor
	abstract;

//#exec TEXTURE IMPORT NAME=CamNav FILE=Textures\CamNav.pcx GROUP=System Mips=On Flags=2
//#exec TEXTURE IMPORT NAME=CamNav_m FILE=Textures\CamNav_m.pcx GROUP=System Mips=On Flags=2

// Camera FOV
var() int 		FOV_Target;				// FOV the camera acquires at this location
// Events
var() name 		Event1;
var() name 		Event2;
var() float 	Event1Time;
var() float 	Event2Time;
// Flags
var() bool 		bEndCutscene;			// end the cutscene when you reach this point
var() bool 		bActive;				// end the cutscene when you reach this point

// Look At
var() name		LookAt;					// tag on an actor to look at.
var() float		LookWeight;				
var() vector	LookAtOffset;			// vector offset to the LookAt Actor's location
// Camera speed
var() float		SpeedModifier;
var() bool 		bCutToNextPoint;		// cut to the next point, rather than interpolate to the next point.

var() bool bHold;
var() float HoldLen;

var() string URL;
var() string URL_PSX2;

var CameraNavigation NextPoint, PrevPoint;

simulated function GetNextPoint(optional bool AutoGen)
{
	local CameraNavigation A, Points[8], NewPoint;
	local int NumPoints;
	local vector Loc;

	if ( NextPoint == none )
	{
		if ( Event != 'None' )
			{
			forEach AllActors(class 'CameraNavigation', A, Event)
			{
				if ( (NumPoints < 8) && (A != self) && A.bActive)
				{
					Points[NumPoints] = A;
					NumPoints ++;
				}
			}
		}
	
		if ( NumPoints > 0 )
		{
			NextPoint = Points[Rand(NumPoints)];
			NextPoint.PrevPoint = self;
		} else {
			if ( AutoGen && bEndCutScene )
			{
				if (PrevPoint == none)
					GetPrevPoint(false);
	
				if (PrevPoint != none)
					Loc = (Location - PrevPoint.Location) + Location;
				else
					Loc =  Location;
	
				NewPoint = spawn(class 'NavCameraPointDynamic',,,Loc);
				NextPoint = NewPoint;
				NewPoint.PrevPoint = self;
			} else {
				NextPoint = none;
			}
		}
	}
}

simulated function GetPrevPoint(optional bool AutoGen)
{
	local CameraNavigation A, Points[8], NewPoint;
	local int NumPoints;
	local vector Loc;

	if ( PrevPoint == none )
	{
		if ( Event != 'None' )
		{
			forEach AllActors(class 'CameraNavigation', A)
			{
				if (A.Event == Tag)
					if ( (NumPoints < 8) && (A != self) && A.bActive )
					{
						Points[NumPoints] = A;
						NumPoints ++;
					}
			}
		}
		
		if (NumPoints > 0)
		{
			PrevPoint = Points[Rand(NumPoints)];
			PrevPoint.NextPoint = self;
		} else {
			if ( AutoGen )
			{
				if ( NextPoint == none )
					GetNextPoint(false);
				if (NextPoint != none)
					Loc = (Location - NextPoint.Location) + Location;
				else
					Loc =  Location;
				NewPoint = spawn(class 'NavCameraPointDynamic',,,Loc);
				PrevPoint = NewPoint;
				NewPoint.NextPoint = self;
			} else {
				PrevPoint =  none;
			}
		}
	}
}

function Teleport(PlayerPawn Player)
{
	local Teleporter Dest;
	local int i;
	local Actor A;	
	local string NewURL;

	if ( GetPlatform() == PLATFORM_PSX2 )
	{
		if ( URL_PSX2 ~= "" )
			NewURL = URL;
		else
			NewURL = URL_PSX2;
	} else {
		NewURL = URL;
	}

	if( (InStr( NewURL, "/" ) >= 0) || (InStr( NewURL, "#" ) >= 0) )
	{
		// Teleport to a level on the net.
		if( (Role == ROLE_Authority) && (Player != None) )
			Level.Game.SendPlayer(Player, NewURL);
	}
}

simulated function Trigger( Actor Other, Pawn EventInstigator )
{
	bActive = !bActive;
}

defaultproperties
{
     LookWeight=1
     SpeedModifier=1
     DrawScale=0.25
     RemoteRole=ROLE_None
     bStatic=False
     bNoDelete=True
}
