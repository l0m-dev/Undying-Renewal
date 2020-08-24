//=============================================================================
// LightningFX.
//=============================================================================
class LightningFX expands ScriptedFX;

//#exec OBJ LOAD FILE=\Aeons\Textures\Lightning.utx PACKAGE=Lightning

defaultproperties
{
     ColorStart=(Base=(R=255,G=255,B=255))
     Textures(0)=Texture'Lightning.fx_Ltng00'
     LODBias=100
     CollisionRadius=1024
     CollisionHeight=1024
}
