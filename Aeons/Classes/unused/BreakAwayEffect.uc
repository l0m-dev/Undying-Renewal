//=============================================================================
// BreakAwayEffect.
//=============================================================================
class BreakAwayEffect expands Effects;

#exec MESH IMPORT MESH=BreakAwayStone0_m SKELFILE=BreakAwayStone0.ngf

#exec MESH IMPORT MESH=Blox1_m SKELFILE=Blox1.ngf 
#exec MESH IMPORT MESH=Blox2_m SKELFILE=Blox2.ngf 
#exec MESH IMPORT MESH=BloxSide_m SKELFILE=BloxSide.ngf 

var rotator InitialRot;
var vector InitialLoc, TargetLoc;
var() sound EndSound[3];
var() sound StartSound[3];

function PreBeginPlay()
{
	super.PreBeginPlay();
	InitialRot = rotation;
	InitialLoc = Location;
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	if ((DrawScale < 1) && (GetStateName() != 'Grow'))
		GotoState('Grow');
}

function UnTrigger(Actor Other, Pawn EventInstigator)
{
	if ((DrawScale > 0) && (GetStateName() != 'Shrink'))
		GotoState('Shrink');
}

auto State Idle
{
	function BeginState()
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
	function Tick(float DeltaTime)
	{	
		DrawScale += DeltaTime * RandRange(3.0, 6.0);
		if (DrawScale >= 1)
			GotoState('HoldBig');
	}
	
	function BeginState()
	{
		SetRotation(RotRand());
		DesiredRotation = InitialRot;
		bHidden = false;
	}
}

state HoldSmall
{
	function Tick(float DeltaTime);

	function BeginState()
	{
		DrawScale = 0;
		bHidden = true;
	}
}

state HoldBig
{
	function Tick(float DeltaTime);
	function BeginState()
	{
		PlaySound (EndSound[Rand(3)],SLOT_Misc,RandRange(0.25, 0.75),,384.0,1.0 + RandRange(-0.2, 0.2));
		DrawScale = 1;
		bHidden = false;
	}
}


state Shrink
{
	function Tick(float DeltaTime)
	{	
		DrawScale -= DeltaTime * RandRange(3.0, 6.0);
		if (DrawScale <= 0)
			GotoState('HoldSmall');
	}

	function BeginState()
	{
		PlaySound (StartSound[Rand(3)],,RandRange(0.25, 0.75),,384.0,1.0 + RandRange(-0.2, 0.2));

		DesiredRotation = RotRand();
		bHidden = false;
	}

}

defaultproperties
{
     Physics=PHYS_Rotating
     RotationRate=(Pitch=60000,Yaw=60000,Roll=60000)
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.BreakAwayStone0_m'
     bRotateToDesired=True
}
