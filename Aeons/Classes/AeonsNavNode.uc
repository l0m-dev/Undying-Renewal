//=============================================================================
// AeonsNavNode.
//=============================================================================
class AeonsNavNode extends PathNode;

//#exec Texture Import File=AlarmFlag.pcx Name=AlarmFlag Mips=On Flags=2
//#exec Texture Import File=CoverFlag.pcx Name=CoverFlag Mips=On Flags=2
//#exec Texture Import File=GuardFlag.pcx Name=GuardFlag Mips=On Flags=2
//#exec Texture Import File=NavChoice.pcx Name=NavChoice Mips=On Flags=2
//#exec Texture Import File=NavMarker.pcx Name=NavMarker Mips=On Flags=2
//#exec Texture Import File=PatrolFlag.pcx Name=PatrolFlag Mips=On Flags=2
//#exec Texture Import File=ScriptFlag.pcx Name=ScriptFlag Mips=On Flags=2
//#exec Texture Import File=SearchFlag.pcx Name=SearchFlag Mips=On Flags=2
//#exec Texture Import File=ShadowFlag.pcx Name=ShadowFlag Mips=On Flags=2
//#exec Texture Import File=SpawnFlag.pcx Name=SpawnFlag Mips=On Flags=2

//****************************************************************************
// This class extends the PathNode NavigationPoint class.
// It adds functionality to dynamically alter the navigation point network
// so that the pathfinding functions will return alternate solutions to
// the same pathing problem in different situations.
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************
var vector					LookVector;			// Vector pointing directly in front of this point.
var vector					LookAtPoint;		// Location directly in front of this point.
var int						HazardLevel;		//


//****************************************************************************
// Inherited member funcs.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();
	LookVector = 500 * vector(Rotation);
	LookAtPoint = Location + LookVector;
}

function Trigger( actor Other, pawn EventInstigator )
{
	IncreaseHazard();
	super.Trigger( Other, EventInstigator );
}


//****************************************************************************
// New member funcs.
//****************************************************************************
// Increase the navigation hazard level of this point.
function IncreaseHazard()
{
	HazardLevel += 1;
	if ( HazardLevel == 0 )
		ExtraCost = default.ExtraCost;
	else
		ExtraCost = 1000000;
}

// Decrease the navigation hazard level of this point.
function DecreaseHazard()
{
	HazardLevel -= 1;
	if ( HazardLevel == 0 )
		ExtraCost = default.ExtraCost;
	else
		ExtraCost = 1000000;
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     bDirectional=True
}
