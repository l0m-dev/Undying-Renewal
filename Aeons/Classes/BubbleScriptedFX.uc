//=============================================================================
// BubbleScriptedFX. 
//=============================================================================
class BubbleScriptedFX expands ScriptedFX;

var particleParams p;

defaultproperties
{
     Lifetime=(Base=1)
     AlphaEnd=(Base=0)
     SizeWidth=(Base=12)
     SizeLength=(Base=12)
     SizeEndScale=(Base=2)
     Gravity=(Z=20)
     Textures(0)=Texture'Aeons.Particles.BubbleTrans'
     RenderPrimitive=PPRIM_Billboard
}
