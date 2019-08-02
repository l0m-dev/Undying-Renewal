//=============================================================================
// The moving brush class.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Mover extends Brush
	native
	nativereplication;

// How the mover should react when it encroaches an actor.
var() enum EMoverEncroachType
{
	ME_StopWhenEncroach,	// Stop when we hit an actor.
	ME_ReturnWhenEncroach,	// Return to previous position when we hit an actor.
   	ME_CrushWhenEncroach,   // Crush the poor helpless actor.
   	ME_IgnoreWhenEncroach,  // Ignore encroached actors.
} MoverEncroachType;

// How the mover moves from one position to another.
var() enum EMoverGlideType
{
	MV_MoveByTime,			// Move linearly.
	MV_GlideByTime,			// Move with smooth acceleration.
} MoverGlideType;

// What classes can bump trigger this mover
var() enum EBumpType
{
	BT_PlayerBump,		// Can only be bumped by player.
	BT_PawnBump,		// Can be bumped by any pawn
	BT_AnyBump,			// Cany be bumped by any solid actor
} BumpType;

//-----------------------------------------------------------------------------
// Keyframe numbers.
var() savable byte       KeyNum;           // Current or destination keyframe.
var savable byte         PrevKeyNum;       // Previous keyframe.
var() const byte NumKeys;          // Number of keyframes in total (0-3).
var() const byte WorldRaytraceKey; // Raytrace the world with the brush here.
var() const byte BrushRaytraceKey; // Raytrace the brush here.

//-----------------------------------------------------------------------------
// Movement parameters.
var() float      MoveTime;         // Time to spend moving between keyframes.
var() float      StayOpenTime;     // How long to remain open before closing.
var() float      OtherTime;        // TriggerPound stay-open time.
var() int        EncroachDamage;   // How much to damage encroached actors.

//-----------------------------------------------------------------------------
// Mover state.
var() bool       bTriggerOnceOnly; // Go dormant after first trigger.
var() bool       bSlave;           // This brush is a slave.
var() bool		 bUseTriggered;		// Triggered by player grab
var() bool		 bDamageTriggered;	// Triggered by taking damage
var() bool       bDynamicLightMover; // Apply dynamic lighting to mover.
var() bool       bTossPlayer;			// toss the player when you hit him.
var() name       PlayerBumpEvent;  // Optional event to cause when the player bumps the mover.
var() name       BumpEvent;			// Optional event to cause when any valid bumper bumps the mover.
var savable actor	SavedTrigger;      // Who we were triggered by.
var() float		 DamageThreshold;	// minimum damage to trigger
var	  savable int		 numTriggerEvents;	// number of times triggered ( count down to untrigger )
var	  Mover		 Leader;			// for having multiple movers return together
var	  Mover		 Follower;
var() name		 ReturnGroup;		// if none, same as tag
var() float		 DelayTime;			// delay before starting to open
var() bool 		 bLoop;
//-----------------------------------------------------------------------------
// Audio.
var(MoverSounds) sound      OpeningSound;     // When start opening.
var(MoverSounds) SoundProps OpeningProps;

var(MoverSounds) sound      OpenedSound;      // When finished opening.
var(MoverSounds) SoundProps OpenedProps;

var(MoverSounds) sound      ClosingSound;     // When start closing.
var(MoverSounds) SoundProps ClosingProps;

var(MoverSounds) sound      ClosedSound;      // When finish closing.
var(MoverSounds) SoundProps ClosedProps;

var(MoverSounds) sound      MoveAmbientSound; // Optional ambient sound when moving.

//-----------------------------------------------------------------------------
// Internal.
var vector       KeyPos[32];
var rotator      KeyRot[32];
var savable vector		BasePos;
var savable vector		OldPos;
var savable vector		OldPrePivot;
var savable vector		SavedPos;

var savable rotator		BaseRot;
var savable rotator		OldRot;
var savable rotator		SavedRot;

// AI related
var       NavigationPoint  myMarker;
var		  Actor			TriggerActor;
var		  Actor         TriggerActor2;
var	savable Pawn		WaitingPawn;
var	savable	bool		bOpening;
var savable bool		bDelaying;
var			bool		bClientPause;

var		  bool			bPlayerOnly;
var		  Trigger		RecommendedTrigger;

// for client side replication
var		savable vector			SimOldPos;
var		savable int				SimOldRotPitch, SimOldRotYaw, SimOldRotRoll;
var		savable vector			SimInterpolate;
var		savable vector			RealPosition;
var     savable rotator			RealRotation;
var		savable int				ClientUpdate;

replication
{
	// Things the server should send to the client.
	reliable if( Role==ROLE_Authority )
		SimOldPos, SimOldRotPitch, SimOldRotYaw, SimOldRotRoll, SimInterpolate, RealPosition, RealRotation;
}

simulated function Timer()
{
	//log ("Mover "$self.name$" Timer() Location is :"$Location, 'Misc');

	if ( Velocity != vect(0,0,0) )
	{
		bClientPause = false;
		return;		
	}
	if ( Level.NetMode == NM_Client )
	{
		if ( ClientUpdate == 0 ) // not doing a move
		{
			if ( bClientPause )
			{
				if ( VSize(RealPosition - Location) > 3 )
					SetLocation(RealPosition);
				else
					RealPosition = Location;
				SetRotation(RealRotation);
				bClientPause = false;
			}
			else if ( RealPosition != Location )
				bClientPause = true;
		}
		else
			bClientPause = false;
	}
	else 
	{
		RealPosition = Location;
		RealRotation = Rotation;
	}
}
		
function FindTriggerActor()
{
	local Actor A;

	TriggerActor = None;
	TriggerActor2 = None;
	ForEach AllActors(class 'Actor', A)
		if ( (A.Event == Tag) && (A.IsA('Trigger') || A.IsA('Mover')) )
		{
			if ( A.IsA('Counter') || A.IsA('Pawn') )
			{
				bPlayerOnly = true;
				return; //FIXME - handle counters
			}
			if (TriggerActor == None)
				TriggerActor = A;
			else if ( TriggerActor2 == None )
				TriggerActor2 = A;
		}

	if ( TriggerActor == None )
	{
		bPlayerOnly = (BumpType == BT_PlayerBump);
		return;
	}

	bPlayerOnly = ( TriggerActor.IsA('Trigger') && (Trigger(TriggerActor).TriggerType == TT_PlayerProximity) );
	if ( bPlayerOnly && ( TriggerActor2 != None) )
	{
		bPlayerOnly = ( TriggerActor2.IsA('Trigger') && (Trigger(TriggerActor).TriggerType == TT_PlayerProximity) );
		if ( !bPlayerOnly )
		{
			A = TriggerActor;
			TriggerActor = TriggerActor2;
			TriggerActor2 = A;
		}
	}
}

/* set specialgoal/movetarget or special pause if necessary
if mover can't be affected by this pawn, return false
Each mover state should implement the appropriate version
*/
function bool HandleDoor(pawn Other)
{
	return false;
}

function bool HandleTriggerDoor(pawn Other)
{
	local bool bOne, bTwo;
	local float DP1, DP2, Dist1, Dist2;

	if ( bOpening || bDelaying )
	{
		WaitingPawn = Other;
		Other.SpecialPause = 2.5;
		return true;
	}
	if ( bPlayerOnly && !Other.bIsPlayer )
		return false;
	if ( bUseTriggered )
	{
		WaitingPawn = Other;
		Other.SpecialPause = 2.5;
		Trigger(Other, Other);
		return true;
	}
	if ( (BumpEvent == tag) || (Other.bIsPlayer && (PlayerBumpEvent == tag)) )
	{
		WaitingPawn = Other;
		Other.SpecialPause = 2.5;
		if ( Other.Base == Self )
			Trigger(Other, Other);
		return true;
	}
	if ( bDamageTriggered )
	{
		WaitingPawn = Other;
		Other.SpecialGoal = self;
		if ( !Other.bCanDoSpecial || (Other.Weapon == None) )
			return false;

		Other.Target = self;
		Other.bShootSpecial = true;
		Other.FireWeapon();
		Trigger(Self, Other);
		Other.bFire = 0;
		return true;
	}

	if ( RecommendedTrigger != None )
	{
		Other.SpecialGoal = RecommendedTrigger;
		Other.MoveTarget = RecommendedTrigger;
		return True;
	}

	bOne = ( (TriggerActor != None) 
			&& (!TriggerActor.IsA('Trigger') || Trigger(TriggerActor).IsRelevant(Other)) );
	bTwo = ( (TriggerActor2 != None) 
			&& (!TriggerActor2.IsA('Trigger') || Trigger(TriggerActor2).IsRelevant(Other)) );
	
	if ( bOne && bTwo )
	{
		// Dotp, dist
		Dist1 = VSize(TriggerActor.Location - Other.Location);
		Dist2 = VSize(TriggerActor2.Location - Other.Location);
		if ( Dist1 < Dist2 )
		{
			if ( (Dist1 < 500) && Other.ActorReachable(TriggerActor) )
				bTwo = false;
		}
		else if ( (Dist2 < 500) && Other.ActorReachable(TriggerActor2) )
			bOne = false;
		
		if ( bOne && bTwo )
		{
			DP1 = Normal(Location - Other.Location) Dot (TriggerActor.Location - Other.Location)/Dist1;
			DP2 = Normal(Location - Other.Location) Dot (TriggerActor2.Location - Other.Location)/Dist2;
			if ( (DP1 > 0) && (DP2 < 0) )
				bOne = false;
			else if ( (DP1 < 0) && (DP2 > 0) )
				bTwo = false;
			else if ( Dist1 < Dist2 )
				bTwo = false;
			else 
				bOne = false;
		}
	}

	if ( bOne )
	{
		Other.SpecialGoal = TriggerActor;
		Other.MoveTarget = TriggerActor;
		return True;
	}
	else if ( bTwo )
	{
		Other.SpecialGoal = TriggerActor2;
		Other.MoveTarget = TriggerActor2;
		return True;
	}
	return false;
}

function Actor SpecialHandling(Pawn Other)
{
	if ( bDamageTriggered )	
	{
		if ( !Other.bCanDoSpecial || (Other.Weapon == None) )
			return None;

		Other.Target = self;
		Other.bShootSpecial = true;
		Other.FireWeapon();
		Other.bFire = 0;
		return self;
	}

	if ( BumpType == BT_PlayerBump && !Other.bIsPlayer )
		return None;

	return self;
}

//-----------------------------------------------------------------------------
// Movement functions.

// Interpolate to keyframe KeyNum in Seconds time.
final function InterpolateTo( byte NewKeyNum, float Seconds )
{
	//log ("Mover "$self.name$" InterpolateTo ...."$NewKeyNum, 'Misc' );
	//LogStack('Misc');
	// NewKeyNum = Clamp( NewKeyNum, 0, ArrayCount(KeyPos)-1 );
	if( NewKeyNum==PrevKeyNum && KeyNum!=PrevKeyNum )
	{
		// Reverse the movement smoothly.
		PhysAlpha = 1.0 - PhysAlpha;
		OldPos    = BasePos + KeyPos[KeyNum];
		OldRot    = BaseRot + KeyRot[KeyNum];
	}
	else
	{
		// Start a new movement.
		OldPos    = Location;
		OldRot    = Rotation;
		PhysAlpha = 0.0;
	}

	// Setup physics.
	SetPhysics(PHYS_MovingBrush);
	bInterpolating   = true;
	PrevKeyNum       = KeyNum;
	KeyNum			 = NewKeyNum;
	PhysRate         = 1.0 / FMax(Seconds, 0.005);

	ClientUpdate++;
	SimOldPos = OldPos;
	SimOldRotYaw = OldRot.Yaw;
	SimOldRotPitch = OldRot.Pitch;
	SimOldRotRoll = OldRot.Roll;
	SimInterpolate.X = 100 * PhysAlpha;
	SimInterpolate.Y = 100 * FMax(0.01, PhysRate);
	SimInterpolate.Z = 256 * PrevKeyNum + KeyNum;
}

// Set the specified keyframe.
final function SetKeyframe( byte NewKeyNum, vector NewLocation, rotator NewRotation )
{
	KeyNum         = Clamp( NewKeyNum, 0, ArrayCount(KeyPos)-1 );
	KeyPos[KeyNum] = NewLocation;
	KeyRot[KeyNum] = NewRotation;
}

// Interpolation ended.
function InterpolateEnd( actor Other )
{
	local byte OldKeyNum;

	OldKeyNum  = PrevKeyNum;
	PrevKeyNum = KeyNum;
	PhysAlpha  = 0;
	ClientUpdate--;

	// If more than two keyframes, chain them.
	if( KeyNum>0 && KeyNum<OldKeyNum )
	{
		// Chain to previous.
		InterpolateTo(KeyNum-1,MoveTime);
	}
	else if( KeyNum<NumKeys-1 && KeyNum>OldKeyNum )
	{
		// Chain to next.
		InterpolateTo(KeyNum+1,MoveTime);
	}
	else
	{
		if ( bLoop )
		{
			KeyNum = 0;
			OldKeyNum  = PrevKeyNum;
			PrevKeyNum = KeyNum;
			SetLocation(BasePos + KeyPos[KeyNum]);
			SetRotation(BaseRot + KeyRot[KeyNum]);
			InterpolateTo(KeyNum+1,MoveTime);
		} else {
			// Finished interpolating.
			AmbientSound = None;
			if ( (ClientUpdate == 0) && (Level.NetMode != NM_Client) )
			{
				RealPosition = Location;
				RealRotation = Rotation;
			}
		}
	}
}

//-----------------------------------------------------------------------------
// Mover functions.

// Notify AI that mover finished movement
function FinishNotify()
{
	local Pawn P;

	if ( StandingCount > 0 )
		for ( P=Level.PawnList; P!=None; P=P.nextPawn )
			if ( P.Base == self )
			{
				P.StopWaiting();
				if ( (P.SpecialGoal == self) || (P.SpecialGoal == myMarker) )
					P.SpecialGoal = None; 
				if ( P == WaitingPawn )
					WaitingPawn = None;
			}

	if ( WaitingPawn != None )
	{
		WaitingPawn.StopWaiting();
		if ( (WaitingPawn.SpecialGoal == self) || (WaitingPawn.SpecialGoal == myMarker) )
			WaitingPawn.SpecialGoal = None; 
		WaitingPawn = None;
	}
}

// Handle when the mover finishes closing.
function FinishedClosing()
{
	// Update sound effects.
	PlaySound( ClosedSound, SLOT_None, ClosedProps.Volume,,ClosedProps.Radius, ClosedProps.Pitch);

	// Notify our triggering actor that we have completed.
	if( SavedTrigger != None )
		SavedTrigger.EndEvent();
	SavedTrigger = None;
	Instigator = None;
	FinishNotify(); 
}

// Handle when the mover finishes opening.
function FinishedOpening()
{
	local actor A;
	local Actor Other;

	// Update sound effects.
	PlaySound( OpenedSound, SLOT_None, OpenedProps.Volume,,OpenedProps.Radius, OpenedProps.Pitch);
	
	// Trigger any chained movers.
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
		{
			if ( A.IsA('Trigger') )
			{
				// handle Pass Thru message
				if ( Trigger(A).bPassThru )
				{
					Trigger(A).PassThru(Other);
				}
			}
			A.Trigger( Self, Instigator );
		}

	FinishNotify();
}

// Open the mover.
function DoOpen()
{
	bOpening = true;
	bDelaying = false;
	InterpolateTo( 1, MoveTime );
	PlaySound( OpeningSound, SLOT_None,OpeningProps.Volume,,OpeningProps.Radius, OpeningProps.Pitch);
	AmbientSound = MoveAmbientSound;
}

// Close the mover.
function DoClose()
{
	local actor A;

	bOpening = false;
	bDelaying = false;
	InterpolateTo( Max(0,KeyNum-1), MoveTime );
	PlaySound( ClosingSound, SLOT_None,ClosingProps.Volume,,ClosingProps.Radius, ClosingProps.Pitch);
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.UnTrigger( Self, Instigator );
	AmbientSound = MoveAmbientSound;
}

//-----------------------------------------------------------------------------
// Engine notifications.

/*
function PostLoadGame()
{

	//log(" *** Mover"$self.name$" PostLoadGame()  *** ", 'Misc');

	// Init key info.
	KeyNum         = Clamp( KeyNum, 0, ArrayCount(KeyPos)-1 );
	PhysAlpha      = 0.0;

	//log(" KeyNum =  "$KeyNum, 'Misc');
	// Set initial location.
	// Move( BasePos + KeyPos[KeyNum] - Location );
	//log ("Set location to : "$(BasePos + KeyPos[KeyNum]), 'Misc');
	SetLocation( BasePos + KeyPos[KeyNum] );
	//log ("Location is     : "$Location, 'Misc');
	// Initial rotation.
	SetRotation( BaseRot + KeyRot[KeyNum] );
	// InterpolateTo(KeyNum,0.01);
	// bInterpolating=false;
	RealPosition = Location;
	RealRotation = Rotation;
}
*/

// When mover enters gameplay.
simulated function BeginPlay()
{
	local rotator R;
	
	//log("Mover BeginPlay() "$self.name, 'Misc');

	// timer updates real position every second in network play
	if ( Level.NetMode != NM_Standalone )
	{
		if ( Level.NetMode == NM_Client )
			settimer(4.0, true);
		else
			settimer(1.0, true);
		if ( Role < ROLE_Authority )
			return;
	}

	if ( Level.NetMode != NM_Client )
	{
		RealPosition = Location;
		RealRotation = Rotation;
	}

	// Init key info.
	Super.BeginPlay();
	KeyNum         = Clamp( KeyNum, 0, ArrayCount(KeyPos)-1 );
	PhysAlpha      = 0.0;

	// Set initial location.
	Move( BasePos + KeyPos[KeyNum] - Location );

	// Initial rotation.
	SetRotation( BaseRot + KeyRot[KeyNum] );

	// find movers in same group
	if ( ReturnGroup == '' )
		ReturnGroup = tag;
}

// Immediately after mover enters gameplay.
function PostBeginPlay()
{
	local mover M;

	//log("Mover PostBeginPlay() "$self.name, 'Misc');
	//brushes can't be deleted, so if not relevant, make it invisible and non-colliding
	if ( !Level.Game.IsRelevant(self) )
	{
		SetCollision(false, false, false);
		SetLocation(Location + vect(0,0,20000)); // temp since still in bsp
		bHidden = true;
	}
	else
	{
		FindTriggerActor();
		// Initialize all slaves.
		if( !bSlave )
		{
			foreach AllActors( class 'Mover', M, Tag )
			{
				if( M.bSlave )
				{
					M.GotoState('');
					M.SetBase( Self );
				}
			}
		}
		if ( Leader == None )
		{	
			Leader = self;
			ForEach AllActors( class'Mover', M )
				if ( (M != self) && (M.ReturnGroup == ReturnGroup) )
				{
					M.Leader = self;
					M.Follower = Follower;
					Follower = M;
				}
		}
	}
}

function MakeGroupStop()
{
	// Stop moving immediately.
	bInterpolating = false;
	AmbientSound = None;
	GotoState( , '' );

	if ( Follower != None )
		Follower.MakeGroupStop();
}

function MakeGroupReturn()
{
	//log ("Mover MakeGroupReturn() .... ", 'Misc');
	// Abort move and reverse course.
	bInterpolating = false;
	AmbientSound = None;
	if( KeyNum<PrevKeyNum )
		GotoState( , 'Open' );
	else
		GotoState( , 'Close' );

	if ( Follower != None )
		Follower.MakeGroupReturn();
}
		
// Return true to abort, false to continue.
function bool EncroachingOn( actor Other )
{
	local Pawn P;
	local DamageInfo DInfo;
	
	DInfo.Damage = EncroachDamage;
	DInfo.DamageType = 'Crushed';
	DInfo.DamageMultiplier = 1.0;

	if ( Other.IsA('Carcass') || Other.IsA('Decoration') )
	{
		if ( Other.AcceptDamage(DInfo) )
			Other.TakeDamage( None, Other.Location, vect(0,0,0), DInfo );
		return false;
	}
	if ( Other.IsA('Fragment')) // || (Other.IsA('Inventory') && (Other.Owner == None)) )
	{
		Other.Destroy();
		return false;
	}

	DInfo.Damage = EncroachDamage;

	// Damage the encroached actor.
	if( EncroachDamage > 0 )
	{
		if ( Other.AcceptDamage(DInfo) )
			Other.TakeDamage( Instigator, Other.Location, vect(0,0,0), DInfo );
	}

	// If we have a bump-player event, and Other is a pawn, do the bump thing.
	P = Pawn(Other);
	if( P!=None && P.bIsPlayer )
	{
		if ( PlayerBumpEvent!='' )
			Bump( Other );
		if ( (MyMarker != None) && (P.Base != self) 
			&& (P.Location.Z < MyMarker.Location.Z - P.CollisionHeight - 0.7 * MyMarker.CollisionHeight) )
			// pawn is under lift - tell him to move
			P.UnderLift(self);
	}

	// Stop, return, or whatever.
	if( MoverEncroachType == ME_StopWhenEncroach ) {
		Leader.MakeGroupStop();
		return true;
	} else if( MoverEncroachType == ME_ReturnWhenEncroach ) {
		Leader.MakeGroupReturn();
		if ( Other.IsA('Pawn') )
		{
			if ( Pawn(Other).bIsPlayer )
			{
				// Pawn(Other).PlaySound(Pawn(Other).Land, SLOT_Talk);
			} else
				Pawn(Other).PlaySound(Pawn(Other).HitSound1, SLOT_Talk);
		}	
		return true;
	} else if( MoverEncroachType == ME_CrushWhenEncroach ) {
		// Kill it.
		Other.KilledBy( Instigator );
		return false;
	} else if( MoverEncroachType == ME_IgnoreWhenEncroach ) {
		// Ignore it.
		return false;
	}
}

// When bumped by player.
function Bump( actor Other )
{
	local actor A;
	local pawn  P;

	P = Pawn(Other);
	if ( (BumpType != BT_AnyBump) && (P == None) )
		return;
	if ( (BumpType == BT_PlayerBump) && !P.bIsPlayer )
		return;
	if ( (BumpType == BT_PawnBump) && (Other.Mass < 10) )
		return;
	if( BumpEvent!='' )
		foreach AllActors( class 'Actor', A, BumpEvent )
		{
			if ( A.IsA('Trigger') )
			{
				// handle Pass Thru message
				if ( Trigger(A).bPassThru )
				{
					Trigger(A).PassThru(Other);
				}
			}
			A.Trigger( Self, P );
		}

	if ( P != None )
	{
		if( P.bIsPlayer && (PlayerBumpEvent!='') )
				foreach AllActors( class 'Actor', A, PlayerBumpEvent )
				{
					if ( A.IsA('Trigger') )
					{
						// handle Pass Thru message
						if ( Trigger(A).bPassThru )
						{
							Trigger(A).PassThru(Other);
						}
					}
					A.Trigger( Self, P );
				}

		if ( P.SpecialGoal == self )
			P.SpecialGoal = None;
	}
}

// When damaged
function TakeDamage( Pawn instigatedBy, Vector hitlocation, Vector momentum, DamageInfo DInfo)
{
	if ( bDamageTriggered && (DInfo.Damage >= DamageThreshold) )
		self.Trigger(self, instigatedBy);
}

//-----------------------------------------------------------------------------
// Trigger states.

// When triggered, open, wait, then close.
state() TriggerOpenTimed
{
	function bool HandleDoor(pawn Other)
	{
		return HandleTriggerDoor(Other);
	}

	function Trigger( actor Other, pawn EventInstigator )
	{
		SavedTrigger = Other;
		Instigator = EventInstigator;
		if ( SavedTrigger != None )
			SavedTrigger.BeginEvent();
		GotoState( 'TriggerOpenTimed', 'Open' );
	}

	function BeginState()
	{
		bOpening = false;
	}

Open:
	Disable( 'Trigger' );
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	Sleep( StayOpenTime );
	if( bTriggerOnceOnly )
		GotoState('');
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable( 'Trigger' );
}

// Toggle when triggered.
state() TriggerToggle
{
	function bool HandleDoor(pawn Other)
	{
		return HandleTriggerDoor(Other);
	}
	
	function Trigger( actor Other, pawn EventInstigator )
	{
		//log("Mover in TriggerToggle state being triggered "$Other, 'Misc');
		SavedTrigger = Other;
		Instigator = EventInstigator;
		if ( SavedTrigger != None )
			SavedTrigger.BeginEvent();
		if( KeyNum==0 || KeyNum<PrevKeyNum )
			GotoState( 'TriggerToggle', 'Open' );
		else
			GotoState( 'TriggerToggle', 'Close' );
	}
Open:
	//log("Mover in TriggerToggle state OPEN TAG ", 'Misc');
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	if ( SavedTrigger != None )
		SavedTrigger.EndEvent();
	Stop;
Close:		
	//log("Mover in TriggerToggle state CLOSE TAG ", 'Misc');
	DoClose();
	FinishInterpolation();
	FinishedClosing();
}

// Open when triggered, close when get untriggered.
state() TriggerControl
{
	function bool HandleDoor(pawn Other)
	{
		return HandleTriggerDoor(Other);
	}

	function Trigger( actor Other, pawn EventInstigator )
	{
		numTriggerEvents++;
		SavedTrigger = Other;
		Instigator = EventInstigator;
		if ( SavedTrigger != None )
			SavedTrigger.BeginEvent();
		GotoState( 'TriggerControl', 'Open' );
	}
	function UnTrigger( actor Other, pawn EventInstigator )
	{
		numTriggerEvents--;
		if ( numTriggerEvents <=0 )
		{
			numTriggerEvents = 0;
			SavedTrigger = Other;
			Instigator = EventInstigator;
			SavedTrigger.BeginEvent();
			GotoState( 'TriggerControl', 'Close' );
		}
	}

	function BeginState()
	{
		numTriggerEvents = 0;
	}

Open:
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	SavedTrigger.EndEvent();
	if( bTriggerOnceOnly )
		GotoState('');
	Stop;
Close:		
	DoClose();
	FinishInterpolation();
	FinishedClosing();
}

// Start pounding when triggered.
state() TriggerPound
{
	function bool HandleDoor(pawn Other)
	{
		return HandleTriggerDoor(Other);
	}

	function Trigger( actor Other, pawn EventInstigator )
	{
		numTriggerEvents++;
		SavedTrigger = Other;
		Instigator = EventInstigator;
		GotoState( 'TriggerPound', 'Open' );
	}
	function UnTrigger( actor Other, pawn EventInstigator )
	{
		numTriggerEvents--;
		if ( numTriggerEvents <= 0 )
		{
			numTriggerEvents = 0;
			SavedTrigger = None;
			Instigator = None;
			GotoState( 'TriggerPound', 'Close' );
		}
	}
	function BeginState()
	{
		numTriggerEvents = 0;
	}

Open:
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	Sleep(OtherTime);
Close:
	DoClose();
	FinishInterpolation();
	Sleep(StayOpenTime);
	if( bTriggerOnceOnly )
		GotoState('');
	if( SavedTrigger != None )
		goto 'Open';
}

//-----------------------------------------------------------------------------
// Bump states.

// Open when bumped, wait, then close.
state() BumpControl
{
	function bool HandleDoor(pawn Other)
	{
		if ( (BumpType == BT_PlayerBump) && !Other.bIsPlayer )
			return false;

		Bump(Other);
		WaitingPawn = Other;
		Other.SpecialPause = 2.5;
		return true;
	}

	function UnTrigger( actor Other, pawn EventInstigator )
	{
		numTriggerEvents--;
		if ( numTriggerEvents <=0 )
		{
			numTriggerEvents = 0;
			SavedTrigger = Other;
			Instigator = EventInstigator;
			SavedTrigger.BeginEvent();
			GotoState( 'BumpControl', 'Close' );
		}
	}

	function Bump( actor Other )
	{
		if ( (BumpType != BT_AnyBump) && (Pawn(Other) == None) )
			return;
		if ( (BumpType == BT_PlayerBump) && !Pawn(Other).bIsPlayer )
			return;
		if ( (BumpType == BT_PawnBump) && (Other.Mass < 10) )
			return;
		Global.Bump( Other );
		SavedTrigger = None;
		Instigator = Pawn(Other);
		GotoState( 'BumpControl', 'Open' );
	}
Open:
	Disable( 'Bump' );
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	if( bTriggerOnceOnly )
		GotoState('');
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable( 'Bump' );
}

// Open when bumped, wait, then close.
state() BumpOpenTimed
{
	function bool HandleDoor(pawn Other)
	{
		if ( (BumpType == BT_PlayerBump) && !Other.bIsPlayer )
			return false;

		Bump(Other);
		WaitingPawn = Other;
		Other.SpecialPause = 2.5;
		return true;
	}

	function Bump( actor Other )
	{
		if ( (BumpType != BT_AnyBump) && (Pawn(Other) == None) )
			return;
		if ( (BumpType == BT_PlayerBump) && !Pawn(Other).bIsPlayer )
			return;
		if ( (BumpType == BT_PawnBump) && (Other.Mass < 10) )
			return;
		Global.Bump( Other );
		SavedTrigger = None;
		Instigator = Pawn(Other);
		GotoState( 'BumpOpenTimed', 'Open' );
	}
Open:
	Disable( 'Bump' );
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	Sleep( StayOpenTime );
	if( bTriggerOnceOnly )
		GotoState('');
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable( 'Bump' );
}

// Open when bumped, close when reset.
state() BumpButton
{
	function bool HandleDoor(pawn Other)
	{
		if ( (BumpType == BT_PlayerBump) && !Other.bIsPlayer )
			return false;

		Bump(Other);
		return false; //let pawn try to move around this button
	}

	function Bump( actor Other )
	{
		if ( (BumpType != BT_AnyBump) && (Pawn(Other) == None) )
			return;
		if ( (BumpType == BT_PlayerBump) && !Pawn(Other).bIsPlayer )
			return;
		if ( (BumpType == BT_PawnBump) && (Other.Mass < 10) )
			return;
		Global.Bump( Other );
		SavedTrigger = Other;
		Instigator = Pawn( Other );
		GotoState( 'BumpButton', 'Open' );
	}
	function BeginEvent()
	{
		bSlave=true;
	}
	function EndEvent()
	{
		bSlave     = false;
		Instigator = None;
		GotoState( 'BumpButton', 'Close' );
	}
Open:
	Disable( 'Bump' );
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	if( bTriggerOnceOnly )
		GotoState('');
	if( bSlave )
		Stop;
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable( 'Bump' );
}

// Open when bumped, wait, then close.
state() BumpToggle
{
	function bool HandleDoor(pawn Other)
	{
		if ( (BumpType == BT_PlayerBump) && !Other.bIsPlayer )
			return false;

		Bump(Other);
		WaitingPawn = Other;
		Other.SpecialPause = 2.5;
		return true;
	}

	function Bump( actor Other )
	{
		if ( (BumpType != BT_AnyBump) && (Pawn(Other) == None) )
			return;
		if ( (BumpType == BT_PlayerBump) && !Pawn(Other).bIsPlayer )
			return;
		if ( (BumpType == BT_PawnBump) && (Other.Mass < 10) )
			return;
		Global.Bump( Other );
		SavedTrigger = None;
		Instigator = Pawn(Other);

		if( KeyNum==0 || KeyNum<PrevKeyNum )
			GotoState( 'BumpOpenTimed', 'Open' );
		else
			GotoState( 'BumpOpenTimed', 'Close' );
	}

Open:
	Disable( 'Bump' );
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	Sleep( StayOpenTime );
	if( bTriggerOnceOnly )
		GotoState('');
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable( 'Bump' );
}


//-----------------------------------------------------------------------------
// Stand states.

// Open when stood on, wait, then close.
state() StandOpenTimed
{
	function bool HandleDoor(pawn Other)
	{
		if ( bPlayerOnly && !Other.bIsPlayer )
			return false;
		Other.SpecialPause = 2.5;
		WaitingPawn = Other;
		if ( Other.Base == self )
			Attach(Other);
		return true;
	}

	function Attach( actor Other )
	{
		local pawn  P;

		P = Pawn(Other);
		if ( (BumpType != BT_AnyBump) && (P == None) )
			return;
		if ( (BumpType == BT_PlayerBump) && !P.bIsPlayer )
			return;
		if ( (BumpType == BT_PawnBump) && (Other.Mass < 10) )
			return;
		SavedTrigger = None;
		GotoState( 'StandOpenTimed', 'Open' );
	}
Open:
	Disable( 'Attach' );
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	Sleep( StayOpenTime );
	if( bTriggerOnceOnly )
		GotoState('');
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable( 'Attach' );
}

defaultproperties
{
     MoverEncroachType=ME_ReturnWhenEncroach
     MoverGlideType=MV_GlideByTime
     NumKeys=2
     MoveTime=1
     StayOpenTime=4
     OpeningProps=(Volume=1,Pitch=1,Radius=1024,PitchDelta=0.2,VolumeDelta=0.2)
     OpenedProps=(Volume=1,Pitch=1,Radius=1024,PitchDelta=0.2,VolumeDelta=0.2)
     ClosingProps=(Volume=1,Pitch=1,Radius=1024,PitchDelta=0.2,VolumeDelta=0.2)
     ClosedProps=(Volume=1,Pitch=1,Radius=1024,PitchDelta=0.2,VolumeDelta=0.2)
     bStatic=False
     bIsMover=True
     bAlwaysRelevant=True
     Physics=PHYS_MovingBrush
     RemoteRole=ROLE_SimulatedProxy
     InitialState=BumpOpenTimed
     bSavable=True
     SoundVolume=228
     TransientSoundVolume=3
     CollisionRadius=160
     CollisionHeight=160
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
     NetPriority=2.7
}
