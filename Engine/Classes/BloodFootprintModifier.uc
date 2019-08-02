//=============================================================================
// BloodFootprintModifier.
//=============================================================================
class BloodFootprintModifier expands PlayerModifier;

var() float BloodTimer;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	if ( Pawn(Owner) == none )
		Destroy();
}

function MyFeetAreBloody()
{
	Pawn(Owner).bBloodyFootprints = true;
	SetTimer(BloodTimer, false);
}

function Timer()
{
	Pawn(Owner).bBloodyFootprints = false;
}

defaultproperties
{
     BloodTimer=4
}
