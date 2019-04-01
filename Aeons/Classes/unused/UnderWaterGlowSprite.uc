//=============================================================================
// UnderWaterGlowSprite.
//=============================================================================
class UnderWaterGlowSprite expands GlowSprite;

#exec OBJ LOAD FILE=\Aeons\Textures\PiratesCoveG.utx PACKAGE=PiratesCoveG

defaultproperties
{
     Texture=Texture'PiratesCoveG.Effects.GlobeGlow_Pcove'
     DrawScale=0.45
     Opacity=0.5
}
