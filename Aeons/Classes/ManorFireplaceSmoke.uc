//=============================================================================
// ManorFireplaceSmoke.
//=============================================================================
class ManorFireplaceSmoke expands FireSmokeFX;

defaultproperties
{
     ParticlesPerSec=(Rand=16)
     SourceWidth=(Base=64)
     SourceHeight=(Base=16)
     SourceDepth=(Base=128)
     AngularSpreadWidth=(Base=2)
     AngularSpreadHeight=(Base=2)
     Lifetime=(Base=0.5)
     ColorStart=(Base=(R=85,G=85,B=85),Rand=(R=42,G=42,B=42))
     AlphaStart=(Base=0.1)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     AlphaDelay=0
     Elasticity=0.01
     Attraction=(Z=-4)
     Textures(0)=Texture'Aeons.MuzzleFlashes.Ghelz_Glow'
     Style=STY_Translucent
}
