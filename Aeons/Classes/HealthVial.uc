//=============================================================================
// HealthVial.
//=============================================================================
class HealthVial expands Health;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	BecomeHealthVial();
}

defaultproperties
{
     PickupMessage="You gained a Health Vial"
     PickupViewMesh=SkelMesh'Aeons.Meshes.StalkerLure_m'
     PickupViewScale=2.2
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_GlassPU01'
     Physics=PHYS_None
     Mesh=SkelMesh'Aeons.Meshes.StalkerLure_m'
     ShadowImportance=0
     DrawScale=2.2
     bUnlit=True
     bMRM=False
     LightType=LT_Steady
     LightBrightness=127
     LightHue=139
     LightSaturation=129
     LightRadius=16
}
