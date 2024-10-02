//=============================================================================
// UndMover.
//=============================================================================
class UndMover expands Mover;

struct Sequence
{
	var() byte 			SeqStartKeyframe; // Start frame #
	var() byte 			SeqEndKeyframe;			// End frame #
	var() byte 			SeqCloseKeyframe;		// Keyframe to return to

	var() bool			bLoop;			// Loop this sequence
	var() bool 			bSnapToStart;	// snap the movers location to the first frame
										// of the sequence at the start of the sequence.
										// If this is FALSE, the mover will interpolate
										// from its current location and orientation to
										// the first frame of the sequence and then continue.
	var() float 		StartInterval;

	var() name 			EventStart;		// Event to fire when the sequence starts
	var() name 			EventEnd;		// Event to fire when the sequence ends

	var() Sound 		SoundStart;		// Sound to play when the sequence starts
	var() SoundProps	SoundStartProps;
	var() Sound 		SoundEnd;		// Sound to play when the sequence ends
	//var() SoundProps	SoundEndProps;

};

var() float Intervals[32];		// Time intervals for each keyfraem
var() Sequence Sequences[16];	// Array of sequence structs
var() int StartupSequence;		// Initial SequenceID to start in
var() int TriggerSequence;		// Sequence to use if triggered by non-Player

var int PendingSeq;				// Pending sequence number...
var Sequence Seq;				// My current sequence.
var bool bInLoop;
var bool bDisabled;

simulated function CheckSoundProps(out SoundProps SP)
{
	if (SP.Volume == 0) SP.Volume = 1;
	if (SP.Radius == 0) SP.Radius = 2048;
	if (SP.Pitch == 0) SP.Pitch = 1;
	if (SP.PitchDelta == 0) SP.PitchDelta = 0.2;
	if (SP.VolumeDelta == 0) SP.VolumeDelta = 0.2;
}

simulated function int GetKeyNum(int i)
{
	// log("Incoming Key = "$i$" NumKeys = "$NumKeys$" result = "$Clamp(i, 0, NumKeys-1), 'Misc');
	// return i;
	return Clamp(i, 0, NumKeys);
}
simulated function BeginPlay()
{
	// set the movers keyNum to the 
	if (Sequences[StartupSequence].bSnapToStart)
		KeyNum = GetKeyNum(Sequences[StartupSequence].SeqStartKeyframe);
	Super.BeginPlay();
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
		if ( !bDisabled )
		{
			//log("UndMover in TriggerToggle state being triggered "$Other, 'Misc');
			SavedTrigger = Other;
			Instigator = EventInstigator;
			if ( SavedTrigger != None )
				SavedTrigger.BeginEvent();
			//log("KeyNum = "$KeyNum$", PrevKeyNum = "$PrevKeyNum, 'Misc');
			if( KeyNum==0 || KeyNum!= Seq.SeqEndKeyframe)
				GotoState( 'TriggerToggle', 'Open' );
			else
				GotoState( 'TriggerToggle', 'Close' );
		}
	}
Open:
	//log("UndMover in TriggerToggle state OPEN TAG ", 'Misc');
	bClosed = false;
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
	//log("UndMover in TriggerToggle state CLOSE TAG ", 'Misc');
	DoClose();
	FinishInterpolation();
	FinishedClosing();
}

// sets the pending sequence ID - this is only called by the triger firing this mover.
simulated function SetPendingSequence(int i)
{
	//log("UndMover "$self.name$" Setting Pending Sequence to "$i, 'Misc');
	PendingSeq = i;
	
	Seq = Sequences[PendingSeq];
	CheckSoundProps(Seq.SoundStartProps);
	
	//	KeyNum = Sequences[Seq.SeqStart].SeqStart;

	// Set start location.
	//Move (BasePos + KeyPos[KeyNum] - Location);
	// Set start rotation.
//	SetRotation (BaseRot + KeyRot[KeyNum]);
}

// Interpolation ended.
simulated function InterpolateEnd( actor Other )
{
	local byte OldKeyNum;
	local Actor A;

	OldKeyNum  = PrevKeyNum;
	PrevKeyNum = KeyNum;
	PhysAlpha  = 0;
	ClientUpdate--;

	// log("Incoming KeyNum = "$KeyNum, 'Misc');
	// we are at the end of the sequence range
	if ( bOpening )
	{
		// opening
		if ((KeyNum >= Seq.SeqEndKeyframe) || (Seq.SeqStartKeyframe == Seq.SeqEndKeyframe))
		{
			if (Seq.bLoop && (Seq.SeqStartKeyframe != Seq.SeqEndKeyframe))
			{
				// we are looping.. wrap around to the beginning
				// log("..............Loop!", 'Misc');
				InterpolateTo(GetKeyNum(Seq.SeqStartKeyframe),Intervals[GetKeyNum(KeyNum)]);
			} else {
				// we are really ending
	
				// End Event
				if ( Seq.EventEnd != 'none' )
					ForEach AllActors(class 'Actor', A, Seq.EventEnd)
						A.Trigger(self, none);
				// End Sound
				if (Seq.soundEnd != none)
				{
					if (Seq.SoundStartProps.pitch == 0)
						Seq.SoundStartProps.pitch = 1;
					PlaySound(Seq.soundEnd,,Seq.SoundStartProps.volume,,Seq.SoundStartProps.Radius,Seq.SoundStartProps.pitch);
				}
	
				FinishedInterpolating();
			}
		} else if ( (KeyNum > Seq.SeqStartKeyframe) && (KeyNum < Seq.SeqEndKeyframe) ) {
			// we are in the middle of the sequence.
			if (bOpening)
				InterpolateTo(GetKeyNum(KeyNum+1),Intervals[GetKeyNum(KeyNum)]);
			else
				InterpolateTo(GetKeyNum(KeyNum-1),Intervals[GetKeyNum(KeyNum-1)]);
		} else {
			if ((KeyNum < Seq.SeqEndKeyframe))
				InterpolateTo(GetKeyNum(KeyNum+1),Intervals[GetKeyNum(KeyNum)]);
		}
	} else {
		// closing

		if ((KeyNum <= Seq.SeqStartKeyframe) || (Seq.SeqStartKeyframe == Seq.SeqEndKeyframe))
		{
			if (Seq.bLoop && (Seq.SeqStartKeyframe != Seq.SeqEndKeyframe))
			{
				// we are looping.. wrap around to the beginning
				// log("..............Loop!", 'Misc');
				InterpolateTo(Seq.SeqEndKeyframe,Intervals[Seq.SeqEndKeyframe]);
			} else {
				// we are really ending
	
				// End Event
				if ( Seq.EventEnd != 'none' )
					ForEach AllActors(class 'Actor', A, Seq.EventEnd)
						A.Trigger(self, none);
				// End Sound
				 if (Seq.soundEnd != none)
				 {
					if (Seq.SoundStartProps.pitch == 0)
						Seq.SoundStartProps.pitch = 1;
					PlaySound(Seq.soundEnd,,Seq.SoundStartProps.volume,,Seq.SoundStartProps.Radius,Seq.SoundStartProps.pitch);
				 }

				FinishedInterpolating();
			}
		} else if ( (KeyNum > Seq.SeqStartKeyframe) && (KeyNum < Seq.SeqEndKeyframe) ) {
			// we are in the middle of the sequence.
			InterpolateTo(GetKeyNum(KeyNum-1),Intervals[GetKeyNum(KeyNum-1)]);
		} else {
			if ((KeyNum > Seq.SeqStartKeyframe))
				InterpolateTo(GetKeyNum(KeyNum-1),Intervals[GetKeyNum(KeyNum-1)]);
		}

	}
}

function PlayStartEvents()
{
	local Actor A;

	// log("PlayStartEvents() ... Sequence = "$PendingSeq, 'Misc');

	if (Seq.EventStart != 'none')
		ForEach AllActors(class 'Actor', A, Seq.EventStart)
			A.Trigger(self, none);

	if (Seq.SoundStart != none)
	{
		// log("PlayStartEvents() ... Sequence = "$PendingSeq$" Calling Playsound()", 'Misc');
		if (Seq.SoundStartProps.pitch == 0)
			Seq.SoundStartProps.pitch = 1;
		PlaySound(Seq.SoundStart,,Seq.SoundStartProps.volume,,Seq.SoundStartProps.Radius,Seq.SoundStartProps.pitch);
	}
}

// Open the mover.
function DoOpen()
{
	//log("UndMover "$self.name$" DoOpen()", 'Misc');	
	//log("DoOpen() ", 'Misc');
	//log( ".........................DoOpen(), was triggered by " $ SavedTrigger.name, 'Misc' );


	//log ("................SavedTrigger is "$SavedTrigger, 'Misc');
	if ( ((!SavedTrigger.IsA('PlayerPawn') && !SavedTrigger.IsA('Mover')) || SavedTrigger.IsA('UndTriggeredSequence'))) // && (SavedTrigger != none) )
	{
		//log ("Setting Pending Sequence to the TriggerSequence", 'Misc');
		PendingSeq = TriggerSequence;	// Use TriggerSequence if anything besides player is opening
	}

	//log("Pending Sequence is "$PendingSeq, 'Misc');
	Seq = Sequences[PendingSeq];
	bOpening = true;
	bDelaying = false;


	/*
	log("", 'Misc');
	log("..................................", 'Misc');
	log("Seq Num:             "$PendingSeq, 'Misc');
	log("Seq Start:           "$Seq.SeqStartKeyframe, 'Misc');
	log("Seq End:             "$Seq.SeqEndKeyframe, 'Misc');
	log("..................................", 'Misc');
	log("", 'Misc');
	log("..UndMover: ---------------------------", 'Misc');
*/

	if ( Seq.bSnapToStart )
	{
		InterpolateTo( Seq.SeqStartKeyframe, 0);
		// SetLocation(KeyPos[Seq.SeqStart]);
		// SetRotation(KeyRot[Seq.SeqStart]);
	}

	if (Seq.SeqStartKeyframe == Seq.SeqEndKeyframe)
	{
		// One frame sequence.
		// log("...UndMover:Single Frame Sequence Detected", 'Misc');
		if ( KeyNum != Seq.SeqStartKeyframe )
		{
			// log("....UndMover:Current Keyframe is not the desired keyframe.. interpolating", 'Misc');
			PlayStartEvents();
			InterpolateTo( Seq.SeqStartKeyframe,  Intervals[Seq.SeqStartKeyframe]);
		}
	} else {
		// Multi-Frame interpolation
		// log("...UndMover:Multi Frame Sequence Detected", 'Misc');
		// log("Interpolating from frame "$KeyNum$" to frame "$Seq.SeqStartKeyframe+1, 'Misc');
		if ( KeyNum == Seq.SeqStartKeyframe )
		{
			// log("....UndMover:I am at my first frame of my sequence... interpolating to the next frame", 'Misc');
			PlayStartEvents();
			InterpolateTo( GetKeyNum(Seq.SeqStartKeyframe+1),  Intervals[GetKeyNum(Seq.SeqStartKeyframe)]);
		} else if ( KeyNum > Seq.SeqStartKeyframe ) {
			// log("....UndMover:I am past my first frame of my sequence... interpolating to the next frame", 'Misc');
			PlayStartEvents();
			InterpolateTo( GetKeyNum(KeyNum+1),  Intervals[GetKeyNum(KeyNum)]);
		}
	}
	if (Seq.SoundStartProps.pitch == 0)
		Seq.SoundStartProps.pitch = 1;
	PlaySound(OpeningSound,,Seq.SoundStartProps.volume,,Seq.SoundStartProps.Radius,Seq.SoundStartProps.pitch);
	AmbientSound = MoveAmbientSound;
	NetUpdateFrequency = default.NetUpdateFrequency;
}

// Close the mover.
function DoClose()
{
	//log("UndMover "$self.name$" DoClose()", 'Misc');	
	// log("....UndMover:DoClose()", 'Misc');
	bOpening = false;
	bDelaying = false;

	if (KeyNum == Seq.SeqEndKeyframe)
	{
		InterpolateTo( GetKeyNum(KeyNum-1),  Intervals[GetKeyNum(KeyNum-1)]);
		if (Seq.SoundStartProps.pitch == 0)
			Seq.SoundStartProps.pitch = 1;
		PlaySound( ClosingSound,,Seq.SoundStartProps.volume,,Seq.SoundStartProps.Radius,Seq.SoundStartProps.pitch);
		AmbientSound = MoveAmbientSound;
	} else if ( (Seq.SeqStartKeyframe == Seq.SeqEndKeyframe) && (KeyNum != Seq.SeqCloseKeyframe) ) {
		if ( GetStateName() == 'TriggerToggle' )
			PlayStartEvents();
		
		InterpolateTo( Seq.SeqCloseKeyframe,  Intervals[Seq.SeqCloseKeyframe]);
		if (Seq.SoundStartProps.pitch == 0)
			Seq.SoundStartProps.pitch = 1;
		PlaySound( ClosingSound,,Seq.SoundStartProps.volume,,Seq.SoundStartProps.Radius,Seq.SoundStartProps.pitch);
		AmbientSound = MoveAmbientSound;
	}
	NetUpdateFrequency = default.NetUpdateFrequency;
}

defaultproperties
{
     Intervals(0)=1
     Intervals(1)=1
     Intervals(2)=1
     Intervals(3)=1
     Intervals(4)=1
     Intervals(5)=1
     Intervals(6)=1
     Intervals(7)=1
     Intervals(8)=1
     Intervals(9)=1
     Intervals(10)=1
     Intervals(11)=1
     Intervals(12)=1
     Intervals(13)=1
     Intervals(14)=1
     Intervals(15)=1
     Intervals(16)=1
     Intervals(17)=1
     Intervals(18)=1
     Intervals(19)=1
     Intervals(20)=1
     Intervals(21)=1
     Intervals(22)=1
     Intervals(23)=1
     Intervals(24)=1
     Intervals(25)=1
     Intervals(26)=1
     Intervals(27)=1
     Intervals(28)=1
     Intervals(29)=1
     Intervals(30)=1
     Intervals(31)=1
     Sequences(0)=(SoundStartProps=(Volume=1,Pitch=1,Radius=1024,PitchDelta=0.2,VolumeDelta=0.2))
     InitialState=TriggerToggle
}
