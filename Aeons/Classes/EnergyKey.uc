//=============================================================================
// EnergyKey.
//=============================================================================
class EnergyKey expands Keys;

var ParticleFX efxA, efxB, efxC;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if ( Owner == None && Level.NetMode != NM_Client )
	{
		efxA = spawn(Class'Aeons.FireFlyTrailFX',,,Location);
		efxA.SetBase(self);
		efxB = spawn(Class'Aeons.FireFlyTrailFliesFX',,,Location);
		efxB.SetBase(self);
		efxC = spawn(Class'Aeons.FireFlyTrail_particles',,,Location);
		efxC.SetBase(self);
	}
}

function PickupFunction(Pawn Other)
{
	Super.PickupFunction(Other);
	
	if (efxA != None)
	{
		efxA.Shutdown();
		efxB.Shutdown();
		efxC.Shutdown();
	}
}

defaultproperties
{
     InventoryGroup=173
     PickupMessage="You found an Energy Key"
     ItemName="Energy Key"
     PickupViewMesh=None
     PickupSound=Sound'LevelMechanics.Onieros.E09_PortalOut01'
     bHidden=True
     Texture=Texture'Aeons.Icons.Key_Icon'
     CollisionRadius=32
     CollisionHeight=32
}
