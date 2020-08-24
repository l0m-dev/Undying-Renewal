class RevenantBossNoMRM expands RevenantNoMRM;

function PreBeginPlay()
{
	super.PreBeginPlay();

	DestroyLimb( 'head' );
}

defaultproperties
{
}
