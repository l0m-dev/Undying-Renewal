//=============================================================================
// LanternSpotlight.
//=============================================================================
class LanternSpotlight expands Light;

// set bHidden to False to allow replication
// set DrawType to DT_Mesh so Rotation replicates to the client

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
     bHidden=False
     DrawType=DT_Mesh
}
