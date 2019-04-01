//=============================================================================
// MindShatterScriptedFX. 
//=============================================================================
class MindShatterScriptedFX expands ScriptedFX;

defaultproperties
{
     Lifetime=(Base=0.3,Rand=1)
     ColorStart=(Base=(R=36,G=50,B=219))
     ColorEnd=(Base=(R=182,G=24,B=29))
     AlphaEnd=(Base=0)
     SizeWidth=(Base=1)
     SizeLength=(Base=1)
     SizeEndScale=(Base=-360)
     SpinRate=(Base=64,Max=64)
     Textures(0)=WetTexture'fxB.MyTex2'
     RenderPrimitive=PPRIM_Billboard
     DrawScale=20
     SpriteProjForward=0
     CollisionRadius=1000
     CollisionHeight=1000
}
