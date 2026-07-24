class RevenantBossNoMRM expands RevenantNoMRM;

function StartLevel()
{
	super.StartLevel();

	DestroyLimb( 'head' );
	ReplicateDestroyLimb( self, 'head' );
}

defaultproperties
{
}
