//=============================================================================
// DirtTextureHitFX. 
//=============================================================================
class DirtTextureHitFX expands TextureHitFX;

defaultproperties
{
     SourceWidth=(Base=4)
     SourceHeight=(Base=8)
     SourceDepth=(Base=8)
     Speed=(Base=40,Rand=100)
     ColorStart=(Base=(R=132,G=113,B=72))
     ColorEnd=(Base=(R=181,G=154,B=134))
     AlphaStart=(Base=0.25)
     SizeEndScale=(Base=4)
     Gravity=(Z=-20)
}
