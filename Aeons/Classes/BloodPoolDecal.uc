//=============================================================================
// BloodPoolDecal.
//=============================================================================
class BloodPoolDecal expands AeonsDecal;

#exec OBJ LOAD FILE=..\Textures\MtFx.utx PACKAGE=MtFx

defaultproperties
{
     DecalTextures(0)=Texture'MtFx.Blood.Blood01H'
     NumDecals=1
     Style=STY_AlphaBlend
}
