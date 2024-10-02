class RevenantBossNoMRM expands RevenantNoMRM;

function PreBeginPlay()
{
	super.PreBeginPlay();

	DestroyLimb( 'head' );
	ReplicateDestroyLimb( self, 'head' );
}

defaultproperties
{
}
