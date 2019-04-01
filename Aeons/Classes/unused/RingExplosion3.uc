//=============================================================================
// RingExplosion3.
//=============================================================================
class RingExplosion3 extends RingExplosion;





simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		PlayAnim( 'Explosion', 0.15 );
		SpawnEffects();
	}	
	if ( Instigator != None )
		MakeNoise(0.5);
}

defaultproperties
{
     DrawScale=1.25
}
