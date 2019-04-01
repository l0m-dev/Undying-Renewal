//=============================================================================
// LanternLight.
//=============================================================================
class LanternLight expands Light;

defaultproperties
{
     bStatic=False
     bNoDelete=False
     bDirectional=True
     Skin=Texture'Engine.S_Light'
     bMovable=True
     LightType=LT_Flicker
     LightBrightness=255
     LightHue=29
     LightSaturation=128
     LightRadius=16
     LightRadiusInner=10
     LightPeriod=4
}
