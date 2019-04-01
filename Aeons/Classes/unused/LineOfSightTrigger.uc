//=============================================================================
// LineOfSightTrigger.
//=============================================================================
class LineOfSightTrigger expands Trigger;

#exec TEXTURE IMPORT NAME=TrigLineOfSight FILE=TrigLineOfSight.pcx GROUP=System Mips=Off Flags=2

var() float TargetFOV;
var() float ViewTimer;
var() name TargetActorTag;
var() bool bControlActorVis;
var() name VisActorTag;

var Actor ControlActors[4];

var float dt;
var actor OtherActor;
var actor TargetActor;

// takes two locations A, and B, and a starting location Loc and determines if
// the vectors from [Loc to A] and [Loc to B] are withing the angleThreshold value

function bool AngleCheck(vector Loc, vector A, float angleThreshold)
{
	local vector vA, vB;
	local float angle;
	local float pi;

	pi = 3.1415926535897932384626433832795;

	angleThreshold *= (pi / 180.0);
	vA = Normal(A - Loc);
	vB = Vector(Pawn(OtherActor).ViewRotation);
	angle = vA dot vB;

	return ( cos(angleThreshold) < angle );
}

function bool LoS(vector Loc)
{
	local vector v1, v2, locB, eyeHeight;
	local float angle;
	local bool pass;
	
	eyeHeight.z = Pawn(OtherActor).EyeHeight;
	// if ( FastTrace(TargetActor.Location, (OtherActor.Location + EyeHeight)) )
		return AngleCheck((OtherActor.Location + EyeHeight), TargetActor.Location, (TargetFOV * 0.5));
}

function bool OtherInRadius()
{
	local vector v1, v2;
	
	v1 = OtherActor.Location;
	v1.z = 0;

	v2 = Location;
	v2.z = 0;
	
	if ( VSize(v1 - v2) < CollisionRadius )
		return true;
	
	return false;
}

function Tick(float deltaTime)
{
	local int i;

	if ((OtherActor != none) && (TargetActor != none))
	{
		// OtherActor.Instigator.ClientMessage("Time: "$dt);
		if ( LoS(TargetActor.Location) && OtherInRadius() )
		{
			if ( bControlActorVis )
			{
				for (i=0; i<4; i++)
				{
					if (ControlActors[i] != none)
						if ( ScriptedPawn(ControlActors[i]) != none )
							ScriptedPawn(ControlActors[i]).RampOpacity( true );
						else
							ControlActors[i].bHidden = false;
				}
			} else {
				dt += deltaTime;
				if ( dt >= ViewTimer )
					FireEvent(OtherActor);
			}
		} else {

			if ( bControlActorVis )
			{
				for (i=0; i<4; i++)
				{
					if (ControlActors[i] != none)
						if ( ScriptedPawn(ControlActors[i]) != none )
							ScriptedPawn(ControlActors[i]).RampOpacity( false );
						else
							ControlActors[i].bHidden = true;
				}
			}

			dt = 0.0;
		}
	}
}

function FireEvent(Actor Other)
{
	local actor A;

	disable('Tick');
	dt = 0;

	if ( Event != '' )
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
			A.Trigger( OtherActor, OtherActor.Instigator );
		}
		
	if ( OtherActor.IsA('Pawn') && (Pawn(OtherActor).SpecialGoal == self) )
		Pawn(OtherActor).SpecialGoal = None;
			
	if( Message != "" && Level.bDebugMessaging)
		// Send a string message to the toucher.
		OtherActor.Instigator.ClientMessage( Message );

	if( bTriggerOnceOnly )
		// Ignore future touches.
		SetCollision(False);

	else if ( RepeatTriggerTime > 0 )
		SetTimer(RepeatTriggerTime, false);
}

function Touch( actor Other )
{
	local actor A;
	local int Counter;

	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	if ( IsRelevant( Other ) )
		OtherActor = Other;
	else
		return;
	
	if ( TargetActorTag != 'none' )
		forEach AllActors(class 'Actor',A, TargetActorTag)
		{
			TargetActor = A;
			// Pawn(Other).ClientMessage("TargetActor found: "$TargetActor);
			break;
		}

	if( TargetActor != none )
	{
		if (bControlActorVis)
		{
			ForEach AllActors(class 'Actor', A, VisActorTag) 
			{
				if ( Counter < 4 ) {
					ControlActors[Counter] = A;
					Counter ++;
				} else {
					log("LineOfSightTrigger - Attempted to add Actor - past array limit of 4");
				}
			}
		}

		if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
			return;
		TriggerTime = Level.TimeSeconds;

		dt = 0;
		enable('Tick');

		if( Message != "" && Level.bDebugMessaging)
			OtherActor.Instigator.ClientMessage( Message );
	}
}

function UnTouch( actor Other )
{
	local int i;
	
	super.UnTouch(Other);
	OtherActor = none;

	if ( bControlActorVis )
	{
		for (i=0; i<4; i++)
		{
			if (ControlActors[i] != none)
				if ( ScriptedPawn(ControlActors[i]) != none )
					ScriptedPawn(ControlActors[i]).RampOpacity( false );
				else
					ControlActors[i].bHidden = true;
		}
	}

}

function PreBeginPlay()
{
	super.PreBeginPlay();
	disable('Tick');

}

defaultproperties
{
     Texture=Texture'Aeons.System.TrigLineOfSight'
     DrawScale=0.5
}
