//=============================================================================
// Keys.
//=============================================================================
class Keys expands Items;

#exec MESH IMPORT MESH=MonasteryKey_m SKELFILE=MonasteryKey.ngf

#exec AUDIO IMPORT  FILE="I_KeyPU01.wav" NAME="I_KeyPU01" GROUP="Inventory"

function PreBeginPlay()
{
	Super.PreBeginPlay();
	if (self.class.name == 'Keys')
		Destroy();
}

defaultproperties
{
     ItemType=ITEM_Inventory
     bActivatable=True
     bDisplayableInv=True
     bAmbientGlow=False
     PickupMessage="You got a <name> Key"
     ItemName="<name>Key"
     PickupViewMesh=SkelMesh'Aeons.Meshes.MonasteryKey_m'
     PickupSound=Sound'Aeons.Inventory.I_KeyPU01'
     Icon=Texture'Aeons.Icons.Key_Icon'
     Mesh=SkelMesh'Aeons.Meshes.MonasteryKey_m'
     AmbientGlow=0
     CollisionRadius=16
     CollisionHeight=8
}
