class AmbroseHound expands Hound;

auto state AISpawn
{
	function FinishSpawn()
	{
		GotoState( 'AmbroseBossFight' );
	}
}

defaultproperties
{
     bGiveScytheHealth=False
     CollisionRadius=30
}
