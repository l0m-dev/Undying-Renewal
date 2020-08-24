//=============================================================================
// LanternSpotlight.
//=============================================================================
class LanternSpotlight expands Light;

defaultproperties
{
     bStatic=False
     bNoDelete=False
     bDirectional=True
     bMovable=True
     LightType=LT_Flicker
     LightEffect=LE_Spotlight
     LightBrightness=255
     LightHue=29
     LightSaturation=128
     LightRadius=36
     LightRadiusInner=16
     LightPeriod=4
     LightCone=60
}
