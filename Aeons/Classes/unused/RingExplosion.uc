//=============================================================================
// RingExplosion.
//=============================================================================
class RingExplosion expands Effects;

var() Sound ExploSound;

simulated function Tick( float DeltaTime )
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		ScaleGlow = (Lifespan/Default.Lifespan);
		AmbientGlow = ScaleGlow * 255;		
	}
}

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		PlayAnim( 'Explosion', 0.25 );
		SpawnEffects();
	}	
	if ( Instigator != None )
		MakeNoise(0.5);
}

simulated function SpawnEffects()
{ 
}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.8
     DrawType=DT_Mesh
     Style=STY_None
     DrawScale=0.7
     ScaleGlow=1.1
     bUnlit=True
}
