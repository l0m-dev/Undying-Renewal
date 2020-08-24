//=============================================================================
// WeaponLight.
// Based on Unreal code.
//=============================================================================
class WeaponLight expands Light;

//#exec TEXTURE IMPORT NAME=WeaponLightPal FILE=WeaponLightPal.pcx GROUP=Effects

defaultproperties
{
     bStatic=False
     bNoDelete=False
     bNetTemporary=True
     bNetOptional=True
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.15
     bMovable=True
     LightType=LT_TexturePaletteOnce
     LightBrightness=255
     LightHue=28
     LightSaturation=32
     LightRadius=13
     bActorShadows=True
     LightSource=LD_Ambient
}
