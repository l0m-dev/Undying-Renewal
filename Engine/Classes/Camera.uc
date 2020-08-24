//=============================================================================
// A camera, used in UnrealEd.
//=============================================================================
class Camera extends PlayerPawn
	native;

// Sprite.
//#exec Texture Import File=Textures\S_Camera.pcx Name=S_Camera Mips=On Flags=2

defaultproperties
{
     Location=(X=-500,Y=-300,Z=300)
     Texture=Texture'Engine.S_Camera'
     CollisionRadius=16
     CollisionHeight=39
     LightBrightness=100
     LightRadius=20
}
