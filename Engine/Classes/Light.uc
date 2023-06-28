//=============================================================================
// The light class.
//=============================================================================
class Light extends Invisible
	native;

//#exec Texture Import File=Textures\S_Light.pcx  Name=S_Light Mips=On Flags=2

defaultproperties
{
     bStatic=True
     bHidden=True
     bNoDelete=True
     Texture=Texture'Engine.S_Light'
     ShadowImportance=1
     bMovable=False
     CollisionRadius=24
     CollisionHeight=24
     LightType=LT_Steady
     LightBrightness=64
     LightSaturation=255
     LightRadius=40
     LightPeriod=32
     LightCone=128
     VolumeBrightness=64
}
