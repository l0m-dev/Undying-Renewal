//=============================================================================
// LBGScriptedFX.
//=============================================================================
class LBGScriptedFX expands ScriptedFX;

#exec OBJ LOAD FILE=\Aeons\Textures\Lightning.utx PACKAGE=Lightning

defaultproperties
{
     ColorStart=(Base=(R=255,G=255,B=255))
     ColorEnd=(Base=(R=255,G=255,B=255))
     SizeWidth=(Base=32)
     Textures(0)=Texture'Lightning.fx_Ltng00'
}
