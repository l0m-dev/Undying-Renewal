//=============================================================================
// HealingRoot.
//=============================================================================
class HealingRoot expands Health;

//#exec MESH IMPORT MESH=HealingRoot_m SKELFILE=HealingRoot.ngf


function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	BecomeHealingRoot();
}

defaultproperties
{
     PickupMessage="You gained some Healing Roots"
     PickupViewMesh=SkelMesh'Aeons.Meshes.HealingRoot_m'
     PickupViewScale=2
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_HealthRootPU01'
     Mesh=SkelMesh'Aeons.Meshes.HealingRoot_m'
     DrawScale=2
     CollisionRadius=16
     CollisionHeight=44
}
