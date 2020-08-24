//=============================================================================
// BarrelTNT.
//=============================================================================
class BarrelTNT expands Container;

//#exec MESH IMPORT MESH=BarrelTNT_m SKELFILE=BarrelTNT.ngf 

var() name BlowUpEvent;

function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	// log("Barrel TNT taking Damage of Type "$DInfo.DamageType, 'Misc');
	
	switch ( DInfo.DamageType )
	{
		case 'Stomped':
			break;
		
		default:
			gotoState('Explode');
			break;
	}
}

function Destroyed()
{
	local Actor A;

	if ( Region.Zone.bWaterZone )
		Spawn(class 'UnderwaterExplosionFX',,,Location);
	else
		Spawn(class 'DynamiteExplosion',,,Location);
	
	if ( BlowUpEvent != 'none' )
	{
		ForEach AllActors(class 'Actor', A)
		{
			A.Trigger(self, None);
		}
	}
}

state Explode
{

	function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo){}

	Begin:
		sleep(RandRange(0.1, 0.5));
		Destroy();
}

defaultproperties
{
     bPushable=True
     bStatic=False
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.BarrelTNT_m'
     CollisionRadius=32
     CollisionHeight=42
     bCollideActors=True
     bCollideWorld=True
     bBlockPlayers=True
     bProjTarget=True
}
