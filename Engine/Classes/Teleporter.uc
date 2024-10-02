///=============================================================================
// Teleports actors either between different teleporters within a level
// or to matching teleporters on other levels, or to general Internet URLs.
//=============================================================================
class Teleporter extends NavigationPoint
	native;

//#exec Texture Import File=Textures\Teleport.pcx Name=S_Teleport Mips=On Flags=2

//-----------------------------------------------------------------------------
// Teleporter URL can be one of the following forms:
//
// TeleporterName
//		Teleports to a named teleporter in this level.
//		if none, acts only as a teleporter destination
//
// LevelName/TeleporterName
//     Teleports to a different level on this server.
//
// Unreal://Server.domain.com/LevelName/TeleporterName
//     Teleports to a different server on the net.
//
var() string URL;
var() string URL_PSX2;

//-----------------------------------------------------------------------------
// Product the user must have installed in order to enter the teleporter.
var() name ProductRequired;

//-----------------------------------------------------------------------------
// Teleporter destination flags.
var() bool    bChangesVelocity; // Set velocity to TargetVelocity.
var() bool    bChangesYaw;      // Sets yaw to teleporter's Rotation.Yaw
var() bool    bReversesX;       // Reverses X-component of velocity.
var() bool    bReversesY;       // Reverses Y-component of velocity.
var() bool    bReversesZ;       // Reverses Z-component of velocity.

// Teleporter flags
var() bool	  bEnabled;			// Teleporter is turned on;
var() bool	  bForcePlayerTouch; // force a player touch() event on trigger

// Transition screen flags
var() bool		bUseTransitionScreen;
var() string	TransitionScreenName[6];
var() sound		EntrySound;
var() sound		ExitSound;

//-----------------------------------------------------------------------------
// Teleporter destination directions.
var() vector  TargetVelocity;   // If bChangesVelocity, set target's velocity to this.

// AI related
var Actor TriggerActor;		//used to tell AI how to trigger me
var Actor TriggerActor2;

var float LastFired;

//-----------------------------------------------------------------------------
// Teleporter destination functions.

replication
{
	reliable if( Role==ROLE_Authority )
		bEnabled, URL;
	reliable if ( bNetInitial && (Role == ROLE_Authority) )
		bChangesVelocity, bChangesYaw, bReversesX, bReversesY, bReversesZ, TargetVelocity; 
}

function PostBeginPlay()
{
	if (URL ~= "")
		SetCollision(false, false, false); //destination only
		
	if ( !bEnabled )
		FindTriggerActor();
	Super.PostBeginPlay();
	
	if (TransitionScreenName[0] ~= "UndyingShellPC.Main_Back_0")
		bUseTransitionScreen = false;
}

function FindTriggerActor()
{
	local Actor A;

	TriggerActor = None;
	TriggerActor2 = None;
	ForEach AllActors(class 'Actor', A)
		if ( A.Event == Tag)
		{
			if ( Counter(A) != None )
				return; //FIXME - handle counters
			if (TriggerActor == None)
				TriggerActor = A;
			else
			{
				TriggerActor2 = A;
				return;
			}
		}
}

// Accept an actor that has teleported in.
simulated function bool Accept( actor Incoming, Actor Source )
{
	local rotator newRot, oldRot;
	local int oldYaw;
	local float mag;
	local vector oldDir;
	local pawn P;
	local Actor A;

	// Move the actor here.
	Disable('Touch');
	//log("Move Actor here "$tag);
	newRot = Incoming.Rotation;
	if (bChangesYaw)
	{
		oldRot = Incoming.Rotation;
		newRot.Yaw = Rotation.Yaw;
		if ( Source != None )
			newRot.Yaw += (32768 + Incoming.Rotation.Yaw - Source.Rotation.Yaw);
	}

	if ( Pawn(Incoming) != None )
	{
		//tell enemies about teleport
		if ( Role == ROLE_Authority )
		{
			P = Level.PawnList;
			While ( P != None )
			{
				if (P.Enemy == Incoming)
					P.LastSeenPos = Incoming.Location; 
				P = P.nextPawn;
			}
		}
		Pawn(Incoming).SetLocation(Location);
		if ( (Role == ROLE_Authority) 
			|| (Level.TimeSeconds - LastFired > 0.5) )
		{
			Pawn(Incoming).SetRotation(newRot);
			Pawn(Incoming).ViewRotation = newRot;
			LastFired = Level.TimeSeconds;
		}
		Pawn(Incoming).MoveTimer = -1.0;
		Pawn(Incoming).MoveTarget = self;
		PlayTeleportEffect( Incoming, false);

		if ( ExitSound != none )
			Pawn(Incoming).PlaySound(ExitSound);
	}
	else
	{
		if ( !Incoming.SetLocation(Location) )
		{
			Enable('Touch');
			return false;
		}
		if ( bChangesYaw )
			Incoming.SetRotation(newRot);
	}

	Enable('Touch');

	
	if (bChangesVelocity)
		Incoming.Velocity = TargetVelocity;
	else
	{
		if ( bChangesYaw )
		{
			if ( Incoming.Physics == PHYS_Walking )
				OldRot.Pitch = 0;
			oldDir = vector(OldRot);
			mag = Incoming.Velocity Dot oldDir;		
			Incoming.Velocity = Incoming.Velocity - mag * oldDir + mag * vector(Incoming.Rotation);
		} 
		if ( bReversesX )
			Incoming.Velocity.X *= -1.0;
		if ( bReversesY )
			Incoming.Velocity.Y *= -1.0;
		if ( bReversesZ )
			Incoming.Velocity.Z *= -1.0;
	}	

	// Play teleport-in effect.

	if (Event != 'none')
	{
		ForEach AllActors (class 'Actor', A, Event)
		{	
			if ( A.IsA('Trigger') )
			{
				if ( Trigger(A).bPassThru )
					Trigger(A).PassThru(P);
			}
			A.Trigger(none, P);
		}
	}
	return true;
}
	
function PlayTeleportEffect(actor Incoming, bool bOut)
{
	if ( Incoming.IsA('Pawn') )
	{
		Incoming.MakeNoise(1.0);
		Level.Game.PlayTeleportEffect(Incoming, bOut, true);
	}
}

//-----------------------------------------------------------------------------
// Teleporter functions.

function Trigger( actor Other, pawn EventInstigator )
{
	local int i;
	local PlayerPawn P;

	if ( bForcePlayerTouch )
	{
		// force a player touch when triggered
		ForEach AllActors(class 'PlayerPawn', P)
		{
			break;
		}

		if (P != none)
			Touch(P);
	} else {
	
		bEnabled = !bEnabled;
		if ( bEnabled ) //teleport any pawns already in my radius
			for (i=0;i<8;i++)
				if ( Touching[i] != None )
					Touch(Touching[i]);
	}
}

// Teleporter was touched by an actor.
simulated function Touch( actor Other )
{
	local Teleporter Dest;
	local int i;
	local Actor A;
	local PlayerPawn Player;
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

	if ( !bEnabled )
	{
		//log ("Touch() called, but bEnabled is false", 'Misc');
		return;
	}

	if( Other.bCanTeleport && Other.PreTeleport(Self)==false )
	{
		if( (InStr( NewURL, "/" ) >= 0) || (InStr( NewURL, "#" ) >= 0) )
		{
			// Teleport to a level on the net.
			if( (Role == ROLE_Authority) && (PlayerPawn(Other) != None) )
			{
				Player = PlayerPawn(Other);
				// don't teleport a dead player!
				if (Player.Health <= 0)
					return;

				if( Player.Player.Console != none )
				{
					// needs replication
					Player.Player.Console.bUseTransitionScreen = bUseTransitionScreen;
					for(i = 0; i < 6; ++i )
					{
						Player.Player.Console.TransitionScreenName[i] = TransitionScreenName[i];
					}
				}
				
				// play the sound of teleporting
				if ( EntrySound != none )
					Player.PlaySound(EntrySound);
				
				Level.Game.SendPlayer(PlayerPawn(Other), NewURL);
			}
		}
		else
		{
			// Teleport to a random teleporter in this local level, if more than one pick random.

			foreach AllActors( class 'Teleporter', Dest )
				if( string(Dest.tag)~=NewURL && Dest!=Self )
					i++;
			i = rand(i);
			foreach AllActors( class 'Teleporter', Dest )
				if( string(Dest.tag)~=NewURL && Dest!=Self && i-- == 0 )
					break;
			if( Dest != None )
			{
				// Teleport the actor into the other teleporter.
				if ( Other.IsA('Pawn') )
					PlayTeleportEffect( Pawn(Other), false);
				Dest.Accept( Other, self );
				if( (Event != '') && (Other.IsA('Pawn')) )
					foreach AllActors( class 'Actor', A, Event )
						A.Trigger( Other, Other.Instigator );
			}
			else if ( Role == ROLE_Authority )
				Pawn(Other).ClientMessage( "Teleport destination for "$self$" not found!" );
		}
	}
}

/* SpecialHandling is called by the navigation code when the next path has been found.  
It gives that path an opportunity to modify the result based on any special considerations
*/

function Actor SpecialHandling(Pawn Other)
{
	local int i;
	local vector Dist2D;
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

	if ( bEnabled && (Other.RouteCache[1] != None)
		&& Other.RouteCache[1].IsA('Teleporter') && (string(Other.RouteCache[1].tag)~=NewURL) )
	{
		if ( Abs(Location.Z - Other.Location.Z) < CollisionHeight + Other.CollisionHeight )
		{
			Dist2D = Location - Other.Location;
			Dist2D.Z = 0;
			if ( VSize(Dist2D) < CollisionRadius + Other.CollisionRadius )
				Touch(Other);
		}	
		return self;
	}

	if (TriggerActor == None)
	{
		FindTriggerActor();
		if (TriggerActor == None)
			return None;
	}

	if ( (TriggerActor2 != None) 
		&& (VSize(TriggerActor2.Location - Other.Location) < VSize(TriggerActor.Location - Other.Location)) )
		return TriggerActor2;
					
	return TriggerActor;			
}	
	

defaultproperties
{
     bChangesYaw=True
     bEnabled=True
     bUseTransitionScreen=True
     TransitionScreenName(0)="UndyingShellPC.Main_Back_0"
     TransitionScreenName(1)="UndyingShellPC.Main_Back_1"
     TransitionScreenName(2)="UndyingShellPC.Main_Back_2"
     TransitionScreenName(3)="UndyingShellPC.Main_Back_3"
     TransitionScreenName(4)="UndyingShellPC.Main_Back_4"
     TransitionScreenName(5)="UndyingShellPC.Main_Back_5"
     RemoteRole=ROLE_SimulatedProxy
     bDirectional=True
     Texture=Texture'Engine.S_Teleport'
     SoundVolume=128
     CollisionRadius=18
     CollisionHeight=40
     bCollideActors=True
}
