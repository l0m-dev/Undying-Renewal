//=============================================================================
// BloodFootprintModifier.
//=============================================================================
class BloodFootprintModifier expands PlayerModifier;

// made into more generic footstep modifier
// todo: add states?

var bool bBloodyFootprints;
var bool bSnowyFootprints;

var() float BloodTimer;
var() float SnowTimer;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	if ( Pawn(Owner) == none )
		Destroy();
}

function MyFeetAreBloody()
{
	bBloodyFootprints = true;
	bSnowyFootprints = false;
	SetTimer(BloodTimer, false);
}

function MyFeetAreSnowy()
{
	bBloodyFootprints = false;
	bSnowyFootprints = true;
	SetTimer(SnowTimer, false);
}

function Timer()
{
	bBloodyFootprints = false;
	bSnowyFootprints = false;
}

defaultproperties
{
     BloodTimer=4
     SnowTimer=3
}
