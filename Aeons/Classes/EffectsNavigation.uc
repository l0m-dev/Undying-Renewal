//=============================================================================
// EffectsNavigation.
//=============================================================================
class EffectsNavigation expands Actor;

//#exec TEXTURE IMPORT NAME=EFXNav FILE=EFXNav.pcx GROUP="System" FLAGS=2 MIPS=OFF

var() name NextPoint;
var() bool bMasterPoint;

defaultproperties
{
     Style=STY_Masked
     Texture=Texture'Aeons.System.EFXNav'
     DrawScale=3
}
