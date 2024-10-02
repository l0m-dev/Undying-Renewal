//=============================================================================
// BreakAwayEffect.
//=============================================================================
class BreakAwayEffect expands Effects;

//#exec MESH IMPORT MESH=BreakAwayStone0_m SKELFILE=BreakAwayStone0.ngf

//#exec MESH IMPORT MESH=Blox1_m SKELFILE=Blox1.ngf 
//#exec MESH IMPORT MESH=Blox2_m SKELFILE=Blox2.ngf 
//#exec MESH IMPORT MESH=BloxSide_m SKELFILE=BloxSide.ngf 

var rotator InitialRot;
var vector InitialLoc, TargetLoc;
var() sound EndSound[3];
var() sound StartSound[3];

var float BreakAwayDistance;

var transient Actor Triggerer;

simulated function PreBeginPlay()
{
	super.PreBeginPlay();
	InitialRot = rotation;
	InitialLoc = Location;
	Triggerer = None;

	SetTimer(1.0, true);
}

simulated function Timer()
{
	if (Triggerer != None)
	{
		if ( VSize(Triggerer.Location - Location) >= BreakAwayDistance || Triggerer.bDeleteMe )
		{
			UnTrigger(Triggerer, none);
		}
	}
}

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
	if (Triggerer == None)
	{
		Triggerer = Other;
	}
	if ((DrawScale < 1) && (GetStateName() != 'Grow'))
		GotoState('Grow');
}

simulated function UnTrigger(Actor Other, Pawn EventInstigator)
{
	if (Triggerer != None && Other != Triggerer)
	{
		return;
	}
	Triggerer = None;
	if ((DrawScale > 0) && (GetStateName() != 'Shrink'))
		GotoState('Shrink');
}

auto simulated State Idle
{
	simulated function BeginState()
	{
		bHidden = true;
	}

	Begin:
		SetLocation(InitialLoc);
		SetRotation(Rotator(vect(0,0,1)));
		DrawScale = 0;
}

state Grow
{
	simulated function Tick(float DeltaTime)
	{	
		DrawScale += DeltaTime * RandRange(3.0, 6.0);
		if (DrawScale >= 1)
			GotoState('HoldBig');
	}
	
	simulated function BeginState()
	{
		SetRotation(RotRand());
		DesiredRotation = InitialRot;
		bHidden = false;
	}
}

state HoldSmall
{
	simulated function Tick(float DeltaTime);

	simulated function BeginState()
	{
		DrawScale = 0;
		bHidden = true;
	}
}

state HoldBig
{
	simulated function Tick(float DeltaTime);
	simulated function BeginState()
	{
		PlaySound (EndSound[Rand(3)],SLOT_Misc,RandRange(0.25, 0.75),,384.0,1.0 + RandRange(-0.2, 0.2));
		DrawScale = 1;
		bHidden = false;
	}
}


state Shrink
{
	simulated function Tick(float DeltaTime)
	{	
		DrawScale -= DeltaTime * RandRange(3.0, 6.0);
		if (DrawScale <= 0)
			GotoState('HoldSmall');
	}

	simulated function BeginState()
	{
		PlaySound (StartSound[Rand(3)],,RandRange(0.25, 0.75),,384.0,1.0 + RandRange(-0.2, 0.2));

		DesiredRotation = RotRand();
		bHidden = false;
	}

}

defaultproperties
{
     BreakAwayDistance=256
     Physics=PHYS_Rotating
     RotationRate=(Pitch=60000,Yaw=60000,Roll=60000)
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.BreakAwayStone0_m'
     bFixedRotationDir=True
     bRotateToDesired=True
     NetPriority=1.4
     RemoteRole=ROLE_SimulatedProxy
     bNoDelete=True
}
